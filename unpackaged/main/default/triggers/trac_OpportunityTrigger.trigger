/**
*******************************************************************************
* trac_OpportunityTrigger - part of the TELUS Agri project
* @description  Main Apex trigger for the Opportnity object
* @author       Neha Jain, Traction on Demand
* @date         2020-12-17
*******************************************************************************
*/

trigger trac_OpportunityTrigger on Opportunity (before update) {

    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            new trac_Opportunity(Trigger.new, Trigger.oldMap).checkStageOrder();
            new trac_Opportunity(Trigger.new, Trigger.oldMap).insertCycleTimeWhenStageChange();
        }

    }

}