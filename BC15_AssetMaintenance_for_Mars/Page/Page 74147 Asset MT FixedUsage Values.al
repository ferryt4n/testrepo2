page 74147 "MCH Asset MT FixedUsage Values"
{
    Caption = 'Asset Maint. Task Fixed Usage Values';
    DataCaptionFields = "Asset No.","Task Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "MCH Asset M. Task Fixed Usage";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Usage Value";"Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
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

