page 74120 "MCH Maint. Team Member List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maint. Team Member List';
    DataCaptionFields = "Maint. Team Code","Resource No.";
    Editable = false;
    PageType = List;
    SourceTable = "MCH Maint. Team Member";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Maint. Team Code";"Maint. Team Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource Name";"Resource Name")
                {
                    ApplicationArea = Basic,Suite;
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
    }
}

