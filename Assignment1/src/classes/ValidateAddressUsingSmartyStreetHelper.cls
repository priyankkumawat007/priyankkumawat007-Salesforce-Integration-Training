/** 
 * Purpose          :   Validate the Email Address
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   25-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
public class ValidateAddressUsingSmartyStreetHelper{
	/**
    * Method Name  :   getAddresses
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Future Method to validate given address is valid of not using SmartyStreet API
                       whenever a contact record is getting insert or update . 
    *
    * return       :   void
    *
    * param        :   String contactMailingStreet,String contactMailingCity,String contactMailingState,String ContactId
    **/
	@future(callout=true)
    public static void getAddresses(String contactMailingStreet,String contactMailingCity,String contactMailingState,String ContactId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String street = EncodingUtil.urlEncode(contactMailingStreet, 'UTF-8');
        String city = EncodingUtil.urlEncode(contactMailingCity, 'UTF-8');
        String state = EncodingUtil.urlEncode(contactMailingState, 'UTF-8');
        String URL = 'https://us-street.api.smarty.com/street-address?' +
            'auth-id=b10d7a54-3ba2-6bb7-01ff-400d323e59d0&' +
            'auth-token=Ec52eQ53KYZA14s6AijJ&' +
            'street=' + street + '&' +
            'city=' + city + '&' +
            'state='+ state + '&' +
            'candidates=10';
        req.setEndpoint(URL);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        List<Contact> updateCon = new List<Contact>();
        if(res.getStatusCode() == 200 && res.getBody() != null && res.getBody().length()>3){
            Contact newCon = new Contact();
            newCon.Id = ContactId;
            newCon.Address_Verified__c = true;
            updateCon.add(newCon);
        }else if(res.getBody().length()<=3){
            Contact newCon = new Contact();
            newCon.Id = ContactId;
            newCon.Address_Verified__c = false;
            updateCon.add(newCon);
        }
        if(!updateCon.isEmpty()){
            update updateCon;
        }
	}
}