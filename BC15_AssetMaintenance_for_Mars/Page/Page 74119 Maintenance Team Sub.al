page 74119 "MCH Maintenance Team Sub"
{
    Caption = 'Maintenance Team Subform';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "MCH Maint. Team Member";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Resource Name";"Resource Name")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Resource)
            {
                ApplicationArea = All;
                Caption = 'Resource';
                Image = Resource;
                RunObject = Page "Resource Card";
                RunPageLink = "No."=FIELD("Resource No.");
            }
        }
    }
}

