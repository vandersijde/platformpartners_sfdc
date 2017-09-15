({
    doInit : function(component, event, helper){
        
    },
	validateIBAN : function(component, event, helper) {
        helper.validateIBAN(component, component.get("v.iban"));
	}
})