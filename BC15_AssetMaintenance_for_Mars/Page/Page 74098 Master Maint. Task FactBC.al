page 74098 "MCH Master Maint. Task FactBC"
{
    Caption = 'Master Maint. Task - Ongoing';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "MCH Master Maintenance Task";

    layout
    {
        area(content)
        {
            cuegroup(Control1101214005)
            {
                ShowCaption = false;
                field("No. of Asset Maint. Tasks";"No. of Asset Maint. Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Maint. Tasks';
                }
                field("No. of Request WO Lines";"No. of Request WO Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Order Requests';
                }
                field("No. of Planned WO Lines";"No. of Planned WO Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Planned Work Orders';
                }
                field("No. of Released WO Lines";"No. of Released WO Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Released Work Orders';
                }
                field("No. of Planning Wksh. Lines";"No. of Planning Wksh. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Planning Wksh. Lines';
                }
            }
        }
    }

    actions
    {
    }
}

