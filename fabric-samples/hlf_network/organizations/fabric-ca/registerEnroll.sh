#!/bin/bash

#  Org1 - hospitals
function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/hospitals.ehr.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hospitals.ehr.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-hospitals --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
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

###  ======================== peer0-tls ======================================

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hospitals -M ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer0.hospitals.ehr.com/tls --enrollment.profile tls --csr.hosts peer0.hospitals.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
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
 
###  ======================== peer1-tls ======================================

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-hospitals -M ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls --enrollment.profile tls --csr.hosts peer1.hospitals.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/tlsca/tlsca.hospitals.ehr.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/ca
  cp ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/peers/peer1.hospitals.ehr.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hospitals.ehr.com/ca/ca.hospitals.ehr.com-cert.pem

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


# function createpatients() {
#   infoln "Enrolling the CA admin"
#   mkdir -p organizations/peerOrganizations/patients.ehr.com/

#   export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/patients.ehr.com/

#   set -x
#   fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-patients --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   echo 'NodeOUs:
#   Enable: true
#   ClientOUIdentifier:
#     Certificate: cacerts/localhost-8054-ca-patients.pem
#     OrganizationalUnitIdentifier: client
#   PeerOUIdentifier:
#     Certificate: cacerts/localhost-8054-ca-patients.pem
#     OrganizationalUnitIdentifier: peer
#   AdminOUIdentifier:
#     Certificate: cacerts/localhost-8054-ca-patients.pem
#     OrganizationalUnitIdentifier: admin
#   OrdererOUIdentifier:
#     Certificate: cacerts/localhost-8054-ca-patients.pem
#     OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml

#   infoln "Registering peer0"
#   set -x
#   fabric-ca-client register --caname ca-patients --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null


#   infoln "Registering peer1"
#   set -x
#   fabric-ca-client register --caname ca-patients --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   infoln "Registering user"
#   set -x
#   fabric-ca-client register --caname ca-patients --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   infoln "Registering the org admin"
#   set -x
#   fabric-ca-client register --caname ca-patients --id.name patientsadmin --id.secret patientsadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null


#   infoln "Generating the peer0 msp"
#   set -x
#   fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/msp --csr.hosts peer0.patients.ehr.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/msp/config.yaml

  
#   infoln "Generating the peer1 msp"
#   set -x
#   fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/msp --csr.hosts peer1.patients.ehr.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/msp/config.yaml

#   # ======================= Peer 0 TLS =================================

#   infoln "Generating the peer0-tls certificates"
#   set -x
#   fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls --enrollment.profile tls --csr.hosts peer0.patients.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/ca.crt
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/server.crt
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/server.key

#   mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts/ca.crt

#   mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca/tlsca.patients.ehr.com-cert.pem

#   mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer0.patients.ehr.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca/ca.patients.ehr.com-cert.pem
  
#   # ================= Peer 1 TLS ============================
  
#   infoln "Generating the peer1-tls certificates"
#   set -x
#   fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls --enrollment.profile tls --csr.hosts peer1.patients.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/ca.crt
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/server.crt
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/server.key

#   mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts/ca.crt

#   mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca/tlsca.patients.ehr.com-cert.pem

#   mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca
#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca/ca.patients.ehr.com-cert.pem

# #  ======================================================================

#   infoln "Generating the user msp"
#   set -x
#   fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/User1@patients.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/User1@patients.ehr.com/msp/config.yaml

