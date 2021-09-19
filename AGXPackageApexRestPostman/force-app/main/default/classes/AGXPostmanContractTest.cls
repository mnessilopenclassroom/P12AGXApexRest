@IsTest(SeeAllData=false)
public class AGXPostmanContractTest {
    
    @isTest static void NewContractTest() {
        String thisContractId = AGXPostmanContract.NewContract('TEST','Draft', Date.valueOf('2022-10-01'), 18);
        Account acc = new Account();
        acc = [SELECT id, Name FROM Account WHERE Name= 'TEST'];
        Id accId = acc.Id;
        Contract thisContract = [SELECT Id, ContractTerm, AccountId FROM Contract WHERE AccountId =:accId];
        
        System.assertEquals(thisContract.ContractTerm, 18);
        System.debug('Account Id '+thisContract.AccountId);
        System.debug('Contract Id '+thisContract.Id);
    }
    
    @isTest static void UpdateContractTest(){
        Account acc = new Account();
        acc.Name = 'TEST';
        insert acc;
        Id accId = acc.Id;
        Contract cont = new Contract(
        AccountId =  accId,
        Status = 'Draft',
        StartDate = Date.valueOf('2020-10-01'),
        ContractTerm = 18);
        insert cont;
        Id contId = cont.Id;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://cunning-unicorn-74n66d-dev-ed.lightning.force.com/services/apexrest/Contracts/' + contId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"ContractTerm":"12"}');
        RestContext.request = request;
        
        String thisContract = AGXPostmanContract.updateContract('TEST', 'Activated', Date.valueOf('2022-10-01') , 12);
        
        Contract myContract = [SELECT Id, Status FROM Contract WHERE Id=:contId];
        
        System.assertEquals(myContract.Status, 'Activated'); 
        System.assert(thisContract.contains('mis à jour dans Salesforce'));
    }

}