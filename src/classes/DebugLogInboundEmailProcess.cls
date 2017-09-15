global class DebugLogInboundEmailProcess implements Messaging.InboundEmailHandler {
 
  	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
 
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String myPlainText= '';
        myPlainText = email.plainTextBody;
       
        system.debug('### myPlainText: ' + JSON.serialize(myPlainText));

        //Process Body
        List<String> rows = myPlainText.split('\n');
        system.debug('### number of rows: ' + rows.size());
        
        result.success = true;
        return result;
  	}
}