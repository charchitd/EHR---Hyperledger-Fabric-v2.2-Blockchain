
const express = require('express')
const authctl = require('authCtl.js')

const router = express.Router()

router.post('/register', authctl)

module.exports = router 

