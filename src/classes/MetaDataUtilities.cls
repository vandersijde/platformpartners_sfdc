public class MetaDataUtilities {

    public static final String NO_PERMISSION = 'No Permission';
    public static final String READ_PERMISSION = 'Read Permission';
    public static final String WRITE_PERMISSION = 'Read/Write Permission';
    
    public static String GetFieldLevelSecurity(String objectName){
        String returnValue = '';
        Map<String, SObjectType> sObjMap = Schema.getGlobalDescribe();
		Map<String, FieldLevelSecurity> fldSecurityMap = new Map<String, FieldLevelSecurity>();
        
        if(sObjMap.containsKey(objectName)){	
	        SObjectType sObjType = sObjMap.get(objectName);
            Map<String, Schema.SObjectField> fldMap = sObjType.getDescribe().fields.getMap();
            for(Schema.SObjectField fld:fldMap.values()){
               	schema.DescribeFieldResult fldDesc = fld.getDescribe();
                fldSecurityMap.put(fldDesc.getLabel(), new FieldLevelSecurity(null, fldDesc.isAccessible(), fldDesc.isUpdateable(), fldDesc.getName(), String.valueOf(fldDesc.getType()) ));
            }

            returnValue = JSON.serialize(fldSecurityMap);
        }else{
			returnValue = 'The object "' + objectName + '" does not exist.';			            
        }

        return returnValue;
    }
    
    public class FieldLevelSecurity{
        public Id recordId {get;set;}
        public String apiName {get;set;}
        public String fieldType {get;set;}
        public Boolean visible {get;set;}
        public Boolean updatable {get;set;}
        public Boolean selected {get;set;}
        
        public FieldLevelSecurity(Id recordId, Boolean isVisible, Boolean isUpdatable, String objName, String fldType){
            visible = isVisible;
            updatable = isUpdatable;
            apiName = objName;
            fieldType = fldType;
            selected = false;
        }
    }
    
    public static Map<String, Map<String, FieldLevelSecurity>> GetFieldLevelSecurity(Set<String> profileNameSet, String objectType, Boolean isOwnedByProfile){
		String soql = 'SELECT ParentId ';
        soql += 'FROM ObjectPermissions ';
        soql += 'WHERE ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.Profile.Name IN :profileNameSet) ';
        soql += 'AND PermissionsRead = true ';
        soql += 'AND SobjectType = :objectType';
        if(isOwnedByProfile) soql += ' AND Parent.IsOwnedByProfile = :isOwnedByProfile';
		
        List<PermissionSetAssignment> psaList = [SELECT 
                                                 	PermissionSetId, 
                                                 	PermissionSet.IsOwnedByProfile, 
                                                 	Assignee.Profile.Name 
                                                 FROM 
                                                 	PermissionSetAssignment 
                                                 WHERE 
                                                 	Assignee.Profile.Name IN :profileNameSet
                                                 AND
                                                	PermissionSet.IsOwnedByProfile = :isOwnedByProfile];

        Map<Id, String> psaMap = new Map<Id, String>();
        for(PermissionSetAssignment psa:psaList){
            psaMap.put(psa.PermissionSetId, psa.Assignee.Profile.Name);
        }
        
		List<FieldPermissions> fpList = [SELECT 
                                          	SobjectType, 
                                          	Field, 
                                          	PermissionsRead,
                                          	PermissionsEdit,
                                         	ParentId
										  FROM 
                                          	FieldPermissions
										  WHERE 
                                          	ParentId IN :psaMap.keySet()
                                          AND 
                                          	SObjectType = :objectType];

        Map<String, Map<String, FieldLevelSecurity>> flsMap = new Map<String, Map<String, FieldLevelSecurity>>();
        for(FieldPermissions fp:fpList){
            if(flsMap.containsKey(psaMap.get(fp.ParentId))){
	            flsMap.get(psaMap.get(fp.ParentId)).put(fp.Field.toLowerCase(), new FieldLevelSecurity(fp.Id, fp.PermissionsRead, fp.PermissionsEdit, fp.Field, ''));
            }else{
                FieldLevelSecurity fls = new FieldLevelSecurity(fp.Id, fp.PermissionsRead, fp.PermissionsEdit, fp.Field, '');
                flsMap.put(psaMap.get(fp.ParentId), new Map<String, FieldLevelSecurity>{fp.Field.toLowerCase()=>fls});
            }
        }        
        return flsMap;
    }
    
    public static void SetFieldLevelSecurity(Map<String, Map<String, FieldLevelSecurity>> flsMap, String flsType){
        
    }
}