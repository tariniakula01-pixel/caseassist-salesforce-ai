@isTest
private class PolicyLookupServiceTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Customer');
        insert acc;

        Policy__c activePolicy = new Policy__c(
            Name = 'Test Active Policy',
            Policy_Holder__c = acc.Id,
            Policy_Number__c = 'POL-TEST-1',
            Coverage_Type__c = 'Auto',
            Status__c = 'Active'
        );
        Policy__c inactivePolicy = new Policy__c(
            Name = 'Test Inactive Policy',
            Policy_Holder__c = acc.Id,
            Policy_Number__c = 'POL-TEST-2',
            Coverage_Type__c = 'Home',
            Status__c = 'Inactive'
        );
        insert new List<Policy__c>{ activePolicy, inactivePolicy };
    }

    @isTest
    static void testReturnsOnlyActivePolicies() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Customer' LIMIT 1];

        Test.startTest();
        List<Policy__c> results = PolicyLookupService.getActivePolicies(acc.Id);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return exactly one active policy');
        System.assertEquals('POL-TEST-1', results[0].Policy_Number__c);
    }

    @isTest
    static void testAccountWithNoActivePolicies() {
        Account noPolicyAcc = new Account(Name = 'No Policy Customer');
        insert noPolicyAcc;

        Test.startTest();
        List<Policy__c> results = PolicyLookupService.getActivePolicies(noPolicyAcc.Id);
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should return an empty list');
    }
}