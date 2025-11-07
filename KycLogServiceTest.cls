@IsTest
private class KycLogServiceTest {
    @IsTest
    static void testCreateLog() {
        // Mock request and response
        KycService.KycRequest req = new KycService.KycRequest();
        req.firstName = 'Test';
        req.lastName = 'User';
        req.ssn = '9999';
        req.dob = '1990-01-01';

        KycService.KycResponse res = new KycService.KycResponse();
        res.status = 'APPROVED';
        res.reason = 'Test case approval';
        res.requestId = 'REQ-001';
        res.timestamp = String.valueOf(System.now());

        Test.startTest();
        KycLogService.createLog(req, res);
        Test.stopTest();

        List<KYC_Log__c> logs = [SELECT Id, Status__c, Request_ID__c FROM KYC_Log__c];
        System.assertEquals(1, logs.size(), 'Log record should be created');
        System.assertEquals('APPROVED', logs[0].Status__c);
        System.assertEquals('REQ-001', logs[0].Request_ID__c);
    }
}
