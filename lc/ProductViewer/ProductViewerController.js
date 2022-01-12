({
    doInit : function(component, event, helper) {
        // for demo, just grab this product by name
        helper.getProduct(component, 'Always Be Yourself');
        helper.getProducts(component);
    },
    change : function(component, event, helper) {
        // get the value of the select option
        selectedName = event.target.value;
        helper.getProduct(component, selectedName);
    },    
    addToCart : function(component, event, helper) {
       var product = component.get("v.product");
       var evt = $A.get("e.aotpjd:AddToCart");
       evt.setParams({
        "product": product
       });
       evt.fire();
    },
})