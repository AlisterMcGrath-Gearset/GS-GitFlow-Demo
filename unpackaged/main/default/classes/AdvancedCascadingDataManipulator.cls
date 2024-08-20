global class AdvancedCascadingDataManipulator implements Schedulable {

    Integer AccountCount = 0;
    Integer CaseCount = 0;
    Integer ContactCount = 0;
    Integer LeadCount = 0;
    Integer OpportunityCount = 0;
    Integer PriceBookEntryCount = 0;
    
    Id PricebookId;
    List<PriceBookEntry> PricebookEntries;
        
    RandomDataGenerator randomizer = new RandomDataGenerator();
    
    private void Initialise() {
        AccountCount = [SELECT COUNT() FROM Account];
        CaseCount = [SELECT COUNT() FROM Case];
        ContactCount = [SELECT COUNT() FROM Contact];
        LeadCount = [SELECT COUNT() FROM Lead];
        OpportunityCount = [SELECT COUNT() FROM Opportunity];
        
        PricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
        PriceBookEntryCount = [SELECT COUNT() FROM PriceBookEntry];
        PricebookEntries = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE Pricebook2Id = :PricebookId];
    }

    //
    // Accounts
    // 
    private void CreateAccountAndAssociatedItems() {
        
        Account newAccount = CreateAccount();
        
        List<sObject> childRecordsToInsert = new List<sObject>();
        
        Integer numberOfContacts = 1 + randomizer.GetRandomNumber(2);
        for (Integer i = 0; i < numberOfContacts; i++) {
            Contact newContact = CreateContactOnAccount(newAccount);
        	childRecordsToInsert.add((sObject)newContact);
        }
        Database.insert(childRecordsToInsert, false);
        
        List<Opportunity> opportunityRecordsToInsert = new List<Opportunity>();
        Integer numberOfOpportunities = 1 + randomizer.GetRandomNumber(4);
        for (Integer i = 0; i < numberOfOpportunities; i++) {
            Opportunity newOpportunity = CreateOpportunityOnAccount(newAccount);
            opportunityRecordsToInsert.add(newOpportunity);
        }
        
        Database.SaveResult[] opportunityCreationResults = Database.insert(opportunityRecordsToInsert, false);
        
        List<OpportunityLineItem> opportunityLineItemRecordsToInsert = new List<OpportunityLineItem>();
        for (Database.SaveResult oppCreateResult : opportunityCreationResults) {
            if (!oppCreateResult.isSuccess()) {
                continue;
            }
        	Integer numberOfOpportunityLineItems = 1 + randomizer.GetRandomNumber(4);
            for (Integer i = 0; i < numberOfOpportunityLineItems; i++) {
                OpportunityLineItem newOpportunityLineItem = CreateOpportunityLineItem(oppCreateResult.getId());
                
                opportunityLineItemRecordsToInsert.add(newOpportunityLineItem);
            }
        }
        Database.insert(opportunityLineItemRecordsToInsert, false);
    }
    
    private Account CreateAccount() {
        Account newAccount = new Account();
        newAccount.Name = randomizer.GenerateRandomFullName();
        newAccount.Phone = randomizer.GenerateRandomPhone();
        
        insert newAccount;
        AccountCount = AccountCount + 1;
        
        return newAccount;
    }
    
    private Account GetRandomAccount(){
        Integer accountsCount = AccountCount;
        Integer randomAccountIndex = Math.floor(Math.random() * accountsCount).intValue();
        return [SELECT Name FROM Account LIMIT 1 OFFSET :randomAccountIndex];
    }
    
    private void DeleteRandomAccount() {
        Account accountToDelete = GetRandomAccount();
        delete accountToDelete;
        AccountCount = AccountCount - 1;
    }
    
    private void EditRandomAccount() {
        Account accountToEdit = GetRandomAccount();
        accountToEdit.Name = randomizer.GenerateRandomFullName();
        accountToEdit.Phone = randomizer.GenerateRandomPhone();
        update accountToEdit;
    }
   
    //
    // Contacts
    //  
    private Contact CreateContactOnAccount(Account account) {
        Contact newContact = new Contact();
        newContact.FirstName = randomizer.GenerateRandomFirstName();
        newContact.LastName = randomizer.GenerateRandomLastName();
        newContact.Description = randomizer.GenerateRandomStringOfMaxLength(20);
        newContact.AccountId = account.Id;
        ContactCount = ContactCount + 1;
        
        return newContact;
    }
    
    private void EditRandomContact() {
        Integer randomContactIndex = Math.floor(Math.random() * ContactCount).intValue();
        Contact contactToEdit = [SELECT FirstName, LastName, Description FROM Contact LIMIT 1 OFFSET :randomContactIndex];
        
        contactToEdit.FirstName = randomizer.GenerateRandomFirstName();
        contactToEdit.LastName = randomizer.GenerateRandomLastName();
        contactToEdit.Description = randomizer.GenerateRandomStringOfMaxLength(20);
        update contactToEdit;
    }
    
    //
    // Opportunity, OpportunityLineItem
    // 
    
    private Pricebook2 GetPricebook2Id() {
        return [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
    }
    
    private PriceBookEntry GetRandomPriceBookEntryOnPricebook(Id pricebookId) {
        
        Integer priceBookEntryIndex = Math.floor(Math.random() * PricebookEntries.size()).intValue();
        return PricebookEntries.get(priceBookEntryIndex);
    }
    
    private OpportunityLineItem CreateOpportunityLineItem(Id opportunityId) {
        
        PriceBookEntry priceBookEntry = GetRandomPriceBookEntryOnPricebook(PricebookId);
        
        OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem();
        newOpportunityLineItem.OpportunityId = opportunityId; 
        newOpportunityLineItem.PricebookEntryId = priceBookEntry.Id;
        newOpportunityLineItem.Quantity = randomizer.GetRandomNumber(20);
        newOpportunityLineItem.TotalPrice = randomizer.GetRandomNumber(2000);
        
        return newOpportunityLineItem;
    }
    
    private Opportunity CreateOpportunityOnAccount(Account account) {
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Description =  randomizer.GenerateRandomStringOfMaxLength(20); 
        newOpportunity.Name = randomizer.GenerateRandomCompany();
        newOpportunity.StageName = 'Stage1';
        newOpportunity.CloseDate =  date.newInstance(2020, 5, 1);
        newOpportunity.AccountId = account.Id;
        newOpportunity.Pricebook2Id = PricebookId;
        
        OpportunityCount = OpportunityCount + 1;
        
        return newOpportunity;
    }
    
    private void EditRandomOpportunity() {
        Integer randomOpportunityIndex = Math.floor(Math.random() * OpportunityCount).intValue();
        Opportunity opportunityToEdit = [SELECT NextStep, Description FROM Opportunity LIMIT 1 OFFSET :randomOpportunityIndex];
        
        opportunityToEdit.NextStep = randomizer.GenerateRandomStringOfMaxLength(5);
        opportunityToEdit.Description = randomizer.GenerateRandomStringOfMaxLength(10);
        update opportunityToEdit;
    }
    
    //
    // Cases
    // 
    private void CreateRandomCase() {
        Case newCase = new Case();
        newCase.IsEscalated = randomizer.GenerateRandomBool();
        newCase.Reason = randomizer.GenerateRandomStringOfMaxLength(10);
        insert newCase;
        CaseCount = CaseCount + 1;
    }
    
    private Case GetRandomCase() {
        Integer casesCount = CaseCount;
        Integer randomCaseIndex = Math.floor(Math.random() * casesCount).intValue();
        return [SELECT IsEscalated, Reason FROM Case LIMIT 1 OFFSET :randomCaseIndex];
    }
    
    private void DeleteRandomCase() {
        Case caseToDelete = GetRandomCase();
        delete caseToDelete;
        CaseCount = CaseCount - 1;
    }
    
    private void EditRandomCase() {
        Case caseToEdit = GetRandomCase();
        caseToEdit.IsEscalated = !caseToEdit.IsEscalated;
        caseToEdit.Reason = randomizer.GenerateRandomStringOfMaxLength(10);
        update caseToEdit;
    }
    
    //
    // Leads
    // 
    private void CreateLead() {
        Lead newLead = new Lead();
        newLead.LastName = randomizer.GenerateRandomLastName();
        newLead.Company = randomizer.GenerateRandomCompany();
        newLead.Phone = randomizer.GenerateRandomPhone();
        insert newLead;
        LeadCount = LeadCount + 1;
    }
    
    private Lead GetRandomLead(){
        Integer leadsCount = LeadCount;
        Integer randomLeadIndex = Math.floor(Math.random() * leadsCount).intValue();
        return [SELECT Company, Phone FROM Lead LIMIT 1 OFFSET :randomLeadIndex];
    }
    
    private void DeleteRandomLead() {
        Lead leadToDelete = GetRandomLead();
        delete leadToDelete;
        LeadCount = LeadCount - 1;
    }
    
    private void EditRandomLead() {
        Lead leadToEdit = GetRandomLead();
        leadToEdit.Company = randomizer.GenerateRandomCompany();
        leadToEdit.Phone = randomizer.GenerateRandomPhone();
        update leadToEdit;
    }
    
    private void DoAccountAction() {
        try {
            Integer actionIndex = randomizer.GetRandomNumber(3);
            
            switch on actionIndex {
                 when 0 {
                     CreateAccountAndAssociatedItems();
                 }
                 when 1 {
                     DeleteRandomAccount();
                 }
                 when 2 {
                     EditRandomAccount();
                     EditRandomContact();
                     EditRandomOpportunity();
                 }
                 when else {
                     System.debug('default');
                 }
            }
        }
        catch (DmlException e) {
            System.debug('DmlException exception caught ' + e.getMessage());
        }
        catch (SObjectException e) {
            System.debug('SObject exception caught ' + e.getMessage());
        }
        catch (System.QueryException e) {
            System.debug('QueryException exception caught ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('Generic exception caught ' + e.getMessage());
        }
    }
    
    private void DoCaseAction() {
        try {
            Integer actionIndex =  randomizer.GetRandomNumber(3);
    
            switch on actionIndex {
                when 0 {
                    CreateRandomCase();
                }
                when 1 {
                    DeleteRandomCase();
                }
                when 2 {
                    EditRandomCase();
                }
                when else {
                    System.debug('default');
                }
            }
        }
        catch (DmlException e) {
            System.debug(e.getMessage());
        }
        catch (SObjectException e) {
            System.debug('SObject exception caught ' + e.getMessage());
        }
        catch (System.QueryException e) {
            System.debug('QueryException exception caught ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('Generic exception caught ' + e.getMessage());
        }
    }
    
    private void DoLeadAction() {
        try {
            Integer actionIndex =  randomizer.GetRandomNumber(3);
    
            switch on actionIndex {
                when 0 {
                    CreateLead();
                }
                when 1 {
                    DeleteRandomLead();
                }
                when 2 {
                    EditRandomLead();
                }
                when else {
                    System.debug('default');
                }
            }
        }
        catch (DmlException e) {
            System.debug(e.getMessage());
        }
        catch (SObjectException e) {
            System.debug('SObject exception caught ' + e.getMessage());
        }
        catch (System.QueryException e) {
            System.debug('QueryException exception caught ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('Generic exception caught ' + e.getMessage());
        }
    }
    
    global void execute(SchedulableContext ctx) {
        
        Initialise();
        
        for (Integer i = 0; i < 15; i++) {
            DoAccountAction();
            DoCaseAction();
            DoLeadAction();
        }
        
        String now = Datetime.now().format();
        System.debug('Data munger ran @ ' + now);
   }   
}