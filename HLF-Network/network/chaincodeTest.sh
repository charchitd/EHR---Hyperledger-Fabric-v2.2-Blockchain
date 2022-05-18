#!/bin/bash

cd ../chaincode/EHR/javascript

## Treatment Records 

#// Query test

treatmentQueryTest()

{

docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051 -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt cli peer --tls=true --cafile=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem --orderer=orderer.ehr.com:7050 chaincode query -C ehrchannel -n ehr -c '{"function":"readTreatmentRecords","Args":["PATIENTTREAT1"]}'

}
#Output : {"ID":"TR-789f2","docType":"patientTreatment","doctorName":"L Mohan","hospitalId":"002","name":" ortho treatment","patientId":"02","status":"first-visit","visitDate":"10-01-2020 16:22:22"}

#// Invoke

treatmentInvokeTest()
{

docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051 -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt cli peer --tls=true --cafile=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem --orderer=orderer.ehr.com:7050 chaincode invoke -C ehrchannel -n ehr -c '{"function":"createTreatmentRecords","Args":["treatmentId", "ICU", "001", "02", "A.K John", "second-visit", "11-02-2021 04:08:22"]}' --waitForEvent --waitForEventTimeout 300s --peerAddresses peer0.hospitals.ehr.com:7051 --peerAddresses peer0.patients.ehr.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/ca.crt

}


## Patient Records


#// Query test
patientQueryTest()
{

docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051 -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt cli peer --tls=true --cafile=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem --orderer=orderer.ehr.com:7050 chaincode query -C ehrchannel -n ehr -c '{"function":"readPatient","Args":["PATIENT1"]}'

}
#// Invoke 

patientInvokeTest()

{

docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051 -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt cli peer --tls=true --cafile=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem --orderer=orderer.ehr.com:7050 chaincode invoke -C ehrchannel -n ehr -c '{"function":"createPatient","Args":["patientId", "name", "birthDate", "weight", "height", "age", "approveStatus"]}' --waitForEvent --waitForEventTimeout 300s --peerAddresses peer0.hospitals.ehr.com:7051 --peerAddresses peer0.patients.ehr.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/ca.crt

}

## Hospital Records


#// Query test

hospitalQueryTest()

{

docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051 -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt cli peer --tls=true --cafile=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem --orderer=orderer.ehr.com:7050 chaincode query -C ehrchannel -n ehr -c '{"function":"readHospital","Args":["HOSPITAL1"]}'

}

#// Invoke

hospitalInvokeTest()

{
docker exec -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_ADDRESS=peer0.hospitals.ehr.com:7051 -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt cli peer --tls=true --cafile=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem --orderer=orderer.ehr.com:7050 chaincode invoke -C ehrchannel -n ehr -c '{"function":"createHospital","Args":["hospitalId", "name","address", "doctorList"]}' --waitForEvent --waitForEventTimeout 300s --peerAddresses peer0.hospitals.ehr.com:7051 --peerAddresses peer0.patients.ehr.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/ca.crt
}


sleep 2
echo " "
echo " =========== Query test for patient Treatment records ========== "

treatmentQueryTest

sleep 2
echo " "
echo "=========== Invoke test for patient Treatment records ======"

treatmentInvokeTest

sleep 2

echo " "
echo "=========== Query test for patient records ======"

patientQueryTest

sleep 2

echo " "
echo "=========== Invoke test for patient records ======"

patientInvokeTest

sleep 2

echo " "
echo "=========== Query test for Hospital records ======"

hospitalQueryTest

sleep 2

echo " "
echo "=========== Invoke test for Hospital records ======"

hospitalInvokeTest
