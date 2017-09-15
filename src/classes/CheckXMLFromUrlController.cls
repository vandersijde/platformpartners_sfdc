public class CheckXMLFromUrlController {

    public String url {get;set;}
    public String response {get;set;}
    
    public CheckXMLFromUrlController(){
        
    }
    
    public PageReference SendRequest(){
        response = '';
        if(url != null){
            Http http = new Http(); 
            HttpRequest req = new HttpRequest(); 
            req.setMethod('GET'); 
            req.setHeader('Accept', 'application/xml'); 
            req.setHeader('Content-Type', 'application/xml'); 
            req.setEndpoint(url); 
            try{	
                HttpResponse res = http.send(req);
                response = res.getBody();
            }catch(Exception ex){
                response = ex.getMessage();
            }
        }
        return null;
    }
}