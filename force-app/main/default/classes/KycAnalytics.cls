public with sharing class KycAnalytics {
    public class Summary {
        @AuraEnabled public Integer total;
        @AuraEnabled public Integer approved;
        @AuraEnabled public Integer review;
        @AuraEnabled public Integer rejected;
        @AuraEnabled public Integer days;
    }

    @AuraEnabled(cacheable=true)
    public static Summary getSummary(Integer lastNDays) {
        Integer days = (lastNDays == null || lastNDays <= 0) ? 7 : lastNDays;
        DateTime start = Date.today().addDays(-days).toStartOfDay();

        List<AggregateResult> rows = [
            SELECT Status__c status, COUNT(Id) cnt
            FROM KYC_Log__c
            WHERE Timestamp__c >= :start
            GROUP BY Status__c
        ];

        Summary s = new Summary();
        s.days = days;
        s.total = 0; s.approved = 0; s.review = 0; s.rejected = 0;

        for (AggregateResult r : rows) {
            String status = (String) r.get('status');
            Integer c = (Integer) r.get('cnt');
            s.total += c;
            if (status == 'APPROVED')       s.approved += c;
            else if (status == 'REVIEW')    s.review   += c;
            else if (status == 'REJECTED')  s.rejected += c;
        }
        return s;
    }
}
