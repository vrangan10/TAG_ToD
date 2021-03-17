/**
*******************************************************************************
* trac_Constants  part of the Telus Agri project
* @description Contains constants used in custom apex classes. As opposed to updating many
*   locations when an attribute or field value changes, utilize this class to define
*   contants and make centralized changes.
* @author Neha Jain, Traction on Demand
* @date 2020-17-02
*
********************************************************************************
*/

public with sharing class trac_Constants {

    //Picklist Values
    public static final String OPP_STAGE_SIT6_REPOSITORY = 'SIT 6: Repository';
    public static final String OPP_STAGE_SIT5_IDENTIFY_TARGET = 'SIT 5: Identify Target';
    public static final String OPP_STAGE_SIT4_CONFIRM_OPPORTUNITY = 'SIT 4: Confirm Opportunity';
    public static final String OPP_STAGE_SIT3_QUALIFY_OPPORTUNITY = 'SIT 3: Qualify Opportunity';
    public static final String OPP_STAGE_SIT2_ADVOCATE_SOLUTION = 'SIT 2: Advocate Solution';
    public static final String OPP_STAGE_SIT1_CLOSE_OPPORTUNITY = 'SIT 1: Close Opportunity';
    public static final String OPP_STAGE_CLOSED_WON = 'Closed Won';
    public static final String OPP_STAGE_CLOSED_LOST = 'Closed Lost';

}