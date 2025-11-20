@IsTest
static void testLogWithRetry() {
    KycService.KycRequest req = new KycService.KycRequest();
    req.firstName = 'Test';
    req.lastName = 'Retry';
    req.ssn = '2222';
    req.dob = '1990-05-05';

    KycService.KycResponse res = new KycService.KycResponse();
    res.status = 'APPROVED';
    res.reason = 'Verified';
    res.requestId = 'REQ-123';
    res.timestamp = String.valueOf(System.now());

    Test.startTest();
    KycLogService.createLog(req, res, 2);
    Test.stopTest();

    KYC_Log__c log = [SELECT Retry_Attempt__c FROM KYC_Log__c LIMIT 1];
    System.assertEquals(2, log.Retry_Attempt__c);
}
