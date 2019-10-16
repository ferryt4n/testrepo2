query 74030 "MCH AM Count Work Orders"
{
    Caption = 'Count Work Orders';

    elements
    {
        dataitem(MCH_Work_Order_Header;"MCH Work Order Header")
        {
            filter(Status;Status)
            {
            }
            filter(Work_Order_Type;"Work Order Type")
            {
            }
            filter(Responsibility_Group_Code;"Responsibility Group Code")
            {
            }
            filter(Maint_Location_Code;"Maint. Location Code")
            {
            }
            filter(Progress_Status_Code;"Progress Status Code")
            {
            }
            filter(Person_Responsible;"Person Responsible")
            {
            }
            filter(Assigned_User_ID;"Assigned User ID")
            {
            }
            filter(Starting_Date;"Starting Date")
            {
            }
            filter(Ending_Date;"Ending Date")
            {
            }
            filter(Expected_Ending_Date;"Expected Ending Date")
            {
            }
            column(Count_Orders)
            {
                Method = Count;
            }
        }
    }
}

