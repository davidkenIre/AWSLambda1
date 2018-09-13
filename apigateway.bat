https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-custom-integrations.html
arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB

##1
aws apigateway create-rest-api --name 'testapi5' --region eu-west-1 --endpoint-configuration types=REGIONAL
{
    "apiKeySource": "HEADER",
    "name": "'testapi5'",
    "createdDate": 1536862991,
    "endpointConfiguration": {
        "types": [
            "REGIONAL"
        ]
    },
    "id": "2chntb7zif"
}

##2
aws apigateway get-resources --rest-api-id 2chntb7zif --region eu-west-1
{
    "items": [
        {
            "path": "/",
            "id": "j66yqbvgwf"
        }
    ]
}

##3
aws apigateway create-resource --rest-api-id 2chntb7zif --region eu-west-1 --parent-id j66yqbvgwf --path-part greeting
{
    "path": "/greeting",
    "pathPart": "greeting",
    "id": "q0lgtc",
    "parentId": "j66yqbvgwf"
}

##4
aws apigateway put-method --rest-api-id 2chntb7zif --region eu-west-1 --resource-id q0lgtc --http-method GET --authorization-type "NONE" --request-parameters method.request.querystring.greeter=false
{
    "apiKeyRequired": false,
    "httpMethod": "GET",
    "authorizationType": "NONE",
    "requestParameters": {
        "method.request.querystring.greeter": false
    }
}

##5
aws apigateway put-method-response --region eu-west-1 --rest-api-id 2chntb7zif --resource-id q0lgtc --http-method GET --status-code 200
{
    "statusCode": "200"
}


##6  
aws apigateway put-integration --region eu-west-1 --rest-api-id 2chntb7zif --resource-id q0lgtc --http-method GET --type AWS_PROXY --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --request-templates file://c:/temp/integration-request-template.json --credentials arn:aws:iam::138752486395:role/lattuceorcl 
{
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB",
    "httpMethod": "POST",
    "requestTemplates": {
        "application/json": "{\"greeter\":\"$input.params('greeter')\"}"
    },
    "cacheNamespace": "q0lgtc",
    "credentials": "arn:aws:iam::138752486395:role/lattuceorcl",
    "type": "AWS",
    "cacheKeyParameters": []
}

##6.5
You are about to give API Gateway permission to invoke your Lambda function:
arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB
aws lambda add-permission --function-name arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --statement-id apigateway-beta-6 --action lambda:* --principal apigateway.amazonaws.com
{
    "Statement": "{\"Sid\":\"apigateway-beta-9\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"apigateway.amazonaws.com\"},\"Action\":\"lambda:*\",\"Resource\":\"arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB\"}"
}

##7
aws apigateway put-integration-response --region eu-west-1  --rest-api-id 2chntb7zif --resource-id q0lgtc --http-method GET    --status-code 200         --selection-pattern ""  
{
    "selectionPattern": "",
    "statusCode": "200"
}

##8
aws apigateway create-deployment --rest-api-id 2chntb7zif --stage-name test
{
    "id": "1n8dhu",
    "createdDate": 1536789625
}

=========== Lambda Proxy Integration
##1
aws apigateway create-rest-api --name testapi7 --region eu-west-1 --endpoint-configuration types=REGIONAL
{
    "apiKeySource": "HEADER",
    "name": "testapi7",
    "createdDate": 1536870371,
    "endpointConfiguration": {
        "types": [
            "REGIONAL"
        ]
    },
    "id": "3r12i5v7pd"
}


##2
aws apigateway get-resources --rest-api-id 3r12i5v7pd --region eu-west-1
{
    "items": [
        {
            "path": "/",
            "id": "hfw79orfd4"
        }
    ]
}

##3
aws apigateway create-resource --rest-api-id 3r12i5v7pd --region eu-west-1 --parent-id hfw79orfd4 --path-part {proxy+}
{
    "path": "/{proxy+}",
    "pathPart": "{proxy+}",
    "id": "jx565j",
    "parentId": "hfw79orfd4"
}

##4
aws apigateway put-method --rest-api-id 3r12i5v7pd --region eu-west-1 --resource-id jx565j --http-method ANY --authorization-type "NONE" 
{
    "apiKeyRequired": false,
    "httpMethod": "ANY",
    "authorizationType": "NONE"
}

