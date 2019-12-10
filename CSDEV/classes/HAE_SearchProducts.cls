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
    public static List<Product2> fetchProductsByName(String productName){ 
        return [SELECT Id, NAME FROM Product2 WHERE NAME LIKE :'%'+productName+'%']; 
    }   
}