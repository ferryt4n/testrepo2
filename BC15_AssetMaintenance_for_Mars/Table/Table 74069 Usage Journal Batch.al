table 74069 "MCH Usage Journal Batch"
{
    Caption = 'Usage Journal Batch';
    DataCaptionFields = Name,Description;
    LookupPageID = "MCH Usage Jnl. Batches";

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "MCH Usage Journal Template";
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
        field(10;"Template Type";Option)
        {
            CalcFormula = Lookup("MCH Usage Journal Template".Type WHERE (Name=FIELD("Journal Template Name")));
            Caption = 'Template Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Usage';
            OptionMembers = Usage;
        }
        field(20;"No. of Journal Lines";Integer)
        {
            CalcFormula = Count("MCH Usage Journal Line" WHERE ("Journal Template Name"=FIELD("Journal Template Name"),
                                                                "Journal Batch Name"=FIELD(Name),
                                                                "Monitor Code"=FILTER(<>'')));
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
        UsageJnlLine.SetRange("Journal Template Name","Journal Template Name");
        UsageJnlLine.SetRange("Journal Batch Name",Name);
        UsageJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        UsageJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        UsageJnlLine.SetRange("Journal Template Name",xRec."Journal Template Name");
        UsageJnlLine.SetRange("Journal Batch Name",xRec.Name);
        while UsageJnlLine.Find('-') do
          UsageJnlLine.Rename("Journal Template Name",Name,UsageJnlLine."Line No.");
    end;

    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        UsageJnlTemplate: Record "MCH Usage Journal Template";
        UsageJnlLine: Record "MCH Usage Journal Line";
}

