public class ProfileComparisonController {

    public String[] selectedProfiles {
        get{
            if(selectedProfiles == null) selectedProfiles = new List<String>();
            return selectedProfiles;
        }
        set;
    }
    
    public String selectedObject {get;set;}
    
    public ProfileComparisonController(){
        
    }
    
    public List<SelectOption> profileSelectList{
        get{
            if(profileSelectList == null){
                profileSelectList = new List<SelectOption>();
                List<Profile> profileList = [SELECT Name FROM Profile LIMIT 250];
                for(Profile prof:profileList){
                    profileSelectList.add(new SelectOption(prof.Name, prof.Name));
                }
                profileSelectList.sort();
            }
            return profileSelectList;
        }
        set;
    }

    public List<SelectOption> objectSelectList{
        get{
            if(objectSelectList == null){
                objectSelectList = new List<SelectOption>{new SelectOption('', '-- Select an Object --')};
                Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
                for(String obj:objTypeMap.keySet()){
                    Schema.DescribeSObjectResult objDesc = objTypeMap.get(obj).getDescribe();
                    if(!objDesc.isCustomSetting() && objDesc.isSearchable()){
	                    objectSelectList.add(new SelectOption(objDesc.getName(), objDesc.getLabel()));
                    }
                }
                objectSelectList.sort();
            }
            return objectSelectList;
        }
        set;
    }
    
    public String JSONOutput {get;set;}
    
    public Map<String, Map<String, MetaDataUtilities.FieldLevelSecurity>> fieldLevelData{
        get{
            if(fieldLevelData == null){
                fieldLevelData = new Map<String, Map<String, MetaDataUtilities.FieldLevelSecurity>>();
            }
            return fieldLevelData;
        }
        set;
    }
 
    public PageReference RetrieveFLS(){
        if(selectedObject != null && selectedObject != '' && !selectedProfiles.isEmpty()){
            selectedObjectFieldMap = null;
            fieldLevelData = null;
            Set<String> profileSet = new Set<String>();
            profileSet.addAll(selectedProfiles);
            fieldLevelData = MetaDataUtilities.GetFieldLevelSecurity(profileSet, selectedObject, true);
            for(String profile:fieldLevelData.keySet()){
                for(String fld:selectedObjectFieldMap.keySet()){
                    if(!fieldLevelData.get(profile).containsKey(fld)){
                        fieldLevelData.get(profile).put(fld, new MetaDataUtilities.FieldLevelSecurity(null, false, false, fld, ''));
                    }
                }
            }
            JSONOutput = JSON.serializePretty(fieldLevelData);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select an object and one or more profiles!'));
        }
        return null;
    }
    
    public PageReference SetNoPermission(){
        MetaDataUtilities.SetFieldLevelSecurity(fieldLevelData, MetaDataUtilities.NO_PERMISSION);
        return null;
    }
    
    public PageReference SetReadPermission(){
        MetaDataUtilities.SetFieldLevelSecurity(fieldLevelData, MetaDataUtilities.READ_PERMISSION);
        return null;
    }

    public PageReference SetReadWritePermission(){
        MetaDataUtilities.SetFieldLevelSecurity(fieldLevelData, MetaDataUtilities.WRITE_PERMISSION);
        return null;
    }

    public Map<String, String> selectedObjectFieldMap{
        get{
            if(selectedObjectFieldMap == null){
                selectedObjectFieldMap = new Map<String, String>();
                if(selectedObject != null && selectedObject != ''){	
                	Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
                    Map<String, Schema.SObjectField> fldResMap = objTypeMap.get(selectedObject).getDescribe().fields.getMap();
    
                    for(String fld:fldResMap.keySet()){
                        Schema.DescribeFieldResult fr = fldResMap.get(fld).getDescribe();
                        selectedObjectFieldMap.put(selectedObject.toLowerCase() + '.' + fld, fr.getLabel());
                        String fldType = fr.isCalculated() ? 'FORMULA' : String.valueOf(fr.getType());
                        fldTypeMap.put(selectedObject.toLowerCase() + '.' + fld, fldType);
                    }
                }
            }
            return selectedObjectFieldMap;
        }
        set;
    }

    public Map<String, String> fldTypeMap{
        get{
            if(fldTypeMap == null) fldTypeMap = new Map<String, String>();
            return fldTypeMap;
        }
        set;
    }

}