// User Schema

const mongo = require('mongoose');
const Schema =  mongo.Schema;

const userinfo = new Schema({

    user_name: {
        type: string
    
    },
    user_id: {
        type: string
    
    },
    pass: {
        type: string
    
    },
    
}, {timestamps: true})

const User = mongo.model('User', userinfo)

module.exports = User;

// npm install bcryptjs jsonwebtoken
// 