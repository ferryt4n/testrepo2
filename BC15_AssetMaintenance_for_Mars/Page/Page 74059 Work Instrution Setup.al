page 74059 "MCH Work Instrution Setup"
{
    Caption = 'Work Instruction Setup';
    DataCaptionExpression = CaptionText;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
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

    local procedure CaptionText(): Text
    begin
        exit(StrSubstNo('%1 - %2',"Table Name",Code));
    end;
}

