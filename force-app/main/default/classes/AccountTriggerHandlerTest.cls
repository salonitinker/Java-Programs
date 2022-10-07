@isTest
public with sharing class AccountTriggerHandlerTest {
    @TestSetup
    static void makeData() {
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User objUser1 = new User(
            Alias = 'Test', 
            LastName='User 1', 
            Email='TestUser1@gmail.com', 
            EmailEncodingKey='UTF-8', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuserforownerchange1@gmail.com'
        );
        insert objUser1;
        
        User objUser2 = new User(
            Alias = 'Test', 
            LastName='User 2', 
            Email='testuser2@gmail.com', 
            EmailEncodingKey='UTF-8', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuserforownerchange2@gmail.com'
        );
        insert objUser2;
    }
    @isTest
    static void changeAccountOwner() {

        Test.startTest();

        List <User> lstUser = new List <User> ();
        
        for (User objUser : [ SELECT Id FROM User LIMIT 2 ])
            lstUser.add(objUser);

        Account objAccount = new Account(
            Name = 'Test Account',
            OwnerId = lstUser[0].Id
        );
        insert objAccount;
        
        objAccount.OwnerId = lstUser[1].Id;

        update objAccount;

        Test.stopTest();
    }
}