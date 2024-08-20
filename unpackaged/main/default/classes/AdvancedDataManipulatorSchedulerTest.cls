@IsTest public class AdvancedDataManipulatorSchedulerTest {
    @IsTest(SeeAllData=true) public static void AdvancedDataManipulatorSchedulerTest() {
        // Instantiate a new controller with all parameters in the page
        AdvancedDataManipulatorScheduler controller = new AdvancedDataManipulatorScheduler();
        controller.Schedule();
    }
}