public class MyFutureClass {
    // Include callout=true when making callouts
    @future(callout=true)    
    static void myFutureMethod(Set<Id> ids) {
        List<Contact> contacts = [SELECT Id, LastName, FirstName, Email
            FROM Contact WHERE Id IN :ids];
        for (Contact con: contacts) {
            String response = anotherClass.calloutMethod(con.Id,
                con.FirstName,
                con.LastName,
                con.Email);
            // May want to add some code here to log response
        }
    }
}