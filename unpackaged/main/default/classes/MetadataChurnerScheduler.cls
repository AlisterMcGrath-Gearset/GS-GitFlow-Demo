public class MetadataChurnerScheduler {
    public void Schedule() {
        // Can't run jobs more than every hour but we can queue up 4 and ofset them by 15 minutes
        System.schedule('ChurnMetadata0min', '0 0 * * * ?', new MetadataChurner());
        System.schedule('ChurnMetadata15min', '0 15 * * * ?', new MetadataChurner());
        System.schedule('ChurnMetadata30min', '0 30 * * * ?', new MetadataChurner());
        System.schedule('ChurnMetadata45min', '0 45 * * * ?', new MetadataChurner());
    }
}