table 74054 "MCH AM Planning Wksh. Line"
{
    Caption = 'Maint. Planning Wksh. Line';
    DataCaptionFields = "Journal Batch Name","Line No.";
    DrillDownPageID = "MCH AM Planning Wksh. Lines";
    LookupPageID = "MCH AM Planning Wksh. Lines";
    PasteIsValid = false;

    fields
    {
        field(1;"Worksheet Template Name";Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "MCH AM Planning Wksh. Templ.";
        }
        field(2;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "MCH AM Planning Wksh. Name".Name WHERE ("Worksheet Template Name"=FIELD("Worksheet Template Name"));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "MCH Maintenance Asset";

            trigger OnValidate()
            var
                TempAMPlanningWkshLine: Record "MCH AM Planning Wksh. Line";
                NoRespGroupAccess: Boolean;
            begin
                if "Asset No." = '' then begin
                  Init;
                  exit;
                end;

                if "Asset No." <> xRec."Asset No."  then begin
                  GetSetup;
                  GetMaintAsset;
                  if MaintUserMgt.UserHasAssetRespGroupFilter then begin
                    if (MaintAsset."Responsibility Group Code" = '') then
                      NoRespGroupAccess := true
                    else
                      NoRespGroupAccess := not MaintUserMgt.UserHasAccessToRespGroup(UserId,MaintAsset."Responsibility Group Code");
                    if NoRespGroupAccess then
                      Error(Text001,
                        MaintAsset.TableCaption,MaintAsset."No.",
                        MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
                  end;

                  TempAMPlanningWkshLine := Rec;
                  Init;
                  "Asset No." := TempAMPlanningWkshLine."Asset No.";

                  MaintAsset.CheckMandatoryFields;
                  MaintAsset.TestField(Blocked,false);
                  Description := MaintAsset.Description;
                  "Description 2" := MaintAsset."Description 2";
                  "Asset Category Code" := MaintAsset."Category Code";
                  "Posting Group" := MaintAsset."Posting Group";
                  if (MaintAsset."Fixed Maint. Location Code" <> '') then
                    "Maint. Location Code" := MaintAsset."Fixed Maint. Location Code";
                  if (MaintAsset."Responsibility Group Code" <> '') then
                    "Responsibility Group Code" := MaintAsset."Responsibility Group Code";
                  Priority := AMSetup."Def. Work Order Priority";
                end;
            end;
        }
        field(6;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(7;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(10;"Asset Category Code";Code[20])
        {
            Caption = 'Asset Category Code';
            Editable = false;
            TableRelation = "MCH Maint. Asset Category";
        }
        field(11;"Posting Group";Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = "MCH Maint. Asset Posting Group";
        }
        field(12;"Responsibility Group Code";Code[20])
        {
            Caption = 'Resp. Group Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Asset Responsibility Group";

            trigger OnValidate()
            var
                RespGroupAccesErrMsg: Label 'Your setup does not allow processing for %1 = %2.';
            begin
                if ("Asset No." <> '') and ("Responsibility Group Code" <> xRec."Responsibility Group Code") then begin
                  GetMaintAsset;
                  if (MaintAsset."Responsibility Group Code" <> '') and ("Responsibility Group Code" <> MaintAsset."Responsibility Group Code") then
                    Error(Text002,FieldCaption("Responsibility Group Code"),MaintAsset.TableCaption,"Asset No.",MaintAsset."Responsibility Group Code");
                  if not MaintUserMgt.UserHasAccessToRespGroup(UserId,"Responsibility Group Code") then
                    Error(RespGroupAccesErrMsg,
                      FieldCaption("Responsibility Group Code"),"Responsibility Group Code");
                end;
            end;
        }
        field(16;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            TableRelation = "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("Asset No."));

            trigger OnValidate()
            var
                MasterMaintTask: Record "MCH Master Maintenance Task";
                AssetMaintTask: Record "MCH Asset Maintenance Task";
            begin
                if ("Task Code" <> xRec."Task Code") then begin
                  // blank recs
                  CopyFromAssetMaintTask(AssetMaintTask);
                  CopyFromMasterMaintTask(MasterMaintTask);

                  Validate("Task Scheduled Date",0D);
                  Validate("Task Scheduled Usage Value",0);
                end;

                if "Task Code" <> '' then begin
                  TestField("Asset No.");
                  AssetMaintTask.Get("Asset No.","Task Code");
                  AssetMaintTask.TestField(Blocked,false);

                  MasterMaintTask.Get("Task Code");
                  MasterMaintTask.TestField(Status,MasterMaintTask.Status::Active);
                  CopyFromAssetMaintTask(AssetMaintTask);
                  CopyFromMasterMaintTask(MasterMaintTask);
                end;
            end;
        }
        field(17;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(20;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            TableRelation = "MCH Work Order Type";

            trigger OnValidate()
            var
                WorkOrderType: Record "MCH Work Order Type";
            begin
                if ("Work Order Type" <> '') then begin
                  WorkOrderType.Get("Work Order Type");
                  WorkOrderType.TestField(Blocked,false);
                end;
                if ("Work Order Type" <> xRec."Work Order Type") then begin
                  GetSetup;
                  if ("Work Order Type" <> '') then begin
                    if (WorkOrderType."Def. Work Order Priority" > WorkOrderType."Def. Work Order Priority"::" ") then
                      Priority := WorkOrderType."Def. Work Order Priority" - 1;
                  end else begin
                    Priority := AMSetup."Def. Work Order Priority";
                  end;
                end;
            end;
        }
        field(22;Priority;Option)
        {
            Caption = 'Priority';
            OptionCaption = 'Very High,High,Medium,Low,Very Low';
            OptionMembers = "Very High",High,Medium,Low,"Very Low";
        }
        field(30;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            TableRelation = "MCH Maintenance Location";

            trigger OnValidate()
            begin
                if ("Asset No." <> '') and ("Maint. Location Code" <> xRec."Maint. Location Code") then begin
                  GetMaintAsset;
                  if (MaintAsset."Fixed Maint. Location Code" <> '') and ("Maint. Location Code" <> MaintAsset."Fixed Maint. Location Code") then
                    Error(Text002,FieldCaption("Maint. Location Code"),MaintAsset.TableCaption,"Asset No.",MaintAsset."Fixed Maint. Location Code");
                end;
            end;
        }
        field(33;"Task Trigger Method";Option)
        {
            Caption = 'Task Trigger Method';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Manual,Calendar,Fixed Date,Usage,Fixed Usage';
            OptionMembers = Manual,"Calendar (Recurring)","Fixed Date","Usage (Recurring)","Fixed Usage";
        }
        field(34;"Task Scheduled Date";Date)
        {
            Caption = 'Task Scheduled Date';
        }
        field(35;"Task Scheduled Usage Value";Decimal)
        {
            BlankZero = true;
            Caption = 'Task Scheduled Usage';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(39;"Task Description";Text[100])
        {
            Caption = 'Task Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40;"Task Description 2";Text[50])
        {
            Caption = 'Task Description 2';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41;"Trigger Description";Text[250])
        {
            Caption = 'Trigger Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42;"Recurr. Trigger Calc. Method";Option)
        {
            Caption = 'Recurring Trigger Calc. Method';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Fixed Schedule,Actual Completion';
            OptionMembers = " ","Fixed Schedule","Actual Completion";
        }
        field(43;"Lead Time (Days)";Integer)
        {
            BlankZero = true;
            Caption = 'Lead Time (Days)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44;"Last Scheduled Date";Date)
        {
            CalcFormula = Max("MCH Work Order Line"."Task Scheduled Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                 "Task Code"=FIELD("Task Code")));
            Caption = 'Last Scheduled Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45;"Last Completion Date";Date)
        {
            CalcFormula = Max("MCH Work Order Line"."Completion Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'Last Completion Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Budget Type Filter";Option)
        {
            Caption = 'Budget Type Filter';
            Editable = false;
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(51;"Budgeted Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("MCH Maint. Task Budget Line"."Cost Amount" WHERE ("Task Code"=FIELD("Task Code"),
                                                                                 Type=FIELD("Budget Type Filter")));
            Caption = 'Budgeted Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Budgeted Hours";Decimal)
        {
            CalcFormula = Sum("MCH Maint. Task Budget Line".Hours WHERE ("Task Code"=FIELD("Task Code"),
                                                                         Type=FIELD("Budget Type Filter")));
            Caption = 'Budgeted Hours';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Usage Monitor Code";Code[20])
        {
            Caption = 'Usage Monitor Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "MCH Asset Usage Monitor"."Monitor Code" WHERE ("Asset No."=FIELD("Asset No."));
        }
        field(61;"Current Usage";Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("MCH Usage Monitor Entry"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Monitor Code"=FIELD("Usage Monitor Code")));
            Caption = 'Current Usage';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Last Scheduled Usage";Decimal)
        {
            BlankZero = true;
            CalcFormula = Max("MCH Work Order Line"."Task Scheduled Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                        "Task Code"=FIELD("Task Code")));
            Caption = 'Last Scheduled Usage';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(63;"Last Completion Usage";Decimal)
        {
            BlankZero = true;
            CalcFormula = Max("MCH Work Order Line"."Usage on Completion" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                 "Task Code"=FIELD("Task Code")));
            Caption = 'Last Completion Usage';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(64;"Usage Tolerance";Decimal)
        {
            BlankZero = true;
            Caption = 'Usage Tolerance';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(100;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(101;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Worksheet Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Asset No.","Task Code","Starting Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key3;"Starting Date",Priority,"Work Order Type","Asset No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key4;"Starting Date",Priority,"Work Order Type","Responsibility Group Code","Maint. Location Code")
        {
            MaintainSQLIndex = false;
        }
        key(Key5;"Starting Date",Priority,"Work Order Type")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        AMPlanningWkshLine: Record "MCH AM Planning Wksh. Line";
    begin
        PlanningWkshTemplate.Get("Worksheet Template Name");
        PlanningWkshName.Get("Worksheet Template Name","Journal Batch Name");

        if (CurrentKey <> AMPlanningWkshLine.CurrentKey) then begin
          AMPlanningWkshLine := Rec;
          AMPlanningWkshLine.SetRecFilter;
          AMPlanningWkshLine.SetRange("Line No.");
          if AMPlanningWkshLine.FindLast then
            "Line No." := AMPlanningWkshLine."Line No." + 10000
          else
            "Line No." := 10000;
        end;

        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;

    var
        PlanningWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        PlanningWkshName: Record "MCH AM Planning Wksh. Name";
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintAsset: Record "MCH Maintenance Asset";
        MaintUser: Record "MCH Asset Maintenance User";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        Text001: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
        HasSetup: Boolean;
        Text002: Label 'The %1 for %2 %3 must be %4.';

    local procedure GetMaintAsset()
    begin
        if MaintAsset."No." <> "Asset No." then
          MaintAsset.Get("Asset No.");
    end;

    local procedure GetSetup()
    begin
        if HasSetup then
          exit;
        AMSetup.Get;
        HasSetup := true;
    end;


    procedure IsOpenedFromBatch(): Boolean
    var
        JournalBatch: Record "MCH AM Planning Wksh. Name";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GetFilter("Journal Batch Name");
        if BatchFilter <> '' then begin
          TemplateFilter := GetFilter("Worksheet Template Name");
          if TemplateFilter <> '' then
            JournalBatch.SetFilter("Worksheet Template Name",TemplateFilter);
          JournalBatch.SetFilter(Name,BatchFilter);
          JournalBatch.FindFirst;
        end;
        exit((("Journal Batch Name" <> '') and ("Worksheet Template Name" = '')) or (BatchFilter <> ''));
    end;

    local procedure CopyFromAssetMaintTask(AssetMaintTask: Record "MCH Asset Maintenance Task")
    begin
        "Task Description" := AssetMaintTask.Description;
        "Lead Time (Days)" := AssetMaintTask."Schedule Lead Time (Days)";
        "Usage Monitor Code" := AssetMaintTask."Usage Monitor Code";
        "Usage Tolerance" := AssetMaintTask."Usage Schedule-Ahead Tolerance";
    end;

    local procedure CopyFromMasterMaintTask(MasterMaintTask: Record "MCH Master Maintenance Task")
    begin
        "Task Description 2" := MasterMaintTask."Description 2";
        "Task Trigger Method" := MasterMaintTask."Trigger Method";
        "Trigger Description" := MasterMaintTask."Trigger Description";
        "Recurr. Trigger Calc. Method" := MasterMaintTask."Recurring Trigger Calc. Method";
        Validate("Work Order Type",MasterMaintTask."Scheduling Work Order Type")
    end;
}

