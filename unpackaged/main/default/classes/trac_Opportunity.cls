/**
*******************************************************************************
* trac_Opportunity  part of the Telus ADT Agri project
* @description Domain class to control functionality around Opportunity fired from Trigger Context
* @author Neha Jain, Traction on Demand
* @date 2020-12-02
*
*******************************************************************************
*/
public without sharing class trac_Opportunity {
    private List<Opportunity> newOpportunities;
    private Map<Id, Opportunity> oldOpportunities;

    public trac_Opportunity(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {
        this.newOpportunities = newOpportunities;
        this.oldOpportunities = oldOpportunities;
    }



    /**
    * @description  Method to check Opportunities stages
    * @author       Neha Jain
    * @date         2020-12-17
    */
    public void checkStageOrder() {
        trac_OpportunityHelper.checkStageOrder(newOpportunities,oldOpportunities);
    }
    /**
    * @description  Method to update cycle stage
    * @author       Neha Jain
    * @date         2020-12-17
    */
    public void insertCycleTimeWhenStageChange() {
        trac_OpportunityHelper.insertCycleTimeWhenStageChange(newOpportunities,oldOpportunities);
    }
}