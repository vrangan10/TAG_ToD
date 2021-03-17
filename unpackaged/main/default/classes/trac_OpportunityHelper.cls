/**
*******************************************************************************
* trac_OpportunityHelper  part of the Telus Agri project
* @description Helper class to have the business logic for Opportunity object
* @author Neha Jain, Traction on Demand
* @date 2020-17-02
*
*******************************************************************************
*/

public with sharing class trac_OpportunityHelper {

    public static void insertCycleTimeWhenStageChange(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {
        for (Opportunity opportunity : newOpportunities) {
            if(oldOpportunities.get(opportunity.Id).StageName != opportunity.StageName && oldOpportunities.get(opportunity.Id).Last_Stage_Change__c!=null){
                if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY && opportunity.StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET){
                    opportunity.Cycle_Time_SIT_6_to_SIT_5__c = (System.now().getTime() -oldOpportunities.get(opportunity.Id).Last_Stage_Change__c.getTime())/ 1000 / 60 / 60 / 24;
                } else if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET){
                    if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = (System.now().getTime() -oldOpportunities.get(opportunity.Id).Last_Stage_Change__c.getTime())/ 1000 / 60 / 60 / 24;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY ){
                        opportunity.Cycle_Time_SIT_6_to_SIT_5__c = 0;
                    }

                } else if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY){
                    if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = (System.now().getTime() -oldOpportunities.get(opportunity.Id).Last_Stage_Change__c.getTime())/ 1000 / 60 / 60 / 24;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET ){
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY ){
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                        opportunity.Cycle_Time_SIT_6_to_SIT_5__c = 0;
                    }

                } else if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY){
                    if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION ){
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = (System.now().getTime() -oldOpportunities.get(opportunity.Id).Last_Stage_Change__c.getTime())/ 1000 / 60 / 60 / 24;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET ){
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY ){
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                        opportunity.Cycle_Time_SIT_6_to_SIT_5__c = 0;
                    }

                }
                else if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION){
                    if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = (System.now().getTime() -oldOpportunities.get(opportunity.Id).Last_Stage_Change__c.getTime())/ 1000 / 60 / 60 / 24;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET ){
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY ){
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                        opportunity.Cycle_Time_SIT_6_to_SIT_5__c = 0;
                    }

                } else if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY){
                    if(opportunity.StageName == trac_Constants.OPP_STAGE_CLOSED_WON || opportunity.StageName == trac_Constants.OPP_STAGE_CLOSED_LOST ){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = (System.now().getTime() -oldOpportunities.get(opportunity.Id).Last_Stage_Change__c.getTime())/ 1000 / 60 / 60 / 24;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION){
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                    }else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET ){
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY ){
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                        opportunity.Cycle_Time_SIT_6_to_SIT_5__c = 0;
                    }

                } else if(oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_CLOSED_WON || oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_CLOSED_LOST){
                    if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = 0;
                    }else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = 0;
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                    }else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = 0;
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY ){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = 0;
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET ){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = 0;
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                    } else if(opportunity.StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY ){
                        opportunity.Cycle_Time_SIT_1_to_Closed__c = 0;
                        opportunity.Cycle_Time_SIT_2_to_SIT_1__c = 0 ;
                        opportunity.Cycle_Time_SIT_3_to_SIT_2__c = 0;
                        opportunity.Cycle_Time_SIT_4_to_SIT_3__c = 0;
                        opportunity.Cycle_Time_SIT_5_to_SIT_4__c = 0;
                        opportunity.Cycle_Time_SIT_6_to_SIT_5__c = 0;
                    }

                }

            }


        }

    }
    public static void checkStageOrder(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {

        for (Opportunity opportunity : newOpportunities) {
            if (oldOpportunities.get(opportunity.Id).StageName != opportunity.StageName) {
                if ((oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT6_REPOSITORY && opportunity.StageName != trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET)
                        || (oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET && opportunity.StageName != trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY && opportunity.StageName != trac_Constants.OPP_STAGE_SIT6_REPOSITORY)
                        || (oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY && opportunity.StageName != trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY && opportunity.StageName != trac_Constants.OPP_STAGE_SIT5_IDENTIFY_TARGET && opportunity.StageName != trac_Constants.OPP_STAGE_SIT6_REPOSITORY)
                        || (oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY && (opportunity.StageName == trac_Constants.OPP_STAGE_SIT1_CLOSE_OPPORTUNITY || opportunity.StageName == trac_Constants.OPP_STAGE_CLOSED_LOST || opportunity.StageName == trac_Constants.OPP_STAGE_CLOSED_WON))
                        || (oldOpportunities.get(opportunity.Id).StageName == trac_Constants.OPP_STAGE_SIT2_ADVOCATE_SOLUTION && (opportunity.StageName == trac_Constants.OPP_STAGE_CLOSED_LOST || opportunity.StageName == trac_Constants.OPP_STAGE_CLOSED_WON))
                        ) {
                    opportunity.addError(System.Label.Error_SkipOppStage);
                }
            }
        }
    }

}