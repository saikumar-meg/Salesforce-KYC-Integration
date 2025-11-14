public with sharing class KycTrendController {

    public class TrendPoint {
        @AuraEnabled public String dateLabel;
        @AuraEnabled public Integer approved;
        @AuraEnabled public Integer review;
        @AuraEnabled public Integer rejected;
    }

    @AuraEnabled(cacheable=true)
    public static List<TrendPoint> getKycTrend(Integer lastNDays) {
        Integer days = (lastNDays == null || lastNDays <= 0) ? 7 : lastNDays;
        Date startDate = Date.today().addDays(-days);

        // Query daily grouped log data
        List<AggregateResult> grouped = [
            SELECT DAY_ONLY(Timestamp__c) dayVal,
                   Status__c status,
                   COUNT(Id) cnt
            FROM KYC_Log__c
            WHERE Timestamp__c >= :startDate
            GROUP BY DAY_ONLY(Timestamp__c), Status__c
            ORDER BY DAY_ONLY(Timestamp__c)
        ];

        // Map Day -> TrendPoint
        Map<Date, TrendPoint> trendMap = new Map<Date, TrendPoint>();

        for (AggregateResult ar : grouped) {
            Date d = (Date) ar.get('dayVal');
            String s = (String) ar.get('status');
            Integer c = (Integer) ar.get('cnt');

            if (!trendMap.containsKey(d)) {
                TrendPoint tp = new TrendPoint();
                tp.dateLabel = d.format();
                tp.approved = 0;
                tp.review = 0;
                tp.rejected = 0;
                trendMap.put(d, tp);
            }

            TrendPoint ref = trendMap.get(d);
            if (s == 'APPROVED')       ref.approved += c;
            else if (s == 'REVIEW')    ref.review   += c;
            else if (s == 'REJECTED')  ref.rejected += c;
        }

        List<TrendPoint> finalList = new List<TrendPoint>();
        for (Date d : trendMap.keySet()) {
            finalList.add(trendMap.get(d));
        }
        finalList.sort();

        return finalList;
    }
}
