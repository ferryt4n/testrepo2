table 74072 "MCH Work Instruction Category"
{
    Caption = 'Work Instruction Category';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Work Instr. Categories";
    LookupPageID = "MCH Work Instr. Categories";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(3;"No. of Work Instructions";Integer)
        {
            CalcFormula = Count("MCH Work Instruction Header" WHERE ("Category Code"=FIELD(Code)));
            Caption = 'No. of Work Instructions';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if (Code <> '') then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);
    end;

    var
        AMFunctions: Codeunit "MCH AM Functions";
}

