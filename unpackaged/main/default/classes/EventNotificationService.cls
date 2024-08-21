public class EventNotificationService {

    // Sends notifications for updated events
    public static void sendUpdatedEventNotifications() {
        List<Event> updatedEvents = [SELECT Id, OwnerId, Subject FROM Event WHERE LastModifiedDate = LAST_N_DAYS:1];
        
        for (Event event : updatedEvents) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(event.OwnerId);
            mail.setSubject('Updated Event: ' + event.Subject);
            mail.setPlainTextBody('An event has been updated: ' + event.Subject);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    // Sends reminders for overdue events
    public static void sendOverdueEventReminders() {
        List<Event> overdueEvents = [SELECT Id, OwnerId, Subject, StartDateTime FROM Event WHERE StartDateTime < TODAY];
        
        for (Event event : overdueEvents) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(event.OwnerId);
            mail.setSubject('Overdue Event Reminder: ' + event.Subject);
            mail.setPlainTextBody('Reminder: You have an overdue event: ' + event.Subject + ' that was scheduled on ' + event.StartDateTime);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}