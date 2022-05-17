
// < ----------------  Electronic Health Records Chaincode ------------------ >

'use strict';
// const dateTime = require('date-and-time');

const { Contract } = require('fabric-contract-api');


class SmartContract extends Contract {

    async Init(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        
        const patient = [
            {
                ID : String(),
                name: String(),
                birthDate: String(),
                weight: Number(),
                height: parseFloat(),
                age: Number(),
                approveStatus:Boolean()
                
                
            },
            // {
            //     ID: '02',
            //     name: 'narayan',
            //     birthDate: '11/02/1998',
            //     weight: '78kg',
            //     height: '181cms',
            //     age: '24',
            //     approveStatus:'false' // by default..
                
            // },
        ];
       // pushing data to the ledger
        for (let i = 0; i < patient.length; i++) {
            patient[i].docType = 'patient';
            await ctx.stub.putState('PATIENT' + i, Buffer.from(JSON.stringify(patient[i])));
            console.info('Added <--> ', patient[i]);
        }



        const hospital = [
            {
                ID : String(),
                name: String(),
                address: String(),
                doctorList: [
                        {
                            name: String(),
                            dept: String(),
                        },

                        {
                            name: String(),
                            dept: String(),
                        },    
                    ]
                
            },
            // {
            //     ID : String(),
            //     name: 'Apollo Hospital',
            //     address: 'Bangalore, India',
            //     doctorList: [
            //             {
            //                 name: 'Nitin Menon',
            //                 dept: 'Dental',
            //             },

            //             {
            //                 name: 'L Mohan',
            //                 dept: 'Ortho',
            //             },    
            //         ]
                
          //  },
           
        ];

        for (let i = 0; i < hospital.length; i++) {
            hospital[i].docType = 'hospital';
            await ctx.stub.putState('HOSPITAL' + i, Buffer.from(JSON.stringify(hospital[i])));
            console.info('Added <--> ', hospital[i]);
        }



        // -------   Patient Treatment  Records ------------------
        const patientTreatment = [
            {
                ID: String(),
                name: String(),
                hospitalId: String(),
                patientId: String(),
                doctorName: String(),
                status: String(),
                visitDate: String()
            },

            // {
            //     ID: "TR-789f2",
            //     name: " ortho treatment",
            //     hospitalId: "002",
            //     patientId: "02",
            //     doctorName: "L Mohan",
            //     status: "first-visit",
            //     visitDate: "10-01-2020 16:22:22"
            // },
        ]

        for (let i = 0; i < patientTreatment.length; i++) {
            patientTreatment[i].docType = 'patientTreatment';
            await ctx.stub.putState('PATIENTTREAT' + i, Buffer.from(JSON.stringify(patientTreatment[i])));
            console.info('Added <--> ', patientTreatment[i]);
        }



        console.info('============= END : Initialize Patient Ledger ===========');
        // console.info('============= END : Initialize Hospital Ledger ===========');
    }

    // [ =========================== Patient records =========================== ]
    async patientExists(ctx, patientId) {
        const buffer = await ctx.stub.getState(patientId);
        return (!!buffer && buffer.length > 0); // if its noninvertable true and checking patient count is already exist
    }

    async createPatient(ctx, patientId, name, birthDate, weight, height, age, approveStatus) {
        const exists = await this.patientExists(ctx, patientId);
        if (exists) {
            throw new Error(`The patient ${patientId} already exists`);
        }
        const patient = {
            name: name,
            birthDate: birthDate,
            weight:weight,
            height:height,
            docType: 'patient',
            age:age,
            approveStatus:approveStatus,
        };
        const buffer = Buffer.from(JSON.stringify(patient)); // creating a buffer for the patient's data
        await ctx.stub.putState(patientId, buffer); // pushing that buffer into the ledger wrt patientId
    }

    async readPatient(ctx, patientId) {
        const exists = await this.patientExists(ctx, patientId);
        if (!exists) {
            throw new Error(`The patient ${patientId} does not exist`);
        }
        const buffer = await ctx.stub.getState(patientId); // getting the data from the ledger
        const asset = JSON.parse(buffer.toString()); // when recieving data from web server the data is always a string
        return asset;
    }

    async updatePatient(ctx, patientId, newApproveStatus) {
        const exists = await this.patientExists(ctx, patientId);
        if (!exists) {
            throw new Error(`The patient ${patientId} does not exist`);
        }
        const patient = await this.readPatient(ctx, patientId)
        patient.approveStatus = newApproveStatus;
        const buffer = Buffer.from(JSON.stringify(patient));
        await ctx.stub.putState(patientId, buffer);
    }
    
    


