public static void upsertOpportunities(String accountName, List<String> oppNames) {
    // variables to hold data
    Id holdAccountId;
    Account accountRecord;
    List<Opportunity> opportunityList = new List<Opportunity>();

    // Determine whether Account record exists or whether Account is created with INSERT
    List<Account> accountList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
    if (accountList.isEmpty()) {
        accountRecord = new Account(Name = accountName);
        insert accountRecord;
        holdAccountId = accountRecord.Id;
    } else {
        holdAccountId = accountList[0].Id;
    }

    // Determine whether any Opportunities exist from the oppNames list
    List<Opportunity> existingOppList = [SELECT Id, Name FROM Opportunity WHERE Name IN :oppNames];

    // Set to keep track of existing opportunity names
    Set<String> existingOppNamesSet = new Set<String>();
    for (Opportunity opp : existingOppList) {
        existingOppNamesSet.add(opp.Name);
        // Update AccountId for existing opportunities
        opp.AccountId = holdAccountId;
    }

    // Add existing opportunities to the opportunity list
    opportunityList.addAll(existingOppList);

    // Create new opportunities for names not found in the existing list
    for (String oppName : oppNames) {
        if (!existingOppNamesSet.contains(oppName)) {
            Opportunity newOpportunity = createOpportunity(oppName, holdAccountId);
            opportunityList.add(newOpportunity);
        }
    }

    // Upsert all opportunities
    upsert opportunityList;
}

// Helper method to create an Opportunity
private static Opportunity createOpportunity(String oppName, Id accountId) {
    return new Opportunity(
        Name = oppName,
        AccountId = accountId,
        StageName = 'Qualification',
        Amount = 50000,
        CloseDate = Date.today().addMonths(3)
    );
}



/*
 start of testing info
// Prepare the Account name
        String accountName = 'cmTest02 Test Account';
    
        // Prepare the Opportunity names
        List<String> oppNames = new List<String>{ 'cmTest02 Opp 1', 'cmTest02 Opp 2', 'cmTest02 Opp 3' };
    
        // Call the method to test
        DMLOperations.upsertOpportunities(accountName, oppNames);

        DMLOperations.upsertOpportunities(accountName, oppNames);

        //SELECT Id, Name FROM Opportunity WHERE AccountId = '001Hp00003b1OWFIA2'
        SELECT Id, Name FROM Opportunity WHERE Name LIKE '%cmTest%'
 end of testing info
*/