#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/hospitals.ehr.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hospitals.ehr.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitals.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitals.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitals.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospitals.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-hospitals --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-hospitals --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-hospitals --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hospitals -M ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/msp --csr.hosts peer0.hospitals.ehr.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hospitals -M ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls --enrollment.profile tls --csr.hosts peer0.hospitals.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hospitals/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/tlsca/tlsca.hospitals.ehr.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/ca
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/ca/ca.hospitals.ehr.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-hospitals -M ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/users/User1@hospitals.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/users/User1@hospitals.ehr.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-hospitals -M ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/users/Admin@hospitals.ehr.com/msp/config.yaml
}


## patients - PATIENTS
function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/patients.ehr.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/patients.ehr.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-patients --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-patients.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-patients.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-patients.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-patients.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-patients --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-patients --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-patients --id.name patientsadmin --id.secret patientsadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/msp --csr.hosts peer0.patients.ehr.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls --enrollment.profile tls --csr.hosts peer0.patients.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca/tlsca.patients.ehr.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca/ca.patients.ehr.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/User1@patients.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/User1@patients.ehr.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/Admin@patients.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/Admin@patients.ehr.com/msp/config.yaml
}


## Orderer Org
function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/ehr.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/ehr.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp --csr.hosts orderer.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls --enrollment.profile tls --csr.hosts orderer.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp/config.yaml
}
