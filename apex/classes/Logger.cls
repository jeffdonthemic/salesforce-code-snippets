/**

public virtual Decimal scoreParticipant(String membername) { 
  Logger.log(Logger.INFO, 'ChallengeBase', 
    'Scoring participant: ' + membername, 
    this.challengeId);
  // keep performing awesome Apex code
}

 */

public class Logger {

  public static String INFO = 'INFO';
  public static String DEBUG = 'DEBUG';
  public static String WARNING = 'WARNING';
  public static String ERROR = 'ERROR';
  public static String FATAL = 'FATAL';

  // insert a generic log entry 
  public static void log(String priority, String className, String message) { 
    insert (new Log__c(priority__c=priority,class__c=className,
      message__c=message));
  }
  
  // insert a log entry for a specific challenge record
  public static void log(String priority, String className, String message, ID challengeId) { 
    insert (new Log__c(priority__c=priority,class__c=className,
      message__c=message,challenge__c=challengeId));
  }

  // test method
  public static testMethod void testLogger() {
    Test.startTest();
    Logger.log(Logger.INFO, 'TestClassName', 'My Test Message');
    Test.stopTest();
    System.assertEquals(1,[select count() from Log__c where class__c = 'TestClassName']);
    // make sure the log info was written correctly
    Log__c log = [select Priority__c, Class__c, Message__c  from Log__c where class__c = 'TestClassName'];
    System.assertEquals(Logger.INFO,log.Priority__c);
    System.assertEquals('TestClassName',log.Class__c);
    System.assertEquals('My Test Message',log.Message__c);
  }

}