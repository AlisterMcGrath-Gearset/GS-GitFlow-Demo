global class AdvancedDataManipulator implements Schedulable {

    Integer AccountCount = 0;
    Integer CaseCount = 0;
    Integer ContactCount = 0;
    Integer LeadCount = 0;
    Integer OpportunityCount = 0;
	
    RandomDataGenerator randomizer = new RandomDataGenerator();
    
    private void GetGlobalDataSetCounts() {
        AccountCount = [SELECT COUNT() FROM Account];
        CaseCount = [SELECT COUNT() FROM Case];
        ContactCount = [SELECT COUNT() FROM Contact];
        LeadCount = [SELECT COUNT() FROM Lead];
        OpportunityCount = [SELECT COUNT() FROM Opportunity];
    }

    private void CreateRandomAccount() {
        Account newAccount = new Account();
        newAccount.Name = randomizer.GenerateRandomFullName();
        newAccount.Phone = randomizer.GenerateRandomPhone();
        insert newAccount;
        AccountCount = AccountCount + 1;
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
    
    private void CreateRandomContact() {
        Contact newContact = new Contact();
        newContact.FirstName = randomizer.GenerateRandomFirstName();
        newContact.LastName = randomizer.GenerateRandomLastName();
        newContact.Description = randomizer.GenerateRandomStringOfMaxLength(20);
        insert newContact;
        ContactCount = ContactCount + 1;
    }
    
    private Contact GetRandomContact(){
        Integer contactsCount = ContactCount;
        Integer randomContactIndex = Math.floor(Math.random() * contactsCount).intValue();
        return [SELECT FirstName, LastName, Description FROM Contact LIMIT 1 OFFSET :randomContactIndex];
    }
    
    private void DeleteRandomContact() {
        Contact contactToDelete = GetRandomContact();
        delete contactToDelete;
        ContactCount = ContactCount - 1;
    }
    
    private void EditRandomContact() {
        Contact contactToEdit = GetRandomContact();
        contactToEdit.FirstName = randomizer.GenerateRandomFirstName();
        contactToEdit.LastName = randomizer.GenerateRandomLastName();
        contactToEdit.Description = randomizer.GenerateRandomStringOfMaxLength(20);
        update contactToEdit;
    }
    
    private void CreateRandomLead() {
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
        LeadCount = LeadCount + 1;
    }
    
    private void EditRandomLead() {
        Lead leadToEdit = GetRandomLead();
        leadToEdit.Company = randomizer.GenerateRandomCompany();
        leadToEdit.Phone = randomizer.GenerateRandomPhone();
        update leadToEdit;
    }
    
    private void CreateRandomOpportunity() {
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Description =  randomizer.GenerateRandomStringOfMaxLength(20); 
        newOpportunity.Name = randomizer.GenerateRandomCompany();
        newOpportunity.StageName = 'Stage1';
        newOpportunity.CloseDate =  date.newInstance(2020, 5, 1);
        insert newOpportunity;
        OpportunityCount = OpportunityCount + 1;
    }
    
    private Opportunity GetRandomOpportunity(){
        Integer opportunitiesCount = OpportunityCount;
        Integer randomOpportunityIndex = Math.floor(Math.random() * opportunitiesCount).intValue();
        return [SELECT NextStep, Description FROM Opportunity LIMIT 1 OFFSET :randomOpportunityIndex];
    }
    
    private void DeleteRandomOpportunity() {
        Opportunity opportunityToDelete = GetRandomOpportunity();
        delete opportunityToDelete;
        OpportunityCount = OpportunityCount - 1;
    }
    
    private void EditRandomOpportunity() {
        Opportunity opportunityToEdit = GetRandomOpportunity();
        opportunityToEdit.NextStep = randomizer.GenerateRandomStringOfMaxLength(5);
        opportunityToEdit.Description = randomizer.GenerateRandomStringOfMaxLength(10);
        update opportunityToEdit;
    }
    
    private void DoAccountAction() {
        try {
            Integer actionIndex =  randomizer.GetRandomNumber(3);
            
            switch on actionIndex {
                 when 0 {
                     CreateRandomAccount();
                 }
                 when 1 {
                    DeleteRandomAccount();
                 }
                 when 2 {
                     EditRandomAccount();
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
    
    private void DoContactAction() {
        try {
            Integer actionIndex =  randomizer.GetRandomNumber(3);
    
            switch on actionIndex {
                when 0 {
                    CreateRandomContact();
                }
                when 1 {
                    DeleteRandomContact();
                }
                when 2 {
                    EditRandomContact();
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
                    CreateRandomLead();
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

    private void DoOpportunityAction() {
        try {
            Integer actionIndex =  randomizer.GetRandomNumber(3);
    
            switch on actionIndex {
                when 0 {
                    CreateRandomOpportunity();
                }
                when 1 {
                    DeleteRandomOpportunity();
                }
                when 2 {
                    EditRandomOpportunity();
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
        
        GetGlobalDataSetCounts();
        
        for (Integer i = 0; i < 15; i++) {
            DoAccountAction();
            DoCaseAction();
            DoContactAction();
            DoLeadAction();
            DoOpportunityAction();
        }
        
        String now = Datetime.now().format();
        System.debug('Data munger ran @ ' + now);
   }   
}