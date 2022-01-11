public class WebServiceCallout {

	@future (callout=true)
	public static void sendMail() {
		
		String id = '4rwr3---1';
		String name = 'MyName';	
		String description = 'Mydescription';
		String addresses = 'jeff@jeffdouglas.com,jeff.douglas@informausa.com';			
		
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://dev.bluemethod.com/ws/sendMail.cfm?id='+id+'&name='+EncodingUtil.urlEncode(name, 'UTF-8')+'&description='+EncodingUtil.urlEncode(description, 'UTF-8')+'&addresses='+EncodingUtil.urlEncode(addresses, 'UTF-8'));
		req.setMethod('GET');
		req.setCompressed(true); // otherwise we hit a limit of 32000
		Http http = new Http();
		HttpResponse res = http.send(req);
		System.debug('========================== response: '+res);
	}
	
	// run WebServiceCallout.testMe(); from Execute Anonymous
	public static testMethod void testMe() {
		WebServiceCallout.sendMail();
	}

}
