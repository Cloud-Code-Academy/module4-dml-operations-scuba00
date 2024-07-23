/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Conrad Monreal
 */


public with sharing class DMLOperations {

    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}

    /**
     * Question 1 Completed
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {

        // Check for Account read and create permissions
        if (!Schema.sObjectType.Account.isAccessible() 
            || !Schema.sObjectType.Account.isCreateable()) {
                throw new OtherException('Current user does not have permission to read or create Account records.');
        }        

        // Create a new Account instance
        Account acct = new Account (
        // Set some fields on the Account
            Name = 'Nance Consulting'
        );
        // Insert the Account into the database
        insert acct;
        // Return the Id of the newly created Account
        Id newAccountId = acct.Id;
        return newAccountId;
    }

    /**
     * Question 2 Completed
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {

        // Check for Account read and create permissions
        if (!Schema.sObjectType.Account.isAccessible() 
            || !Schema.sObjectType.Account.isCreateable()) {
                throw new OtherException('Current user does not have permission to read or create Account records.');
        }

        // Create a new Account and set the fields inline
        Account acct = new Account (
            Name = name,
            Industry = industry
        );
        // Insert the Account
        insert acct;
    }

    
    /**
     * Question 3 Completed
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {

        // Check for Contact read and create permissions
        if (!Schema.sObjectType.Contact.isAccessible() 
            || !Schema.sObjectType.Contact.isCreateable()) {
                throw new OtherException('Current user does not have permission to read or create Contact records.');
        }

        // Create a new Contact instance
        Contact contactRecord = new Contact (
        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
            LastName = 'Conrad',
            AccountId = accountId
        );
        // Insert the Contact into the database
        insert contactRecord;

        // Return the Id of the newly created Contact
        return contactRecord.Id;
    }

    /**
     * Question 4 Completed
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {

        // Check for Contact read and update permissions
        if (!Schema.sObjectType.Contact.isAccessible() 
            || !Schema.sObjectType.Contact.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or update Contact records.');
        }

        // Retrieve the Contact from the database
        Contact contactRecord = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];
        
        // Update the Contact's last name
        contactRecord.LastName = newLastName;
        // Update the Contact in the database
        update contactRecord;
    }

    /**
     * Question 5 Completed
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {

        // Check for Opportunity read and update permissions
        if (!Schema.sObjectType.Opportunity.isAccessible() 
            || !Schema.sObjectType.Opportunity.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or update Opportunity records.');
        }

        // Retrieve the Opportunity from the database
        Opportunity oppRecord = [SELECT Id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        oppRecord.StageName = newStage;

        // Update the Opportunity in the database
        update oppRecord;
    }

    /**
     * Question 6 Completed
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {

        // Check for Account read and update permissions
        if (!Schema.sObjectType.Account.isAccessible() 
            || !Schema.sObjectType.Account.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or update Account records.');
        }

        // Query the account
        Account accountRecord = [SELECT Id FROM Account WHERE Id = :accountId];

        accountRecord.Name = newName;
        accountRecord.Industry = newIndustry;

        // Update the Account with the given Id with the new name and industry
        update accountRecord;
    }

    /**
     * Question 7 completed
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {

        // Check for Opportunity create and update permissions
        if (!Schema.sObjectType.Opportunity.isCreateable() 
            || !Schema.sObjectType.Opportunity.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or update Opportunity records.');
        }

        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        // Upsert the opportunities List so that records are either updated or created
        for(Opportunity opportunityRecord : opportunities){
            opportunityRecord.StageName = 'Qualification';
            opportunityRecord.CloseDate = Date.today().addMonths(3);
            opportunityRecord.Amount = 50000;
        }
        upsert opportunities;
    }

    /**
     * Question 8 Completed
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // variables to hold data
        Id holdAccountId;
        Account accountRecord;
        List<Opportunity> opportunityList = new List<Opportunity>();

        // Check for Account read and create permissions
        if (!Schema.sObjectType.Account.isAccessible() 
            || !Schema.sObjectType.Account.isCreateable()) {
                throw new OtherException('Current user does not have permission to read or create Account records.');
        }

        // Check for Opportunity read and create and update permissions
        if (!Schema.sObjectType.Opportunity.isAccessible() 
            || !Schema.sObjectType.Opportunity.isCreateable()        
            || !Schema.sObjectType.Opportunity.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or create or update Opportunity records.');
        }

        // Determine whether Account record exists or whether Account is created with INSERT
        List<Account> accountList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        if (accountList.isEmpty()){
            accountRecord = new Account(Name = accountName);
            insert accountRecord;
            holdAccountId = accountRecord.Id;
        } else {
            holdAccountId = accountlist[0].Id;
        }

        // Determine whether any Opportunities exist from the oppNames list
        List<Opportunity> existingOppList = [SELECT Id, Name FROM Opportunity WHERE Name IN :oppNames];
        
        /**
         * If the size of both lists, existingOppList and oppNames, are the same that means
         * all the opportunity names provided exist on the database.
        */
        if (existingOppList.size() == oppNames.size()) {
            
            for(Opportunity oppRecord : existingOppList){
                oppRecord.AccountId = holdAccountId;
            }
            opportunityList.addAll(existingOppList);

            /**
             * if the size of the existingOppList is zero, then all the opportunities
             * in oppNames need to be created
            */
        } else if (existingOppList.size() == 0) {
            
            for(String oppName : oppNames){
                Opportunity newOpportunity = createOpportunity(oppName, holdAccountId);
                opportunityList.add(newOpportunity);
            }

        } else {
            // modify existing opportunities with AccountId
            // addAll() is performed to add the entire list of existing opportunities to the opportunityList
            for(Opportunity oppRecord : existingOppList){
                oppRecord.AccountId = holdAccountId;
            }
            opportunityList.addAll(existingOppList);

            /**
             * Identify nonExistingOppNames:
             * First, create a Set that contains existing opportunities
             * Set allows for a more efficient search, based on a hash lookup
             * I could not use the existingOppList because it is a list defined of Opportunity 
             * objects.  oppNames is a list of strings.  I created a Set of strings to compare.
             */
            Set<String> existingOppNamesSet = new Set<String>();
            for (Opportunity opp : existingOppList) {
                existingOppNamesSet.add(opp.Name);
            }

            /**
             * Loop through the provided opportunity list (oppNames) to determine
             * which opportunities need to be formatted to be inserted in the database.
             * Each new opportunity is added to the opportunityList
             */
            for(String oppName : oppNames){
                if (!existingOppNamesSet.contains(oppName)) {
                    Opportunity newOpportunity = createOpportunity(oppName, holdAccountId);
                    opportunityList.add(newOpportunity);
                }
            }
        }

        // all opportunities are placed in the opportunityList collection for an upsert
        upsert opportunityList;
    }
    
    // Helper method for Problem 8, used to create an Opportunity
    private static Opportunity createOpportunity(String oppName, Id accountId) {
        return new Opportunity(
            Name = oppName,
            AccountId = accountId,
            StageName = 'Qualification',
            Amount = 50000,
            CloseDate = Date.today().addMonths(3)
        );
    }


    /**
     * Question 9 Completed
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {

        // Check for Account read and create and update permissions
        if (!Schema.sObjectType.Account.isAccessible() 
            || !Schema.sObjectType.Account.isCreateable()        
            || !Schema.sObjectType.Account.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or create or update Account records.');
        }

        Account accountFormatRecord = new Account();
        Account accountChkRec = new Account();
        
        Boolean createNewAccountRecord = true;

        try {
            accountChkRec = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
            createNewAccountRecord = false;
        } catch (System.QueryException e) {
            System.debug('Account does not exist');
        }

        if(createNewAccountRecord) {
            accountFormatRecord.Name = accountName;
            accountFormatRecord.Description = 'New Account';
        } else {
            accountChkRec.Description = 'Updated Account';
            accountFormatRecord = accountChkRec;
        }

        upsert accountFormatRecord;
        return accountFormatRecord;

/* Trying to understand I did both the List<Account> and try-catch processes.
        // If the Account does not exist, create a new one and set the description
		// if the Account exists, update the description
		// otherwise, create a new Account and set the description
        // Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

        Account accountRecord = new Account();
        if (accounts.isEmpty()){
            accountRecord.Name = accountName;
            accountRecord.Description = 'New Account';
        } else {
            accountRecord = accounts[0];
            accountRecord.Description = 'Updated Account';
        }
		// Upsert the Account
        upsert accountRecord;
		return accountRecord;
*/
        
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it.
     *  (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {

        // Check for Contacts 
        if (contactsToUpsert.size() == 0) {
                throw new OtherException('contactsToUpsert list is empty - no records to process.');
        }

        // Check for Account read and create and update permissions
        if (!Schema.sObjectType.Account.isAccessible() 
            || !Schema.sObjectType.Account.isCreateable()        
            || !Schema.sObjectType.Account.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or create or update Account records.');
        }

        // Check for Contact read and create and update permissions
        if (!Schema.sObjectType.Contact.isAccessible() 
            || !Schema.sObjectType.Contact.isCreateable()        
            || !Schema.sObjectType.Contact.isUpdateable()) {
                throw new OtherException('Current user does not have permission to read or create or update Contact records.');
        }


        Map<String, Id> accountNameToIdMap = new Map<String, Id>();

        List<String> contactLastNamesList = new List<String>();

        // Loop through each Contact
		// Extract the Account Name from Contact's LastName
        for (Contact contactRecord : contactsToUpsert) {
            contactLastNamesList.add(contactRecord.LastName);    
        }

		// Get the account based on the name or create one if it doesn't exist
        // Step01: Determine whether any Accounts exist from the contactsToUpsert list and add them to the accountNametoIdMap
        List<Account> existingAccountList = [SELECT Id, Name FROM Account WHERE Name IN :contactLastNamesList];

        /**
         * If the size of both lists, existingOppList and oppNames, are the same that means
         * all the opportunity names provided exist on the database.
        */
        if (existingAccountList.size() > 0) {
            
            for(Account accountRecord : existingAccountList){
                accountNameToIdMap.put(accountRecord.Name, accountRecord.Id);
            }
            

            /**
             * if the size of the existingAccountList is zero, then all the Contacts
             * in contactsToUpser need an Account to be created
            */
        }
        
        // Step02: create new accounts
        List<Account> createNewAccountList = new List<Account>();

        for (Contact contactRecord : contactsToUpsert) {
            if (!accountNameToIdMap.containsKey(contactRecord.LastName)) {
                Account newAccount = new Account (Name = contactRecord.LastName);
                createNewAccountList.add(newAccount);
            }
        }
         
        if(createNewAccountList.size() > 0){
            Insert createNewAccountList;

            for(Account acountRecord : createNewAccountList){
                accountNameToIdMap.put(acountRecord.Name, acountRecord.Id);
            }
        } 

        // Step03: Link the Account to the Contact
        for (Contact contactRecord : contactsToUpsert) {
            contactRecord.AccountId = accountNameToIdMap.get(contactRecord.LastName);
        }

        // all AccountIds are placed in the contactsToUpsert collection for an upsert
        upsert contactsToUpsert;
    
    }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {

        // Check for Lead read and create and update and delete permissions
        if (!Schema.sObjectType.Lead.isAccessible() 
            || !Schema.sObjectType.Lead.isCreateable()        
            || !Schema.sObjectType.Lead.isUpdateable()
            || !Schema.sObjectType.Lead.isDeletable()) {
                throw new OtherException('Current user does not have permission to read or create or update or delete Lead records.');
        }

        List<Lead> leadsToInsert = new List<Lead>();

        // Loop through each Lead name
        for(String leadName : leadNames) {
            Lead leadRecord = new Lead(LastName = leadName, Company = 'Test');
            leadsToInsert.add(leadRecord);
        }

        // Insert the Leads
        insert leadsToInsert;

        // Delete the Leads
        try {
            delete leadsToInsert;
            System.debug('Leads successfully deleted.');
        } catch (DmlException e) {
            System.debug('Error deleting Leads: ' + e.getMessage());
        }

    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
 
        // Check for Case read and create and update and delete permissions
        if (!Schema.sObjectType.Case.isAccessible() 
            || !Schema.sObjectType.Case.isCreateable()        
            || !Schema.sObjectType.Case.isUpdateable()
            || !Schema.sObjectType.Case.isDeletable()) {
            throw new OtherException('Current user does not have permission to read or create or update or delete Case records.');
        }        
            
        List<Case> casesToInsert = new List<Case>();

            
        for (Integer i = 0; i < numOfCases; i++) {
            Case caseRecord = new Case(AccountId = accountId, Status = 'New', Origin = 'Web');
            casesToInsert.add(caseRecord);
        }

        // Insert the Cases
        insert casesToInsert;

        // Delete the cases
            try {
            delete casesToInsert;
            System.debug('Cases successfully deleted.');
        } catch (DmlException e) {
            System.debug('Error deleting Cases: ' + e.getMessage());
        }
       
    }
}