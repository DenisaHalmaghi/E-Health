import useAuthStore from "@/stores/auth-store";
import { Contract } from "ethers";

const contractAddress = import.meta.env.VITE_CONTRACT_ADDRESS;
const abiPath = import.meta.env.VITE_CONTRACT_ABI;
const { abi } = await import(
  "../../../e-health-contract/artifacts/contracts/EHealth.sol/EHealth.json"
);

interface ConsultationPayload {
  prescriptionFile: string;
  oneTimeUsage: boolean;
  patient: string;
  referralFile?: string;
}

export default class ContractRepository {
  private contract?: Contract;

  constructor() {
    const initializer = {
      get(obj: any, prop: string) {
        if (typeof obj[prop] === "function") {
          return async (...args: unknown[]) => {
            await obj._initialize();
            return obj[prop](...args);
          };
        }

        return obj[prop];
      },
    };
    return new Proxy(this, initializer);
  }

  private async _initialize(): Promise<void> {
    const authStore = useAuthStore();

    if (!authStore.signer) {
      await authStore.auth();
    }

    if (!authStore.signer) {
      throw new Error("Missing signer");
    }

    if (this.contract) {
      return;
    }

    this.contract = new Contract(contractAddress, abi, authStore.signer);
  }

  public getContract(): Contract {
    return this.contract!;
  }

  public async getConsultations(): Promise<unknown> {
    console.log("eee", this.getContract().functions);
    const response = await this.getContract().getConsultations();

    return response;
  }

  public async addConsultation({
    patient,
    oneTimeUsage,
    prescriptionFile,
    referralFile,
  }: ConsultationPayload): Promise<unknown> {
    const tx = await this.getContract().addConsultation(
      patient,
      prescriptionFile,
      oneTimeUsage,
      referralFile
    );

    await tx.wait();
    return tx;
  }
}
