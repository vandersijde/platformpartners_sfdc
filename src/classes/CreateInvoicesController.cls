/**
 * @author        Richard van der Sijde (Platform Partners B.V.)
 * @date          27-03-2014
 * @description   This class is a controller for the CreateInvoices visualforce page.
 */
      
public with sharing class CreateInvoicesController {

    /**
     * @description    property which will return a map of orders with related orderline records
     */
    public Map<Id, List<Order_line__c>> orderLinesToInvoice{
        get{
            if(orderLinesToInvoice == null){
                orderLinesToInvoice = new Map<Id, List<Order_line__c>>();
                List<Order_line__c> orderLines = [SELECT Name, Order__c, Status__c, Description__c, Rate__c, Hours__c,
                                                  Amount_excl_VAT__c, Amount_incl_VAT__c, VAT__c 
                                                  FROM Order_line__c 
                                                  WHERE Status__c = 'Ready to invoice'];
                for(Order_line__c orderLine:orderLines){
                    if(orderLinesToInvoice.containsKey(orderLine.Order__c)){
                        orderLinesToInvoice.get(orderLine.Order__c).add(orderLine);
                    }else{
                        orderLinesToInvoice.put(orderLine.Order__c, new List<Order_line__c>{orderLine});
                    }
                }
            }
            return orderLinesToInvoice;
        }
        set;
    }
    
    /**
     * @description    property which will return a list of orders
     */
    public List<Order__c> ordersToInvoice{
        get{
            if(ordersToInvoice == null){
                ordersToInvoice = [SELECT Name, Customer_account__r.Name, Invoice_account__r.Name, Customer_account__c, Invoice_account__c
                                   FROM Order__c
                                   WHERE Id IN :orderLinesToInvoice.keySet()];
            }
            return ordersToInvoice;
        }
        set;
    }

    /**
     * @description    List of order instances (order class)
     */
    public List<order> orderList{
        get{
            if(orderList == null){
                orderList = new List<order>();
                for(Order__c ord:ordersToInvoice){
                    order o = new order(ord);
                    for(Order_line__c ordLine:orderLinesToInvoice.get(ord.Id)){
                        orderline ol = new orderline(ordLine);
                        o.orderLines.add(ol);
                    }
                    orderList.add(o);
                }
            }
            return orderList;
        }
        set;
    }

    /**
     * @description    order class to have a record associated with a selection boolean and a list of related orderlines
     */
    public class order{
        public Order__c Record {get;set;}
        public Invoice__c Invoice {get;set;}
        public List<Invoice_line__c> InvoiceLines {get;set;}   
        public List<orderline> orderlines {get;set;}
        
        public Boolean hasOrderlinesSelected {
            get{
                hasOrderlinesSelected = false;
                for(orderline ol:orderlines){
                    if(ol.Selected){ 
                        hasOrderlinesSelected = true;
                        break;
                    }
                }
                return hasOrderlinesSelected;    
            }
            set;
        }
        public Boolean Selected {
            get;
            set{
                system.debug('### value: ' + value);
                for(orderline ol:this.orderLines){
                    ol.Selected = value;
                }
                this.Selected = value;    
            }
        }
        
        /**
         * @description    constructor for the order class
         */
        public order(Order__c orderRecord){
            this.Record = orderRecord;
            this.orderLines = new List<orderline>();
            this.Selected = false;
        }
    }    

    /**
     * @description    orderline class to have a record associated with a selection boolean
     */
    public class orderline{
        public Boolean Selected {get;set;}
        public Order_line__c Record {get;set;}
        
        /**
         * @description    constructor for the orderline class
         */
        public orderline(Order_line__c orderLineRecord){
            this.Record = orderLineRecord;
            this.Selected = false;
        }
    }
    
    /**
     * @description    PageReference which will create the invoices for the selected items
     */
    public PageReference CreateInvoices(){
        Map<Invoice__c, List<Invoice_line__c>> invoicesToInsert = new Map<Invoice__c, List<Invoice_line__c>>();
        List<Invoice__c> invToInsert = new List<Invoice__c>();
        
        Integer invoiceNumber = GetLastInvoiceNumber();
        
        for(order o:orderList){
            if(o.hasOrderlinesSelected){
                invoiceNumber++;
                o.Invoice = new Invoice__c();
                o.Invoice.Name = String.valueOf(invoiceNumber);
                o.Invoice.Order__c = o.Record.Id;
                o.Invoice.Invoice_date__c = system.today();
                o.InvoiceLines = new List<Invoice_line__c>();

                for(orderline ol:o.orderlines){
                    Invoice_line__c il = new Invoice_line__c();
                    il.Hours__c = ol.Record.Hours__c;
                    il.Rate__c = ol.Record.Rate__c;
                    il.Description__c = ol.Record.Description__c;
                    o.InvoiceLines.add(il);
                }
                
                invToInsert.add(o.Invoice); 
            }
        }
        
        if(!invToInsert.isEmpty()){ 
            System.Savepoint sp = Database.setSavepoint();
            try{
                insert invToInsert;
            
                List<Invoice_line__c> invLineToInsert = new List<Invoice_line__c>();
                for(order o:orderList){
                    if(o.Invoice != null && o.Invoice.Id != null){
                        for(Invoice_line__c il:o.InvoiceLines){
                            il.Invoice__c = o.Invoice.Id;
                        }
                        invLineToInsert.addAll(o.InvoiceLines);                
                    }
                }
                
                insert invLineToInsert;    
                SetLastInvoiceNumber(String.valueOf(invoiceNumber));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Confirm, 'Invoices are created succesfully!'));
                
            }catch(DMLException ex){
                Database.rollback(sp);
                ApexPages.addMessages(ex);
            }
        }

        return null;
    }
    
    /**
     * @description    method to get the last invoice number from the custom settings
     */
    private Integer GetLastInvoiceNumber(){
    	InvoiceSettings__c invSettings = InvoiceSettings__c.getValues('LAST_INVOICE_NR');
    	return Integer.valueOf(invSettings.Value__c);
    }

    /**
     * @description    method to store the last invoice number in the custom settings
     */
    private void SetLastInvoiceNumber(String invNr){
    	InvoiceSettings__c invSettings = InvoiceSettings__c.getValues('LAST_INVOICE_NR');
    	invSettings.Value__c = invNr;
    	update invSettings;
    }
}