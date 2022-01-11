public class CalloutClass {
    @future(callout=true)
    public static void makeCallout() {
        HttpRequest request = new HttpRequest();
        String endpoint = 'http://yourHost/yourService';
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = new HTTP().send(request);
    }
}