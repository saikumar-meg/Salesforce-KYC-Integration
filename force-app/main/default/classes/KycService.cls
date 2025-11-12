public with sharing class KycService {
    public class KycRequest {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String ssn;
        @AuraEnabled public String dob;
    }

    public class KycResponse {
        @AuraEnabled public String status;
        @AuraEnabled public String reason;
        @AuraEnabled public String requestId;
        @AuraEnabled public String timestamp;
    }

    @TestVisible private static String endpointPath = '/verify';

    public static KycResponse verify(KycRequest req) {
        System.assertNotEquals(null, req, 'Request cannot be null');
        KycResponse output = new KycResponse();

        // Add detailed debug log for traceability
        System.debug(LoggingLevel.INFO, 'Starting KYC verification for: ' + req.firstName + ' ' + req.lastName);

        try {
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('POST');
            httpReq.setEndpoint('callout:KYC_API' + endpointPath);
            httpReq.setHeader('Content-Type', 'application/json');

            Map<String, Object> body = new Map<String, Object>{
                'firstName' => req.firstName,
                'lastName'  => req.lastName,
                'ssn'       => req.ssn,
                'dob'       => req.dob
            };
            httpReq.setBody(JSON.serialize(body));

            Http http = new Http();
            HTTPResponse res = http.send(httpReq);

            // Handle HTTP response
            if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
                Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                output.status = (String) parsed.get('status');
                output.reason = (St
