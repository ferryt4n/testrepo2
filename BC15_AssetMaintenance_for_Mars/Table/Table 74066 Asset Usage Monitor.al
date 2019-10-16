table 74066 "MCH Asset Usage Monitor"
{
    Caption = 'Asset Usage Monitor';
    DataCaptionFields = "Asset No.","Monitor Code",Description;
    DrillDownPageID = "MCH Asset Usage Monitors";
    LookupPageID = "MCH Asset Usage Monitors";

    fields
    {
        field(1;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            NotBlank = true;
            TableRelation = "MCH Maintenance Asset";

            trigger OnValidate()
            var
                MaintAsset: Record "MCH Maintenance Asset";
            begin
                if MaintAsset.Get("Asset No.") then
                  CheckUserAssetRespGroupAccess(MaintAsset);
            end;
        }
        field(2;"Monitor Code";Code[20])
        {
            Caption = 'Monitor Code';
            NotBlank = true;
            TableRelation = "MCH Master Usage Monitor";
        }
        field(3;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(4;"Asset Description";Text[100])
        {
            CalcFormula = Lookup("MCH Maintenance Asset".Description WHERE ("No."=FIELD("Asset No.")));
            Caption = 'Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(6;"Category Code";Code[20])
        {
            Caption = 'Category Code';
            Editable = false;
            TableRelation = "MCH Usage Monitor Category";
        }
        field(7;"Reading Type";Option)
        {
            Caption = 'Reading Type';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = Meter,Transactional;
        }
        field(8;Position;Text[100])
        {
            Caption = 'Position';
            DataClassification = CustomerContent;
        }
        field(9;"Description 2";Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(10;"Identifier Code";Code[100])
        {
            Caption = 'Identifier Code';

            trigger OnValidate()
            var
                Text000: Label 'cannot be ''''%1''''. This %2 is already assigned to %2 %3 %4';
            begin
                if ("Identifier Code" <> '') then begin
                  AssetUsageMonitor.Reset;
                  AssetUsageMonitor.SetCurrentKey("Identifier Code");
                  AssetUsageMonitor.SetRange("Identifier Code","Identifier Code");
                  if AssetUsageMonitor.FindSet then
                    repeat
                      if (AssetUsageMonitor."Asset No." <> "Asset No.") or (AssetUsageMonitor."Monitor Code" <> "Monitor Code") then
                        FieldError("Identifier Code",
                          StrSubstNo(Text000,"Identifier Code",FieldCaption("Identifier Code"),
                          TableCaption,AssetUsageMonitor."Asset No.",AssetUsageMonitor."Monitor Code"));
                    until AssetUsageMonitor.Next = 0;
                end;
            end;
        }
        field(12;"Serial No.";Code[50])
        {
            Caption = 'Serial No.';
        }
        field(13;"Last Calibration Date";Date)
        {
            Caption = 'Last Calibration Date';
        }
        field(14;"Next Calibration Date";Date)
        {
            Caption = 'Next Calibration Date';
            DataClassification = CustomerContent;
        }
        field(15;"Master Monitor Status";Option)
        {
            CalcFormula = Lookup("MCH Master Usage Monitor".Status WHERE (Code=FIELD("Monitor Code")));
            Caption = 'Master Monitor Status';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = Setup,"On Hold",Active,Blocked;
        }
        field(16;"Master Monitor Description";Text[100])
        {
            CalcFormula = Lookup("MCH Master Usage Monitor".Description WHERE (Code=FIELD("Monitor Code")));
            Caption = 'Master Monitor Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(20;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(21;"Usage Net Change";Decimal)
        {
            CalcFormula = Sum("MCH Usage Monitor Entry"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Monitor Code"=FIELD("Monitor Code"),
                                                                             "Reading Date"=FIELD("Date Filter")));
            Caption = 'Usage Net Change';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"First Reading Date";Date)
        {
            CalcFormula = Min("MCH Usage Monitor Entry"."Reading Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                              "Monitor Code"=FIELD("Monitor Code")));
            Caption = 'First Reading Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23;"Last Reading Date";Date)
        {
            CalcFormula = Max("MCH Usage Monitor Entry"."Reading Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                              "Monitor Code"=FIELD("Monitor Code"),
                                                                              Cancelled=CONST(false)));
            Caption = 'Last Reading Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24;"Usage at Date";Decimal)
        {
            CalcFormula = Sum("MCH Usage Monitor Entry"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Monitor Code"=FIELD("Monitor Code"),
                                                                             "Reading Date"=FIELD(UPPERLIMIT("Date Filter"))));
            Caption = 'Usage at Date';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25;"Total Usage";Decimal)
        {
            CalcFormula = Sum("MCH Usage Monitor Entry"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Monitor Code"=FIELD("Monitor Code")));
            Caption = 'Total Usage';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;Picture;Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
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
        field(100;"Meter/Usage Adj. from Date";Date)
        {
            Caption = 'Meter/Usage Adj. from Date';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                // Internal system use only on Balance/Usage adjustments.
            end;
        }
        field(150;"Asset Resp. Group Code";Code[20])
        {
            Caption = 'Asset Resp. Group Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MCH Asset Responsibility Group";
        }
    }

    keys
    {
        key(Key1;"Asset No.","Monitor Code")
        {
            Clustered = true;
        }
        key(Key2;"Identifier Code")
        {
        }
        key(Key3;"Category Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Asset No.","Monitor Code",Description,Blocked,"Master Monitor Status","Unit of Measure Code")
        {
        }
        fieldgroup(Brick;"Asset No.",Description,"Last Reading Date","Monitor Code","Unit of Measure Code",Picture)
        {
        }
    }

    trigger OnDelete()
    var
        UsageEntry2: Record "MCH Usage Monitor Entry";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        Text000: Label 'You cannot delete %1 %2 %3 because it has current entries registered.\You must cancel all associated entries before deletion.';
        Text001: Label 'You cannot delete %1 %2 %3 because it is being used by one or more asset maint. tasks.';
    begin
        if UsageEntriesExist(false) then
          Error(Text000,TableCaption,"Asset No.","Monitor Code");
        AssetMaintTask.SetCurrentKey("Usage Monitor Code");
        AssetMaintTask.SetRange("Asset No.","Asset No.");
        AssetMaintTask.SetRange("Usage Monitor Code","Monitor Code");
        if not AssetMaintTask.IsEmpty then
          Error(Text001,TableCaption,"Asset No.","Monitor Code");

        UsageEntry2.SetCurrentKey("Asset No.","Monitor Code");
        UsageEntry2.SetRange("Monitor Code","Monitor Code");
        UsageEntry2.SetRange("Asset No.","Asset No.");
        if not UsageEntry2.IsEmpty then
          UsageEntry2.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        MaintAsset: Record "MCH Maintenance Asset";
    begin
        TestField("Asset No.");
        MaintAsset.Get("Asset No.");
        CheckUserAssetRespGroupAccess(MaintAsset);
        "Asset Resp. Group Code" := MaintAsset."Responsibility Group Code";
        TestField("Monitor Code");
        MasterUsageMonitor.Get("Monitor Code");
        if not (MasterUsageMonitor.Status in [MasterUsageMonitor.Status::Active,MasterUsageMonitor.Status::"On Hold"]) then
          MasterUsageMonitor.FieldError(Status);

        TransferFromUsageMonitor(MasterUsageMonitor,true);
        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;

    var
        MasterUsageMonitor: Record "MCH Master Usage Monitor";
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
        UsageEntry: Record "MCH Usage Monitor Entry";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";


    procedure Caption(): Text
    begin
        if "Asset No." = '' then
          exit;
        CalcFields("Asset Description");
        exit(StrSubstNo('%1 %2 - %3 %4',"Asset No.","Asset Description","Monitor Code",Description));
    end;


    procedure ShowCard()
    var
        AssetUsageMonitorCard: Page "MCH Asset Usage Monitor Card";
    begin
        if ("Asset No." = '') or ("Monitor Code" = '') then
          exit;
        AssetUsageMonitor.Reset;
        AssetUsageMonitor := Rec;
        AssetUsageMonitor.SetRange("Asset No.","Asset No.");
        Clear(AssetUsageMonitorCard);
        AssetUsageMonitorCard.SetTableView(AssetUsageMonitor);
        AssetUsageMonitorCard.SetRecord(AssetUsageMonitor);
        AssetUsageMonitorCard.Run;
    end;


    procedure ShowUsageEntries()
    begin
        if ("Asset No." = '') or ("Monitor Code" = '') then
          exit;
        SetUsageEntryFilter(UsageEntry,false);
        UsageEntry.SetFilter("Reading Date",GetFilter("Date Filter"));
        if UsageEntry.FindLast then ;
        PAGE.Run(0,UsageEntry);
    end;


    procedure ShowTrendscape()
    var
        AssetUsageMonTrend: Page "MCH Asset Usage Monitor Trend";
    begin
        if "Monitor Code" = '' then
          exit;
        AssetUsageMonitor.Reset;
        AssetUsageMonitor.SetRange("Asset No.","Asset No.");
        AssetUsageMonitor.SetRange("Monitor Code","Monitor Code");
        AssetUsageMonTrend.SetTableView(AssetUsageMonitor);
        AssetUsageMonTrend.Run;
    end;


    procedure GetStyleTxt() StyleTxt: Text
    begin
        if ("Monitor Code" = '') then
          exit('');
        if Blocked then
          exit('Unfavorable');

        CalcFields("Master Monitor Status");
        case "Master Monitor Status" of
          "Master Monitor Status"::Setup : exit('Strong');
          "Master Monitor Status"::"On Hold" : exit('StrongAccent');
          "Master Monitor Status"::Active : exit('');
          "Master Monitor Status"::Blocked : exit('Unfavorable');
        end;
    end;


    procedure UsageEntriesExist(ExcludeCancelled: Boolean) OK: Boolean
    begin
        SetUsageEntryFilter(UsageEntry,ExcludeCancelled);
        exit(not UsageEntry.IsEmpty);
    end;


    procedure FindLastReadingValue() LastReadingValue: Decimal
    var
        MAUsageEntry2: Record "MCH Usage Monitor Entry";
    begin
        SetUsageEntryFilter(UsageEntry,true);
        if UsageEntry.FindLast then
          exit(UsageEntry."Reading Value");
    end;


    procedure FindLastUsageValue() LastUsageValue: Decimal
    var
        MAUsageEntry2: Record "MCH Usage Monitor Entry";
    begin
        SetUsageEntryFilter(UsageEntry,true);
        if UsageEntry.FindLast then
          exit(UsageEntry."Usage Value");
    end;


    procedure ShowFirstUsageEntry()
    var
        MAUsageEntry2: Record "MCH Usage Monitor Entry";
    begin
        SetUsageEntryFilter(UsageEntry,false);
        UsageEntry.SetRange(Cancelled,false);
        if UsageEntry.FindFirst then ;
        UsageEntry.SetRange(Cancelled);
        PAGE.Run(0,UsageEntry);
    end;


    procedure ShowLastUsageEntry()
    var
        MAUsageEntry2: Record "MCH Usage Monitor Entry";
    begin
        SetUsageEntryFilter(UsageEntry,false);
        UsageEntry.SetRange(Cancelled,false);
        if UsageEntry.FindLast then ;
        UsageEntry.SetRange(Cancelled);
        PAGE.Run(0,UsageEntry);
    end;

    local procedure SetUsageEntryFilter(var TheUsageEntry: Record "MCH Usage Monitor Entry";ExcludeCancelled: Boolean)
    begin
        TheUsageEntry.Reset;
        if IsMeterMonitor then
          TheUsageEntry.SetCurrentKey("Asset No.","Monitor Code","Reading Date-Time","Reading Value")
        else
          TheUsageEntry.SetCurrentKey("Asset No.","Monitor Code","Reading Date","Reading Time");

        TheUsageEntry.SetRange("Asset No.","Asset No.");
        TheUsageEntry.SetRange("Monitor Code","Monitor Code");
        if ExcludeCancelled then begin
          if not IsMeterMonitor then
            TheUsageEntry.SetCurrentKey("Asset No.","Monitor Code",Cancelled,"Reading Date","Reading Time");
          TheUsageEntry.SetRange(Cancelled,false);
        end;
    end;


    procedure SetSecurityFilterOnAssetResponsibilityGroup(FilterGrpNo: Integer)
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
          FilterGroup(FilterGrpNo);
          SetFilter("Asset Resp. Group Code",MaintUserMgt.GetAssetRespGroupFilter);
          FilterGroup(0);
        end;
    end;

    local procedure CheckUserAssetRespGroupAccess(var MaintAsset: Record "MCH Maintenance Asset")
    var
        UserAssetRespGroupAccessErrMsg: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
    begin
        if MaintAsset."No." = '' then
          exit;
        if not MaintUserMgt.UserHasAccessToRespGroup(UserId,MaintAsset."Responsibility Group Code") then
          Error(UserAssetRespGroupAccessErrMsg,
            MaintAsset.TableCaption,MaintAsset."No.",
            MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
    end;

    local procedure IsMeterMonitor() OK: Boolean
    begin
        exit("Reading Type" = "Reading Type"::Meter);
    end;


    procedure TransferFromUsageMonitor(UsageMonitor: Record "MCH Master Usage Monitor";OnInsert: Boolean)
    begin
        if OnInsert then begin
          Description := UsageMonitor.Description;
          "Description 2" := UsageMonitor."Description 2";
        end;
        "Unit of Measure Code" := UsageMonitor."Unit of Measure Code";
        "Category Code" := UsageMonitor."Category Code";
        "Reading Type" := UsageMonitor."Reading Type";
    end;


    procedure IncludeInSchedule() OK: Boolean
    begin
        if Blocked then
          exit(false);
        if not MasterUsageMonitor.Get("Monitor Code") then
          exit(false);
        exit(MasterUsageMonitor.Status = MasterUsageMonitor.Status::Active);
    end;
}

