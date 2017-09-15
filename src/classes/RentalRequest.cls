@RestResource(urlMapping='/RentalRequest/*')
global with sharing class RentalRequest {

    @HttpPost	
    global static Response requestNewRental(Request req) {
        Response resp = new Response();
        resp.Status = 'OK';
        resp.Message = 'You send me: ' + req.CompanyName;
        return new Response();
    }
	
    global class Request{
        global String CompanyName;
    }

    global class Response{
        global String Status;
        global String Message;
    }
}