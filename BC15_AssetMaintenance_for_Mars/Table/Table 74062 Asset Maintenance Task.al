table 74062 "MCH Asset Maintenance Task"
{
    Caption = 'Asset Maint. Task';
    DataCaptionFields = "Asset No.","Task Code",Description;
    DrillDownPageID = "MCH Asset Maint. Task List";
    LookupPageID = "MCH Asset Maint. Task Lookup";

    fields
    {
        field(2;"Asset No.";Code[20])
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
        field(3;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            NotBlank = true;
            TableRelation = "MCH Master Maintenance Task";

            trigger OnValidate()
            var
                MasterMaintTask: Record "MCH Master Maintenance Task";
            begin
                MasterMaintTask.Get("Task Code");
                if not (MasterMaintTask.Status in [MasterMaintTask.Status::Active,MasterMaintTask.Status::"On Hold"]) then
                  MasterMaintTask.FieldError(Status);

                Description := MasterMaintTask.Description;
                "Trigger Method" := MasterMaintTask."Trigger Method";
                "Expected Duration (Hours)" := MasterMaintTask."Expected Duration (Hours)";
                "Expected Downtime (Hours)" := MasterMaintTask."Expected Downtime (Hours)";
                if ("Trigger Method" <> "Trigger Method"::Manual) then begin
                  "Schedule Lead Time (Days)" := MasterMaintTask."Schedule Lead Time (Days)";
                  if ("Trigger Method" in ["Trigger Method"::"Usage (Recurring)","Trigger Method"::"Fixed Usage"]) then
                    "Usage Schedule-Ahead Tolerance" := MasterMaintTask."Usage Schedule-Ahead Tolerance";
                end;
            end;
        }
        field(4;Description;Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5;"Master Task Description";Text[100])
        {
            CalcFormula = Lookup("MCH Master Maintenance Task".Description WHERE (Code=FIELD("Task Code")));
            Caption = 'Master Task Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Asset Description";Text[100])
        {
            CalcFormula = Lookup("MCH Maintenance Asset".Description WHERE ("No."=FIELD("Asset No.")));
            Caption = 'Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;Blocked;Boolean)
        {
            BlankZero = true;
            Caption = 'Blocked';
        }
        field(8;"Master Task Status";Option)
        {
            CalcFormula = Lookup("MCH Master Maintenance Task".Status WHERE (Code=FIELD("Task Code")));
            Caption = 'Master Task Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Setup,On Hold,Active,Blocked';
            OptionMembers = Setup,"On Hold",Active,Blocked;
        }
        field(9;"Category Code";Code[20])
        {
            CalcFormula = Lookup("MCH Master Maintenance Task"."Category Code" WHERE (Code=FIELD("Task Code")));
            Caption = 'Category Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "MCH Maintenance Task Category";
        }
        field(10;"Expected Duration (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expected Duration (Hours)';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(11;"Expected Downtime (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expected Downtime (Hours)';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(12;"Trigger Method";Option)
        {
            Caption = 'Trigger Method';
            Editable = false;
            OptionCaption = 'Manual,Calendar (Recurring),Fixed Date,Usage (Recurring),Fixed Usage';
            OptionMembers = Manual,"Calendar (Recurring)","Fixed Date","Usage (Recurring)","Fixed Usage";
        }
        field(13;"Schedule Lead Time (Days)";Integer)
        {
            Caption = 'Schedule Lead Time (Days)';
            DataClassification = CustomerContent;
            MaxValue = 90;
            MinValue = 0;
        }
        field(14;"Usage Monitor Code";Code[20])
        {
            Caption = 'Usage Monitor Code';
            TableRelation = "MCH Asset Usage Monitor"."Monitor Code" WHERE ("Asset No."=FIELD("Asset No."));

            trigger OnValidate()
            begin
                if "Usage Monitor Code" <> '' then begin
                  if not ("Trigger Method" in ["Trigger Method"::Manual,"Trigger Method"::"Usage (Recurring)","Trigger Method"::"Fixed Usage"]) then
                    Error(Text002,
                      FieldCaption("Usage Monitor Code"),FieldCaption("Trigger Method"),"Trigger Method");
                end;
            end;
        }
        field(15;"Usage Schedule-Ahead Tolerance";Decimal)
        {
            Caption = 'Usage Schedule-Ahead Tolerance';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(19;"Trigger Description";Text[250])
        {
            CalcFormula = Lookup("MCH Master Maintenance Task"."Trigger Description" WHERE (Code=FIELD("Task Code")));
            Caption = 'Trigger Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Effective Date";Date)
        {
            Caption = 'Effective Date';
            NotBlank = true;

            trigger OnValidate()
            begin
                Validate("Expiry Date");
            end;
        }
        field(21;"Expiry Date";Date)
        {
            Caption = 'Expiry Date';

            trigger OnValidate()
            begin
                if "Expiry Date" <> 0D then
                  if "Expiry Date" < "Effective Date" then
                    Error(Text001,FieldCaption("Expiry Date"),FieldCaption("Effective Date"));
            end;
        }
        field(22;"Starting Value (Recurr. Usage)";Decimal)
        {
            BlankZero = true;
            Caption = 'Starting Value (Recurr. Usage)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if "Starting Value (Recurr. Usage)" <> 0 then
                  TestField("Trigger Method","Trigger Method"::"Usage (Recurring)");
                Validate("Expiry Value (Recurr. Usage)");
            end;
        }
        field(23;"Expiry Value (Recurr. Usage)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expiry Value (Recurr. Usage)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if "Expiry Value (Recurr. Usage)" <> 0 then begin
                  TestField("Trigger Method","Trigger Method"::"Usage (Recurring)");
                  if "Expiry Value (Recurr. Usage)" < "Starting Value (Recurr. Usage)" then
                    Error(Text003,FieldCaption("Expiry Value (Recurr. Usage)"),FieldCaption("Starting Value (Recurr. Usage)"));
                end;
            end;
        }
        field(25;"Recurring Trigger Calc. Method";Option)
        {
            CalcFormula = Lookup("MCH Master Maintenance Task"."Recurring Trigger Calc. Method" WHERE (Code=FIELD("Task Code")));
            Caption = 'Recurring Trigger Calc. Method';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Fixed Schedule,Last Completion';
            OptionMembers = " ","Fixed Schedule","Last Completion";
        }
        field(30;"No. of Fixed Dates";Integer)
        {
            CalcFormula = Count("MCH Asset M. Task Fixed Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                      "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Fixed Dates';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31;"First Fixed Date";Date)
        {
            CalcFormula = Min("MCH Asset M. Task Fixed Date"."Due Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                               "Task Code"=FIELD("Task Code")));
            Caption = 'First Fixed Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32;"Last Fixed Date";Date)
        {
            CalcFormula = Max("MCH Asset M. Task Fixed Date"."Due Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                               "Task Code"=FIELD("Task Code")));
            Caption = 'Last Fixed Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37;"Last Completion Date";Date)
        {
            CalcFormula = Max("MCH Work Order Line"."Completion Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'Last Completion Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38;"First Scheduled Date";Date)
        {
            CalcFormula = Min("MCH Work Order Line"."Task Scheduled Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                 "Task Code"=FIELD("Task Code")));
            Caption = 'First Scheduled Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;"Last Scheduled Date";Date)
        {
            CalcFormula = Max("MCH Work Order Line"."Task Scheduled Date" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                 "Task Code"=FIELD("Task Code")));
            Caption = 'Last Scheduled Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"No. of Fixed Usage Values";Integer)
        {
            CalcFormula = Count("MCH Asset M. Task Fixed Usage" WHERE ("Asset No."=FIELD("Asset No."),
                                                                       "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Fixed Usage Values';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41;"First Fixed Usage Value";Decimal)
        {
            BlankZero = true;
            CalcFormula = Min("MCH Asset M. Task Fixed Usage"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                   "Task Code"=FIELD("Task Code")));
            Caption = 'First Fixed Usage Value';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(42;"Last Fixed Usage Value";Decimal)
        {
            BlankZero = true;
            CalcFormula = Max("MCH Asset M. Task Fixed Usage"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                   "Task Code"=FIELD("Task Code")));
            Caption = 'Last Fixed Usage Value';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(49;"Last Scheduled Usage Value";Decimal)
        {
            BlankZero = true;
            CalcFormula = Max("MCH Work Order Line"."Task Scheduled Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                        "Task Code"=FIELD("Task Code")));
            Caption = 'Last Scheduled Usage Value';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Current Usage Value";Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("MCH Usage Monitor Entry"."Usage Value" WHERE ("Asset No."=FIELD("Asset No."),
                                                                             "Monitor Code"=FIELD("Usage Monitor Code")));
            Caption = 'Current Usage Value';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Last Completion Usage Value";Decimal)
        {
            BlankZero = true;
            CalcFormula = Max("MCH Work Order Line"."Usage on Completion" WHERE ("Asset No."=FIELD("Asset No."),
                                                                                 "Task Code"=FIELD("Task Code")));
            Caption = 'Last Completion Usage Value';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(53;"Budget Type Filter";Option)
        {
            Caption = 'Budget Type Filter';
            Editable = false;
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(54;"Budgeted Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("MCH Maint. Task Budget Line"."Cost Amount" WHERE ("Task Code"=FIELD("Task Code"),
                                                                                 Type=FIELD("Budget Type Filter")));
            Caption = 'Budgeted Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55;"Budgeted Hours";Decimal)
        {
            CalcFormula = Sum("MCH Maint. Task Budget Line".Hours WHERE ("Task Code"=FIELD("Task Code"),
                                                                         Type=FIELD("Budget Type Filter")));
            Caption = 'Budgeted Hours';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"No. of Request WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Request),
                                                             "Asset No."=FIELD("Asset No."),
                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Request WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"No. of Planned WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Planned),
                                                             "Asset No."=FIELD("Asset No."),
                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Planned WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"No. of Released WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Released),
                                                             "Asset No."=FIELD("Asset No."),
                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Released WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"No. of Finished WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Finished),
                                                             "Asset No."=FIELD("Asset No."),
                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Finished WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104;"No. of Planning Wksh. Lines";Integer)
        {
            CalcFormula = Count("MCH AM Planning Wksh. Line" WHERE ("Asset No."=FIELD("Asset No."),
                                                                    "Task Code"=FIELD("Task Code")));
            Caption = 'No. of Planning Wksh. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Ongoing Work Orders";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH Work Order Line" WHERE (Status=FILTER(Request|Planned|Released),
                                                             "Asset No."=FIELD("Asset No."),
                                                             "Task Code"=FIELD("Task Code")));
            Caption = 'Ongoing Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106;"Ongoing Planning Worksheet";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH AM Planning Wksh. Line" WHERE ("Asset No."=FIELD("Asset No."),
                                                                    "Task Code"=FIELD("Task Code")));
            Caption = 'Ongoing Planning Worksheet';
            Editable = false;
            FieldClass = FlowField;
        }
        field(150;"Asset Resp. Group Code";Code[20])
        {
            Caption = 'Asset Resp. Group Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MCH Asset Responsibility Group";
        }
        field(200;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(201;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(202;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(203;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(300;"No. of Attachments";Integer)
        {
            CalcFormula = Count("MCH AM Document Attachment" WHERE ("Table ID"=CONST(74062),
                                                                    "No."=FIELD("Asset No."),
                                                                    "No. 2"=FIELD("Task Code")));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
            InitValue = 0;

            trigger OnLookup()
            begin
                Rec.ShowDocumentAttachments;
            end;
        }
    }

    keys
    {
        key(Key1;"Asset No.","Task Code")
        {
            Clustered = true;
        }
        key(Key2;"Task Code")
        {
        }
        key(Key3;"Usage Monitor Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Asset No.","Task Code",Description,"Trigger Method","Category Code",Blocked)
        {
        }
    }

    trigger OnDelete()
    var
        WorkOrderLine: Record "MCH Work Order Line";
    begin
        WorkOrderLine.Reset;
        WorkOrderLine.SetCurrentKey("Asset No.","Task Code");
        WorkOrderLine.SetRange("Asset No.","Asset No.");
        WorkOrderLine.SetRange("Task Code","Task Code");
        if not WorkOrderLine.IsEmpty then
          Error(
            Text000,
            TableCaption,"Asset No.","Task Code",WorkOrderLine.TableCaption);

        DeleteFixedDates;
        DeleteFixedUsageValues;
    end;

    trigger OnInsert()
    var
        MaintAsset: Record "MCH Maintenance Asset";
        MasterMaintTask: Record "MCH Master Maintenance Task";
    begin
        TestField("Asset No.");
        MaintAsset.Get("Asset No.");
        CheckUserAssetRespGroupAccess(MaintAsset);
        "Asset Resp. Group Code" := MaintAsset."Responsibility Group Code";

        TestField("Task Code");
        MasterMaintTask.Get("Task Code");

        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        SetLastModified;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 %3 because there exists at least one %4 associated with it.';
        Text001: Label '%1 cannot be earlier than %2.';
        Text002: Label '%1 cannot be specified when %2 is %3.';
        Text003: Label '%1 cannot be less than %2.';
        MaintTaskMgt: Codeunit "MCH Maint. Task Mgt.";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";


    procedure ShowCard()
    var
        AssetMaintProcCard: Page "MCH Asset Maint. Task Card";
    begin
        if ("Asset No." = '') or ("Task Code" = '') then
          exit;
        AssetMaintProcCard.SetRecord(Rec);
        AssetMaintProcCard.Run;
    end;


    procedure ShowBudget()
    var
        MaintProcBudgetLine: Record "MCH Maint. Task Budget Line";
    begin
        if ("Asset No." = '') or ("Task Code" = '') then
          exit;
        MaintProcBudgetLine.SetRange("Task Code","Task Code");
        PAGE.Run(0,MaintProcBudgetLine);
    end;


    procedure ShowFixedDates()
    var
        AssetMTFixedDate: Record "MCH Asset M. Task Fixed Date";
    begin
        if ("Asset No." = '') or ("Task Code" = '') or
           ("Trigger Method" <> "Trigger Method"::"Fixed Date")
        then
          exit;
        AssetMTFixedDate.FilterGroup(2);
        AssetMTFixedDate.SetRange("Asset No.","Asset No.");
        AssetMTFixedDate.SetRange("Task Code","Task Code");
        AssetMTFixedDate.FilterGroup(0);
        PAGE.Run(0,AssetMTFixedDate);
    end;


    procedure ShowFixedUsageValues()
    var
        AssetMTFixedUsageValue: Record "MCH Asset M. Task Fixed Usage";
    begin
        if ("Asset No." = '') or ("Task Code" = '') or
           ("Trigger Method" <> "Trigger Method"::"Fixed Usage")
        then
          exit;
        AssetMTFixedUsageValue.FilterGroup(2);
        AssetMTFixedUsageValue.SetRange("Asset No.","Asset No.");
        AssetMTFixedUsageValue.SetRange("Task Code","Task Code");
        AssetMTFixedUsageValue.FilterGroup(0);
        PAGE.Run(0,AssetMTFixedUsageValue);
    end;


    procedure ShowDocumentAttachments()
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
        AMDocAttachDetails: Page "MCH AM Doc.Attach. Details";
    begin
        if ("Asset No." = '') or ("Task Code" = '') then
          exit;
        AMDocumentAttachment.FilterGroup(4);
        AMDocumentAttachment.SetRange("Table ID",DATABASE::"MCH Asset Maintenance Task");
        AMDocumentAttachment.SetRange("No.","Asset No.");
        AMDocumentAttachment.SetRange("No. 2","Task Code");
        AMDocumentAttachment.FilterGroup(0);
        AMDocAttachDetails.SetTableView(AMDocumentAttachment);
        AMDocAttachDetails.SetCaption(StrSubstNo('%1 - %2 %3',TableCaption,"Asset No.","Task Code"));
        AMDocAttachDetails.RunModal;
    end;


    procedure ShowAsset()
    var
        MaintAsset: Record "MCH Maintenance Asset";
    begin
        if not MaintAsset.Get("Asset No.") then
          exit;
        MaintAsset.ShowCard;
    end;


    procedure ShowMasterMaintTask()
    var
        MasterMaintTask: Record "MCH Master Maintenance Task";
    begin
        if "Task Code" = '' then
          exit;
        MasterMaintTask.Get("Task Code");
        MasterMaintTask.ShowCard;
    end;


    procedure ShowAssetUsageMonitor()
    var
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
    begin
        if "Usage Monitor Code" = '' then
          exit;
        AssetUsageMonitor.Get("Asset No.","Usage Monitor Code");
        AssetUsageMonitor.ShowCard;
    end;


    procedure ShowUsageMonitorEntries()
    var
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
    begin
        if "Usage Monitor Code" = '' then
          exit;
        AssetUsageMonitor.Get("Asset No.","Usage Monitor Code");
        AssetUsageMonitor.ShowUsageEntries;
    end;


    procedure ShowMaintForecastOverview()
    var
        MaintFCastOverview: Page "MCH Maint. FCast Overview";
    begin
        if "Task Code" = '' then
          exit;
        MaintFCastOverview.InitPageFromAssetMaintTask(Rec);
        MaintFCastOverview.Run;
    end;


    procedure GetStyleTxt() StyleTxt: Text
    begin
        if ("Task Code" = '') then
          exit('');
        if Blocked then
          exit('Unfavorable');
    end;


    procedure GetMasterStyleTxt() StyleTxt: Text
    begin
        if ("Task Code" = '') then
          exit('');
        CalcFields("Master Task Status");
        case "Master Task Status" of
          "Master Task Status"::Setup : exit('Strong');
          "Master Task Status"::"On Hold" : exit('AttentionAccent');
          "Master Task Status"::Active : exit('');
          "Master Task Status"::Blocked : exit('Unfavorable');
        end;
    end;

    local procedure DeleteFixedDates()
    var
        AssetMTFixedDate: Record "MCH Asset M. Task Fixed Date";
    begin
        AssetMTFixedDate.SetRange("Asset No.","Asset No.");
        AssetMTFixedDate.SetRange("Task Code","Task Code");
        if not AssetMTFixedDate.IsEmpty then
          AssetMTFixedDate.DeleteAll(true);
    end;

    local procedure DeleteFixedUsageValues()
    var
        AssetMTFixedUsageValue: Record "MCH Asset M. Task Fixed Usage";
    begin
        AssetMTFixedUsageValue.SetRange("Asset No.","Asset No.");
        AssetMTFixedUsageValue.SetRange("Task Code","Task Code");
        if not AssetMTFixedUsageValue.IsEmpty then
          AssetMTFixedUsageValue.DeleteAll(true);
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


    procedure SetLastModified()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;


    procedure HasDateIncompleteOngoingWorkOrder() OK: Boolean
    var
        WorkOrderLine: Record "MCH Work Order Line";
    begin
        WorkOrderLine.SetCurrentKey("Asset No.","Task Code","Completion Date");
        WorkOrderLine.SetRange(Status,WorkOrderLine.Status::Request,WorkOrderLine.Status::Released);
        WorkOrderLine.SetRange("Asset No.","Asset No.");
        WorkOrderLine.SetRange("Task Code","Task Code");
        WorkOrderLine.SetRange("Completion Date",0D);
        exit(not WorkOrderLine.IsEmpty);
    end;


    procedure HasUsageIncompleteOngoingWorkOrder() OK: Boolean
    var
        WorkOrderLine: Record "MCH Work Order Line";
    begin
        WorkOrderLine.SetCurrentKey("Asset No.","Task Code","Usage on Completion");
        WorkOrderLine.SetRange(Status,WorkOrderLine.Status::Request,WorkOrderLine.Status::Released);
        WorkOrderLine.SetRange("Asset No.","Asset No.");
        WorkOrderLine.SetRange("Task Code","Task Code");
        WorkOrderLine.SetRange("Usage on Completion",0);
        exit(not WorkOrderLine.IsEmpty);
    end;
}

