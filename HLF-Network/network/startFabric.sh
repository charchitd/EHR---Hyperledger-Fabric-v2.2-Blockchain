#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -ex

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
starttime=$(date +%s)
CC_SRC_LANGUAGE=${1:-"javascript"}
CC_SRC_LANGUAGE=`echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:]`
if [ "$CC_SRC_LANGUAGE" = "go" -o "$CC_SRC_LANGUAGE" = "golang"  ]; then
	CC_RUNTIME_LANGUAGE=golang
	CC_SRC_PATH=github.com/hyperledger/fabric-samples/chaincode/EHR/
	echo Vendoring Go dependencies ...
	pushd ../chaincode/EHR
	GO111MODULE=on go mod vendor
	popd
	echo Finished vendoring js dependencies

elif [ "$CC_SRC_LANGUAGE" = "javascript" ]; then
echo "Installing Chaincode-------------"
	CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js
	CC_SRC_PATH=/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/EHR/javascript
     echo Compiling JS code into JavaScript ...
	pushd ../chaincode/EHR/javascript
	npm install
	npm rebuild
	popd
    echo "----------javascript Dependencies install ----------------"
elif [ "$CC_SRC_LANGUAGE" = "typescript" ]; then
	CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js
	CC_SRC_PATH=/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/EHR/typescript
	echo Compiling TypeScript code into JavaScript ...
	pushd ../chaincode/dsg/typescript
	npm install
	npm run build
	popd
	echo Finished compiling TypeScript code into JavaScript
else
	echo The chaincode language ${CC_SRC_LANGUAGE} is not supported by this script
	echo Supported chaincode languages are: go, java, javascript, and typescript
	exit 1
fi


# clean the keystore
rm -rf ./hfc-key-store

# launch network; create channel and join peer to channel
#pushd ../first-network
echo y | ./byfn.sh down
echo y | ./byfn.sh up -a -n -s couchdb
##popd

CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
ORG1_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp
ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt
ORG2_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/patients.ehr.com/users/Admin@patients.ehr.com/msp
ORG2_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/ca.crt
ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

PEER0_ORG1="docker exec
-e CORE_PEER_LOCALMSPID=Org1MSP
-e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051
-e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE}
cli
peer
--tls=true
--cafile=${ORDERER_TLS_ROOTCERT_FILE}
--orderer=orderer.ehr.com:7050"

PEER1_ORG1="docker exec
-e CORE_PEER_LOCALMSPID=Org1MSP
-e CORE_PEER_ADDRESS=peer1.hospitals.ehr.com:8051
-e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE}
cli
peer
--tls=true
--cafile=${ORDERER_TLS_ROOTCERT_FILE}
--orderer=orderer.ehr.com:7050"

