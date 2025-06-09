public class AdminVisibilityHandler {
    public static void applyObjectVisibility(Id userId) {
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        
        // Retrieve all custom objects
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        // Iterate over each object and assign visibility
        for (Schema.SObjectType obj : schemaMap.values()) {
            DescribeSObjectResult objDescribe = obj.getDescribe();
            
            // Check if the object is not a standard object
            if (!objDescribe.isCustom()) {
                continue;
            }
            
            String objectApiName = objDescribe.getName();
            
            // Check if the Permission Set for the object exists, create if not
            List<PermissionSet> permSetList = [SELECT Id FROM PermissionSet LIMIT 1];
            PermissionSet permSet;
            if (permSetList.isEmpty()) {
                permSet = new PermissionSet();
                permSet.Name = 'PS_' + objectApiName;
                permSet.Label = objectApiName + ' Permission Set';
                insert permSet;
                
                // Add object permissions
                ObjectPermissions objPerm = new ObjectPermissions();
                objPerm.ParentId = permSet.Id;
                objPerm.SObjectType = objectApiName;
                objPerm.PermissionsRead = true;
                objPerm.PermissionsCreate = true;
                objPerm.PermissionsEdit = true;
                objPerm.PermissionsDelete = true;
                objPerm.PermissionsViewAllRecords = true;
                objPerm.PermissionsModifyAllRecords = true;
                insert objPerm;
            } else {
                permSet = permSetList[0];
            }
            
            // Assign Permission Set to user
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = userId;
            psa.PermissionSetId = permSet.Id;
            psaList.add(psa);
        }
        
        if (!psaList.isEmpty()) {
            insert psaList;
        }
    }
}