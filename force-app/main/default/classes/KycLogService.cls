public with sharing class KycLogService {
    /**
     * Creates a log record in KYC_Log__c after each KYC verification.
     * Bulk-safe and exception-handled version.
     */
    public static void createLog(KycService.KycRequest req, KycService.KycResponse res) {
        if (req == null || res == null) {
            System.debug(LoggingLevel.WARN, 'Skipping log creation due to null input.');
            return;
        }

        try {
            KYC_Log__c log = new KYC_Log__c();
            log.Customer_Name__c = req.firstName + ' ' + req.lastName;
            log.Request_ID__c = res.requestId != null ? res.requestId : 'N/A';
            log.Status__c = res.status != null ? res.status : 'Unknown';
            log.Reason__c = res.reason != null ? res.reason : 'No reason provided';
            if (res.timestamp != null && res.timestamp != '') {
                try {
                    log.Timestamp__c = DateTime.valueOfGmt(res.timestamp);
                } catch (Exception dtEx) {
                    log.Timestamp__c = System.now();
                    System.debug(LoggingLevel.WARN, 'Invalid timestamp format; defaulted to current time: ' + dtEx.getMessage());
                }
            } else {
                log.Timestamp__c = System.now();
            }

            insert log;
            System.debug(LoggingLevel.INFO, 'KYC log successfully created: ' + log.Id);
        } catch (DmlException dmlEx) {
            System.debug(LoggingLevel.ERROR, 'Failed to insert KYC log: ' + dmlEx.getMessage());
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Unexpected error in createLog(): ' + ex.getMessage());
        }
    }
}
