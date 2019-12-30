/**
* Name			:	HAE_SearchProducts
* Date			:	11/29/2019
* Description	:	This is the controller class for HAE_ProductView LWC	
*/public class HAE_SearchProducts {
   /**
	* Name			:	fetchProductsByName
	* Param			: 	String: Product Name
	* Return		:   List of matched product.
	* Description	:	This method returns list of products.
	*/   
    @AuraEnabled(cacheable=true)
    public static List<HAE_Product_Attributes__c> fetchProductsByName(String productName,String caseRegion){ 
        return [SELECT Id, HAE_Product__r.Name, HAE_Region__c FROM HAE_Product_Attributes__c WHERE HAE_Product__r.Name LIKE :'%'+productName+'%' AND HAE_Region__c = :caseRegion]; 
    }   
}