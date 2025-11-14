@IsTest
private class KycTrendControllerTest {

    @IsTest
    static void testTrend() {
        List<KYC_Log__c> logs = new List<KYC_Log__c>();

        logs.add(new KYC_Log__c(Customer_Name__c='A', Status__c='APPROVED', Request_ID__c='r1', Reason__c='ok', Timestamp__c=System.now().addDays(-1)));
        logs.add(new KYC_Log__c(Customer_Name__c='B', Status__c='REVIEW',   Request_ID__c='r2', Reason__c='manual', Timestamp__c=System.now().addDays(-1)));
        logs.add(new KYC_Log__c(Customer_Name__c='C', Status__c='REJECTED', Request_ID__c='r3', Reason__c='watchlist', Timestamp__c=System.now().addDays(-2)));

        insert logs;

        Test.startTest();
        List<KycTrendController.TrendPoint> results = KycTrendController.getKycTrend(7);
        Test.stopTest();

        System.assert(results.size() > 0, 'Trend list should not be empty');
    }
}
