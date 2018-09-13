### Create rest api
xxxx aws apigateway create-rest-api --name 'testapi3 (AWS CLI, Regional)' --description 'testapi3 desc' --region eu-west-1 --endpoint-configuration '{ "types": ["REGIONAL"] }'
aws apigateway create-rest-api --name 'testapi3' --description 'testapi3desc' --region eu-west-1
> 8v9lk2i3ec

### get resources
aws apigateway get-resources --rest-api-id 8v9lk2i3ec --region eu-west-1
> wwjcv59um0

### create resource
aws apigateway create-resource --rest-api-id 8v9lk2i3ec --region eu-west-1 --parent-id wwjcv59um0 --path-part GET
>     "path": "/GET",
    "pathPart": "GET",
    "id": "39u22g",
    "parentId": "wwjcv59um0"


###
aws apigateway put-method --rest-api-id 8v9lk2i3ec --resource-id 39u22g --http-method GET --authorization-type "NONE" --region eu-west-1
{
    "apiKeyRequired": false,
    "httpMethod": "GET",
    "authorizationType": "NONE"
}

### 5
aws apigateway put-method-response --rest-api-id 8v9lk2i3ec --resource-id 39u22g --http-method GET --status-code 200  --region eu-west-1
{
    "statusCode": "200"
}


aws apigateway put-integration \
        --region eu-west-1
        --rest-api-id 8v9lk2i3ec \
        --resource-id 39u22g \
        --http-method GET \
        --type AWS \
        --integration-http-method GET \
        --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB \
        --request-templates file://path/to/integration-request-template.json \
        --credentials arn:aws:iam::138752486395:role/lattuceorcl

aws apigateway put-integration --region eu-west-1 --rest-api-id 8v9lk2i3ec --resource-id 39u22g --http-method GET --type AWS --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --credentials arn:aws:iam::138752486395:role/lattuceorcl


### 7
 aws apigateway put-integration-response --region eu-west-1  --rest-api-id 8v9lk2i3ec     --resource-id 39u22g  --http-method GET    --status-code 200         --selection-pattern ""  



===========
https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-custom-integrations.html
arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB

##1
aws apigateway create-rest-api --name 'testapi4' --region eu-west-1
{
    "apiKeySource": "HEADER",
    "name": "'testapi4'",
    "createdDate": 1536788914,
    "endpointConfiguration": {
        "types": [
            "EDGE"
        ]
    },
    "id": "dl2vghd1qe"
}

##2
aws apigateway get-resources --rest-api-id dl2vghd1qe --region eu-west-1
{
    "items": [
        {
            "path": "/",
            "id": "xhasquizpi"
        }
    ]
}

##3
aws apigateway create-resource --rest-api-id dl2vghd1qe --region eu-west-1 --parent-id xhasquizpi --path-part greeting
{
    "path": "/greeting",
    "pathPart": "greeting",
    "id": "74rlw8",
    "parentId": "xhasquizpi"
}

##4
aws apigateway put-method --rest-api-id dl2vghd1qe --region eu-west-1 --resource-id 74rlw8 --http-method GET --authorization-type "NONE" --request-parameters method.request.querystring.greeter=false
{
    "apiKeyRequired": false,
    "httpMethod": "GET",
    "authorizationType": "NONE",
    "requestParameters": {
        "method.request.querystring.greeter": false
    }
}

##5
aws apigateway put-method-response --region eu-west-1 --rest-api-id dl2vghd1qe --resource-id 74rlw8 --http-method GET --status-code 200
{
    "statusCode": "200"
}

##6  
aws apigateway put-integration --region eu-west-1 --rest-api-id dl2vghd1qe --resource-id 74rlw8 --http-method GET --type AWS --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --request-templates file://c:/temp/integration-request-template.json --credentials arn:aws:iam::138752486395:role/lattuceorcl 
{
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB",
    "httpMethod": "POST",
    "cacheNamespace": "74rlw8",
    "credentials": "arn:aws:iam::138752486395:role/lattuceorcl",
    "type": "AWS",
    "cacheKeyParameters": []
}

##6.5
You are about to give API Gateway permission to invoke your Lambda function:
arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB
aws lambda add-permission --function-name arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --statement-id apigateway-beta-6 --action lambda:* --principal apigateway.amazonaws.com

##7
aws apigateway put-integration-response --region eu-west-1  --rest-api-id dl2vghd1qe --resource-id 74rlw8 --http-method GET    --status-code 200         --selection-pattern ""  
{
    "selectionPattern": "",
    "statusCode": "200"
}

##8
aws apigateway create-deployment --rest-api-id dl2vghd1qe --stage-name test
{
    "id": "1n8dhu",
    "createdDate": 1536789625
}