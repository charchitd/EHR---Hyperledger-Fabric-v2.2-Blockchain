
# cd ../network/
# ./teardown.sh
# cd ../app/
# ./startFabric.sh
# npm install
# node enrollAdmin
# node registerUser
# node server
cd ..
./startFabric.sh

cd javascript
sudo rm -rf node-module
sudo rm -rf wallet
npm install
npm install express
npm install ip
npm install date-format
npm audit fix

node enrollAdmin.js
node registerUser.js
node server.js

