/**
*******************************************************************************
* trac_TestDataFactory  part of the Telus Agri project
* @description this class contains setup data for all the test classes
* @author Neha Jain, Traction on Demand
* @date 2020-12-18
*
*******************************************************************************
*/

@isTest
public class trac_TestDataFactory {

/**
    * @description this method used to create test Account records
    * @param numberOfRecords - Integer, the no. of records need to be created
    * @param isInsert - Boolean, the records need to be inserted or not
    * @param fieldValueByFieldName - Map<String,String>, field value by field name for Account records to be created
    * @return listOfTestAccounts - List<Account>, list of inserted Account records
    */
    public static List<Account> createTestAccounts(Integer numberOfRecords, Boolean isInsert,Map<String, String> fieldValueByFieldName) {
        List<Account> listOfTestAccounts = new List<Account>();

        for(Integer i=0; i<numberOfRecords; i++) {
            Account account = new Account();
            account.Name = getFieldValues(fieldValueByFieldName, 'Name', 'Test Account' + i);
            account.Type = getFieldValues(fieldValueByFieldName, 'Type', 'Analyst');
            account.Website = getFieldValues(fieldValueByFieldName, 'Website', 'www.Testwebsite.com');
            account.Sub_Industry__c = getFieldValues(fieldValueByFieldName, 'Sub_Industry__c', '3rd Party Applicator');
            account.Industry__c = getFieldValues(fieldValueByFieldName, 'Industry__c', 'Equipment Company');
            account.Vertical__c = getFieldValues(fieldValueByFieldName, 'Vertical__c', 'Agri-Business');
            listOfTestAccounts.add(account);
        }
        if(isInsert) {
            insert listOfTestAccounts;
        }

        return listOfTestAccounts;
    }

    /**
    * @description this method used to create test Opportunity records
    * @param numberOfRecords - Integer, the no. of records need to be created
    * @param isInsert - Boolean, the records need to be inserted or not
    * @param fieldValueByFieldName - Map<String,String>, field value by field name for Opportunity records to be created
    * @param listOfContacts - List<Contact>, list of Contacts used for lookup field 'Position_Reports_To__c'
    * @param recordTypeName - String, RecordType name for Opportunity
    * @return listOfTestOpportunities - List<Opportunity>, list of inserted Opportunity records
    */
    public static List<Opportunity> createTestOpportunities(Integer numberOfRecords, Boolean isInsert,
            Map<String, String> fieldValueByFieldName, List<Account> listOfAccounts,Map<String, Decimal> cycleTimeMap) {
        List<Opportunity> listOfTestOpportunities = new List<Opportunity>();

        for(Integer i=0; i<numberOfRecords; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = getFieldValues(fieldValueByFieldName, 'Name', 'Test Opportunity' + i);
            opp.CloseDate = System.today() + 12 ;
            opp.StageName = getFieldValues(fieldValueByFieldName, 'StageName', trac_Constants.OPP_STAGE_SIT6_REPOSITORY) ;
            if(cycleTimeMap.containsKey('Cycle_Time_SIT_6_to_SIT_5__c')){
                opp.Cycle_Time_SIT_6_to_SIT_5__c = cycleTimeMap.get('Cycle_Time_SIT_6_to_SIT_5__c');
            }
            if(cycleTimeMap.containsKey('Cycle_Time_SIT_5_to_SIT_4__c')){
                opp.Cycle_Time_SIT_5_to_SIT_4__c = cycleTimeMap.get('Cycle_Time_SIT_5_to_SIT_4__c');
            }
            if(cycleTimeMap.containsKey('Cycle_Time_SIT_4_to_SIT_3__c')){
                opp.Cycle_Time_SIT_4_to_SIT_3__c = cycleTimeMap.get('Cycle_Time_SIT_4_to_SIT_3__c');
            }
            if(cycleTimeMap.containsKey('Cycle_Time_SIT_3_to_SIT_2__c')){
                opp.Cycle_Time_SIT_3_to_SIT_2__c = cycleTimeMap.get('Cycle_Time_SIT_3_to_SIT_2__c');
            }
            if(cycleTimeMap.containsKey('Cycle_Time_SIT_2_to_SIT_1__c')){
                opp.Cycle_Time_SIT_2_to_SIT_1__c = cycleTimeMap.get('Cycle_Time_SIT_2_to_SIT_1__c');
                opp.Competitor_Name__c = 'DCI';
            }
            if(cycleTimeMap.containsKey('Cycle_Time_SIT_1_to_Closed__c')){
                opp.Cycle_Time_SIT_1_to_Closed__c = cycleTimeMap.get('Cycle_Time_SIT_1_to_Closed__c');
                opp.Competitor_Name__c = 'DCI';
            }
            opp.Project_Name__c = getFieldValues(fieldValueByFieldName, 'Project Name', 'Test Project' + i);
            if(listOfAccounts.size() >= numberOfRecords) {
                opp.AccountId = listOfAccounts[i].Id;
            }
            else if(listOfAccounts.size() == 1 && numberOfRecords > 1) {
                opp.AccountId = listOfAccounts[0].Id;
            }

            listOfTestOpportunities.add(opp);
        }

        if(isInsert) {
            insert listOfTestOpportunities;
        }

        return listOfTestOpportunities;
    }

    /**
    * @description method is used to check whether valueByFieldName Map contains field values, if yes then return value else null.
    * @param fieldValueByFieldName - Map<String, String>, sObject field value by Field API Name
    * @param fieldName - String, sObject field API name
    * @return String, field's value if map contains the field else null
    */
    private static String getFieldValues(Map<String, String> fieldValueByFieldName, String fieldName, String fieldValue) {
        if(fieldValueByFieldName != null && fieldValueByFieldName.containsKey(fieldName)) {
            return fieldValueByFieldName.get(fieldName);
        }

        return fieldValue;
    }

}