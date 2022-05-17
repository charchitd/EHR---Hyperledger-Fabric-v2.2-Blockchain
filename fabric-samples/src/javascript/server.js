//SPDX-License-Identifier: Apache-2.0

// nodejs server setup 

// call the packages we need
var express       = require('express');        // call express
var app           = express();                 // define our app using express
var bodyParser    = require('body-parser');
var path          = require('path');

// instantiate the app
var app = express();

// Load all of our middleware
// configure app to use bodyParser()
// this will let us get the data from a POST
// app.use(express.static(__dirname + '/client'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// this line requires and runs the code from our routes.js file and passes it app
app.use('/', require("./routes"));

// set up a static file server that points to the "client" directory
app.use(express.static(path.join(__dirname, './client')));
// var ip = require("ip");
// console.dir ( ip.address() );
// Save our port
var port = process.env.PORT || 8000;

// Start the server and listen on port 
app.listen(port,function(){
  console.log("Live on port: " + port);
});
// var http = require('http');
// http.createServer(function (req, res) {
//   res.writeHead(200, {'Content-Type': 'text/plain'});
//   res.end('Hello World\n');
// }).listen(8000, 'APP_PRIVATE_IP_ADDRESS');
// console.log('Server running at http://APP_PRIVATE_IP_ADDRESS:8000/');
