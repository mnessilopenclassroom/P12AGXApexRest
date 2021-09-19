@isTest(SeeAllData=false)
public class AGXPostmanContactTest {    
    static Id SetupContact(){   
    Contact ctc = new Contact(
        Salutation = 'Mr',
        Password__c = '1234',
        FirstName = 'fabrice',
        LastName = 'like',
        Email = 'likefabrice@sfr.fr', 
        Phone = '0102030405', 
        mailingstreet = '1 rue de la paix',
        mailingcity ='Paris',
        mailingcountry ='France'
        );
        insert ctc;
        return ctc.Id;
}    
     @isTest static void NewContact() {
         
        String thisContactPost= AGXPostmanContact.createNewContact('1234', 'fabrice', 'like', 'likefabriced@sfr.fr');        
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE LastName ='like'];
        System.assertEquals(thisContact.Email, 'likefabriced@sfr.fr');
        System.assert(thisContact.Id != null);
         System.debug('This Contact Id : '+thisContact.Id);
         System.assert(thisContactPost.contains('Nouveau contact creer dans Salesforce'));
    }
    
    @isTest static void NewContactExist() {
        
        Id ctcId = SetupContact();         
        String thisContactPost= AGXPostmanContact.createNewContact('1234', 'fabrice', 'like', 'likefabrice@sfr.fr');        
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id =:ctcId];
        System.assertEquals(thisContact.Email, 'likefabrice@sfr.fr');
        System.assert(thisContactPost.contains('Le contact existe deja dans Salesforce'));
    }
    
     @isTest static void UpdateContactTest() {
         
        Id ctcId = SetupContact(); 
        RestRequest request = new RestRequest();
        request.requestURI = 'https://cunning-unicorn-74n66d-dev-ed.lightning.force.com//services/apexrest/Contacts/' + ctcId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"mailingcity":"Versailles"}');
        RestContext.request = request;
        String thisContactId = AGXPostmanContact.updateContact('1234', 'fabrice', 'like', 'likefabrice@sfr.fr','0102030405','1 rue de la paix','Versailles','France');
        
        Contact thisContact = [SELECT Id, mailingCity FROM Contact WHERE Id=:ctcId];
        
        System.assertEquals(thisContact.mailingCity, 'Versailles');
        System.assert(thisContactId.contains('Le contact est mis à jour'));
    }
    
     @isTest static void DeleteContactTest() {
         
        Id CtcId = SetupContact();
        RestRequest request = new RestRequest();
        request.requestURI =  'https://cunning-unicorn-74n66d-dev-ed.lightning.force.com//services/apexrest/Contacts/' + CtcId;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Active__c" : "false"}');
        RestContext.request = request;
         
        String thisContactId = AGXPostmanContact.deleteContact();
        
        Contact thisContact = [SELECT Id, Active__c FROM Contact WHERE Id =:CtcId];
        
        System.assertEquals(thisContact.Active__c, false);
         System.assert(thisContactId.contains('plus actif dans Salesforce'));
    }

}