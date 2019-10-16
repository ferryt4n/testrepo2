page 74148 "MCH Asset MT FixedDates"
{
    Caption = 'Asset Maint. Task Fixed Dates';
    DataCaptionFields = "Asset No.","Task Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "MCH Asset M. Task Fixed Date";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
            }
        }
    }

    actions
    {
    }
}

