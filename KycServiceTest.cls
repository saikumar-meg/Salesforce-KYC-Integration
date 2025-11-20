@IsTest
static void testRetryAttemptTracking() {
    Test.setMock(HttpCalloutMock.class, new KycServiceMock());

    KycService.KycRequest req = new KycService.KycRequest();
    req.firstName = 'Retry';
    req.lastName = 'Count';
    req.ssn = '9999';
    req.dob = '1988-04-04';

    Test.startTest();
    KycService.KycResponse res = KycService.verify(req);
    Test.stopTest();

    KYC_Log__c log = [SELECT Retry_Attempt__c FROM KYC_Log__c ORDER BY CreatedDate DESC LIMIT 1];
    System.assert(log.Retry_Attempt__c >= 1, 'Retry attempt should be recorded');
}
