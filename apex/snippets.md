```
// Using RSA-SHA1 with Crypto Class
String algorithmName = 'RSA';
String key = 'pkcs8 format private key';
Blob privateKey = EncodingUtil.base64Decode(key);
Blob input = Blob.valueOf('12345qwerty');
Crypto.sign(algorithmName, input, privateKey);
```



```
// DML Database Methods
// https://blog.jeffdouglas.com/2009/11/02/using-saleforce-dml-statements-or-dml-database-methods/

List<Contact> contacts = new List<Contact>();

for (Integer i = 0; i < 5; i++) {
 contacts.add(new Contact(FirstName='First '+i,LastName='Last '+i,Email='my@email.com'));
}

try {

 Database.SaveResult[] results = Database.insert(contacts,false);
 if (results != null){
  for (Database.SaveResult result : results) {
   if (!result.isSuccess()) {
    Database.Error[] errs = result.getErrors();
    for(Database.Error err : errs)
     System.debug(err.getStatusCode() + ' - ' + err.getMessage());
    }
   }
  }

} catch (Exception e) {
 System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
}
```

```
String pdfContent = 'This is a test string';
Account a = new account(name = 'test');
insert a;
Attachment attachmentPDF = new Attachment();
attachmentPdf.parentId = a.id;
attachmentPdf.name = a.name + '.pdf';
attachmentPdf.body = blob.toPDF(pdfContent);
insert attachmentPDF;
```

```
// Random list of things
List<string> theList = new list<string>();
theList.add('item 0');
theList.add('item 1');
theList.add('item 2');
theList.add('item 3');
theList.add('item 4');
theList.add('item 5');

// Random items to retrieve from list
Integer i = math.mod(math.abs(Crypto.getRandomInteger()), obList.size());

theList.get(i);
```

```
Create a new date
Date.newInstance(2006,10,10)); 
```

```
Dynamic SOQL and Casting Results to a List

String qry = 'Select c.Name, c.Id From Cat3__c c Where c.Name LIKE \'%'+searchText+'%\' Order By c.Name';
// cast the results as a List of Cat3__c objects   	
searchResults = (List<Cat3__c>)Database.query(qry);
```


