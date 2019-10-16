page 74087 "MCH Work Instruction Lookup"
{
    Caption = 'Work Instructions';
    Editable = false;
    PageType = List;
    SourceTable = "MCH Work Instruction Header";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Unfavorable;
                    StyleExpr = Blocked;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(AdvancedView)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the Work Instruction List page showing all possible columns.';

                trigger OnAction()
                var
                    WorkInstructionList: Page "MCH Work Instruction List";
                begin
                    WorkInstructionList.SetRecord(Rec);
                    WorkInstructionList.LookupMode := true;
                    if WorkInstructionList.RunModal = ACTION::LookupOK then begin
                      WorkInstructionList.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }
}

