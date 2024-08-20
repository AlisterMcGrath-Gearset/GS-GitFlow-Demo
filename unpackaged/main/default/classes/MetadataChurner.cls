global class MetadataChurner implements Schedulable {
   
   private Metadata.LayoutSection createSection() {
        Metadata.LayoutSection newLayoutSection = new Metadata.LayoutSection();
        newLayoutSection.style = Metadata.LayoutSectionStyle.OneColumn;
        newLayoutSection.label = 'Layout section that gets changed. Created: ' + Datetime.now().format();
        newLayoutSection.detailHeading = true;
        newLayoutSection.editHeading = true;
        
        Metadata.LayoutItem item = new Metadata.LayoutItem();
        item.behavior = Metadata.UiBehavior.ReadOnly;
        item.emptySpace = true;
        
        Metadata.LayoutColumn column = new Metadata.LayoutColumn();
        column.layoutItems.add(item);
        
        newLayoutSection.layoutColumns.add(column);
        
        return newLayoutSection;
    }
    
    private Metadata.Layout buildLayout() {
        // Retrieve Campaign layout and section 
        List<Metadata.Metadata> layouts = 
           Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {'Campaign-Campaign Layout'});
        Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0);

        Metadata.LayoutSection layoutSectionToEdit = null;
        List<Metadata.LayoutSection> layoutSections = layoutMd.layoutSections;
        for (Metadata.LayoutSection section : layoutSections) {
           if (section.label.startsWith('Layout section that gets changed.')) {
               layoutSectionToEdit = section;
               break;
           }
        }
        
        // Edit the section if we have one, create one if not.
        if (layoutSectionToEdit == null) {
           Metadata.LayoutSection newLayoutSection = createSection();
           layoutSections.add(newLayoutSection);
        } else {
           layoutSectionToEdit.label = 'Layout section that gets changed. Last changed: ' + Datetime.now().format();
        }

        return layoutMd;
    }
    
    private Metadata.DeployContainer constructDeploymentRequest() {
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        // Add components to container         
        Metadata.Layout layoutMetadata = buildLayout();
        container.addMetadata(layoutMetadata);
        return container;
    }
    
    public class PostInstallCallback implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result,
            Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.Succeeded) {
                // Deployment was successful, take appropriate action.
                System.debug('Deployment succeeded!');
            } else {
                // Deployment wasn’t successful, take appropriate action.
            	System.debug('Deployment did not suceed - '  + result.status.name());
            }
        }
    }
    
    // Deploy metadata
    private void deploy(Metadata.DeployContainer container) {
        // Create callback. 
        PostInstallCallback callback = new PostInstallCallback();
        // Deploy the container with the new components. 
        Id asyncResultId = Metadata.Operations.enqueueDeployment(container, callback);
    }
    
    global void execute(SchedulableContext ctx) {
        Metadata.DeployContainer container = constructDeploymentRequest();
        deploy(container);
        
        String now = Datetime.now().format();
        System.debug('Metadata munger ran @ ' + now);
   }
}