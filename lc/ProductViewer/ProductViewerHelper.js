({
    getProducts: function(component) {
        var action = component.get("c.getProducts");
        var self = this;
        action.setCallback(this, function(a) {
            component.set("v.products", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getProduct: function(component, productName) {
        var action = component.get("c.getProductByName");
        action.setParams({
          "name": productName
        });
        var self = this;
        action.setCallback(this, function(a) {
            // display the product to the chrome dev console
            console.log(a.getReturnValue());
            component.set("v.product", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
})