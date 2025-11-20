public with sharing class KycLogService {
    public static void createLog(
        KycService.KycRequest req,
        KycService.KycResponse res,
        Integer attempts
    ) {
        try {
            KYC_Log__c log = new KYC_Log__c();
            log.Customer_Name__c = req.firstName + ' ' + req.lastName;
            log.Status__c = res.status;
            log.Reason__c = res.reason;
            log.Request_ID__c = res.requestId;
            log.Timestamp__c = res.timestamp != null
                ? DateTime.valueOfGmt(res.timestamp)
                : System.now();
            log.Retry_Attempt__c = attempts;

            insert log;
        } catch (Exception ex) {
            System.debug('Failed to create KYC log with retry attempts: ' + ex.getMessage());
        }
    }
}
