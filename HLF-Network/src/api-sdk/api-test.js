// test
var api = require('api-stub');
var config = [{

    path :'/status',
    data : {'Fname': 'Charchit',
        'Lname': 'Dhawan',
        'description' : 'testng successful',
        'status': true}

}]

var server = new api(config);
server.start(3000);


