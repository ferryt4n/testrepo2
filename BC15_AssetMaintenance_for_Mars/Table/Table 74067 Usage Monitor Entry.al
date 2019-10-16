table 74067 "MCH Usage Monitor Entry"
{
    Caption = 'Usage Monitor Entry';
    DrillDownPageID = "MCH Usage Monitor Entries";
    LookupPageID = "MCH Usage Monitor Entries";

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            NotBlank = true;
            TableRelation = "MCH Maintenance Asset";
        }
        field(3;"Monitor Code";Code[20])
        {
            Caption = 'Monitor Code';
            NotBlank = true;
            TableRelation = "MCH Asset Usage Monitor"."Monitor Code" WHERE ("Asset No."=FIELD("Asset No."));
        }
        field(4;"Reading Date";Date)
        {
            Caption = 'Reading Date';
            DataClassification = CustomerContent;
        }
        field(5;"Reading Time";Time)
        {
            Caption = 'Reading Time';
            DataClassification = CustomerContent;
        }
        field(6;"Usage Value";Decimal)
        {
            Caption = 'Usage Value';
            DecimalPlaces = 0:5;
        }
        field(7;"Reading Value";Decimal)
        {
            Caption = 'Reading Value';
            DecimalPlaces = 0:5;
        }
        field(8;"Original Reading Value";Decimal)
        {
            Caption = 'Original Reading Value';
            DecimalPlaces = 0:5;
        }
        field(14;"Closing Meter Reading";Boolean)
        {
            BlankZero = true;
            Caption = 'Closing Meter Reading';
            DataClassification = CustomerContent;
        }
        field(15;Description;Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(16;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(17;"Reading Date-Time";DateTime)
        {
            Caption = 'Reading Date-Time';
            DataClassification = CustomerContent;
        }
        field(20;"Reading Type";Option)
        {
            Caption = 'Reading Type';
            DataClassification = CustomerContent;
            OptionMembers = Meter,Transactional;
        }
        field(30;"Registered By";Code[50])
        {
            Caption = 'Registered By';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(31;"Registered Date-Time";DateTime)
        {
            Caption = 'Registered Date-Time';
            DataClassification = CustomerContent;
        }
        field(40;Cancelled;Boolean)
        {
            BlankZero = true;
            Caption = 'Cancelled';
            DataClassification = CustomerContent;
        }
        field(41;"Cancelled By";Code[50])
        {
            Caption = 'Cancelled By';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(42;"Cancellation Date-Time";DateTime)
        {
            Caption = 'Cancellation Date-Time';
            DataClassification = CustomerContent;
        }
        field(43;"Cancellation Reason Code";Code[10])
        {
            Caption = 'Cancellation Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Asset No.","Monitor Code","Reading Date","Reading Time")
        {
            SumIndexFields = "Usage Value";
        }
        key(Key3;"Asset No.","Monitor Code",Cancelled,"Reading Date","Reading Time")
        {
            SumIndexFields = "Usage Value";
        }
        key(Key4;"Asset No.","Monitor Code","Reading Date-Time","Reading Value")
        {
        }
        key(Key5;"Asset No.","Monitor Code",Cancelled,"Reading Value","Reading Date")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }
}

