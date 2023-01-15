import ContractRepository from "@/repositories/ContractRepository";
import type { Consultation } from "@/types/consultation";
import IpfsFileService from "./IpfsFileService";

export default class EHealthService {
  constructor(
    private repository: ContractRepository = new ContractRepository(),
    private fileService: IpfsFileService = new IpfsFileService()
  ) {}

  public async createConsultation(data: Consultation) {
    const prescriptionCid = await this.fileService.add(data.prescription);
    console.log("-----CID------", prescriptionCid);

    const payload = {
      patient: data.patient,
      oneTimeUsage: data.prescription.oneTimeUsage,
      prescriptionFile: prescriptionCid,
      referralFile: "",
    };

    const response = await this.repository.addConsultation(payload);
  }
  public async getConsultations() {
    // const prescriptionCid = await this.fileService.add(data.prescription);

    const response = await this.repository.getConsultations();
  }
}
