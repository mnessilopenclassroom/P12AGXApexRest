@RestResource(urlMapping='/Contacts/*')
global with sharing class AGXPostmanContact {
    
  @HttpPost
    global static String createNewContact(String Password, String FirstName, String LastName, String Email) {     

    List<Contact> ctcList = [SELECT Id, Active__c FROM Contact WHERE Email =: Email] ;
    Contact ctc = (ctcList != null && ctcList.size()>0)?ctcList[0]:null;
        if (ctc != null) {
            return 'Le contact existe deja dans Salesforce : '+ctc.id;
        }
        else{
  			Contact thisContact = new Contact(
            Active__c = true,
            Password__c = Password,
            FirstName = FirstName,
            LastName = LastName,
            Email = Email);
            insert thisContact;
            return 'Nouveau contact creer dans Salesforce : '+ thisContact.id;            
    	}	
	}
    
  @HttpPut
	global static String updateContact(String Password, String FirstName, String LastName, String Email, 
                                   String Phone, String mailingstreet,String mailingcity, String mailingcountry){
    
    RestRequest request = RestContext.request;
  
	String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

	Contact result = [SELECT Id, Password__c, FirstName, LastName, Email, Phone, mailingstreet, mailingcity, mailingcountry FROM Contact WHERE Id = :id];
    Contact thisContact = new Contact(); 
    	thisContact.Id = id;  
    	thisContact.Password__c=Password;
        thisContact.FirstName = FirstName;
        thisContact.LastName = LastName ;
        thisContact.mailingstreet = mailingstreet ;
        thisContact.mailingcity = mailingcity ;
        thisContact.mailingcountry = mailingcountry ;
        thisContact.Phone = Phone ;
        thisContact.Email = Email;                                                    
             update thisContact;             
             return 'Le contact est mis à jour : '+thisContact.Id;
	}
    
    
    @HttpDelete
		global static String deleteContact(){
    
    RestRequest request = RestContext.request;
	String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
	
	Contact result = [SELECT Active__c FROM Contact WHERE Id = :id];
    Contact thisContact = new Contact(); 
    thisContact.Id = id; 
    thisContact.Active__c = false;  
   
             update thisContact;
             
             return 'Le contact '+thisContact.Id+' n\'est plus actif dans Salesforce';
}
    
    
}