<#  
.SYNOPSIS  
    Deploy a Sample APIGateway interface and call a Lambda function
.DESCRIPTION  
    Deploy a Sample APIGateway interface and call a Lambda function
.LINK  
    https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-custom-integrations.html
#>

# Constants
$AWSAccountNo="138752486395"
$RoleName="lattuceorcl"
$APIName="testapi"
$FunctionName="GetStringFromDB"
$Region="eu-west-1"

# Delete all existing APIs
$apis=aws apigateway get-rest-apis
$apis=$apis | ConvertFrom-Json
$RunAtLeastOnce=0
foreach ($api in $apis.items) {
	if ($RunAtLeastOnce -eq 1) {
		write-output "Waiting 10 seconds before deleting next API"
		start-sleep 10
	}
	write-output "Deleting API: $($api.id)"
	aws apigateway delete-rest-api --rest-api-id $api.id
	$RunAtLeastOnce=1
}

##1
write-output ("Step 1: Create rest API and output the restapi ID")
$restapi=aws apigateway create-rest-api --name $APIName --region $Region --endpoint-configuration types=REGIONAL
$restapi=$restapi | ConvertFrom-Json
write-output "Restapi.id: $($restapi.id)"

##2
write-output ("Step 2: Get Resources and return the resurce item id")
$resources=aws apigateway get-resources --rest-api-id $restapi.id --region $Region
$resources=$resources | ConvertFrom-Json
write-output "resources.items.id: $($resources.items.id)"

##3
write-output ("Step 3: Create a Resource and return the resource id")
$resource=aws apigateway create-resource --rest-api-id $restapi.id --region $Region --parent-id $resources.items.id --path-part greeting
$resource=$resource | ConvertFrom-Json
write-output "resource.id: $($resource.id)"

##4
write-output ("Step 4: Create a method")
$method=aws apigateway put-method --rest-api-id $restapi.id --region $Region --resource-id $resource.id --http-method GET --authorization-type "NONE" --request-parameters method.request.querystring.greeter=false

##5
write-output ("Step 5: Create a method response")
$PutMethodID=aws apigateway put-method-response --region $Region --rest-api-id $restapi.id --resource-id $resource.id --http-method GET --status-code 200

##6  
write-output ("Step 6: Put Integration")
$PutIntegration=aws apigateway put-integration --region $Region --rest-api-id $restapi.id --resource-id $resource.id --http-method GET --type AWS --integration-http-method POST --uri arn:aws:apigateway:$($Region):lambda:path/2015-03-31/functions/arn:aws:lambda:$($Region):$($AWSAccountNo):function:$($FunctionName)/invocations --request-templates file://c:/temp/integration-request-template.json --credentials arn:aws:iam::$($AWSAccountNo):role/$($RoleName) 
                                                                              
##7
write-output ("Step 7: Add permission to call Lambda function")
$guid=[guid]::NewGuid()
$AddPermission=aws lambda add-permission --function-name arn:aws:lambda:$($Region):$($AWSAccountNo):function:$($FunctionName) --statement-id $guid --action lambda:InvokeFunction --source-arn arn:aws:execute-api:$($Region):$($AWSAccountNo):$($restapi.id)/*/GET/greeting  --principal apigateway.amazonaws.com

##8
write-output ("Step 8: Put Integration Response")
$PutIntegrationResponse=aws apigateway put-integration-response --region $Region --rest-api-id $restapi.id --resource-id $resource.id --http-method GET --status-code 200 --selection-pattern `"`"

##9
write-output ("Step 9: Create a deployment to call the API")
$CreateDeployment=aws apigateway create-deployment --rest-api-id $restapi.id --stage-name test

##10
write-output ("Step 10: Call the API using WGET")
$Content=wget "https://$($restapi.id).execute-api.$($Region).amazonaws.com/test/greeting"
write-output $Content.content
