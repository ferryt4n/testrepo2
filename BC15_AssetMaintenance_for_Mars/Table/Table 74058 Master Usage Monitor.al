table 74058 "MCH Master Usage Monitor"
{
    Caption = 'Master Usage Monitor';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Master Usage Monitors";
    LookupPageID = "MCH Master Usage Monitors";

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
        field(3;"Description 2";Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(5;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                TestStatusSetup;
                if ("Unit of Measure Code" = '') and UsageEntriesExist(true) then
                  TestField("Unit of Measure Code");
            end;
        }
        field(6;"Category Code";Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "MCH Usage Monitor Category";
        }
        field(7;"Reading Type";Option)
        {
            Caption = 'Reading Type';
            DataClassification = CustomerContent;
            OptionMembers = Meter,Transactional;

            trigger OnValidate()
            begin
                TestStatusSetup;
                if ("Reading Type" <> xRec."Reading Type") and (Code <> '') then
                  if UsageEntriesExist(true) then
                    Error(Text001,FieldCaption("Reading Type"),TableCaption,Code);
            end;
        }
        field(19;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Setup,On Hold,Active,Blocked';
            OptionMembers = Setup,"On Hold",Active,Blocked;

            trigger OnValidate()
            begin
                if (Code <> '' ) and (Status <> xRec.Status) then
                  UpdateMAUsageMonitors;
            end;
        }
        field(41;"Adj. Factor Before Rounding";Decimal)
        {
            Caption = 'Adj. Factor Before Rounding';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            InitValue = 1;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestStatusSetup;
                if (CurrFieldNo = FieldNo("Adj. Factor Before Rounding")) and
                   ("Adj. Factor Before Rounding" <> xRec."Adj. Factor Before Rounding") and
                   ("Adj. Factor After Rounding" = xRec."Adj. Factor Before Rounding")
                then
                  "Adj. Factor After Rounding" := "Adj. Factor Before Rounding";
            end;
        }
        field(42;"Reading Rounding Direction";Option)
        {
            Caption = 'Rounding Direction';
            DataClassification = CustomerContent;
            OptionMembers = Nearest,Up,Down;

            trigger OnValidate()
            begin
                TestStatusSetup;
            end;
        }
        field(43;"Reading Rounding Precision";Decimal)
        {
            Caption = 'Rounding Precision';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            InitValue = 0.00001;

            trigger OnValidate()
            begin
                TestStatusSetup;
                if "Reading Rounding Precision" = 0 then
                  "Reading Rounding Precision" := 0.00001;
                if "Reading Rounding Precision" < 0 then
                  FieldError("Reading Rounding Precision",Text003);
            end;
        }
        field(44;"Adj. Factor After Rounding";Decimal)
        {
            Caption = 'Adj. Factor After Rounding';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            InitValue = 1;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestStatusSetup;
            end;
        }
        field(50;"Min. Allowed Reading Value";Decimal)
        {
            Caption = 'Min. Allowed Reading Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusSetup;
                if ("Min. Allowed Reading Value" > "Max. Allowed Reading Value") and ("Max. Allowed Reading Value" <> 0) then
                  FieldError("Min. Allowed Reading Value",
                    StrSubstNo(Text004,"Min. Allowed Reading Value",FieldCaption("Max. Allowed Reading Value"),"Max. Allowed Reading Value"));
            end;
        }
        field(51;"Max. Allowed Reading Value";Decimal)
        {
            BlankZero = true;
            Caption = 'Max. Allowed Reading Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusSetup;
                Validate("Min. Allowed Reading Value");
            end;
        }
        field(55;"Max. Allowed Aged Read. Days";Integer)
        {
            Caption = 'Max. Allowed Aged Reading Days';
            DataClassification = CustomerContent;
            InitValue = 7;
            MinValue = 0;
        }
        field(56;"Max. Allowed Read-Ahead Days";Integer)
        {
            Caption = 'Max. Allowed Read-Ahead Days';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(60;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(61;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(62;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(63;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(100;"No. of Asset Usage Monitors";Integer)
        {
            CalcFormula = Count("MCH Asset Usage Monitor" WHERE ("Monitor Code"=FIELD(Code)));
            Caption = 'No. of Asset Usage Monitors';
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
        key(Key2;"Category Code")
        {
        }
        key(Key3;"Reading Type")
        {
        }
        key(Key4;Status)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Description,"Category Code",Status,"Unit of Measure Code")
        {
        }
        fieldgroup(Brick;"Code",Description,"Unit of Measure Code","Category Code",Status)
        {
        }
    }

    trigger OnDelete()
    var
        MAUsageMonitor: Record "MCH Asset Usage Monitor";
    begin
        TestStatusSetup;
        MAUsageMonitor.SetCurrentKey("Monitor Code");
        MAUsageMonitor.SetRange("Monitor Code",Code);
        if not MAUsageMonitor.IsEmpty then
          Error(Text010,TableCaption,Code,MAUsageMonitor.TableCaption);

        if UsageEntriesExist(false) then
          Error(Text000,TableCaption,Code);
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        SetLastModified;
    end;

    var
        UsageEntry: Record "MCH Usage Monitor Entry";
        Text000: Label 'You cannot delete %1 %2 because it has current entries registered.\You must cancel all associated usage entries before deletion.';
        Text001: Label 'You cannot change %1 in %2 %3 because current entries exist.\You must cancel all associated usage entries before changing %1.';
        Text003: Label 'must be greater than 0.';
        Text004: Label '(%1) cannot be greater than %2 (%3)';
        Text005: Label '(%1) cannot be later than %2 (%3)';
        Text010: Label 'You cannot delete %1 %2 because one or more linked %1.';


    procedure ShowCard()
    begin
        if (Code = '') then
          exit;
        PAGE.Run(PAGE::"MCH Master Usage Monitor Card",Rec);
    end;


    procedure UsageEntriesExist(ExcludeCancelled: Boolean) OK: Boolean
    begin
        UsageEntry.Reset;
        UsageEntry.SetCurrentKey("Asset No.","Monitor Code",Cancelled);
        UsageEntry.SetRange("Monitor Code",Code);
        if ExcludeCancelled then
          UsageEntry.SetRange(Cancelled,false);
        exit(not UsageEntry.IsEmpty);
    end;


    procedure TestStatusSetup()
    begin
        TestField(Status,Status::Setup);
    end;


    procedure GetStyleTxt() StyleTxt: Text
    begin
        case Status of
          Status::Setup : exit('Strong');
          Status::"On Hold" : exit('StrongAccent');
          Status::Active : exit('');
          Status::Blocked : exit('Unfavorable');
        end;
    end;


    procedure SetStatus(NewStatus: Option;DoUpdateMAUsageMonitors: Boolean)
    begin
        if (NewStatus = Status) then
          exit;
        LockTable;
        Get(Code);

        if (NewStatus = Status::Active) then begin
          DoUpdateMAUsageMonitors := true;
          TestField("Unit of Measure Code");
        end;
        if DoUpdateMAUsageMonitors then
          UpdateMAUsageMonitors;

        Status := NewStatus;
        SetLastModified;
        Modify;
    end;

    local procedure SetLastModified()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;

    local procedure UpdateMAUsageMonitors()
    var
        MAUsageMonitor: Record "MCH Asset Usage Monitor";
        xMAUsageMonitor: Record "MCH Asset Usage Monitor";
    begin
        Modify(true);
        MAUsageMonitor.LockTable;
        MAUsageMonitor.SetRange("Monitor Code",Code);
        if not MAUsageMonitor.FindSet(true) then
          exit;
        repeat
          xMAUsageMonitor := MAUsageMonitor;
          MAUsageMonitor.TransferFromUsageMonitor(Rec,false);
          if (Format(MAUsageMonitor) <> Format(xMAUsageMonitor)) then
            MAUsageMonitor.Modify(true);
        until MAUsageMonitor.Next = 0;
    end;


    procedure BatchCreateMAUsageMonitors()
    var
        BatchCreateMAUsageMon: Report "MCH Batch Manage MA Usage Mon.";
    begin
        if Code = '' then
          exit;
        BatchCreateMAUsageMon.SetUsageMonitor(Rec);
        BatchCreateMAUsageMon.RunModal;
    end;


    procedure CalcRoundAdjustedReadingValue(InputValue: Decimal) AdjustedValue: Decimal
    begin
        if ("Adj. Factor Before Rounding" * "Reading Rounding Precision" * "Adj. Factor After Rounding") = 0 then
          exit(InputValue);
        AdjustedValue := InputValue * "Adj. Factor Before Rounding";
        case "Reading Rounding Direction" of
          "Reading Rounding Direction"::Up :
            AdjustedValue := Round(AdjustedValue,"Reading Rounding Precision",'>');
          "Reading Rounding Direction"::Nearest :
            AdjustedValue := Round(AdjustedValue,"Reading Rounding Precision",'=');
          "Reading Rounding Direction"::Down :
            AdjustedValue := Round(AdjustedValue,"Reading Rounding Precision",'<');
          else
            FieldError("Reading Rounding Direction");
        end;
        AdjustedValue := Round(AdjustedValue * "Adj. Factor After Rounding",0.00001);
    end;
}

