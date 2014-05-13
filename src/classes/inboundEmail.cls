global class inboundEmail implements Messaging.InboundEmailHandler {
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
 
		// Create an InboundEmailResult object for returning the result of the
		// Apex Email Service
		
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

		String myPlainText= '';
		myPlainText = email.plainTextBody;
		Task[] newTask = new Task[0];

		Contact con = [SELECT Id, Name, Email FROM Contact WHERE Email = :email.fromAddress LIMIT 1];

		if (con == null) {

			Contact contact = new Contact();
		    Contact.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
		    Contact.LastName = email.fromname.substring(email.fromname.indexOf(' '));
		    Contact.Email = env.fromAddress;
		    Contact.From_Inbound__c = true;
		    insert contact;

		    newTask.add(new Task(
			Description =  myPlainText,
		    Priority = 'Normal',
		    Status = 'Inbound Email',
		    Subject = email.subject,
		    WhoId =  con.Id));
		    insert newTask; 

		}
		else {

		newTask.add(new Task(
			Description =  myPlainText,
		    Priority = 'Normal',
		    Status = 'Inbound Email',
		    Subject = email.subject,
		    WhoId =  con.Id));

		}

		return result;
	}
}