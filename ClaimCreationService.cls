public with sharing class ClaimCreationService {
    /**
     * Creates a new Claim__c record linked to a given Policy.
     * Status defaults to 'New' — risk classification happens
     * in a separate step, not here, so this method stays
     * focused on one responsibility: record creation.
     */
    public static Claim__c createClaim(Id policyId, String description, Date incidentDate, Decimal estimatedAmount) {
        Claim__c newClaim = new Claim__c(
            Related_Policy__c = policyId,
            Description__c = description,
            Incident_Date__c = incidentDate,
            Estimated_Amount__c = estimatedAmount,
            Claim_Status__c = 'New'
        );
        insert newClaim;
        return newClaim;
    }
}