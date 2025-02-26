@isTest
public class ValidateAddressUsingSmartyStreetTest {
    /** 
     * Method Name  :   HttpMockFactory
     * 
     * Purpose      :   Implements the HttpCalloutMock interface to simulate HTTP callouts for testing.
     *                  This mock class provides a predefined response for address validation requests.
     * 
     * Methods      :   respond(HttpRequest req) - Returns a mock HTTP response with a sample address validation result.
     *                  The response body contains a valid address for testing purposes.
    **/
    public class HttpMockFactory implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            HttpResponse res = new httpResponse();
            res.setBody('{"candidate": [{"delivery_line_1": "1600 Amphitheatre Parkway", "city": "Mountain View", "state_abbreviation": "CA", "zipcode": "94043"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    /** 
     * Method Name  :   checkAddressValidationTrue
     * 
     * Purpose      :   Test method to verify the functionality of the address validation process using the SmartyStreets API.
     *                  It ensures that the `Address_Verified__c` field on the Contact record is set to `true` when the address is valid.
     * 
     * Steps        :   1. Create a test Contact record with a sample address.
     *                  2. Set up a mock HTTP callout response using HttpMockFactory to simulate a valid address response.
     *                  3. Call the `ValidateAddressUsingSmartyStreetHelper.getAddresses` method to validate the address.
     *                  4. Query the updated Contact record and assert that the `Address_Verified__c` field is set to `true`.
     * 
     * Assertions   :   - The `Address_Verified__c` field on the Contact record should be `true` after address validation.
     **/
	@isTest
    static void checkAddressValidationTrue(){
		contact contactTest = new Contact();
        contactTest.LastName = 'Contact1000';
        contactTest.MailingStreet ='1600 amphitheatre';
        contactTest.MailingCity = 'mountain view';
        contactTest.MailingState ='CA';
        insert contactTest;

		Test.setMock(HttpCalloutMock.class,new HttpMockFactory());
		Test.startTest();
			List<Contact> CheckTestId = [SELECT Id FROM Contact WHERE LastName = 'Contact1000'];
			ValidateAddressUsingSmartyStreetHelper.getAddresses('1600 amphitheatre','mountain view','CA', CheckTestId[0].Id);
		Test.stopTest();
		List<Contact> CheckTest = [SELECT Id,Address_Verified__c FROM Contact WHERE LastName = 'Contact1000'];
		Assert.areEqual(true, CheckTest[0].Address_Verified__c, 'Address Verified Must Be True');
    }	
}