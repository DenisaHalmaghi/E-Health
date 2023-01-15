// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

enum Role {
    None,
    Doctor,
    Patient,
    Pharmacist,
    Provider
}

enum RecordType {
    Test,
    Vaccine,
    Prescription
}

enum PaymentType {
    Prescription,
    Test,
    Consultation
}

enum ProviderType {
    None,
    Hospital_Clinic,
    Pharmacy
}

contract EHealth is Ownable {
    mapping(address => Role) public roles;
    mapping(address => ProviderType) public providerTypes;

    mapping(address => address) public providerOfDoctorOrPharmacist;

    event DoctorAdded(address doctor);
    event PatientAdded(address patient);
    event PharmacistAdded(address pharmacist);
    event ProviderAdded(address provider, ProviderType providerType);
    event RecordAdded(uint recordId, address patient, address doctor);
    event PrescriptionAdded(
        uint prescriptionId,
        uint recordId,
        address patient,
        address doctor,
        address pharmacist
    );
    event PaymentMade(
        address patient,
        address provider,
        uint amount,
        PaymentType reason,
        uint timestamp
    );

    struct Prescription {
        string cid;
        bool oneTimeUsage;
        bool used;
    }

    struct Test {
        string cid;
        address provider;
        uint dateTime;
        uint consultation;
    }

    struct Consultation {
        uint id;
        address doctor;
        uint dateTime;
        Prescription prescription;
        string referralCid;
    }

    struct Vaccine {
        string cid;
        uint datetime;
        address provider;
    }

    mapping(address => Consultation[]) public patientConsulations;
    mapping(address => Test[]) private patientTests;
    mapping(address => Vaccine[]) private patientVaccines;

    struct Payment {
        address patient;
        address provider;
        uint amount;
        PaymentType reason;
        uint timestamp;
    }

    mapping(address => Payment[]) public patientPayments;

    modifier notAddedYet(address entity) {
        if (roles[entity] != Role.None) {
            revert("User is already a member of the system.");
        }
        _;
    }

    modifier isDoctor() {
        if (roles[msg.sender] != Role.Doctor) {
            revert("Only doctors can perform this action.");
        }
        _;
    }

    modifier isPatient(address patient) {
        if (roles[patient] != Role.Patient) {
            revert("Patient is not a member of the system.");
        }
        _;
    }

    modifier isPharmacist() {
        if (roles[msg.sender] != Role.Pharmacist) {
            revert("Only pharmacists can perform this action.");
        }
        _;
    }

    modifier isProviderType(address provider, ProviderType providerType) {
        if (roles[provider] != Role.Provider) {
            revert("Only providers can perform this action.");
        }

        if (providerTypes[provider] != providerType) {
            revert("Only providers can perform this action.");
        }
        _;
    }

    modifier isProvider(address provider) {
        if (roles[provider] != Role.Provider) {
            revert("Only providers can perform this action.");
        }
        _;
    }

    function addProvider(
        address provider,
        ProviderType providerType
    ) public onlyOwner notAddedYet(provider) {
        roles[provider] = Role.Provider;
        providerTypes[provider] = providerType;
        emit ProviderAdded(provider, providerType);
    }

    function addDoctor(
        address doctor
    )
        public
        isProviderType(msg.sender, ProviderType.Hospital_Clinic)
        notAddedYet(doctor)
    {
        roles[doctor] = Role.Doctor;
        providerOfDoctorOrPharmacist[doctor] = msg.sender;
        emit DoctorAdded(doctor);
    }

    function addPharmacist(
        address pharmacist
    )
        public
        isProviderType(msg.sender, ProviderType.Pharmacy)
        notAddedYet(pharmacist)
    {
        roles[pharmacist] = Role.Pharmacist;
        providerOfDoctorOrPharmacist[pharmacist] = msg.sender;
        emit PharmacistAdded(pharmacist);
    }

    function getProvider(
        address doctorOrPharmacist
    ) public view returns (address) {
        return providerOfDoctorOrPharmacist[doctorOrPharmacist];
    }

    function addPatient(address patient) public notAddedYet(patient) {
        roles[patient] = Role.Patient;
        emit PatientAdded(patient);
    }

    function getConsultations() public view returns (Consultation[] memory) {
        return patientConsulations[msg.sender];
    }

    function addConsultation(
        address patient,
        string memory _prescriptionFile,
        bool _oneTimeUsage,
        string memory _referralFile
    ) public isDoctor isPatient(patient) {
        Prescription memory prescription = Prescription({
            cid: _prescriptionFile,
            oneTimeUsage: _oneTimeUsage,
            used: false
        });
        Consultation memory consultation = Consultation({
            id: 1,
            doctor: msg.sender,
            dateTime: block.timestamp,
            prescription: prescription,
            referralCid: _referralFile
        });
        patientConsulations[patient].push(consultation);
    }

    function addVaccine(
        string memory _file,
        address patient
    ) public isDoctor isPatient(patient) {
        Vaccine memory vaccine = Vaccine({
            cid: _file,
            datetime: block.timestamp,
            provider: msg.sender
        });
        patientVaccines[patient].push(vaccine);
    }

    function addTest(
        string memory _file,
        address patient,
        uint _consultation
    ) public isDoctor isPatient(patient) {
        Test memory testStruct = Test({
            cid: _file,
            provider: msg.sender,
            dateTime: block.timestamp,
            consultation: _consultation
        });
        patientTests[patient].push(testStruct);
    }

    function makePayment(
        address provider,
        PaymentType reason
    ) public payable isPatient(msg.sender) isProvider(provider) {
        uint timestamp = block.timestamp;

        (bool sent, bytes memory data) = provider.call{value: msg.value}("");

        if (!sent) {
            revert("Failed to send Ether");
        }

        patientPayments[msg.sender].push(
            Payment({
                patient: msg.sender,
                provider: provider,
                amount: msg.value,
                reason: reason,
                timestamp: timestamp
            })
        );

        emit PaymentMade(msg.sender, provider, msg.value, reason, timestamp);
    }
}