#   infoln "Generating the org admin msp"
#   set -x
#   fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/Admin@patients.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/Admin@patients.ehr.com/msp/config.yaml
# }



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
  
  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-patients --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
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

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/msp --csr.hosts peer1.patients.ehr.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/msp/config.yaml

  # ===================== Org2 - Peer 0 TLS ================================
  
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
  
  
  # ===================== Org2 - Peer 1 TLS ================================
  
  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls --enrollment.profile tls --csr.hosts peer1.patients.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/tlsca/tlsca.patients.ehr.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca
  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/peers/peer1.patients.ehr.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/patients.ehr.com/ca/ca.patients.ehr.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/User1@patients.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/patients.ehr.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/User1@patients.ehr.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://patientsadmin:patientsadminpw@localhost:8054 --caname ca-patients -M ${PWD}/organizations/peerOrganizations/patients.ehr.com/users/Admin@patients.ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
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
  # fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer2 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-orderer3 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://admin:adminpw@localhost:12054 --caname ca-orderer4 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://admin:adminpw@localhost:13054 --caname ca-orderer5 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  ## change

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
  
  
  # echo 'NodeOUs: 
  # Enable: true
  # ClientOUIdentifier:
  #   Certificate: cacerts/localhost-10054-ca-orderer2.pem
  #   OrganizationalUnitIdentifier: client
  # PeerOUIdentifier:
  #   Certificate: cacerts/localhost-10054-ca-orderer2.pem
  #   OrganizationalUnitIdentifier: peer
  # AdminOUIdentifier:
  #   Certificate: cacerts/localhost-10054-ca-orderer2.pem
  #   OrganizationalUnitIdentifier: admin
  # OrdererOUIdentifier:
  #   Certificate: cacerts/localhost-10054-ca-orderer2.pem
  #   OrganizationalUnitIdentifier: orderer2' >${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml
  
  
  # echo 'NodeOUs: 
  # Enable: true
  # ClientOUIdentifier:
  #   Certificate: cacerts/localhost-11054-ca-orderer3.pem
  #   OrganizationalUnitIdentifier: client
  # PeerOUIdentifier:
  #   Certificate: cacerts/localhost-11054-ca-orderer3.pem
  #   OrganizationalUnitIdentifier: peer
  # AdminOUIdentifier:
  #   Certificate: cacerts/localhost-11054-ca-orderer3.pem
  #   OrganizationalUnitIdentifier: admin
  # OrdererOUIdentifier:
  #   Certificate: cacerts/localhost-11054-ca-orderer3.pem
  #   OrganizationalUnitIdentifier: orderer3' >${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml
  
  
  # echo 'NodeOUs: 
  # Enable: true
  # ClientOUIdentifier:
  #   Certificate: cacerts/localhost-12054-ca-orderer4.pem
  #   OrganizationalUnitIdentifier: client
  # PeerOUIdentifier:
  #   Certificate: cacerts/localhost-12054-ca-orderer4.pem
  #   OrganizationalUnitIdentifier: peer
  # AdminOUIdentifier:
  #   Certificate: cacerts/localhost-12054-ca-orderer4.pem
  #   OrganizationalUnitIdentifier: admin
  # OrdererOUIdentifier:
  #   Certificate: cacerts/localhost-12054-ca-orderer4.pem
  #   OrganizationalUnitIdentifier: orderer4' >${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml
  
  
  # echo 'NodeOUs: 
  # Enable: true
  # ClientOUIdentifier:
  #   Certificate: cacerts/localhost-13054-ca-orderer5.pem
  #   OrganizationalUnitIdentifier: client
  # PeerOUIdentifier:
  #   Certificate: cacerts/localhost-13054-ca-orderer5.pem
  #   OrganizationalUnitIdentifier: peer
  # AdminOUIdentifier:
  #   Certificate: cacerts/localhost-13054-ca-orderer5.pem
  #   OrganizationalUnitIdentifier: admin
  # OrdererOUIdentifier:
  #   Certificate: cacerts/localhost-13054-ca-orderer5.pem
  #   OrganizationalUnitIdentifier: orderer5' >${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml

  
  
  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer2 --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer3 --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer4 --id.name orderer4 --id.secret orderer4pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer5 --id.name orderer5 --id.secret orderer5pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin" ##### root cause
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer2 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer3 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer4 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client register --caname ca-orderer5 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp --csr.hosts orderer.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer2 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/msp --csr.hosts orderer2.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:11054 --caname ca-orderer3 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/msp --csr.hosts orderer3.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:12054 --caname ca-orderer4 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/msp --csr.hosts orderer4.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:13054 --caname ca-orderer5 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/msp --csr.hosts orderer5.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls --enrollment.profile tls --csr.hosts orderer.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer2 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls --enrollment.profile tls --csr.hosts orderer2.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:11054 --caname ca-orderer3 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls --enrollment.profile tls --csr.hosts orderer3.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:12054 --caname ca-orderer4 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls --enrollment.profile tls --csr.hosts orderer4.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://orderer:ordererpw@localhost:13054 --caname ca-orderer5 -M ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls --enrollment.profile tls --csr.hosts orderer5.ehr.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null



  # =============== Orderer ==============================
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem
  
  # # =============== Orderer2 ==============================
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/ca.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/server.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/server.key

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer2.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem
  
  # # =============== Orderer3 ================================
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/ca.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/server.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/server.key

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer3.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem
  
  
  # # =============== Orderer4 ==============================
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/ca.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/server.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/server.key

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer4.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem
 
 
  # # =============== Orderer5 ==============================

  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/ca.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/server.crt
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/server.key

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  # mkdir -p ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/ehr.com/orderers/orderer5.ehr.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ehr.com/msp/tlscacerts/tlsca.ehr.com-cert.pem

  # =================================================================

  
  
  
  
  
  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer2 -M ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:11054 --caname ca-orderer3 -M ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:12054 --caname ca-orderer4 -M ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:13054 --caname ca-orderer5 -M ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/ehr.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ehr.com/users/Admin@ehr.com/msp/config.yaml





}
