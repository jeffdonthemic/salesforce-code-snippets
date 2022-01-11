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


