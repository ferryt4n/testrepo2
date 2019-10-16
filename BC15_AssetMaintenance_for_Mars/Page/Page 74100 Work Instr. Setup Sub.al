page 74100 "MCH Work Instr. Setup Sub"
{
    Caption = 'Work Instructions';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Work Instruction Setup";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Work Instruction No.";
                ShowCaption = false;
                field("Work Instruction No.";"Work Instruction No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Style = Unfavorable;
                    StyleExpr = Blocked;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowText)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Text Lines';
                Image = ViewDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowRecordAssignedWorkInstructions;
                end;
            }
        }
    }
}

