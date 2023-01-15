import { defineStore } from "pinia";
import { markRaw } from "vue";
import { providers } from "ethers";
import Web3Modal from "web3modal";
import type { JsonRpcSigner } from "@ethersproject/providers/src.ts/json-rpc-provider";

const useAuthStore = defineStore("auth", {
  state: () => ({
    signer: null as JsonRpcSigner | null,
    signerAddress: "",
  }),
  actions: {
    async auth(): Promise<void> {
      try {
        const web3Modal = new Web3Modal();
        const connection = await web3Modal.connect();
        const provider = new providers.Web3Provider(connection);

        connection.on("accountsChanged", async () => {
          this.signer = markRaw(provider.getSigner());
          try {
            this.signerAddress = await this.signer.getAddress();
          } catch (e) {
            // localStorage.remove("is_authenticated");
            location.reload();
          }
        });

        this.signer = markRaw(provider.getSigner());
        this.signerAddress = await this.signer.getAddress();

        // localStorage.set("is_authenticated", true);
      } catch (e) {
        console.error(e);
        // localStorage.remove("is_authenticated");
      }
    },
  },
});

export default useAuthStore;
