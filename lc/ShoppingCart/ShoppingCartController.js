({
    handleAddToCartEvent : function(component, event, helper) {
        var product = event.getParam("product");
        var items = component.get("v.items");
        if (!items) items = []; 
        items.push(product);
        component.set("v.total", parseInt(component.get("v.total")) + product.aotpjd__Points__c);
        component.set("v.items", items);
    },
})