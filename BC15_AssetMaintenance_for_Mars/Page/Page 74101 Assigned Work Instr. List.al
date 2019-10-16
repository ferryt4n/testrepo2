page 74101 "MCH Assigned Work Instr. List"
{
    Caption = 'Assigned Work Instructions';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "MCH Work Instruction Setup";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Work Instruction No.";"Work Instruction No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
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

    trigger OnAfterGetRecord()
    begin
        if not ViewIsFiltered then begin
          FilterGroup(2);
          SetRange("Table Name","Table Name");
          SetRange(Code,Code);
          FilterGroup(0);
          ViewIsFiltered := true;
        end;
    end;

    var
        ViewIsFiltered: Boolean;
}

