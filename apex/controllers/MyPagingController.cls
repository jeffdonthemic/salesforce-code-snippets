public class MyPagingController {

private List accounts;
private List pageAccounts;
private Integer pageNumber;
private Integer pageSize;
private Integer totalPageNumber;


public Integer getPageNumber()
{
return pageNumber;
}

public List getAccounts()
{
return pageAccounts;
}

public Integer getPageSize()
{
return pageSize;
}

public Boolean getPreviousButtonEnabled()
{
return !(pageNumber > 1);
}

public Boolean getNextButtonDisabled()
{
if (accounts == null) return true;
else
return ((pageNumber * pageSize) >= accounts.size());
}

public Integer getTotalPageNumber()
{
if (totalPageNumber == 0 && accounts !=null)
{
totalPageNumber = accounts.size() / pageSize;
Integer mod = accounts.size() - (totalPageNumber * pageSize);
if (mod > 0)
totalPageNumber++;
}

return totalPageNumber;
}

public MyPagingController()
{
pageNumber = 0;
totalPageNumber = 0;
pageSize = 20;
ViewData();
}

public PageReference ViewData()
{
accounts = null;
totalPageNumber = 0;
BindData(1);
return null;
}

private void BindData(Integer newPageIndex)
{
try
{

if (accounts == null)
accounts = [Select id, Name, Phone, Fax from Account limit 1000];


pageAccounts = new List();

Transient Integer counter = 0;
Transient Integer min = 0;
Transient Integer max = 0;

if (newPageIndex > pageNumber)
{
min = pageNumber * pageSize;
max = newPageIndex * pageSize;
}
else
{
max = newPageIndex * pageSize;
min = max - pageSize;
min = (min <>
}


for(Account a : accounts)
{
counter++;
if (counter > min && counter <= max)
pageAccounts.add(a);
}

pageNumber = newPageIndex;

if (pageAccounts == null || pageAccounts.size() <= 0)
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
}
catch(Exception ex)
{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
}

}

public PageReference nextBtnClick() {

BindData(pageNumber + 1);
return null;
}

public PageReference previousBtnClick() {

BindData(pageNumber - 1);
return null;
}

}
