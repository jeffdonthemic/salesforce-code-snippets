global class ProcessJobApplicantEmail implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
      
      Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
      
      Contact contact = new Contact();
      contact.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
      contact.LastName = email.fromname.substring(email.fromname.indexOf(' '));
      contact.Email = envelope.fromAddress;
      insert contact;
      
      System.debug('====> Created contact '+contact.Id);
      
      if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
          for (integer i = 0 ; i < email.binaryAttachments.size(); i++) {
              Attachment attachment = new Attachment();
              // attach to the newly created contact record
              attachment.ParentId = contact.Id;
              attachment.Name = email.binaryAttachments[i].filename;
              attachment.Body = email.binaryAttachments[i].body;
              insert attachment;
            }
      }
      return result;
    }
}