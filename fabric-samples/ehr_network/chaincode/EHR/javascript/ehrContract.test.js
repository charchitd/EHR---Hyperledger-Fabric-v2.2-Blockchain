'use strict';
const sinon = require('sinon');
const chai = require('chai');
const mocha = require('mocha')

let describe = mocha.describe;
const it = mocha.it;

// const describe = mocha.describe
const sinonChai = require('sinon-chai');
const expect = chai.expect;

const { Context } = require('fabric-contract-api');
const { ChaincodeStub } = require('fabric-shim');

const EhrContract = require('./ehrContract.js');

const assert = sinon.assert;
chai.use(sinonChai);

    describe('EHR Basic Tests', () => {
    let transactionContext, chaincodeStub;
    beforeEach(() => {
        transactionContext = new Context();

        chaincodeStub = sinon.createStubInstance(ChaincodeStub);
        transactionContext.setChaincodeStub(chaincodeStub);

        chaincodeStub.putState.callsFake((key, value) => {
            if (!chaincodeStub.states) {
                chaincodeStub.states = {};
            }
            chaincodeStub.states[key] = value;
        });

        chaincodeStub.getState.callsFake(async (key) => {
            let ret;
            if (chaincodeStub.states) {
                ret = chaincodeStub.states[key];
            }
            return Promise.resolve(ret);
        });

        chaincodeStub.deleteState.callsFake(async (key) => {
            if (chaincodeStub.states) {
                delete chaincodeStub.states[key];
            }
            return Promise.resolve(key);
        });

        chaincodeStub.getStateByRange.callsFake(async () => {
            function* internalGetStateByRange() {
                if (chaincodeStub.states) {
                    // Shallow copy
                    const copied = Object.assign({}, chaincodeStub.states);

                    for (let key in copied) {
                        yield {value: copied[key]};
                    }
                }
            }

            return Promise.resolve(internalGetStateByRange());
        });

        const patient = [
            {
                ID : String(),
                name: String(),
                birthDate: String(),
                weight: Number(),
                height: parseFloat(),
                age: Number(),
                approveStatus:Boolean()
                
                
            }]
    });

    describe('Test Init', () => {
        it('should return error on Init', async () => {
            chaincodeStub.putState.rejects('failed inserting key');
            let ehr = new EhrContract();
            try {
                await ehr.Init(transactionContext);
                assert.fail('InitLedger should have failed');
            } catch (err) {
                expect(err.name).to.equal('failed inserting key');
            }
        });

        it('should return success on InitLedger', async () => {
            let ehr = new EhrContract();
            await ehr.Init(transactionContext);
            let ret = JSON.parse((await chaincodeStub.getState('patient1')).toString());
            expect(ret).to.eql(Object.assign({docType: 'patient'}, patient));
        });
    });

    describe('Test createPatient', () => {
        it('should return error on createPatient', async () => {
            chaincodeStub.putState.rejects('failed inserting key');

            let ehr = new EhrContract();
            try {
                await ehr.createPatient(transactionContext, patient.ID, patient.name, patient.birthDate, patient.weight, patient.height, patient.age, patient.approveStatus);
                assert.fail('createPatient should have failed');
            } catch(err) {
                expect(err.name).to.equal('failed inserting key');
            }
        });

        it('should return success on createPatient', async () => {
            let ehr = new EhrContract();

            await ehr.createPatient(transactionContext, patient.ID, patient.name, patient.birthDate, patient.weight, patient.height, patient.age, patient.approveStatus);

            let ret = JSON.parse((await chaincodeStub.getState(patient.ID)).toString());
            expect(ret).to.eql(patient);
        });
    });

    describe('Test readPatient', () => {
        it('should return error on readPatient', async () => {
            let ehr = new EhrContract();
            await ehr.createPatient(transactionContext, patient.ID, patient.name, patient.birthDate, patient.weight, patient.height, patient.age, patient.approveStatus);

            try {
                await ehr.readPatient(transactionContext, 'patient2');
                assert.fail('Readpatient should have failed');
            } catch (err) {
                expect(err.message).to.equal('The patient patient2 does not exist');
            }
        });

        it('should return success on readPatient', async () => {
            let ehr = new EhrContract();
            await ehr.createPatient(transactionContext, patient.ID, patient.name, patient.birthDate, patient.weight, patient.height, patient.age, patient.approveStatus);

            let ret = JSON.parse(await chaincodeStub.getState(patient.ID));
            expect(ret).to.eql(patient);
        });
    });

    describe('Test updatePatient', () => {
        it('should return error on updatePatient', async () => {
            let ehr = new ehr();
            await ehr.createPatient(transactionContext, patient.ID, patient.name, patient.birthDate, patient.weight, patient.height, patient.age, patient.approveStatus);

            try {
                await ehr.Updatepatient(transactionContext, 'patient2', 'Narayan', '11/02/1998', 78, 182.6, 24, 'false');
                assert.fail('Updatepatient should have failed');
            } catch (err) {
                expect(err.message).to.equal('The patient patient2 does not exist');
            }
        });

        it('should return success on Updatepatient', async () => {
            let ehr = new EhrContract();
            await ehr.createPatient(transactionContext, patient.ID, patient.name, patient.birthDate, patient.weight, patient.height, patient.age, patient.approveStatus);

            await ehr.updatePatient(transactionContext, 'patient1', 'Ritik', '30/05/1990', 72, 170, 32, false);
            let ret = JSON.parse(await chaincodeStub.getState(patient.ID));
            let expected = {
                ID: 'patient1',
                name: 'Ritik',
                birthDate:'30/05/1990',
                weight: 72,
                height: 170,
                age: 32,
                approveStatus: false
            };
            expect(ret).to.eql(expected);
        });
    });

    
    describe('Test queryAllPatients', () => {
        it('should return success on queryAllPatients', async () => {
            let ehr = new EhrContract();

            await ehr.createPatient(transactionContext, 'patient1', 'Narayan', '11/02/1998', 78, 180.6, 24, false);
            await ehr.createPatient(transactionContext, 'patient2', 'Ritik', '30/05/1990', 72, 170, 32, false);
            await ehr.createPatient(transactionContext, 'patient3', 'Mayank', '11/01/1998', 87, 177.5, 24, false);
            await ehr.createPatient(transactionContext, 'patient4', 'Arpit', '07/07/1998', 80, 178, 23, false);
        

            let ret = await ehr.queryAllPatients(transactionContext);
            ret = JSON.parse(ret);
            expect(ret.length).to.equal(4);

            let expected = [
                {Record: {ID: 'patient1', name: 'Narayan', birthDate: '11/02/1998', weight: 78, height: 180.6, age: 24, approveStatus: false}},
                {Record: {ID: 'patient2', name: 'Ritik', birthDate: '30/05/1990', weight: 72, height: 170, age: 32, approveStatus: false}},
                {Record: {ID: 'patient3', name: 'Mayank', birthDate: '11/01/1998', weight: 87, height: 177.5, age: 24, approveStatus: false}},
                {Record: {ID: 'patient4', name: 'Arpit', birthDate: '07/07/1998', weight: 80, height: 178, age: 23, approveStatus: false}},
            ];

            expect(ret).to.eql(expected);
        });

        it('should return success on GetAllpatients for non JSON value', async () => {
            let ehr = new EhrContract();

            chaincodeStub.putState.onFirstCall().callsFake((key, value) => {
                if (!chaincodeStub.states) {
                    chaincodeStub.states = {};
                }
                chaincodeStub.states[key] = 'non-json-value';
            });

            await ehr.createPatient(transactionContext, 'patient1', 'Narayan', '11/02/1998', 78, 180.6, 24, false);
            await ehr.createPatient(transactionContext, 'patient2', 'Ritik', '30/05/1990', 72, 170, 32, false);
            await ehr.createPatient(transactionContext, 'patient3', 'Mayank', '11/01/1998', 87, 177.5, 24, false);
            await ehr.createPatient(transactionContext, 'patient4', 'Arpit', '07/07/1998', 80, 178, 23, false);
        
            let ret = await ehr.queryAllPatients(transactionContext);
            ret = JSON.parse(ret);
            expect(ret.length).to.equal(4);

            let expected = [

                {Record: 'non-json-value'},
                // {Record: {ID: 'patient1', name: 'Narayan', birthDate: '11/02/1998', weight: 78, height: 180.6, age: 24, approveStatus: false}},
                {Record: {ID: 'patient2', name: 'Ritik', birthDate: '30/05/1990', weight: 72, height: 170, age: 32, approveStatus: false}},
                {Record: {ID: 'patient3', name: 'Mayank', birthDate: '11/01/1998', weight: 87, height: 177.5, age: 24, approveStatus: false}},
                {Record: {ID: 'patient4', name: 'Arpit', birthDate: '07/07/1998', weight: 80, height: 178, age: 23, approveStatus: false}},

                
                // {Record: {ID: 'patient2', Color: 'orange', Size: 10, Owner: 'Paul', AppraisedValue: 200}},
                // {Record: {ID: 'patient3', Color: 'red', Size: 15, Owner: 'Troy', AppraisedValue: 300}},
                // {Record: {ID: 'patient4', Color: 'pink', Size: 20, Owner: 'Van', AppraisedValue: 400}}
            ];

            expect(ret).to.eql(expected);
        });
    });
});
