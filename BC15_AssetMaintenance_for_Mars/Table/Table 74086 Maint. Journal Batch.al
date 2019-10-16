table 74086 "MCH Maint. Journal Batch"
{
    Caption = 'Maintenance Journal Batch';
    DataCaptionFields = Name,Description;
    LookupPageID = "MCH Maint. Jnl. Batches";

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "MCH Maint. Journal Template";
        }
        field(2;Name;Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(4;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";

            trigger OnValidate()
            begin
                if "Reason Code" <> xRec."Reason Code" then begin
                  MaintJnlLine.SetRange("Journal Template Name","Journal Template Name");
                  MaintJnlLine.SetRange("Journal Batch Name",Name);
                  MaintJnlLine.ModifyAll("Reason Code","Reason Code");
                  Modify;
                end;
            end;
        }
        field(5;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                  MaintJnlTemplate.Get("Journal Template Name");
                  if "No. Series" = "Posting No. Series" then
                    Validate("Posting No. Series",'');
                end;
            end;
        }
        field(6;"Posting No. Series";Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                  FieldError("Posting No. Series",StrSubstNo(Text001,"Posting No. Series"));
                MaintJnlLine.SetRange("Journal Template Name","Journal Template Name");
                MaintJnlLine.SetRange("Journal Batch Name",Name);
                MaintJnlLine.ModifyAll("Posting No. Series","Posting No. Series");
                Modify;
            end;
        }
        field(10;"Template Type";Option)
        {
            CalcFormula = Lookup("MCH Maint. Journal Template".Type WHERE (Name=FIELD("Journal Template Name")));
            Caption = 'Template Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Inventory,Timesheet';
            OptionMembers = Inventory,Timesheet;
        }
        field(20;"No. of Journal Lines";Integer)
        {
            CalcFormula = Count("MCH Maint. Journal Line" WHERE ("Journal Template Name"=FIELD("Journal Template Name"),
                                                                 "Journal Batch Name"=FIELD(Name),
                                                                 "Work Order No."=FILTER(<>'')));
            Caption = 'No. of Journal Lines';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name",Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        MaintJnlLine.SetRange("Journal Template Name","Journal Template Name");
        MaintJnlLine.SetRange("Journal Batch Name",Name);
        MaintJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        MaintJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        MaintJnlLine.SetRange("Journal Template Name",xRec."Journal Template Name");
        MaintJnlLine.SetRange("Journal Batch Name",xRec.Name);
        while MaintJnlLine.Find('-') do
          MaintJnlLine.Rename("Journal Template Name",Name,MaintJnlLine."Line No.");
    end;

    var
        Text001: Label 'must not be %1';
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlLine: Record "MCH Maint. Journal Line";


    procedure SetupNewBatch()
    begin
        MaintJnlTemplate.Get("Journal Template Name");
        "No. Series" := MaintJnlTemplate."No. Series";
        "Posting No. Series" := MaintJnlTemplate."Posting No. Series";
        "Reason Code" := MaintJnlTemplate."Reason Code";
    end;
}

