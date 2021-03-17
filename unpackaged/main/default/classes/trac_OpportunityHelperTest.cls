/**
*******************************************************************************
* trac_OpportunityHelperTest  part of Telus Agri project
* @description this test class contains methods to test the methods of trac_OpportunitySelector class
* @author Neha Jain, Traction on Demand
* @date 2020-12-18
*
*******************************************************************************
*/
@isTest
public with sharing class trac_OpportunityHelperTest {

/**
    * @description creates test data for Opportunity and related objects using class trac_TestDataFactory
    * @return null
    */
    @testSetup static void setup() {
        //Inserting Accounts
        List<Account> listOfTestAccounts = trac_TestDataFactory.createTestAccounts(1, true, new Map<String, String>());
        Map<String,String> oppFieldMap = new Map<String, String>();
        Map<String,Decimal> cycleTimeMap = new Map<String, Decimal>();

        //Inserting Opportunities
        trac_TestDataFactory.createTestOpportunities(1, true, new Map<String, String>(), listOfTestAccounts,new Map<String, Decimal>() );

        oppFieldMap.put('Project Name','Project Name 5');
        oppFieldMap.put('Name','Name 5');
        oppFieldMap.put('StageName',trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET);
        cycleTimeMap.put('Cycle_Time_SIT_6_to_SIT_5__c',6);
        trac_TestDataFactory.createTestOpportunities(1, true, oppFieldMap, listOfTestAccounts,cycleTimeMap);
        oppFieldMap.put('Project Name','Project Name 4');
        oppFieldMap.put('Name','Name 4');
        cycleTimeMap.put('Cycle_Time_SIT_5_to_SIT_4__c',5);
        oppFieldMap.put('StageName',trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY);
        trac_TestDataFactory.createTestOpportunities(1, true, oppFieldMap, listOfTestAccounts,cycleTimeMap);

        oppFieldMap.put('Project Name','Project Name 3');
        oppFieldMap.put('Name','Name 3');
        oppFieldMap.put('StageName',trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY);
        cycleTimeMap.put('Cycle_Time_SIT_4_to_SIT_3__c',4);
        trac_TestDataFactory.createTestOpportunities(1, true, oppFieldMap, listOfTestAccounts,cycleTimeMap);

        oppFieldMap.put('Project Name','Project Name 2');
        oppFieldMap.put('Name','Name 2');
        oppFieldMap.put('StageName',trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION);
        cycleTimeMap.put('Cycle_Time_SIT_3_to_SIT_2__c',3);
        trac_TestDataFactory.createTestOpportunities(1, true, oppFieldMap, listOfTestAccounts,cycleTimeMap);

        oppFieldMap.put('Project Name','Project Name 1');
        oppFieldMap.put('Name','Name 1');
        oppFieldMap.put('StageName',trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY);
        cycleTimeMap.put('Cycle_Time_SIT_2_to_SIT_1__c',2);
        trac_TestDataFactory.createTestOpportunities(1, true, oppFieldMap, listOfTestAccounts,cycleTimeMap);

        oppFieldMap.put('Project Name','Closed Project Name');
        oppFieldMap.put('Name','Name 0');
        oppFieldMap.put('StageName',trac_Constants.OPP_STAGE_CLOSED_LOST);
        cycleTimeMap.put('Cycle_Time_SIT_1_to_Closed__c',1);
        List<Opportunity> listOfOpportunities = trac_TestDataFactory.createTestOpportunities(1, false, oppFieldMap, listOfTestAccounts,cycleTimeMap);
        listOfOpportunities[0].Lost_Reason__c = 'Strategic Alignment & Relationship';
        listOfOpportunities[0].Lost_Reason_Details__c = 'Bankruptcy';
//        listOfOpportunities[0].Competitor_Name__c = 'DCI';
        listOfOpportunities[0].Deal_Lost_Reason_Comments__c = 'Lost';
        insert listOfOpportunities;


    }

    @isTest
    static void checkStageOrderTest() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity];
        try {
            for (Opportunity opportunity : listOfOpportunities) {
                opportunity.StageName = trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY;
            }
            Test.startTest();
            update listOfOpportunities;
            Test.stopTest();
        } catch (Exception e) {
            System.assert(e.getMessage().contains(System.Label.Error_SkipOppStage), e.getMessage());
        }
    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT5Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT6_REPOSITORY];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addDays(-4);
        }
        update listOfOpportunities;
            for (Opportunity opportunity : listOfOpportunities) {
                opportunity.StageName = trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET;
            }
            Test.startTest();
            update listOfOpportunities;
            Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_6_to_SIT_5__c FROM Opportunity];
        System.assertEquals(4,newOppList[0].Cycle_Time_SIT_6_to_SIT_5__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT4Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET];
        System.debug('106::listOfOpportunities=='+listOfOpportunities);
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addDays(-10);
        }
        update listOfOpportunities;
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(10,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT5ReverseTest() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity
        Where StageName = :trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addHours(-4);
        }
        update listOfOpportunities;
        System.debug('129::reverse listOfOpportunities=='+listOfOpportunities);
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT6_REPOSITORY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_6_to_SIT_5__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT3Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addDays(-4);
        }
        update listOfOpportunities;
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(4,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT4ReverseTest() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addHours(-4);
        }
        update listOfOpportunities;
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT2Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addDays(-4);
        }
        update listOfOpportunities;
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_3_to_SIT_2__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(4,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT3Reverse1Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT3Reverse2Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT6_REPOSITORY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_6_to_SIT_5__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT1Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName,Competitor_Name__c FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addDays(-10);
        }
        update listOfOpportunities;
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY;
            opportunity.Competitor_Name__c = 'DCI';
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(10,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT2Reverse1Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT2Reverse2Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT2Reverse3Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT2Reverse4Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT6_REPOSITORY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_6_to_SIT_5__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);

    }


    @isTest
    static void insertCycleTimeWhenStageChangeForClosedTest() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY];
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.Last_Stage_Change__c = System.now().addDays(-10);
        }
        update listOfOpportunities;
        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_CLOSED_LOST;
            opportunity.Lost_Reason__c = 'Strategic Alignment & Relationship';
            opportunity.Lost_Reason_Details__c = 'Bankruptcy';
            opportunity.Competitor_Name__c = 'None';
            opportunity.Deal_Lost_Reason_Comments__c = 'Lost';
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(10,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT1Reverse1Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT1Reverse2Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT1Reverse3Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForSIT1Reverse4Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForSIT1Reverse5Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT6_REPOSITORY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_6_to_SIT_5__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForClosedReverse1Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_CLOSED_LOST];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Cycle_Time_SIT_1_to_Closed__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForClosedReverse2Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_CLOSED_LOST];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Cycle_Time_SIT_1_to_Closed__c,Cycle_Time_SIT_2_to_SIT_1__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForClosedReverse3Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_CLOSED_LOST];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForClosedReverse4Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_CLOSED_LOST];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }
    @isTest
    static void insertCycleTimeWhenStageChangeForClosedReverse5Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_CLOSED_LOST];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }

    @isTest
    static void insertCycleTimeWhenStageChangeForClosedReverse6Test() {
        List<Opportunity> listOfOpportunities = [SELECT Id,Name,StageName FROM Opportunity Where StageName = :trac_Constants.OPP_STAGE_CLOSED_LOST];

        for (Opportunity opportunity : listOfOpportunities) {
            opportunity.StageName = trac_Constants.OPP_STAGE_SIT6_REPOSITORY;
        }

        Test.startTest();
        update listOfOpportunities;
        Test.stopTest();
        List<Opportunity> newOppList = [SELECT Id,StageName,Cycle_Time_SIT_5_to_SIT_4__c,Cycle_Time_SIT_6_to_SIT_5__c,Cycle_Time_SIT_4_to_SIT_3__c,Cycle_Time_SIT_3_to_SIT_2__c,Cycle_Time_SIT_2_to_SIT_1__c,Cycle_Time_SIT_1_to_Closed__c FROM Opportunity where id = :listOfOpportunities[0].Id];
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_6_to_SIT_5__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_5_to_SIT_4__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_4_to_SIT_3__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_3_to_SIT_2__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_2_to_SIT_1__c);
        System.assertEquals(0,newOppList[0].Cycle_Time_SIT_1_to_Closed__c);

    }
}