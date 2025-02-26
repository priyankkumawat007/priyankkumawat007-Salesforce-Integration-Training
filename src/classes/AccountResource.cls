/** 
 * Purpose          :   This class serves as REST full API. 
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   25-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
@RestResource(urlMapping='/AccountAPI/*')
global with sharing class AccountResource {
	/**
    * Method Name  :   getAccount
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Getting the account Id in URL and Returning the list of account.
    *
    * return       :   List<Account>
    *
    * param        :   N/A
    **/
    @HTTPGet
    global static List<Account> getAccount() {
        RestRequest  accountRequest = RestContext.request;
        String accountRequestURI = accountRequest.requestURI;
        String accountId = String.valueOf(accountRequestURI.substring(accountRequestURI.lastIndexOf('/')+1));
        List<Account> acc = [SELECT Id, Name FROM Account WHERE Id =: accountId];
        return acc;
    }
	/**
    * Method Name  :   createAccountAndContact
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Creating Accounts and Contacts
    *
    * return       :   List<String>
    *
    * param        :   String accountName,String firstName,String lastName, String email
    **/
	@HTTPPost
    global static List<String> createAccountAndContact(String accountName,String firstName,String lastName, String email){
		List<String> resultList = new List<String>();
		List<Contact> newContacts = new List<Contact>();
		List<Account> newAccounts = new List<Account>();
		List<Account> existAcc = [SELECT Id, Name FROM Account WHERE Name =: accountName];
		List<Contact> existCon = [SELECT Id FROM Contact WHERE AccountId IN: existAcc AND LastName =:lastName];
		if(!existAcc.isEmpty()){
			if(!existCon.isEmpty()){
                resultList.add(String.valueOf(existAcc[0].Id));
                resultList.add('Duplicate Contact');
                return resultList;
            } 
			Contact con = new Contact(AccountId = existAcc[0].Id, FirstName = firstName, LastName = lastName, Email = email);
			newContacts.add(con);
       	}else{
           	Account acc = new Account(Name = accountName, Phone_Number__c = '8005883995');
            newAccounts.add(acc);
            if(!newAccounts.isEmpty()){
                insert newAccounts;
            }
            Contact con = new Contact(AccountId = acc.Id, FirstName = firstName, LastName = lastName, Email = email);
            newContacts.add(con);
      	}
        try {
            insert newContacts;
            String accId = String.valueOf(newContacts[0].AccountId);
            String conId = String.valueOf(newContacts[0].Id);
            resultList.add(accId);
            resultList.add(conId);  
        } catch(DmlException e) {
            if(e.getMessage().contains('DUPLICATES_DETECTED')){
                resultList.add(String.valueOf(newAccounts.isEmpty() ? existAcc[0].Id : newContacts[0].Id));
				resultList.add('Duplicate Email');
            }
        }
        return resultList;
    }
}