import { ethers } from "hardhat";

async function main() {
  const [owner, hospital, doctor, patient] = await ethers.getSigners();

  const EHealth = await ethers.getContractFactory("EHealth");
  const eHealth = await EHealth.deploy();

  await eHealth.deployed();
  
  console.log(`EHealth deployed to ${eHealth.address}`);
  
  await eHealth.addProvider(hospital.address, 1)
  console.log(`EHealth hospital added :${hospital.address}`);
  
  await eHealth.addPatient(patient.address)
  console.log(`EHealth patient added :${patient.address}`);

  await eHealth.connect(hospital).addDoctor(doctor.address)
  console.log(`EHealth doctor added :${doctor.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
