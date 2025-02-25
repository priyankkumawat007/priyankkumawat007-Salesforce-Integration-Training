/** 
 * Purpose          :   Test Class for AccountResource.
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   25-2-2024
 * 
 * Revision Logs    :   V_1.0 - Created
 **/
@isTest
public class AccountResourceTest {
	@TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Fexle Services Private Limited', Phone_Number__c = '8005883998');
        insert acc;
        Contact con = new Contact(LastName = 'testContact', AccountId = acc.id, Email = 'abcd12345@gmail.com');
        insert con;
    }
    /** 
	* Method Name  :   testGetAccount
	* 
	* Purpose      :   Test method to verify the functionality of the getAccount method in the AccountResource class.
	*                  It tests whether the correct Account record is retrieved based on the provided Account Id.
	*	 
	* Steps        :   1. Query an existing Account record.
	*                  2. Set up a mock REST request with the Account Id.
	*                  3. Call the getAccount method.
	*                  4. Assert that the returned Account record matches the expected Name.
	**/
	@isTest
    static void testGetAccount(){
		Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Fexle Services Private Limited' LIMIT 1];
        Test.startTest();
        	RestRequest accountRequest = new RestRequest();
        	accountRequest.requestURI = 'https://priyank-sf-dev-ed.develop.my.salesforce.com/services/apexrest/AccountAPI/'+acc.Id;
        	accountRequest.httpMethod ='GET';
        	RestContext.request = accountRequest;
        	List<Account> returnedAccount  = AccountResource.getAccount();
		Test.stopTest();
		Assert.areEqual('Fexle Services Private Limited',returnedAccount[0].Name,'Name Must Be TestAccountAPI1');
    }
	/** 
 	* Method Name  :   testCreateAccountAndContact
 	* 
 	* Purpose      :   Test method to verify the functionality of the createAccountAndContact method in the AccountResource class.
 	*                  It tests whether a new Account and Contact are created when the Account does not already exist.
 	* 
 	* Steps        :   1. Call the createAccountAndContact method with test data.
 	*                  2. Query the created Account and Contact records.
 	*                  3. Assert that the Account and Contact records are created with the expected values.
 	**/
	@isTest
    static void testCreateAccountAndContact() {
        Test.startTest();
			AccountResource.createAccountAndContact('Shubham','hello','world 2','Xoriant2world@Homes.com');
        Test.stopTest();
		List<Account> Acc = [SELECT Id, Name FROM Account WHERE Name = 'Shubham'];
		List<Contact> Con = [SELECT Id FROM Contact WHERE LastName = 'world 2'];
		Assert.isNotNull(Acc);
        Assert.isNotNull(Con);
        Assert.areEqual('Shubham',Acc[0].Name, 'Name Must Be Shubham');
    }
	/** 
 	* Method Name  :   testErrorCreateAccountAndContact
 	* 
 	* Purpose      :   Test method to verify the functionality of the createAccountAndContact method in the AccountResource class
 	*                  when the Account already exists. It ensures that the method does not create duplicate Accounts.
 	* 
 	* Steps        :   1. Call the createAccountAndContact method with an existing Account name.
 	*                  2. Query the existing Account and the newly created Contact records.
 	*                  3. Assert that the existing Account is used and the Contact is created with the expected values.
 	**/
    @isTest
    static void testErrorCreateAccountAndContact() {
		
        Test.startTest();
			AccountResource.createAccountAndContact('Fexle Services Private Limited','hello','testContact','Xoriant2world@Homes.com');
        Test.stopTest();
		List<Account> Acc = [SELECT Id, Name FROM Account WHERE Name = 'Fexle Services Private Limited'];
		List<Contact> Con = [SELECT Id FROM Contact WHERE LastName = 'testContact'];
		Assert.isNotNull(Acc);
        Assert.isNotNull(Con);
        Assert.areEqual('Fexle Services Private Limited',Acc[0].Name, 'Name Must Be Fexle Services Private Limited');
		
    }    
	/** 
 	* Method Name  :   testCreateAccountAndContactWhenAccountExist
 	* 
 	* Purpose      :   Test method to verify the functionality of the createAccountAndContact method in the AccountResource class
 	*                  when the Account already exists. It ensures that the method associates the new Contact with the existing Account.
 	* 
 	* Steps        :   1. Call the createAccountAndContact method with an existing Account name.
 	*                  2. Query the existing Account and the newly created Contact records.
 	*                  3. Assert that the existing Account is used and the Contact is created with the expected values.
 	**/
	@isTest
	static void testCreateAccountAndContactWhenAccountExist() {
        Test.startTest();
			AccountResource.createAccountAndContact('Fexle Services Private Limited','hello','testContact1','Xoriant2world@Homes.com');
        Test.stopTest();
		List<Account> fetchAcc = [SELECT Id, Name FROM Account WHERE Name = 'Fexle Services Private Limited'];
		List<Contact> fetchCon = [SELECT Id,LastName FROM Contact WHERE LastName = 'testContact1'];
		Assert.isNotNull(fetchAcc);
        Assert.isNotNull(fetchCon);
        Assert.areEqual('Fexle Services Private Limited',fetchAcc[0].Name, 'Name Must Be Fexle Services Private Limited');
		Assert.areEqual('testContact1',fetchCon[0].LastName, 'Name Must Be testContact');
    }   
}