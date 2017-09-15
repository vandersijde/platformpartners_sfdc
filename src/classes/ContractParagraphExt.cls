public with sharing class ContractParagraphExt {

    public String selectedObject {get;set;}
    public String selectedField {get;set;}

    public String fieldToDisplay {get{return '{!Contract__c.Name}';}set;}

    public ContractParagraphExt(ApexPages.StandardController controller) {

    }

    public List<SelectOption> objectList{
        get{
            return new List<SelectOption>{new SelectOption('Account', 'Account'),
                                          new SelectOption('Contact', 'Contact'),
                                          new SelectOption('Contract', 'Contract'),
                                          new SelectOption('Object', 'Object')};
        }
        set;
    }

    public List<SelectOption> fieldList{
        get{
            return new List<SelectOption>{new SelectOption('Contract Number', 'Contract Number')};
        }
        set;
    }

}