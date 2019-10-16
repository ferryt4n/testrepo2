page 74178 "MCH Asset M.Task Fxd Date Sub"
{
    Caption = 'Fixed Dates';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Asset M. Task Fixed Date";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Due Date";
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
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

