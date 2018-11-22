// Simplified API example
const http = require("http");
const os = require("os");

console.log("API - starting")

var hnd = function(req, res) {
  console.log("API - incoming request: " + req.connection.remoteAddress);
  res.writeHead(200, { 'Content-Type':'application/json' });
  var randomValue = Math.round(Math.random()*1000);
  res.end("{ \"hostname\":\"" + os.hostname()+"\", \"random\": \"" + randomValue + "\" }\n");
};

var server = http.createServer(hnd);
server.listen(8080);
