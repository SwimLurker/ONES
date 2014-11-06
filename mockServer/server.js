 var http = require('http')

 var os = require('os')

 var config = readConfig()

 sleep = function(milliSecond){
 	var start = new Date().getTime() + milliSecond
 	while(new Date().getTime() < start){}
 }

 http.createServer(function (request, response){ 

 	console.log("--received request:" +request.url +", method:" +request.method + " from client:" + request.connection.remoteAddress);
	if (request.method == "POST" || request.method == "PUT"){
		request.addListener("data", function(dataChunk){
			console.log("----request data: " + dataChunk )
		})
	}else if (request.method == "GET" || request.method == "DELETE"){
		var url = require('url')
		var params = url.parse(request.url,true).query

		console.log("----request parameter: " + JSON.stringify(params))
	}
 	var methodMapping = config[request.method]
 	if (methodMapping){
 		var urlMapping = methodMapping[request.url]
 		if (urlMapping){
 			console.log("----response code:" + urlMapping.responseCode);
 			console.log("----response header:" + JSON.stringify(urlMapping.headers));

 			response.writeHead(urlMapping.responseCode, urlMapping.headers);
 			var responseText = urlMapping["response"];
 			if(responseText ==  undefined) {
 				responseText = readResponseText(urlMapping["responseFile"]);
 			}
 			console.log("----response body:" + responseText)

 			if(urlMapping.delayedMS != undefined){
 				sleep(urlMapping.delayedMS)
 			}
 			response.end(responseText);
 		}else{
 			response.writeHead(404,{'Content-Type': "text/plain"});
 			response.end("Not Found");
 
 		}
 	}else{
 		response.writeHead(405,{'Content-Type': "text/plain"});
 		response.end("Method:" +request.method + " Not Allowed");
 	}
 }).listen(8080);

 console.log('Server running at http://127.0.0.1:8080/');

 function readConfig(){

 	var result = new Object()
 	var fs = require('fs')
 	return JSON.parse(fs.readFileSync('config.json'));
 }

 function readResponseText(filename){
 	var fs = require('fs')
 	try{
 		return fs.readFileSync(filename, 'utf-8')
 	}catch(exp){
 		console.error(exp)
 	}
 }