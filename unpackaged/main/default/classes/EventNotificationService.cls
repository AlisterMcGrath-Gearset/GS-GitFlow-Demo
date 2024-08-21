public class EventNotificationService {

    // Sends notifications for new events
    public static void sendNewEventNotifications() {
        List<Event> newEvents = [SELECT Id, OwnerId, Subject FROM Event WHERE CreatedDate = LAST_N_DAYS:1];
        
        for (Event event : newEvents) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(event.OwnerId);
            mail.setSubject('New Event: ' + event.Subject);
            mail.setPlainTextBody('You have a new event: ' + event.Subject);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    // Sends reminders for upcoming events
    public static void sendUpcomingEventReminders() {
        List<Event> upcomingEvents = [SELECT Id, OwnerId, Subject, StartDateTime FROM Event WHERE StartDateTime = NEXT_N_DAYS:3];
        
        for (Event event : upcomingEvents) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(event.OwnerId);
            mail.setSubject('Upcoming Event Reminder: ' + event.Subject);
            mail.setPlainTextBody('Reminder: You have an event coming up: ' + event.Subject + ' on ' + event.StartDateTime);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}