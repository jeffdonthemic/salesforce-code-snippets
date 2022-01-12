public class AwesomeProductController {
    @AuraEnabled
    public static List<Product__c> getProducts() {
        return [select id, name, photo__c, description__c, points__c from product__c];
    }
    
    @AuraEnabled
    public static Product__c getProductByName(String name) {
        return [select id, name, photo__c, color__c,
                points__c, description__c,
                (select name from aotpjd__product_sizes__r order by name)
                from product__c where name = :name];
  