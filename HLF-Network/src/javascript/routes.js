let express = require('express');
let router = express.Router();
let main = require('./controller.js');
let format = require('date-format');

module.exports = router;

router.use(function(req, res, next) {

  console.log(format.asString('hh:mm:ss.SSS', new Date())+'::............ '+req.url+' .............');
  next(); // make sure we go to the next routes and don't stop here

  function afterResponse() {
      res.removeListener('finish', afterResponse);          
  }    
  res.on('finish', afterResponse);

});
router.get('/test',main.test)
router.get('/getBarList',main.getBarList)
router.get('/getBar',main.getBar)
router.get('/queryBar',main.queryBar)
router.post('/createBar*', main.createBar);
router.get('/getBuy',main.getBuy)
router.get('/getBuyList',main.getBuyList)
router.get('/queryBuy',main.queryBuy)
router.post('/createBuy*', main.createBuy);
router.get('/getSell',main.getSell)
router.get('/getSellList',main.getSellList)
router.get('/querySell',main.querySell)
router.post('/createSell*', main.createSell);
router.get('/getTrade',main.getTrade)
router.get('/getTradeList',main.getTradeList)
router.get('/queryTrade',main.queryTrade)
router.post('/createTrade*', main.createTrade);
router.get('/getSend',main.getSend)
router.get('/getSendList',main.getSendList)
router.get('/querySend',main.querySend)
router.post('/createSend*', main.createSend);







