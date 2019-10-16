page 74177 "MCH Asset M.Task Fxd Usage Sub"
{
    Caption = 'Fixed Usage Values';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Asset M. Task Fixed Usage";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Usage Value";
                field("Usage Value";"Usage Value")
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

