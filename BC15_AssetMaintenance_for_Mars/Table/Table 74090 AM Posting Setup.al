table 74090 "MCH AM Posting Setup"
{
    Caption = 'Asset Maintenance Posting Setup';
    DrillDownPageID = "MCH AM Posting Setup";
    LookupPageID = "MCH AM Posting Setup";

    fields
    {
        field(1;"Asset Posting Group";Code[20])
        {
            Caption = 'Asset Posting Group';
            NotBlank = false;
            TableRelation = "MCH Maint. Asset Posting Group";
        }
        field(2;"Gen. Prod. Posting Group";Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(3;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            TableRelation = "MCH Work Order Type";
        }
        field(4;"Expense Account";Code[20])
        {
            Caption = 'Expense Account';
            TableRelation = "G/L Account";
        }
        field(5;"Resource Account";Code[20])
        {
            Caption = 'Resource Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Resource Account",false);
            end;
        }
        field(6;"Maint. Team Account";Code[20])
        {
            Caption = 'Maint. Team Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Maint. Team Account",true);
            end;
        }
    }

    keys
    {
        key(Key1;"Asset Posting Group","Gen. Prod. Posting Group","Work Order Type")
        {
            Clustered = true;
        }
        key(Key2;"Gen. Prod. Posting Group")
        {
        }
        key(Key3;"Work Order Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";


    procedure CheckGLAcc(AccNo: Code[20];DirectPosting: Boolean)
    begin
        if AccNo = '' then
          exit;
        GLAcc.Get(AccNo);
        GLAcc.CheckGLAcc;
        if DirectPosting then
          GLAcc.TestField("Direct Posting");
    end;
}

