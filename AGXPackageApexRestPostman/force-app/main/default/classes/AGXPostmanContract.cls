@RestResource(urlMapping='/Contracts/*')
global with sharing class AGXPostmanContract {
    
     @HttpPost
    global static String NewContract(String Name, String Status, Date StartDate, Integer ContractTerm) {
        //Créer compte 
        Account Acc = new Account(
        Name = Name);
        insert Acc;        
        Id accId = Acc.Id;
        
        // Créer contrat avec Id compte créé
 	 Contract thisContract = new Contract(
   	 Name=Name,
   	 Status=Status,
   	 AccountId = accId,
   	 StartDate = StartDate,
   	 ContractTerm = ContractTerm);
    	insert thisContract;
                    
    return 'Le Contrat est bien creer dans Salesforce : '+thisContract.Id;
    }
    
    @HttpPut
	global static String updateContract(String Name, String Status, Date StartDate, Integer ContractTerm){
  
    RestRequest request = RestContext.request;
    // Id en paramètre récuperé
	String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

	Contract result = [SELECT Id FROM Contract WHERE Id = :id];
    Contract thisContract = new Contract(); 
    thisContract.Id = id;  
    thisContract.Name = Name;
    thisContract.Status=Status;
    thisContract.StartDate=StartDate;
    thisContract.ContractTerm=ContractTerm;
   
      update thisContract;
              
      return 'Le contrat '+thisContract.Id+' est mis à jour dans Salesforce';
}

}