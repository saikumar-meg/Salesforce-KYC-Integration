cat > force-app/main/default/classes/KycController.cls <<'APEX'
public with sharing class KycController {
    @AuraEnabled(cacheable=false)
    public static KycService.KycResponse runKyc(KycService.KycRequest req) {
        return KycService.verify(req);
    }
}
APEX

cat > force-app/main/default/classes/KycController.cls-meta.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>60.0</apiVersion>
    <status>Active</status>
</ApexClass>
XML
