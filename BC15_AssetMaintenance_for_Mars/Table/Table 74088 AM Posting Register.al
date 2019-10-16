table 74088 "MCH AM Posting Register"
{
    Caption = 'Asset Maint. Posting Register';
    LookupPageID = "MCH AM Posting Registers";

    fields
    {
        field(1;"No.";Integer)
        {
            Caption = 'No.';
        }
        field(2;"From Entry No.";Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "MCH Asset Maint. Ledger Entry";
        }
        field(3;"To Entry No.";Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "MCH Asset Maint. Ledger Entry";
        }
        field(4;"Creation Date";Date)
        {
            Caption = 'Creation Date';
        }
        field(5;"Creation Time";Time)
        {
            Caption = 'Creation Time';
        }
        field(6;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
        field(7;"User ID";Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(8;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(9;"Creation Date-Time";DateTime)
        {
            Caption = 'Creation Date-Time';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Creation Date")
        {
        }
        key(Key3;"Source Code","Journal Batch Name","Creation Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","From Entry No.","To Entry No.","Creation Date","Source Code")
        {
        }
    }


    procedure ShowAMLedgEntries()
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        AMLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
        PAGE.Run(0,AMLedgEntry);
    end;
}

