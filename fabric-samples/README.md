[//]: # (SPDX-License-Identifier: CC-BY-4.0)

# Hyperledger Fabric Samples

You can use Fabric samples to get started working with Hyperledger Fabric, explore important Fabric features, and learn how to build applications that can interact with blockchain networks using the Fabric SDKs. To learn more about Hyperledger Fabric, visit the [Fabric documentation](https://hyperledger-fabric.readthedocs.io/en/latest).

## Getting started with the Electronic Health Record Network

* Go to ehr_network file `$ cd ehr_network`
* Run network.sh file `$ ./network.sh up createChannel`
* To DeployCC : `$ ./network.sh deployCC -ccn basic -ccp ./chaincode/EHR/javascript/ -cci Init -ccl javascript`
* To Restart the Network: `$ ./restartNet.sh` - **This will Restart the whole network and DeployCC as well**


