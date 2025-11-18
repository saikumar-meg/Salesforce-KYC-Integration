@IsTest
static void testRetryLogic() {
    Test.setMock(HttpCalloutMock.class, new KycServiceMock());

    KycService.KycRequest req = new KycService.KycRequest();
    req.firstName = 'Retry';
    req.lastName = 'Test';
    req.ssn = '1234';
    req.dob = '1990-01-01';

    Test.startTest();
    KycService.KycResponse res = KycService.verify(req);
    Test.stopTest();

    System.assertEquals('APPROVED', res.status);
}
