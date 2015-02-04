var http = require('http');
var server = http.createServer();
var port = 22;
server.on('request', function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello World\n');
    console.log('Request handled.\n');
    })
server.listen(port);
console.log('Server running at http://localhost:', port);
