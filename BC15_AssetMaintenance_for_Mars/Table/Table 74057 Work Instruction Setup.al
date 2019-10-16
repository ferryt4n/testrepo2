table 74057 "MCH Work Instruction Setup"
{
    Caption = 'Work Instruction Setup';
    DataCaptionFields = "Table Name","Code";

    fields
    {
        field(1;"Table Name";Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Asset,Maint. Task';
            OptionMembers = Asset,"Maint. Task";
        }
        field(2;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF ("Table Name"=CONST(Asset)) "MCH Maintenance Asset"
                            ELSE IF ("Table Name"=CONST("Maint. Task")) "MCH Master Maintenance Task";
        }
        field(3;"Work Instruction No.";Code[20])
        {
            Caption = 'Work Instruction No.';
            NotBlank = true;
            TableRelation = "MCH Work Instruction Header";
        }
        field(10;Description;Text[100])
        {
            CalcFormula = Lookup("MCH Work Instruction Header".Description WHERE ("No."=FIELD("Work Instruction No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;Blocked;Boolean)
        {
            BlankZero = true;
            CalcFormula = Lookup("MCH Work Instruction Header".Blocked WHERE ("No."=FIELD("Work Instruction No.")));
            Caption = 'Blocked';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Category Code";Code[20])
        {
            CalcFormula = Lookup("MCH Work Instruction Header"."Category Code" WHERE ("No."=FIELD("Work Instruction No.")));
            Caption = 'Category Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "MCH Work Instruction Category";
        }
        field(20;"Has Instruction Text Lines";Boolean)
        {
            CalcFormula = Exist("MCH Work Instruction Line" WHERE ("Work Instruction No."=FIELD("Work Instruction No."),
                                                                   Text=FILTER(<>'')));
            Caption = 'Has Instruction Text Lines';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Table Name","Code","Work Instruction No.")
        {
            Clustered = true;
        }
        key(Key2;"Work Instruction No.")
        {
        }
    }

    fieldgroups
    {
    }


    procedure ShowRecordAssignedWorkInstructions()
    var
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
        AssignedWorkInstrList: Page "MCH Assigned Work Instr. List";
    begin
        if Code = '' then
          exit;
        WorkInstructionSetup := Rec;
        WorkInstructionSetup.FilterGroup(2);
        WorkInstructionSetup.SetRange("Table Name","Table Name");
        WorkInstructionSetup.SetRange(Code,Code);
        WorkInstructionSetup.FilterGroup(0);
        AssignedWorkInstrList.SetTableView(WorkInstructionSetup);
        AssignedWorkInstrList.SetRecord(WorkInstructionSetup);
        AssignedWorkInstrList.Run;
    end;
}

