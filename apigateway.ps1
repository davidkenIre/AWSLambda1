<#
https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-custom-integrations.html
arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB
#>

# Delete all apis
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
write-output ("Step 1")
$restapi=aws apigateway create-rest-api --name 'testapi' --region eu-west-1 --endpoint-configuration types=REGIONAL
$restapi=$restapi | ConvertFrom-Json

##2
write-output ("Step 2")
$resources=aws apigateway get-resources --rest-api-id $restapi.id --region eu-west-1
$resources=$resources | ConvertFrom-Json

write-output "Restapi.id: $($restapi.id)"

##3
write-output ("Step 3")
$resource=aws apigateway create-resource --rest-api-id $restapi.id --region eu-west-1 --parent-id $resources.items.id --path-part greeting
$resource=$resource | ConvertFrom-Json

write-output "resources.items.id: $($resources.items.id)"


##4
write-output ("Step 4")
aws apigateway put-method --rest-api-id $restapi.id --region eu-west-1 --resource-id $resource.id --http-method GET --authorization-type "NONE" --request-parameters method.request.querystring.greeter=false

write-output "resource.id: $($resource.id)"

##5
write-output ("Step 5")
aws apigateway put-method-response --region eu-west-1 --rest-api-id $restapi.id --resource-id $resource.id --http-method GET --status-code 200

##6  
write-output ("Step 6")
aws apigateway put-integration --region eu-west-1 --rest-api-id $restapi.id --resource-id $resource.id --http-method GET --type AWS --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB/invocations --request-templates file://c:/temp/integration-request-template.json --credentials arn:aws:iam::138752486395:role/lattuceorcl 
                                                                              
##7
write-output ("Step 7")
$guid=[guid]::NewGuid()
aws lambda add-permission --function-name arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --statement-id $guid --action lambda:InvokeFunction --source-arn arn:aws:execute-api:eu-west-1:138752486395:$($restapi.id)/*/GET/greeting  --principal apigateway.amazonaws.com


##8
write-output ("Step 8")
aws apigateway put-integration-response   --region eu-west-1 --rest-api-id $restapi.id --resource-id $resource.id --http-method GET --status-code 200 --selection-pattern `"`"


##9
#write-output ("Step 9")
#aws apigateway create-deployment --rest-api-id $restapi.id --stage-name test


#aws lambda add-permission --function-name GetStringFromDB --statement-id apigateway-test-getall-2 --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn "arn:aws:execute-api:eu-west-1:138752486395:ptt19w8jm4/*/GET/greeting"
