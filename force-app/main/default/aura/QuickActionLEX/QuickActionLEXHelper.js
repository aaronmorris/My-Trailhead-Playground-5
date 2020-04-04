({
    close : function(component, event, helper) {
        console.log('close function from helper');
        $A.get("e.force:closeQuickAction").fire();
    }
})