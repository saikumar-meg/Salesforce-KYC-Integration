import { LightningElement, track } from 'lwc';
import getSummary from '@salesforce/apex/KycAnalytics.getSummary';

export default class KycSummary extends LightningElement {
  @track loading = false;
  @track data = { total: 0, approved: 0, review: 0, rejected: 0, days: 7 };
  @track days = 7;

  connectedCallback() {
    this.load();
  }

  async load() {
    this.loading = true;
    try {
      const res = await getSummary(this.days);
      this.data = res || this.data;
    } catch (e) {
      // keep simple UI; in real app, toast the error
      // eslint-disable-next-line no-console
      console.error(e);
    } finally {
      this.loading = false;
    }
  }

  handleDaysChange(e) {
    this.days = parseInt(e.target.value, 10);
    this.load();
  }
}
