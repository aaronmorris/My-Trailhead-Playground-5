({
    initialize: function(component, event, helper) {
        // If using a quick action, this will close the pop up window
        // setTimeout($A.getCallback(function() {
        //     $A.get("e.force:closeQuickAction").fire();
        // }));
    }, 

    recordUpdated: function(component, event, helper) {
        let account = component.get('v.accountRecord');
        console.log('recordUpdated');
        console.log('Name: ' + account.Name);
        console.log('CreatedDate: ' + account.CreatedDate);

        var userId = $A.get('$SObjectType.CurrentUser.Id');
        console.log('userId: ' + userId); 
        component.set('v.showButton', true);
    },

    generateRenewal: function(component, event, helper) {
        console.log('QuickActionLEXController.generateRenewal');
        var accountId = component.get('v.recordId');
        var sObject = component.get('v.accountRecord');
        console.log('accountId: ' + accountId);
        console.log('Name: ' + component.get('v.acct.Name'));
        console.log('sObject: ', sObject);
        console.log('set to account');
    }
})