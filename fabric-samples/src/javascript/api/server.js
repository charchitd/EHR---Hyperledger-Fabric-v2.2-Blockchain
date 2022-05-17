

// nodejs server setup 


const express       = require('express');        // call express
const morgan        = require('morgan');
const mongo         = require('mongoose');                 // define our app using express
const bodyParser    = require('body-parser');
const path          = require('path');
const route         = require('auth.js');




mongo.conect('mongodb://localhost:27017/testsdk', {useNewUrlParser: true, useUnifiedTopology: true})
const db = mongo.connection

db.on('error', (err) => {

    console.log(err)
})

db.once('open', () => {


})


// instantiate the app
const app = express();

// Load all of our middleware
// configure app to use bodyParser()
// this will let us get the data from a POST
// app.use(express.static(__dirname + '/client'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/uploads', express('uploads'))
// this line requires and runs the code from our routes.js file and passes it app
// app.use('/', require("./routes"));


// set up a static file server that points to the "client" directory
// app.use(express.static(path.join(__dirname, './client')));
// var ip = require("ip");
// console.dir ( ip.address() );
// Save our port
const port = process.env.PORT || 3000;

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

app.use('/api', route);