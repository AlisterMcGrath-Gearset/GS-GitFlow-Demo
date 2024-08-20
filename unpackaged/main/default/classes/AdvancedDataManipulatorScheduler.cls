public class AdvancedDataManipulatorScheduler {
    public void Schedule() {
        // Can't run jobs more than every hour but we can queue up 4 and ofset them by 15 minutes
        System.schedule('Generate0min', '0 0 * * * ?', new AdvancedDataManipulator());
        System.schedule('Generate15min', '0 15 * * * ?', new AdvancedDataManipulator());
        System.schedule('Generate30min', '0 30 * * * ?', new AdvancedDataManipulator());
        System.schedule('Generate45min', '0 45 * * * ?', new AdvancedDataManipulator());
    }
}