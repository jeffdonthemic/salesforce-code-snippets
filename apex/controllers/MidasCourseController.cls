public class midasCourseController {

    private final MIDAS_Course__c course = new MIDAS_Course__c(name='testing');
   
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller;

    String selectedLevel1;
    String selectedLevel2;
    String selectedLevel3;
   
    public midasCourseController(ApexPages.StandardController controller) {
   
        //initialize the stanrdard controller
        this.controller = controller;
       
        if (ApexPages.currentPage().getParameters().get('id').length() > 5) {
       
            this.course = (MIDAS_Course__c)controller.getRecord();
           
            selectedLevel1 = course.Course_Category_1__c;
            selectedLevel2 = course.Course_Category_2__c;
            selectedLevel3 = course.Course_Category_3__c;
          
        }
           
    }

    public String getSelectedLevel1() {return this.selectedLevel1;}   
    public void setSelectedLevel1(String s) {this.selectedLevel1 = s;}

    public String getSelectedLevel2() {return this.selectedLevel2;}   
    public void setSelectedLevel2(String s) { this.selectedLevel2 = s;}
   
    public String getSelectedLevel3() {return this.selectedLevel3;}   
    public void setSelectedLevel3(String s) { this.selectedLevel3 = s;} 

    public List<SelectOption> getLevel1Items() {
        List<SelectOption> options = new List<SelectOption>();
       
        options.add(new SelectOption('','-- Choose a Category --'));
        for (MIDAS_Course_Cat1__c cat : [select Id, Name from MIDAS_Course_Cat1__c Order By Name]) {
            options.add(new SelectOption(cat.Id,cat.Name));
        }
       
        return options;
    }
   
    public List<SelectOption> getLevel2Items() {
        List<SelectOption> options = new List<SelectOption>();
       
        if (selectedLevel1 != NULL) {
            options.add(new SelectOption('','-- Choose a Category --'));
            for (MIDAS_Course_Cat2__c cat : [select Id, Name from MIDAS_Course_Cat2__c Where MIDAS_Course_Cat1__c = :selectedLevel1 Order By Name]) {
                options.add(new SelectOption(cat.Id,cat.Name));
            }
        }
       
        return options;
    }
   
    public List<SelectOption> getLevel3Items() {
        List<SelectOption> options = new List<SelectOption>();
       
        if (selectedLevel2 != NULL) {
            options.add(new SelectOption('','-- Choose a Category --'));
            for (MIDAS_Course_Cat3__c cat : [select Id, Name from MIDAS_Course_Cat3__c Where MIDAS_Course_Cat2__c = :selectedLevel2 Order By Name]) {
                options.add(new SelectOption(cat.Id,cat.Name));
            }
        }
       
        return options;
    }           
  
    public MIDAS_Course_Book__c[] getBookInfo() {
        MIDAS_Course_Book__c[] bookInfo = [Select m.Book__r.Id, m.Book__r.Name, m.Book__c, m.Book__r.Edition_Number__c, m.Book__r.ISBN__c, m.Book__r.Lead_Author_Editor__c, m.Book__r.Version_Type__c, m.Name from MIDAS_Course_Book__c m Where m.Course__c = :course.Id];
        return bookInfo;
    } 
   
    public PageReference newBook() {
      // CF00NR0000000H9rc
      PageReference newPage = new PageReference('/a0z/e?retURL=%2F'+ApexPages.currentPage().getParameters().get('id'));
      newPage.setRedirect(true);
      return newPage;
    }   
   
    public PageReference create() {
       
        //add a second reference to the controller.getRecord() method to pull
        //over the newly populated fields from the standard controller
        //as these weren't retrieved during initialization
        MIDAS_Course__c newCourse = (MIDAS_Course__c)controller.getRecord();
       
        newCourse.Course_Category_1__c = selectedLevel1;
        newCourse.Course_Category_2__c = selectedLevel2;
        newCourse.Course_Category_3__c = selectedLevel3;
       
        try {
            insert(newCourse);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return (new ApexPages.StandardController(newCourse)).view();
    }   
   
mail.
    public PageReference cancel() {
        return (new ApexPages.StandardController(course)).cancel();
    }   
   
}
