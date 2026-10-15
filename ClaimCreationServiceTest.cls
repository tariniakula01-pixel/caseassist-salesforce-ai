@isTest
private class ClaimCreationServiceTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Customer');
        insert acc;

        Policy__c policy = new Policy__c(
            Name = 'Test Policy',
            Policy_Holder__c = acc.Id,
            Policy_Number__c = 'POL-TEST-1',
            Coverage_Type__c = 'Auto',
            Status__c = 'Active'
        );
        insert policy;
    }

    @isTest
    static void testCreateClaimSuccessfully() {
        Policy__c policy = [SELECT Id FROM Policy__c LIMIT 1];

        Test.startTest();
        Claim__c result = ClaimCreationService.createClaim(
            policy.Id, 'Rear-end collision', Date.today(), 3500
        );
        Test.stopTest();

        System.assertNotEquals(null, result.Id, 'Claim should be created with an Id');

        Claim__c saved = [SELECT Claim_Status__c, Related_Policy__c FROM Claim__c WHERE Id = :result.Id];
        System.assertEquals('New', saved.Claim_Status__c);
        System.assertEquals(policy.Id, saved.Related_Policy__c);
    }
}