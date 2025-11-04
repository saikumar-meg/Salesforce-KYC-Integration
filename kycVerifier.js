import { LightningElement, track } from 'lwc';
import runKyc from '@salesforce/apex/KycController.runKyc';

export default class KycVerifier extends LightningElement {
  @track form = { firstName: '', lastName: '', ssn: '', dob: '' };
  @track result;
  @track loading = false;

  handleChange(e) {
    const { name, value } = e.target;
    this.form = { ...this.form, [name]: value };
  }

  async handleVerify() {
    this.loading = true;
    this.result = { status: 'LOADING', reason: 'Contacting KYC service...' };
    try {
      const res = await runKyc({ req: this.form });
      this.result = res;
    } catch (e) {
      this.result = { status: 'ERROR', reason: e?.body?.message || e.message };
    } finally {
      this.loading = false;
    }
  }
}
