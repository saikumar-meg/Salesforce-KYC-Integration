cat > force-app/main/default/classes/KycService.cls <<'APEX'
public with sharing class KycService {
    public class KycRequest {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String ssn; // demo only
        @AuraEnabled public String dob; // YYYY-MM-DD
    }
    public class KycResponse {
        public String status; // APPROVED / REVIEW / REJECTED / ERROR
        public String reason;
    }
    @TestVisible private static String endpointPath = '/verify';

    public static KycResponse verify(KycRequest req) {
        System.assertNotEquals(null, req, 'Request is required');
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

        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            Map<String,Object> parsed = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            KycResponse out = new KycResponse();
            out.status = (String) parsed.get('status');
            out.reason = (String) parsed.get('reason');
            return out;
        }
        KycResponse err = new KycResponse();
        err.status = 'ERROR';
        err.reason = 'HTTP ' + res.getStatusCode() + ': ' + res.getBody();
        return err;
    }
}
APEX

cat > force-app/main/default/classes/KycService.cls-meta.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>60.0</apiVersion>
    <status>Active</status>
</ApexClass>
XML
