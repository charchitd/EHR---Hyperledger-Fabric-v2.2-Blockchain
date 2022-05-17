// controller

const User = require('user.js');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const register = (req, res, next) => {
    bcrypt.hash(req.body.password, 10, function(err, hashedPass){

        if (err)
            {
                res.json({
                        
                        error: err
                })
            }

            let user = new User ({

        
                user_name: req.body.user_name,
                user_id: req.body.user_id,
                pass: hashedPass
        
            })
        
            user.save()
            .then(user => {
        
                res.json({
                    message : "Successfully Authenticated"
                })
            })
        
            .catch(error => {
        
                res.json({
        
                    message : "Error 404"
                })
            })
    })

   
} 

module.exports = {

    register
}