    // async queryAllPatients(ctx) {
    //     const startKey = '';
    //     const endKey = '';
    //     const allResults = [];
    //     for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
    //         const strValue = Buffer.from(value).toString('utf8');
    //         let record;
    //         try {
    //             record = JSON.parse(strValue);
    //             console.log("record: ", record)
    //         } catch (err) {
    //             console.log(err);
    //             record = strValue;
    //         }
    //         allResults.push({ Key: key, Record: record });
    //     }
    //     console.info(allResults);
    //     return JSON.stringify(allResults);
    // }

    // [ ==================== Hospital Contract =============================== ]

    async hospitalExists(ctx, hospitalId) {
        const buffer = await ctx.stub.getState(hospitalId);
        return (!!buffer && buffer.length > 0);
    }

    async createHospital(ctx, hospitalId, name, address, doctorList) {
        const exists = await this.hospitalExists(ctx, hospitalId);
        if (exists) {
            throw new Error(`The Hospital ${hospitalId}: ${name} already exists`);
        }
        const hospital = {
            name,
            address,
            docType: 'hospital',
            doctorList,
        };
        const buffer = Buffer.from(JSON.stringify(hospital));
        await ctx.stub.putState(hospitalId, buffer);
    }

    async readHospital(ctx, hospitalId) {
        const exists = await this.hospitalExists(ctx, hospitalId);
        if (!exists) {
            throw new Error(`The hospital ${hospitalId} does not exist`);
        }
        const buffer = await ctx.stub.getState(hospitalId);
        const asset = JSON.parse(buffer.toString());
        return asset;
    }

    async updateHospital(ctx, hospitalId, newName) {
        const exists = await this.hospitalExists(ctx, hospitalId);
        if (!exists) {
            throw new Error(`The hospital ${hospitalId} does not exist`);
        }
        const hospital = await this.readHospital(ctx, hospitalId)
        hospital.name = newName;
        const buffer = Buffer.from(JSON.stringify(hospital));
        await ctx.stub.putState(hospitalId, buffer);
    }


    // async queryAllHospitals(ctx) {
    //     const startKey = '';
    //     const endKey = '';
    //     const allResults = [];
    //     for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
    //         const strValue = Buffer.from(value).toString('utf8');
    //         let record;
    //         try {
    //             record = JSON.parse(strValue);
    //         } catch (err) {
    //             console.log(err);
    //             record = strValue;
    //         }
    //         allResults.push({ Key: key, Record: record });
    //     }
    //     console.info(allResults);
    //     return JSON.stringify(allResults);
    // }

    // [ =================== Patient Treatment Record =============================== ]
    

    async treatmentRecordExists(ctx, treatmentId) {
        const buffer = await ctx.stub.getState(treatmentId);
        return (!!buffer && buffer.length > 0);
    }

    async createTreatmentRecords(ctx, treatmentId, name, patientId, hospitalId, doctorName, status, visitDate)
    {
        const exist = await this.treatmentRecordExists(ctx, treatmentId)
        if (exist)
        {
            throw new Error(`The Treatment Record ${treatmentId} already exists`);
            
        }

        const patientTreatmentRecord = {

            name,
            patientId,
            hospitalId,
            doctorName,
            docType: "patientTreatmentRecord",
            status,
            visitDate,
        }

        const buffer = Buffer.from(JSON.stringify(patientTreatmentRecord));
        await ctx.stub.putState(treatmentId, buffer);
    }


    async readTreatmentRecords(ctx, treatmentId) {
        const exists = await this.treatmentRecordExists(ctx, treatmentId);
        if (!exists) {
            throw new Error(`The Record ID: ${treatmentId} does not exist`);
        }
        const buffer = await ctx.stub.getState(treatmentId);
        const asset = JSON.parse(buffer.toString());
        return asset;
    }

    async updateTreatmentRecords(ctx, treatmentId, newStatus) {
        const exists = await this.treatmentRecordExists(ctx, treatmentId);
        if (!exists) {
            throw new Error(`The Record ID : ${treatmentId} does not exist`);
        }
        const patientTreatmentRecord = await this.readTreatmentRecords(ctx, treatmentId)
        patientTreatmentRecord.status = newStatus;
        const buffer = Buffer.from(JSON.stringify(treatmentId));
        await ctx.stub.putState(treatmentId, buffer);
    }


    async queryAllRecords(ctx) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
                
                
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            
            // console.log('record: ', record.approveStatus);
            allResults.push({ Key: key, Record: record });
            
        }
        // console.log('record14: ', record.approveStatus);
        console.info(allResults);
        return JSON.stringify(allResults);
    }



}











module.exports = SmartContract