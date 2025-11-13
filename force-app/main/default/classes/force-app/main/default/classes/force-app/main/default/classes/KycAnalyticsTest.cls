@IsTest
private class KycAnalyticsTest {
    @IsTest
    static void testGetSummary() {
        List<KYC_Log__c> logs = new List<KYC_Log__c>();
        // Within window
        logs.add(new KYC_Log__c(Customer_Name__c='A', Status__c='APPROVED', Reason__c='ok', Request_ID__c='r1', Timestamp__c=System.now().addDays(-1)));
        logs.add(new KYC_Log__c(Customer_Name__c='B', Status__c='REVIEW',   Reason__c='manual', Request_ID__c='r2', Timestamp__c=System.now().addDays(-2)));
        logs.add(new KYC_Log__c(Customer_Name__c='C', Status__c='REJECTED', Reason__c='watchlist', Request_ID__c='r3', Timestamp__c=System.now().addDays(-3)));
        logs.add(new KYC_Log__c(Customer_Name__c='D', Status__c='APPROVED', Reason__c='ok', Request_ID__c='r4', Timestamp__c=System.now()));
        // Outside window (should not be counted for 7 days)
        logs.add(new KYC_Log__c(Customer_Name__c='Old', Status__c='APPROVED', Reason__c='old', Request_ID__c='r0', Timestamp__c=System.now().addDays(-40)));
        insert logs;

        Test.startTest();
        KycAnalytics.Summary s = KycAnalytics.getSummary(7);
        Test.stopTest();

        System.assertEquals(4, s.total, 'Total should count only recent logs (except the 40-day old one is excluded if outside window and SOQL window is 7 days)');
        System.assertEquals(2, s.approved);
        System.assertEquals(1, s.review);
        System.assertEquals(1, s.rejected);
        System.assertEquals(7, s.days);
    }

    @IsTest
    static void testDefaultDays() {
        Test.startTest();
        KycAnalytics.Summary s = KycAnalytics.getSummary(null);
        Test.stopTest();
        System.assertEquals(7, s.days, 'Default window should be 7 days');
    }
}
