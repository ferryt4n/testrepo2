page 74083 "MCH Maint. Units of Measure"
{
    Caption = 'Maint. Units of Measure';
    DataCaptionFields = "Table Name","Code";
    PageType = List;
    SourceTable = "MCH Maint. Unit of Measure";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
    }
}

