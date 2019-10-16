page 74088 "MCH Work Instr. Where-Used"
{
    Caption = 'Work Instruction - Where-Used';
    DataCaptionFields = "Work Instruction No.","Table Name","Code";
    Editable = false;
    PageType = List;
    SourceTable = "MCH Work Instruction Setup";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Code";
                ShowCaption = false;
                field("Work Instruction No.";"Work Instruction No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Unfavorable;
                    StyleExpr = Blocked;
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
            part(InstructionLines;"MCH Work Instruction Text2 Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Work Instruction No."=FIELD("Work Instruction No.");
            }
        }
    }

    actions
    {
    }
}

