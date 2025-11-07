public with sharing class KycLogService {
    /**
     * Creates a log record in KYC_Log__c after each KYC verification.
     * Called from KycService.verify() once a response is received.
     */
    public static void createLog(KycService.KycRequest req, KycService.KycResponse res) {
        try {
            KYC_Log__c log = new KYC_Log__c();
            log.Customer_Name__c = req.firstName + ' ' + req.lastName;
            log.Request_ID__c = res.requestId;
            log.Status__c = res.status;
            log.Reason__c = res.reason;
            if (res.timestamp != null)
                log.Timestamp__c = DateTime.valueOfGmt(res.timestamp);
            insert log;
            System.debug('KYC log created: ' + log.Id);
        } catch (Exception ex) {
            System.debug('Failed to log KYC record: ' + ex.getMessage());
        }
    }
}
