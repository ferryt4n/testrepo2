table 74055 "MCH Work Instruction Header"
{
    Caption = 'Work Instruction';
    DataCaptionFields = "No.",Description;
    DrillDownPageID = "MCH Work Instruction List";
    LookupPageID = "MCH Work Instruction Lookup";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  AMSetup.Get;
                  NoSeriesMgt.TestManual(AMSetup."Work Instructions Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(5;"Category Code";Code[20])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Work Instruction Category";
        }
        field(10;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(11;Blocked;Boolean)
        {
            BlankZero = true;
            Caption = 'Blocked';
        }
        field(20;"No. of Maint. Assets";Integer)
        {
            CalcFormula = Count("MCH Work Instruction Setup" WHERE ("Table Name"=CONST(Asset),
                                                                    "Work Instruction No."=FIELD("No.")));
            Caption = 'No. of Maint. Assets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"No. of Master Maint. Tasks";Integer)
        {
            CalcFormula = Count("MCH Work Instruction Setup" WHERE ("Table Name"=CONST("Maint. Task"),
                                                                    "Work Instruction No."=FIELD("No.")));
            Caption = 'No. of Master Maint. Tasks';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;Description)
        {
        }
        key(Key3;"Category Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Description,"Category Code")
        {
        }
        fieldgroup(Brick;"No.",Description,"Category Code")
        {
        }
    }

    trigger OnDelete()
    var
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
        WorkInstructionLine: Record "MCH Work Instruction Line";
    begin
        WorkInstructionSetup.SetCurrentKey("Work Instruction No.");
        WorkInstructionSetup.SetRange("Work Instruction No.","No.");
        WorkInstructionSetup.DeleteAll(true);

        WorkInstructionLine.SetRange("Work Instruction No.","No.");
        WorkInstructionLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        AMSetup.Get ;
        if "No." = '' then begin
          AMSetup.TestField("Work Instructions Nos.");
          NoSeriesMgt.InitSeries(AMSetup."Work Instructions Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure AssistEdit(OldWorkInstrHeader: Record "MCH Work Instruction Header"): Boolean
    var
        CurrWorkInstructionHeader: Record "MCH Work Instruction Header";
    begin
        with CurrWorkInstructionHeader do begin
          CurrWorkInstructionHeader := Rec;
          AMSetup.Get;
          AMSetup.TestField("Work Instructions Nos.");
          if NoSeriesMgt.SelectSeries(AMSetup."Work Instructions Nos.",OldWorkInstrHeader."No. Series","No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := CurrWorkInstructionHeader;
            exit(true);
          end;
        end;
    end;


    procedure ConfirmInUseManualDeletion() DoDelete: Boolean
    var
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
        ConfirmInUseDeleteQst: Label '%1 %2 is currently referenced by one or more assets and/or maintenance tasks.\Do you really want to delete this %1 ?';
    begin
        if "No." = '' then
          exit(true);
        WorkInstructionSetup.SetCurrentKey("Work Instruction No.");
        WorkInstructionSetup.SetRange("Work Instruction No.","No.");
        if WorkInstructionSetup.IsEmpty then
          exit(true);
        exit(Confirm(ConfirmInUseDeleteQst,false,TableCaption,"No."));
    end;


    procedure ShowWhereUsed(TableID: Integer)
    var
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
        WorkInstrWhereUsed: Page "MCH Work Instr. Where-Used";
    begin
        if "No." = '' then
          exit;
        WorkInstructionSetup.SetCurrentKey("Work Instruction No.");
        WorkInstructionSetup.SetRange("Work Instruction No.","No.");
        case TableID of
          DATABASE::"MCH Maintenance Asset" :
            WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::Asset);
          DATABASE::"MCH Master Maintenance Task" :
            WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::"Maint. Task");
        end;
        WorkInstrWhereUsed.SetTableView(WorkInstructionSetup);
        WorkInstrWhereUsed.Run;
    end;


    procedure ShowUsedByMaintAssets()
    begin
        ShowWhereUsed(DATABASE::"MCH Maintenance Asset");
    end;


    procedure ShowUsedByMasterMaintTasks()
    begin
        ShowWhereUsed(DATABASE::"MCH Master Maintenance Task");
    end;
}

