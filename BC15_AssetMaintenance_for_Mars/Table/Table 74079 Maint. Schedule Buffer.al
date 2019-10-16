table 74079 "MCH Maint. Schedule Buffer"
{
    Caption = 'AM Schedule Buffer';

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;"Group No.";Integer)
        {
            Caption = 'Group No.';
        }
        field(5;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(6;Priority;Option)
        {
            Caption = 'Priority';
            OptionCaption = 'Very High,High,Medium,Low,Very Low';
            OptionMembers = "Very High",High,Medium,Low,"Very Low";
        }
        field(7;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            TableRelation = "MCH Work Order Type";
        }
        field(10;"Work Order Status";Option)
        {
            Caption = 'Work Order Status';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(11;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
        }
        field(30;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            NotBlank = true;
            TableRelation = "MCH Maintenance Asset";
        }
        field(31;"Asset Description";Text[100])
        {
            Caption = 'Asset Description';
        }
        field(32;"Asset Description 2";Text[50])
        {
            Caption = 'Asset Description 2';
        }
        field(33;"Asset Category Code";Code[20])
        {
            Caption = 'Asset Category Code';
            TableRelation = "MCH Maint. Asset Category";
        }
        field(34;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            TableRelation = "MCH Maintenance Location";
        }
        field(35;"Responsibility Group Code";Code[20])
        {
            Caption = 'Resp. Group Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Asset Responsibility Group";
        }
        field(40;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            TableRelation = "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("Asset No."));
        }
        field(41;"Task Description";Text[100])
        {
            Caption = 'Task Description';
        }
        field(42;"Usage Monitor Code";Code[20])
        {
            Caption = 'Usage Monitor Code';
            TableRelation = "MCH Asset Usage Monitor"."Monitor Code" WHERE ("Asset No."=FIELD("Asset No."));
        }
        field(43;"Current Usage";Decimal)
        {
            BlankZero = true;
            Caption = 'Current Usage';
            DecimalPlaces = 0:5;
        }
        field(44;"Task Description 2";Text[50])
        {
            Caption = 'Task Description 2';
        }
        field(45;"Trigger Description";Text[250])
        {
            Caption = 'Trigger Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50;"Trigger Method";Option)
        {
            Caption = 'Trigger Method';
            Editable = false;
            OptionCaption = 'Manual,Calendar,Fixed Date,Usage,Fixed Usage';
            OptionMembers = Manual,"Calendar (Recurring)","Fixed Date","Usage (Recurring)","Fixed Usage";
        }
        field(51;"Recurr. Trigger Calc. Method";Option)
        {
            Caption = 'Recurring Trigger Calc. Method';
            OptionCaption = ' ,Fixed Schedule,Actual Completion';
            OptionMembers = " ","Fixed Schedule","Actual Completion";
        }
        field(54;"Lead Time (Days)";Integer)
        {
            BlankZero = true;
            Caption = 'Lead Time (Days)';
            MinValue = 0;
        }
        field(55;"Usage Tolerance";Decimal)
        {
            BlankZero = true;
            Caption = 'Usage Tolerance';
            DecimalPlaces = 0:5;
        }
        field(60;"Last Completion Date";Date)
        {
            Caption = 'Last Completion Date';
        }
        field(61;"Last Scheduled Date";Date)
        {
            Caption = 'Last Scheduled Date';
        }
        field(70;"Last Actual Usage";Decimal)
        {
            BlankZero = true;
            Caption = 'Last Actual Usage';
            DecimalPlaces = 0:5;
        }
        field(71;"Last Scheduled Usage";Decimal)
        {
            BlankZero = true;
            Caption = 'Last Scheduled Usage';
            DecimalPlaces = 0:5;
        }
        field(72;"Scheduled Usage";Decimal)
        {
            BlankZero = true;
            Caption = 'Scheduled Usage';
            DecimalPlaces = 0:5;
        }
        field(73;"Scheduled Date";Date)
        {
            Caption = 'Scheduled Date';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Group No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key3;"Starting Date",Priority,"Work Order Type")
        {
            MaintainSQLIndex = false;
        }
        key(Key4;"Starting Date",Priority,"Work Order Type","Asset No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5;"Starting Date",Priority,"Work Order Type","Responsibility Group Code","Maint. Location Code")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }
}

