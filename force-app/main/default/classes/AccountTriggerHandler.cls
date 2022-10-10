public with sharing class AccountTriggerHandler {
    public static void onAfterUpdate (List <Account> lstNewAccount, List <Account> lstOldAccount, Map <Id, Account> mapNewAccount, Map <Id, Account> mapOldAccount) {
        sendEmailToOldOwnerOnAccountOwnerChange (lstNewAccount, mapOldAccount);
    }
    
    public static void sendEmailToOldOwnerOnAccountOwnerChange (List <Account> lstNewAccount, Map <Id, Account> mapOldAccount){

        try {
            Map <Id, List <String>> mapOldOwnerIdWithAccountNames = new Map <Id, List <String>> ();

            for (Account objAccount : [ SELECT Id, Name, OwnerId FROM Account WHERE ID IN : lstNewAccount ]) {								//	=>	Storing account Names and Old Owner Id if Account Owner has been changed
                Account objOldAccount = (Account) mapOldAccount.get(objAccount.ID);
                if (objAccount.OwnerId != objOldAccount.OwnerId) {
                    if (!mapOldOwnerIdWithAccountNames.containsKey(objOldAccount.OwnerId))
                        mapOldOwnerIdWithAccountNames.put(objOldAccount.OwnerId, new List <String> ());
                    mapOldOwnerIdWithAccountNames.get(objOldAccount.OwnerId).add(objAccount.Name);
                }
            }      
            
            if (mapOldOwnerIdWithAccountNames.size() > 0) {						//	=>	Sending Email to the Old Owner if Account Owner has been changed
                for (User objUsers : [ SELECT ID, Name, Email FROM User WHERE ID IN : mapOldOwnerIdWithAccountNames.keySet() ]) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSubject('Account Owner Changed!');
                    String [] toAddresses = new String [] { objUsers.Email };
                    mail.setToAddresses(toAddresses);
                    List <String> lstChangedOwnersAccountNames = new List <String>();
                    lstChangedOwnersAccountNames.addAll(mapOldOwnerIdWithAccountNames.get(objUsers.Id));
                    mail.setPlainTextBody('Dear '+ objUsers.Name + ',\n\nOwner of the following Account(s) has been changed on ' + System.now().format('dd/MM/yyyy HH:mm:ss') + ':\n' + lstChangedOwnersAccountNames + '\n\nThank you!');//mapOldOwnerIdWithAccountName.values()
                    Messaging.sendEmail(new Messaging.Email[] { mail });
                }
            }
        }
        
        catch (Exception e) {
            System.debug ('---	Exception in sendEmailToOldOwnerOnAccountOwnerChange	--- ' + e);
        }
    }    
}