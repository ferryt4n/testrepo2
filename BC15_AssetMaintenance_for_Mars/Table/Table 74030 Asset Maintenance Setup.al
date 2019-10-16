table 74030 "MCH Asset Maintenance Setup"
{
    Caption = 'Asset Maintenance Setup';

    fields
    {
        field(1;"Primary key";Code[10])
        {
            Caption = 'Primary key';
        }
        field(10;"Asset Nos.";Code[20])
        {
            Caption = 'Asset Nos.';
            TableRelation = "No. Series";
        }
        field(11;"Work Instructions Nos.";Code[20])
        {
            Caption = 'Work Instructions Nos.';
            TableRelation = "No. Series";
        }
        field(12;"Maintenance Task Nos.";Code[20])
        {
            Caption = 'Maintenance Task Nos.';
            TableRelation = "No. Series";
        }
        field(13;"Spare Part Nos.";Code[20])
        {
            Caption = 'Spare Part Nos.';
            TableRelation = "No. Series";
        }
        field(14;"Work Order Nos.";Code[20])
        {
            Caption = 'Work Order Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(20;"Work Order Line Restriction";Option)
        {
            Caption = 'Work Order Line Restriction';
            DataClassification = CustomerContent;
            OptionMembers = "Single Line Only","One Asset Only","Same Resp. Group and Maint. Location";
        }
        field(21;"Post Team Timesheet Res. Ledg.";Boolean)
        {
            Caption = 'Post Team Timesheet to Res. Ledger';
        }
        field(25;"WO Invt. Usage to Budget Link";Option)
        {
            Caption = 'WO Inventory Usage to Budget Link';
            InitValue = "Auto Create on Posting";
            OptionCaption = 'Optional,Mandatory on Entry,Auto Create on Posting';
            OptionMembers = Optional,"Mandatory on Entry","Auto Create on Posting";
        }
        field(26;"WO Purchase to Budget Link";Option)
        {
            Caption = 'WO Purchase to Budget Link';
            InitValue = "Auto Create on Posting";
            OptionCaption = 'Optional,Mandatory on Entry,Auto Create on Posting';
            OptionMembers = Optional,"Mandatory on Entry","Auto Create on Posting";
        }
        field(27;"WO Timesheet to Budget Link";Option)
        {
            Caption = 'WO Timesheet to Budget Link';
            InitValue = "Auto Create on Posting";
            OptionCaption = 'Optional,Mandatory on Entry,Auto Create on Posting';
            OptionMembers = Optional,"Mandatory on Entry","Auto Create on Posting";
        }
        field(30;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(31;"Def. Inventory Location Code";Code[10])
        {
            Caption = 'Def. Inventory Location Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));
        }
        field(32;"Def. Work Order Priority";Option)
        {
            Caption = 'Def. Work Order Priority';
            InitValue = Medium;
            OptionCaption = 'Very High,High,Medium,Low,Very Low';
            OptionMembers = "Very High",High,Medium,Low,"Very Low";
        }
        field(34;"Def. WO Type on Request";Code[20])
        {
            Caption = 'Def. WO Type on Request';
            TableRelation = "MCH Work Order Type";
        }
        field(40;"WO Progress Status Mandatory";Boolean)
        {
            Caption = 'WO Progress Status Mandatory';
            InitValue = true;
        }
        field(41;"Use WO No. as Posting Doc. No.";Boolean)
        {
            Caption = 'Use WO No. as Posting Doc. No.';
            InitValue = true;
        }
        field(42;"Work Order Type Mandatory";Boolean)
        {
            Caption = 'Work Order Type Mandatory';
            InitValue = true;
        }
        field(43;"WO Person Respons. Mandatory";Boolean)
        {
            Caption = 'WO Person Responsible Mandatory';
            DataClassification = CustomerContent;
        }
        field(45;"Res. No. Mandatory - Invt.Iss";Boolean)
        {
            Caption = 'Res. No. Mandatory on Invt. Issue';
        }
        field(46;"Res. No. Mandatory - Invt.Rtrn";Boolean)
        {
            Caption = 'Res. No. Mandatory on Invt. Return';
        }
        field(50;"Asset Category Mandatory";Boolean)
        {
            Caption = 'Asset - Category Mandatory';
            DataClassification = CustomerContent;
        }
        field(51;"Asset Fixed Maint. Loc. Mand.";Boolean)
        {
            Caption = 'Asset - Fixed Maint. Location Mandatory';
            DataClassification = CustomerContent;
        }
        field(52;"Asset Resp. Group Mandatory";Boolean)
        {
            Caption = 'Asset - Responsibility Group Mandatory';
            DataClassification = CustomerContent;
        }
        field(60;"Schedule Task Recurr. Limit";Integer)
        {
            Caption = 'Schedule Task Recurrence Limit';
            DataClassification = CustomerContent;
            InitValue = 30;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Schedule Task Recurr. Limit"));
            end;
        }
        field(61;"Max. Sched. Look Ahead (Days)";Integer)
        {
            Caption = 'Max. Schedule Look Ahead (Days)';
            DataClassification = CustomerContent;
            InitValue = 365;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Max. Sched. Look Ahead (Days)"));
            end;
        }
        field(65;"Def. Sched. Task Recurr. Limit";Integer)
        {
            Caption = 'Def. Schedule Task Recurrence Limit';
            DataClassification = ToBeClassified;
            InitValue = 10;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Def. Sched. Task Recurr. Limit"));
            end;
        }
        field(66;"Def. Sched. Look Ahead (Days)";Integer)
        {
            Caption = 'Def. Schedule Look Ahead (Days)';
            DataClassification = ToBeClassified;
            InitValue = 30;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Def. Sched. Look Ahead (Days)"));
            end;
        }
        field(70;"Forecast Task Recurr. Limit";Integer)
        {
            Caption = 'Forecast Task Recurrence Limit';
            DataClassification = CustomerContent;
            InitValue = 90;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Forecast Task Recurr. Limit"));
            end;
        }
        field(71;"Forecast Look Ahead (Days)";Integer)
        {
            Caption = 'Max. Forecast Look Ahead (Days)';
            DataClassification = CustomerContent;
            InitValue = 730;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Forecast Look Ahead (Days)"));
            end;
        }
        field(75;"Def. FCast Task Recurr. Limit";Integer)
        {
            Caption = 'Def. Forecast Task Recurr. Limit';
            DataClassification = CustomerContent;
            InitValue = 30;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Def. FCast Task Recurr. Limit"));
            end;
        }
        field(76;"Def. FCast Look Ahead (Days)";Integer)
        {
            Caption = 'Def. Forecast Look Ahead (Days)';
            DataClassification = CustomerContent;
            InitValue = 365;
            MinValue = 1;

            trigger OnValidate()
            begin
                CheckScheduleForcastValue(FieldCaption("Def. FCast Look Ahead (Days)"));
            end;
        }
        field(80;"Usage Allowed ReadingDate Base";Option)
        {
            Caption = 'Usage Allowed Reading Date (Base)';
            DataClassification = ToBeClassified;
            OptionCaption = 'Working Date,System Date';
            OptionMembers = "Working Date","System Date";
        }
        field(82;"Usage Meter Duplicate Reading";Option)
        {
            Caption = 'Usage Meter Duplicate Reading';
            DataClassification = ToBeClassified;
            OptionCaption = 'Allowed,Not Allowed';
            OptionMembers = Allowed,"Not Allowed";
        }
        field(83;"Usage Trans. Duplicate Reading";Option)
        {
            Caption = 'Usage Trans. Duplicate Reading';
            DataClassification = ToBeClassified;
            OptionCaption = 'Allowed,Not Allowed';
            OptionMembers = Allowed,"Not Allowed";
        }
    }

    keys
    {
        key(Key1;"Primary key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CheckScheduleForcastValue(ScheduleForecastFieldCaption: Text) MaxValue: Integer
    var
        ValueTooHighErr: Label 'The value of %1 must not more than %2.';
        ValueTooLowErr: Label 'The value of %1 must not be less than %2.';
    begin
        case ScheduleForecastFieldCaption of
          FieldCaption("Schedule Task Recurr. Limit"):
            if ("Schedule Task Recurr. Limit" < "Def. Sched. Task Recurr. Limit") then
              Error(ValueTooLowErr,FieldCaption("Schedule Task Recurr. Limit"),FieldCaption("Def. Sched. Task Recurr. Limit"));
          FieldCaption("Max. Sched. Look Ahead (Days)"):
            if ("Max. Sched. Look Ahead (Days)" < "Def. Sched. Look Ahead (Days)") then
              Error(ValueTooLowErr,FieldCaption("Max. Sched. Look Ahead (Days)"),FieldCaption("Def. Sched. Look Ahead (Days)"));
          FieldCaption("Def. Sched. Task Recurr. Limit"):
            if ("Def. Sched. Task Recurr. Limit" > "Schedule Task Recurr. Limit") then
              Error(ValueTooHighErr,FieldCaption("Def. Sched. Task Recurr. Limit"),FieldCaption("Schedule Task Recurr. Limit"));
          FieldCaption("Def. Sched. Look Ahead (Days)"):
            if ("Def. Sched. Look Ahead (Days)" > "Max. Sched. Look Ahead (Days)") then
              Error(ValueTooHighErr,FieldCaption("Def. Sched. Look Ahead (Days)"),FieldCaption("Max. Sched. Look Ahead (Days)"));

          FieldCaption("Forecast Task Recurr. Limit"):
            if ("Forecast Task Recurr. Limit" < "Def. FCast Task Recurr. Limit") then
              Error(ValueTooLowErr,FieldCaption("Forecast Task Recurr. Limit"),FieldCaption("Def. FCast Task Recurr. Limit"));
          FieldCaption("Forecast Look Ahead (Days)"):
            if ("Forecast Look Ahead (Days)" < "Def. FCast Look Ahead (Days)") then
              Error(ValueTooLowErr,FieldCaption("Forecast Look Ahead (Days)"),FieldCaption("Def. FCast Look Ahead (Days)"));
          FieldCaption("Def. FCast Task Recurr. Limit"):
            if ("Def. FCast Task Recurr. Limit" > "Def. FCast Look Ahead (Days)") then
              Error(ValueTooHighErr,FieldCaption("Def. FCast Task Recurr. Limit"),FieldCaption("Def. FCast Look Ahead (Days)"));
          FieldCaption("Def. FCast Look Ahead (Days)"):
            if ("Def. FCast Look Ahead (Days)" > "Forecast Look Ahead (Days)") then
              Error(ValueTooHighErr,FieldCaption("Def. FCast Look Ahead (Days)"),FieldCaption("Forecast Look Ahead (Days)"));
        end;
    end;
}

