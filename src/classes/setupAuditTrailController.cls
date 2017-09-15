/**
 * @author			Richard van der Sijde
 * @date			18-11-2016
 * @description		This controller is used for vf page setupAuditTrail to make a more interactive 
 * 					overview of what has been changed in the setup. Usefull for deployments.
 * 
 */
public class setupAuditTrailController {

    public List<String> textToRemove{
        get{
            if(textToRemove ==  null){
                textToRemove = new List<String>{
                    'Changed ','Created ', 'Component ', 'Page ', 'Apex Class code', 'Static Resource ', 'Trigger code', ' '
                };
            }
            return textToRemove;
        }
        set;
    }
    
    public String startDateString{
        get{
            if(startDateString == null){
                startDateString = String.valueOf(System.Today().addDays(-90));
            }        
            return startDateString;
        }
        set{
            if(value != startDateString) sectionSelectList = null;
            startDateString = value;
        }
    }
    
    public String endDateString{
        get{
            if(endDateString == null){
                endDateString = String.valueOf(System.Today());
            }        
            return endDateString;
        }
        set{
            if(value != endDateString) sectionSelectList = null;
            endDateString = value;
        }
    }
    
    public Date startDate{
        get{
            if(startDateString != null) startDate = Date.valueOf(startDateString);
            return startDate;
        }
        set;
    }
    
    public Date endDate{
        get{
            if(endDateString != null) endDate = Date.valueOf(endDateString);
            return endDate;
        }
        set;
    }

    /**
     * @description		Constructor
     */
    public setupAuditTrailController(){
		ProcessSetupAuditTrail();        
    }
    
    /**
     * @description		Property Stores Section information
     */
    public Map<String, DisplayInfo> displayMap{
        get{
            if(displayMap == null) displayMap = new Map<String, DisplayInfo>();
            return displayMap;
        }
        set;
    }

    /**
     * @description		Method will process the setup audit trail data retrieved
     */
    private void ProcessSetupAuditTrail(){
		Set<String> sectionSet = new Set<String>();
        for(SectionSelect sectSelect:sectionSelectList){
            if(sectSelect.Selected){ 
            	system.debug('### selected action: ' + sectSelect.Label);	
                sectionSet.add(sectSelect.Label);
            }
        }
        for(List<SetupAuditTrail> satList:[SELECT action, display, section, CreatedDate, CreatedBy.Name FROM SetupAuditTrail WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate.addDays(1) ORDER BY CreatedDate desc]){
	        for(SetupAuditTrail sat:satList){
                if(sectionSet.contains(sat.Section)){
                	//Add display data
                    String displayName = sat.Display;
                    for(String removeText:textToRemove){
                        displayName = displayName.replace(removeText, '');
                    }
                    
                    if(displayMap.containsKey(displayName)){
                        Integer num = displayMap.get(displayName).numberOfItems;
                        num++;
                        displayMap.get(displayName).numberOfItems = num;
                    }else{
                        displayMap.put(displayName, new DisplayInfo(displayName, sat.Section, GetAction(sat.Action), sat.CreatedBy.Name, sat.CreatedDate.format('yyyy-MM-dd'), 1));
                    }
                }
            }
        }
    }
    
    private String GetAction(String act){
        String returnValue = act;
        String actLowerCase = act.toLowerCase();
        for(String action:actionMap.keySet()){
            if(actLowerCase.contains(action)){
                returnValue = actionMap.get(action);
                break;
            }
        }
        return returnValue;
    }
    
    private Map<String, String> actionMap{
        get{
            if(actionMap == null){
                actionMap = new Map<String, String>{'create'=>'Add','change'=>'Update','delete'=>'Remove'};
            }
            return actionMap;
        }
        set;
    }
    
    public PageReference ReloadPage(){
        displayMap = null;
        ProcessSetupAuditTrail();
        return null;
    }
    
    public List<SectionSelect> sectionSelectList{
        get{
            if(sectionSelectList == null){
                sectionSelectList = new List<SectionSelect>();
                Set<String> alreadyAddedSet = new Set<String>();
                for(List<SetupAuditTrail> satList:[SELECT Section FROM SetupAuditTrail WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate ORDER BY Section asc]){
                    for(SetupAuditTrail sat:satList){
                        if(sat.Section != null  && !alreadyAddedSet.contains(sat.Section)){ 
                            sectionSelectList.add(new SectionSelect(false, sat.Section));
                            alreadyAddedSet.add(sat.Section);
                        }
                    }
                }
            }
            return sectionSelectList;
        }
        set;
    }
    
    public class SectionSelect{
        public Boolean Selected {get;set;}
        public String Label {get;set;}
        
        public SectionSelect(Boolean selected, String label){
            this.Selected = selected;
            this.Label = label;
        }
    }
    
    public class DisplayInfo{
        Public String Label {get;set;}
        Public String Section {get;set;}
        Public String Action {get;set;}
        public String LastActionDate {get;set;}
        public String LastActorName {get;set;}
        Public Integer numberOfItems {get;set;}
        
        public DisplayInfo(String label, String section, String action, String actorName, String actionDate, Integer numberOfItems){
            this.Label = label;
            this.Section = section;
            this.Action = action;
            this.LastActionDate = actionDate;
            this.LastActorName = actorName;
            this.numberOfItems = numberOfItems;
        }
    }
    
    public PageReference ExportToExcel(){
        return Page.setupAuditTrailExport;
    }
}