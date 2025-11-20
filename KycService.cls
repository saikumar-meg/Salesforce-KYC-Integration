public static KycResponse verify(KycRequest req) {
    System.assertNotEquals(null, req, 'Request cannot be null');

    KycResponse output = new KycResponse();
    Integer attempts = 0;
    Boolean success = false;

    while (attempts < 2 && !success) {
        attempts++;

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

            if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
                Map<String, Object> parsed =
                    (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                output.status = (String) parsed.get('status');
                output.reason = (String) parsed.get('reason');
                output.requestId = (String) parsed.get('requestId');
                output.timestamp = (String) parsed.get('timestamp');

                success = true;
            }
        } catch (Exception ex) {
            if (attempts == 2) {
                output.status = 'ERROR';
                output.reason = 'API unavailable after retry: ' + ex.getMessage();
            }
        }
    }

    KycLogService.createLog(req, output, attempts);

    return output;
}