PEER0_ORG2="docker exec
-e CORE_PEER_LOCALMSPID=Org2MSP
-e CORE_PEER_ADDRESS=peer0.patients.ehr.com:9051
-e CORE_PEER_MSPCONFIGPATH=${ORG2_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${ORG2_TLS_ROOTCERT_FILE}
cli
peer
--tls=true
--cafile=${ORDERER_TLS_ROOTCERT_FILE}
--orderer=orderer.ehr.com:7050"

PEER1_ORG2="docker exec
-e CORE_PEER_LOCALMSPID=Org2MSP
-e CORE_PEER_ADDRESS=peer1.patients.ehr.com:10051
-e CORE_PEER_MSPCONFIGPATH=${ORG2_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${ORG2_TLS_ROOTCERT_FILE}
cli
peer
--tls=true
--cafile=${ORDERER_TLS_ROOTCERT_FILE}
--orderer=orderer.ehr.com:7050"

echo "Packaging smart contract on peer0.hospitals.ehr.com"
${PEER0_ORG1} lifecycle chaincode package \
  EHR1.tar.gz \
  --path "$CC_SRC_PATH" \
  --lang "$CC_RUNTIME_LANGUAGE" \
  --label ehrv1

echo "Installing smart contract on peer0.hospitals.ehr.com"
${PEER0_ORG1} lifecycle chaincode install \
  EHR1.tar.gz

echo "Installing smart contract on peer1.hospitals.ehr.com"
${PEER1_ORG1} lifecycle chaincode install \
  EHR1.tar.gz

echo "Determining package ID for smart contract on peer0.hospitals.ehr.com"
REGEX='Package ID: (.*), Label: ehrv1'
if [[ `${PEER0_ORG1} lifecycle chaincode queryinstalled` =~ $REGEX ]]; then
  PACKAGE_ID_ORG1=${BASH_REMATCH[1]}
else
  echo Could not find package ID for ehrv1 chaincode on peer0.hospitals.ehr.com
  exit 1
fi

echo "Approving smart contract for org1: hospitals"
${PEER0_ORG1} lifecycle chaincode approveformyorg \
  --package-id ${PACKAGE_ID_ORG1} \
  --channelID ehrchannel \
  --name ehr \
  --version 1.0 \
  --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
  --sequence 1 \
  --waitForEvent

echo "Packaging smart contract on peer0.patients.ehr.com"
${PEER0_ORG2} lifecycle chaincode package \
  EHR1.tar.gz \
  --path "$CC_SRC_PATH" \
  --lang "$CC_RUNTIME_LANGUAGE" \
  --label ehrv1

echo "Installing smart contract on peer0.patients.ehr.com"
${PEER0_ORG2} lifecycle chaincode install EHR1.tar.gz

echo "Installing smart contract on peer1.patients.ehr.com"
${PEER1_ORG2} lifecycle chaincode install EHR1.tar.gz

echo "Determining package ID for smart contract on peer0.patients.ehr.com"
REGEX='Package ID: (.*), Label: ehrv1'
if [[ `${PEER0_ORG2} lifecycle chaincode queryinstalled` =~ $REGEX ]]; then
  PACKAGE_ID_ORG2=${BASH_REMATCH[1]}
else
  echo Could not find package ID for ehrv1 chaincode on peer0.patients.ehr.com
  exit 1
fi

echo "Approving smart contract for org2: Patients"
${PEER0_ORG2} lifecycle chaincode approveformyorg \
  --package-id ${PACKAGE_ID_ORG2} \
  --channelID ehrchannel \
  --name ehr \
  --version 1.0 \
  --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
  --sequence 1 \
  --waitForEvent

echo "Committing smart contract"
${PEER0_ORG1} lifecycle chaincode commit \
  --channelID ehrchannel \
  --name ehr \
  --version 1.0 \
  --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
  --sequence 1 \
  --waitForEvent \
  --peerAddresses peer0.hospitals.ehr.com:7051 \
  --peerAddresses peer0.patients.ehr.com:9051 \
  --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE} \
  --tlsRootCertFiles ${ORG2_TLS_ROOTCERT_FILE}

echo "Submitting initLedger transaction to smart contract on ehrchannel"
# echo "The transaction is sent to all of the peers so that chaincode is built before receiving the following requests"



${PEER0_ORG1} chaincode invoke \
  -C ehrchannel \
  -n ehr \
  -c '{"function":"Init","Args":[]}' \
  --waitForEvent \
  --waitForEventTimeout 3000s \
  --peerAddresses peer0.hospitals.ehr.com:7051 \
  --peerAddresses peer0.patients.ehr.com:9051 \
  --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE} \
  --tlsRootCertFiles ${ORG2_TLS_ROOTCERT_FILE}





# Temporary workaround (see FAB-15897) - cannot invoke across all four peers at the same time, so use a query to build
# the chaincode across the remaining peers.
#-C ehrchannel \
 # -n basic \
 #-c '{"function":"Invoke","Args":[]}' \
 #--peerAddresses peer1.org1.ehr.com:8051 \
 #--tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE}
#${PEER1_ORG2} chaincode query \
# -n basic\
 #-c '{"function":"Invoke","Args":[]}' \
#  --peerAddresses peer1.org2.ehr.com:10051 \
#  --tlsRootCertFiles ${ORG2_TLS_ROOTCERT_FILE}

cat <<EOF

Total setup execution time : $(($(date +%s) - starttime)) secs ...

Success !!
EOF
