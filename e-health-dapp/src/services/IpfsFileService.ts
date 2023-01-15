import { create } from "ipfs-http-client";
import axios from "axios";

export default class IpfsFileService {
  constructor(private client = create({ url: "http://localhost:5001" })) {}

  public async read(cid: string): Promise<unknown> {
    const response = await axios.post(
      `http://localhost:5001/api/v0/cat?arg=${cid}`
    );
    return response.data;
  }

  public async add(data: any): Promise<string> {
    const { cid } = await this.client.add(JSON.stringify(data));
    return cid.toString();
  }
}