##5
aws apigateway put-integration --region eu-west-1 --rest-api-id 3r12i5v7pd --resource-id jx565j --http-method ANY --type AWS_PROXY --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB/invocations --credentials arn:aws:iam::138752486395:role/lattuceorcl 
{
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB/invocations",
    "httpMethod": "POST",
    "cacheNamespace": "jx565j",
    "credentials": "arn:aws:iam::138752486395:role/lattuceorcl",
    "type": "AWS_PROXY",
    "cacheKeyParameters": []
}

##5.5
aws lambda add-permission --function-name arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB/*/* --statement-id apigateway-beta-10 --action lambda:* --principal apigateway.amazonaws.com

##6
aws apigateway create-deployment --rest-api-id 3r12i5v7pd --stage-name test
{
    "id": "xaxxnl",
    "createdDate": 1536870514
}


=========== Lambda Custom Integration
###1
aws apigateway create-rest-api --name "HelloWorld (AWS CLI)" --region eu-west-1
{
    "apiKeySource": "HEADER",
    "name": "HelloWorld (AWS CLI)",
    "createdDate": 1536871413,
    "endpointConfiguration": {
        "types": [
            "EDGE"
        ]
    },
    "id": "ptt19w8jm4"
}

##2 
aws apigateway get-resources --rest-api-id ptt19w8jm4 --region eu-west-1
{
    "items": [
        {
            "path": "/",
            "id": "4eqm1yemb8"
        }
    ]
}

##3 
aws apigateway create-resource --rest-api-id ptt19w8jm4 --region eu-west-1 --parent-id 4eqm1yemb8 --path-part greeting
{
    "path": "/greeting",
    "pathPart": "greeting",
    "id": "vlyzll",
    "parentId": "4eqm1yemb8"
}

##4 
aws apigateway put-method --rest-api-id ptt19w8jm4 --region eu-west-1 --resource-id vlyzll --http-method GET --authorization-type "NONE" --request-parameters method.request.querystring.greeter=false
aws apigateway put-method --rest-api-id ptt19w8jm4 --region eu-west-1 --resource-id vlyzll --http-method GET --authorization-type NONE

{
    "apiKeyRequired": false,
    "httpMethod": "GET",
    "authorizationType": "NONE",
    "requestParameters": {
        "method.request.querystring.greeter": false
    }
}

##5 
aws apigateway put-method-response --region eu-west-1 --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET --status-code 200
aws apigateway put-method-response --region eu-west-1 --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET --status-code 200 --response-models "{\"application/json\": \"Empty\"}"
{
    "statusCode": "200"
}

##6 
aws apigateway put-integration --region eu-west-1 --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET --type AWS --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB --request-templates file://c:/temp/integration-request-template.json --credentials arn:aws:iam::138752486395:role/lattuceorcl 
aws apigateway put-integration --region eu-west-1 --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET --type AWS --integration-http-method POST --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB/invocations --credentials arn:aws:iam::138752486395:role/lattuceorcl 

{
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-04-31/functions/arn:aws:lambda:eu-west-1:138752486395:function:GetStringFromDB",
    "httpMethod": "POST",
    "requestTemplates": {
        "application/json": "{\"greeter\":\"$input.params('greeter')\"}"
    },
    "cacheNamespace": "vlyzll",
    "credentials": "arn:aws:iam::138752486395:role/lattuceorcl",
    "type": "AWS",
    "cacheKeyParameters": []
}

##7
aws apigateway put-integration-response --region eu-west-1 --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET --status-code 200 --selection-pattern ""  
aws apigateway put-integration-response --region eu-west-1 --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET --status-code 200 --response-templates "{\"application/json\": \"Empty\"}"
{
    "selectionPattern": "",
    "statusCode": "200"
}        




aws lambda add-permission --function-name GetStringFromDB --statement-id apigateway-test-getall-2 --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn "arn:aws:execute-api:eu-west-1:138752486395:ptt19w8jm4/*/GET/greeting"



##8 
aws apigateway create-deployment --rest-api-id ptt19w8jm4 --stage-name test


###9  
aws apigateway test-invoke-method --rest-api-id ptt19w8jm4 --resource-id vlyzll --http-method GET