
#!/bin/bash

sleep 2
./network.sh down

echo "Network Down Successfully"
sleep 3
echo "Starting Network ..."
./network.sh up createChannel

sleep 2

echo "Deploying Chaincode ..."

./network.sh deployCC -ccn ehrContract -ccp ./chaincode/EHR/javascript/ -cci Init -ccl javascript
