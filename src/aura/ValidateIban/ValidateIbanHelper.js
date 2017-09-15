({
	validateIBAN : function(component, iban) {
		var action = component.get("c.IsIBANValid");
		action.setParams({
          "iban": iban
      	});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.isValid", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})