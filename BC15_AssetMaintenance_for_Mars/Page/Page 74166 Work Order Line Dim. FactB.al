page 74166 "MCH Work Order Line Dim. FactB"
{
    Caption = 'Line Dimensions';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Dimension Set Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Dimension Code";
                ShowCaption = false;
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimension Code';
                    ToolTip = 'Specifies the dimension.';
                }
                field("Dimension Name";"Dimension Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimension Name';
                    ToolTip = 'Specifies the descriptive name of the Dimension Code field.';
                    Visible = false;
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimension Value Code';
                    ToolTip = 'Specifies the dimension value.';
                }
                field("Dimension Value Name";"Dimension Value Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimension Value Name';
                    ToolTip = 'Specifies the descriptive name of the Dimension Value Code field.';
                }
            }
        }
    }

    actions
    {
    }
}

