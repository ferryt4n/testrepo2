table 74059 "MCH Master Maintenance Task"
{
    Caption = 'Master Maint. Task';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Master Maint. Task List";
    LookupPageID = "MCH Master Maint. Task Lookup";
    PasteIsValid = false;

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if Code <> xRec.Code then begin
                  AMSetup.Get;
                  NoSeriesMgt.TestManual(AMSetup."Maintenance Task Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(3;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(5;Status;Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Setup,On Hold,Active,Blocked';
            OptionMembers = Setup,"On Hold",Active,Blocked;
        }
        field(9;"Category Code";Code[20])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Maintenance Task Category";
        }
        field(10;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12;"Scheduling Work Order Type";Code[20])
        {
            Caption = 'Scheduling Work Order Type';
            TableRelation = "MCH Work Order Type";
        }
        field(13;"Expected Duration (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expected Duration (Hours)';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Expected Duration (Hours)" <> xRec."Expected Duration (Hours)") then begin
                  if (CurrFieldNo = FieldNo("Expected Duration (Hours)")) then
                    UpdateDefaultAssetProcSetupValue(FieldCaption("Expected Duration (Hours)"));
                end;
            end;
        }
        field(14;"Expected Downtime (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expected Downtime (Hours)';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Expected Downtime (Hours)" <> xRec."Expected Downtime (Hours)") then begin
                  if (CurrFieldNo = FieldNo("Expected Downtime (Hours)")) then
                    UpdateDefaultAssetProcSetupValue(FieldCaption("Expected Downtime (Hours)"));
                end;
            end;
        }
        field(15;"Schedule Lead Time (Days)";Integer)
        {
            Caption = 'Schedule Lead Time (Days)';
            DataClassification = CustomerContent;
            MaxValue = 90;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Schedule Lead Time (Days)" <> xRec."Schedule Lead Time (Days)") then begin
                  if ("Schedule Lead Time (Days)" <> 0) then
                    if ("Trigger Method" = "Trigger Method"::Manual) then
                      FieldError("Trigger Method");
                  if (CurrFieldNo = FieldNo("Schedule Lead Time (Days)")) then
                    UpdateDefaultAssetProcSetupValue(FieldCaption("Schedule Lead Time (Days)"));
                end;
            end;
        }
        field(16;"Usage Schedule-Ahead Tolerance";Decimal)
        {
            Caption = 'Usage Schedule-Ahead Tolerance';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Usage Schedule-Ahead Tolerance" <> xRec."Usage Schedule-Ahead Tolerance") then begin
                  if ("Usage Schedule-Ahead Tolerance" <> 0) then
                    if not ("Trigger Method" in ["Trigger Method"::"Usage (Recurring)","Trigger Method"::"Fixed Usage by Asset"]) then
                      FieldError("Trigger Method");
                  if (CurrFieldNo = FieldNo("Usage Schedule-Ahead Tolerance")) then
                    UpdateDefaultAssetProcSetupValue(FieldCaption("Usage Schedule-Ahead Tolerance"));
                end;
            end;
        }
        field(20;"Trigger Method";Option)
        {
            Caption = 'Trigger Method';
            OptionCaption = 'Manual,Calendar (Recurring),Fixed Date by Asset,Usage (Recurring),Fixed Usage by Asset';
            OptionMembers = Manual,"Calendar (Recurring)","Fixed Date by Asset","Usage (Recurring)","Fixed Usage by Asset";

            trigger OnValidate()
            begin
                if ("Trigger Method" <> xRec."Trigger Method") then begin
                  TestOnFieldValidate(FieldCaption("Trigger Method"));
                  MaintTaskMgt.InitializeMasterMaintTaskTriggerFields(Rec);
                end;
            end;
        }
        field(21;"Trigger Description";Text[250])
        {
            Caption = 'Trigger Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25;"Recurring Trigger Calc. Method";Option)
        {
            Caption = 'Recurring Trigger Calc. Method';
            OptionCaption = ' ,Fixed Schedule,Last Completion';
            OptionMembers = " ","Fixed Schedule","Last Completion";

            trigger OnValidate()
            begin
                if ("Recurring Trigger Calc. Method" <> xRec."Recurring Trigger Calc. Method") then
                  TestOnFieldValidate(FieldCaption("Recurring Trigger Calc. Method"));

                if ("Trigger Method" in ["Trigger Method"::"Calendar (Recurring)","Trigger Method"::"Usage (Recurring)"]) then begin
                  if "Recurring Trigger Calc. Method" = "Recurring Trigger Calc. Method"::" " then
                    Error(Text002,
                      FieldCaption("Recurring Trigger Calc. Method"),FieldCaption("Trigger Method"),"Trigger Method");
                end else
                  if "Recurring Trigger Calc. Method" <> "Recurring Trigger Calc. Method"::" " then
                    Error(Text001,
                      FieldCaption("Recurring Trigger Calc. Method"),FieldCaption("Trigger Method"),"Trigger Method");
            end;
        }
        field(100;Budget;Boolean)
        {
            CalcFormula = Exist("MCH Maint. Task Budget Line" WHERE ("Task Code"=FIELD(Code)));
            Caption = 'Budget';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"No. of Asset Maint. Tasks";Integer)
        {
            CalcFormula = Count("MCH Asset Maintenance Task" WHERE ("Task Code"=FIELD(Code)));
            Caption = 'No. of Asset Maint. Tasks';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"Budget Type Filter";Option)
        {
            Caption = 'Budget Type Filter';
            Editable = false;
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(103;"Budgeted Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("MCH Maint. Task Budget Line"."Cost Amount" WHERE ("Task Code"=FIELD(Code),
                                                                                 Type=FIELD("Budget Type Filter")));
            Caption = 'Budgeted Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104;"Budgeted Hours";Decimal)
        {
            CalcFormula = Sum("MCH Maint. Task Budget Line".Hours WHERE ("Task Code"=FIELD(Code),
                                                                         Type=FIELD("Budget Type Filter")));
            Caption = 'Budgeted Hours';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(119;"In-Use by Assets";Boolean)
        {
            CalcFormula = Exist("MCH Asset Maintenance Task" WHERE ("Task Code"=FIELD(Code)));
            Caption = 'In-Use by Assets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"In-Use on Work Order Line";Boolean)
        {
            CalcFormula = Exist("MCH Work Order Line" WHERE ("Task Code"=FIELD(Code)));
            Caption = 'In-Use on Work Order Line';
            Editable = false;
            FieldClass = FlowField;
        }
        field(121;"No. of Request WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Request),
                                                             "Task Code"=FIELD(Code)));
            Caption = 'No. of Request WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(122;"No. of Planned WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Planned),
                                                             "Task Code"=FIELD(Code)));
            Caption = 'No. of Planned WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(123;"No. of Released WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Released),
                                                             "Task Code"=FIELD(Code)));
            Caption = 'No. of Released WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(124;"No. of Finished WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Finished),
                                                             "Task Code"=FIELD(Code)));
            Caption = 'No. of Finished WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(125;"No. of Planning Wksh. Lines";Integer)
        {
            CalcFormula = Count("MCH AM Planning Wksh. Line" WHERE ("Task Code"=FIELD(Code)));
            Caption = 'No. of Planning Wksh. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(126;"Ongoing Work Orders";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH Work Order Line" WHERE (Status=FILTER(Request|Planned|Released),
                                                             "Task Code"=FIELD(Code)));
            Caption = 'Ongoing Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(127;"Ongoing Planning Worksheet";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH AM Planning Wksh. Line" WHERE ("Task Code"=FIELD(Code)));
            Caption = 'Ongoing Planning Worksheet';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130;"No. of Work Instructions";Integer)
        {
            CalcFormula = Count("MCH Work Instruction Setup" WHERE ("Table Name"=CONST("Maint. Task"),
                                                                    Code=FIELD(Code)));
            Caption = 'No. of Work Instructions';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                ShowAssignedWorkInstructions;
            end;
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
            CalcFormula = Count("MCH AM Document Attachment" WHERE ("Table ID"=CONST(74059),
                                                                    "No."=FIELD(Code)));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
            InitValue = 0;

            trigger OnLookup()
            begin
                Rec.ShowDocumentAttachments;
            end;
        }
        field(400;"Calendar Recurrence Type";Option)
        {
            BlankZero = true;
            Caption = 'Calendar Recurrence Type';
            DataClassification = CustomerContent;
            OptionCaption = ',Daily,Weekly,Monthly,Yearly';
            OptionMembers = " ",Daily,Weekly,Monthly,Yearly;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Calendar Recurrence Type"));
            end;
        }
        field(410;"Cal. Type of Day";Option)
        {
            BlankZero = true;
            Caption = 'Type of Day';
            DataClassification = CustomerContent;
            OptionCaption = ',Day,,,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Day,"Working Day","Nonworking Day",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;

            trigger OnValidate()
            begin
                // NOTE:
                // Options 'Working Day,Nonworking Day' are reserved for future implementation of Schedule Calandar/s.
                // Values are not present in OptionCaption string.

                TestOnFieldValidate(FieldCaption("Cal. Type of Day"));
            end;
        }
        field(411;"Cal. Which Day in Month";Option)
        {
            BlankZero = true;
            Caption = 'Which Day in Month';
            DataClassification = CustomerContent;
            OptionCaption = ',First,Second,Third,Fourth,Last';
            OptionMembers = " ",First,Second,Third,Fourth,Last;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Which Day in Month"));
            end;
        }
        field(420;"Cal. Daily Recur Every";Integer)
        {
            BlankZero = true;
            Caption = 'Recur every (Days)';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Daily Recur Every"));
                MaintTaskMgt.CheckCalendarRecurEveryValue(Rec,FieldCaption("Cal. Daily Recur Every"),"Cal. Daily Recur Every",CurrFieldNo=0);
            end;
        }
        field(421;"Cal. Daily Type of Day";Option)
        {
            BlankZero = true;
            Caption = 'Type of Day';
            DataClassification = CustomerContent;
            OptionCaption = ',Day';
            OptionMembers = " ",Day,"Working Day","Nonworking Day";

            trigger OnValidate()
            begin
                // NOTE:
                // OptionString = ' ,Day,Working Day,Nonworking Day'
                // Only 'Day' is currently enabled.
                // 'Working Day,Nonworking Day' options are reserved for future implementation of Schedule Calandar/s.

                TestOnFieldValidate(FieldCaption("Cal. Daily Type of Day"));
            end;
        }
        field(430;"Cal. Weekly Recur Every";Integer)
        {
            BlankZero = true;
            Caption = 'Recur every (Weeks)';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly Recur Every"));
                MaintTaskMgt.CheckCalendarRecurEveryValue(Rec,FieldCaption("Cal. Weekly Recur Every"),"Cal. Weekly Recur Every",CurrFieldNo=0);
            end;
        }
        field(431;"Cal. Weekly on Monday";Boolean)
        {
            BlankZero = true;
            Caption = 'Monday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Monday"));
            end;
        }
        field(432;"Cal. Weekly on Tuesday";Boolean)
        {
            BlankZero = true;
            Caption = 'Tuesday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Tuesday"));
            end;
        }
        field(433;"Cal. Weekly on Wednesday";Boolean)
        {
            BlankZero = true;
            Caption = 'Wednesday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Wednesday"));
            end;
        }
        field(434;"Cal. Weekly on Thursday";Boolean)
        {
            BlankZero = true;
            Caption = 'Thursday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Thursday"));
            end;
        }
        field(435;"Cal. Weekly on Friday";Boolean)
        {
            BlankZero = true;
            Caption = 'Friday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Friday"));
            end;
        }
        field(436;"Cal. Weekly on Saturday";Boolean)
        {
            BlankZero = true;
            Caption = 'Saturday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Saturday"));
            end;
        }
        field(437;"Cal. Weekly on Sunday";Boolean)
        {
            BlankZero = true;
            Caption = 'Sunday';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Weekly on Sunday"));
            end;
        }
        field(440;"Cal. Monthly Pattern";Option)
        {
            BlankZero = true;
            Caption = 'Monthly Pattern';
            DataClassification = CustomerContent;
            OptionCaption = ',Recurring Day of Month,Fixed Day of Month,Relative Day of Month';
            OptionMembers = " ","Recurring Day of Month","Fixed Day of Month","Relative Day of Month";

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Monthly Pattern"));
            end;
        }
        field(441;"Cal. Monthly Recur Every";Integer)
        {
            BlankZero = true;
            Caption = 'Recur every (Months)';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Monthly Recur Every"));
                MaintTaskMgt.CheckCalendarRecurEveryValue(Rec,FieldCaption("Cal. Monthly Recur Every"),"Cal. Monthly Recur Every",CurrFieldNo=0);
            end;
        }
        field(442;"Cal. Monthly Fixed Day No.";Integer)
        {
            BlankZero = true;
            Caption = 'Day No. of Month';
            DataClassification = CustomerContent;
            MaxValue = 31;
            MinValue = 1;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Monthly Fixed Day No."));
            end;
        }
        field(450;"Cal. Yearly Recur Every";Integer)
        {
            BlankZero = true;
            Caption = 'Recur every (Years)';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Yearly Recur Every"));
                MaintTaskMgt.CheckCalendarRecurEveryValue(Rec,FieldCaption("Cal. Yearly Recur Every"),"Cal. Yearly Recur Every",CurrFieldNo=0);
            end;
        }
        field(451;"Cal. Yearly Month Name";Option)
        {
            BlankZero = true;
            Caption = 'Month';
            DataClassification = CustomerContent;
            OptionCaption = ',January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Yearly Month Name"));
            end;
        }
        field(452;"Cal. Yearly Pattern";Option)
        {
            BlankZero = true;
            Caption = 'Yearly Pattern';
            DataClassification = CustomerContent;
            OptionCaption = ',Recurring Day of Month,Fixed Day of Month,Relative Day of Month';
            OptionMembers = " ","Recurring Day of Month","Fixed Day of Month","Relative Day of Month";

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Yearly Pattern"));
            end;
        }
        field(453;"Cal. Yearly Mth. Fixed Day No.";Integer)
        {
            BlankZero = true;
            Caption = 'Day No. of Month';
            DataClassification = CustomerContent;
            MaxValue = 31;
            MinValue = 1;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Cal. Yearly Mth. Fixed Day No."));
            end;
        }
        field(500;"Usage - Recur Every";Decimal)
        {
            BlankZero = true;
            Caption = 'Recur Every (Usage Units)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestOnFieldValidate(FieldCaption("Usage - Recur Every"));
            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
        key(Key2;"Trigger Method")
        {
        }
        key(Key3;"Scheduling Work Order Type")
        {
        }
        key(Key4;"Category Code")
        {
        }
        key(Key5;Status)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Description,Status,"Trigger Method","Category Code")
        {
        }
    }

    trigger OnDelete()
    begin
        AssetMaintTask.Reset;
        AssetMaintTask.SetCurrentKey("Task Code");
        AssetMaintTask.SetRange("Task Code",Code);
        if not AssetMaintTask.IsEmpty then
          Error(Text007,TableCaption,Code);

        AMLedgEntry.Reset;
        AMLedgEntry.SetCurrentKey("Asset No.","Maint. Task Code");
        AMLedgEntry.SetRange("Maint. Task Code",Code);
        if not AMLedgEntry.IsEmpty then
          Error(Text008,TableCaption,Code);

        MaintTaskBudgetLine.Reset;
        MaintTaskBudgetLine.SetRange("Task Code",Code);
        MaintTaskBudgetLine.DeleteAll(true);

        WorkInstructSetup.Reset;
        WorkInstructSetup.SetRange("Table Name",WorkInstructSetup."Table Name"::"Maint. Task");
        WorkInstructSetup.SetRange(Code,Code);
        WorkInstructSetup.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        AMSetup.Get ;
        if Code = '' then begin
          AMSetup.TestField("Maintenance Task Nos.");
          NoSeriesMgt.InitSeries(AMSetup."Maintenance Task Nos.",xRec."No. Series",0D,Code,"No. Series");
        end;
        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        SetLastModified;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        MaintProcedure: Record "MCH Master Maintenance Task";
        MaintTaskBudgetLine: Record "MCH Maint. Task Budget Line";
        WorkInstructSetup: Record "MCH Work Instruction Setup";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        Text001: Label '%1 cannot be specified when %2 is %3.';
        Text002: Label '%1 must be specified when %2 is %3.';
        Text004: Label 'Do you want to also update %1 for all assets using %2 %3 ?';
        MaintTaskMgt: Codeunit "MCH Maint. Task Mgt.";
        Text005: Label '%1 cannot be changed because %2 %3 is used on one or more work order line.';
        Text006: Label '%1 cannot be changed because %2 %3 is used for one or more asset.';
        Text007: Label '%1 %2 cannot be deleted because it is used by one or more asset maintenance tasks.';
        Text008: Label '%1 %2 cannot be deleted because it is used in one or more maintenance ledger entries.';
        StatusSetupTriggerDescrTxt: Label 'Task is being Setup...';


    procedure AssistEdit(OldMaintProcedure: Record "MCH Master Maintenance Task"): Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with MaintProcedure do begin
          MaintProcedure := Rec;
          AMSetup.Get;
          AMSetup.TestField("Maintenance Task Nos.");
          if NoSeriesMgt.SelectSeries(AMSetup."Maintenance Task Nos.",OldMaintProcedure."No. Series","No. Series") then begin
            NoSeriesMgt.SetSeries(Code);
            Rec := MaintProcedure;
            exit(true);
          end;
        end;
    end;


    procedure ShowCard()
    begin
        if Code = '' then
          exit;
        PAGE.Run(PAGE::"MCH Master Maint. Task Card",Rec);
    end;


    procedure ShowDocumentAttachments()
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
        AMDocAttachDetails: Page "MCH AM Doc.Attach. Details";
    begin
        if (Code = '') then
          exit;
        AMDocumentAttachment.FilterGroup(4);
        AMDocumentAttachment.SetRange("Table ID",DATABASE::"MCH Master Maintenance Task");
        AMDocumentAttachment.SetRange("No.",Code);
        AMDocumentAttachment.FilterGroup(0);
        AMDocAttachDetails.SetTableView(AMDocumentAttachment);
        AMDocAttachDetails.SetCaption(StrSubstNo('%1 - %2',TableCaption,Code));
        AMDocAttachDetails.RunModal;
    end;


    procedure ShowAssignedWorkInstructions()
    var
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
        AssignedWorkInstrList: Page "MCH Assigned Work Instr. List";
    begin
        if Code = '' then
          exit;
        WorkInstructionSetup.FilterGroup(2);
        WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::"Maint. Task");
        WorkInstructionSetup.SetRange(Code,Code);
        WorkInstructionSetup.FilterGroup(0);
        WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::"Maint. Task");
        WorkInstructionSetup.SetRange(Code,Code);
        AssignedWorkInstrList.SetTableView(WorkInstructionSetup);
        AssignedWorkInstrList.Run;
    end;


    procedure ShowBudget()
    var
        MaintTaskBudgetLine: Record "MCH Maint. Task Budget Line";
        MaintTaskBudget: Page "MCH Maint. Task Budget";
    begin
        if (Code = '') then
          exit;
        MaintTaskBudgetLine.FilterGroup(2);
        MaintTaskBudgetLine.SetRange("Task Code",Code);
        MaintTaskBudgetLine.FilterGroup(0);
        MaintTaskBudget.SetTableView(MaintTaskBudgetLine);
        MaintTaskBudget.RunModal;
    end;


    procedure FindTriggerMethodDescription() TriggerMethodDescription: Text
    begin
        if (Code = '') then
          exit;
        if MaintTaskMgt.FindMasterMaintTaskTriggerDescription(Rec,TriggerMethodDescription) then ;
    end;

    local procedure UpdateDefaultAssetProcSetupValue(ChangedFieldCaption: Text)
    var
        DoModify: Boolean;
    begin
        CalcFields("No. of Asset Maint. Tasks");
        if "No. of Asset Maint. Tasks" > 0 then begin
          if not Confirm(Text004,true,ChangedFieldCaption,TableCaption,Code) then
            exit;
          AssetMaintTask.Reset;
          AssetMaintTask.SetCurrentKey("Task Code");
          AssetMaintTask.SetRange("Task Code",Code);
          AssetMaintTask.LockTable;
          AssetMaintTask.FindSet(true,false);
          repeat
            DoModify := false;
            case ChangedFieldCaption of
              FieldCaption("Expected Duration (Hours)"):
                DoModify := AssetMaintTask."Expected Duration (Hours)" <> "Expected Duration (Hours)";
              FieldCaption("Expected Downtime (Hours)"):
                DoModify := AssetMaintTask."Expected Downtime (Hours)" <> "Expected Downtime (Hours)";
              FieldCaption("Schedule Lead Time (Days)") :
                DoModify := AssetMaintTask."Schedule Lead Time (Days)" <> "Schedule Lead Time (Days)";
              FieldCaption("Usage Schedule-Ahead Tolerance") :
                DoModify := AssetMaintTask."Usage Schedule-Ahead Tolerance" <> "Usage Schedule-Ahead Tolerance";
            end;
            if DoModify then begin
              case ChangedFieldCaption of
                FieldCaption("Expected Duration (Hours)"):
                  AssetMaintTask.Validate("Expected Duration (Hours)","Expected Duration (Hours)");
                FieldCaption("Expected Downtime (Hours)"):
                  AssetMaintTask.Validate("Expected Downtime (Hours)","Expected Downtime (Hours)");
                FieldCaption("Schedule Lead Time (Days)") :
                  AssetMaintTask.Validate("Schedule Lead Time (Days)","Schedule Lead Time (Days)");
                FieldCaption("Usage Schedule-Ahead Tolerance") :
                  AssetMaintTask.Validate("Usage Schedule-Ahead Tolerance","Usage Schedule-Ahead Tolerance");
              end;
              AssetMaintTask.Modify(true);
            end;
          until AssetMaintTask.Next = 0;
        end;
    end;


    procedure TestOnFieldValidate(ChangedFieldCaption: Text)
    var
        UsedOnWorkOrder: Boolean;
        UsedByAssets: Boolean;
        CheckNoWorkOrder: Boolean;
        CheckNoAssets: Boolean;
    begin
        TestStatusSetup();
        UsedOnWorkOrder := IsUsedOnWorkOrder;
        UsedByAssets := IsUsedByAssets;
        if not (UsedByAssets or UsedOnWorkOrder) then
          exit;

        //$$$$$$$$$$$$$$$$$$
        exit;

        case ChangedFieldCaption of
          FieldCaption("Trigger Method"),
          FieldCaption("Calendar Recurrence Type"),
          FieldCaption("Cal. Type of Day"),
          FieldCaption("Cal. Which Day in Month"),
          FieldCaption("Cal. Daily Recur Every"),
          FieldCaption("Cal. Daily Type of Day"),
          FieldCaption("Cal. Weekly Recur Every"),
          FieldCaption("Cal. Weekly on Monday"),
          FieldCaption("Cal. Weekly on Tuesday"),
          FieldCaption("Cal. Weekly on Wednesday"),
          FieldCaption("Cal. Weekly on Thursday"),
          FieldCaption("Cal. Weekly on Friday"),
          FieldCaption("Cal. Weekly on Saturday"),
          FieldCaption("Cal. Weekly on Sunday"),
          FieldCaption("Cal. Monthly Pattern"),
          FieldCaption("Cal. Monthly Recur Every"),
          FieldCaption("Cal. Monthly Fixed Day No."),
          FieldCaption("Cal. Yearly Recur Every"),
          FieldCaption("Cal. Yearly Month Name"),
          FieldCaption("Cal. Yearly Pattern"),
          FieldCaption("Cal. Yearly Mth. Fixed Day No."),
          FieldCaption("Usage - Recur Every"):
            begin
              CheckNoAssets := true;
              CheckNoWorkOrder := true;
            end;
          FieldCaption("Recurring Trigger Calc. Method"):
            begin
              CheckNoWorkOrder := true;
            end;
          else
            exit;
        end;

        if UsedOnWorkOrder and CheckNoWorkOrder then
          Error(Text005,ChangedFieldCaption,TableCaption,Code);
        if UsedByAssets and CheckNoAssets then
          Error(Text006,ChangedFieldCaption,TableCaption,Code);
    end;


    procedure TestStatusSetup()
    begin
        TestField(Status,Status::Setup);
    end;


    procedure GetStatusStyleTxt() StyleTxt: Text
    begin
        case Status of
          Status::Setup : exit('Strong');
          Status::"On Hold" : exit('AttentionAccent');
          Status::Active : exit('');
          Status::Blocked : exit('Unfavorable');
        end;
    end;


    procedure SetStatus(NewStatus: Option;ShowConfirmationDialog: Boolean)
    begin
        if (NewStatus = Status) then
          exit;
        LockTable;
        Get(Code);

        case NewStatus of
          Status::Setup:
            begin
              "Trigger Description" := StatusSetupTriggerDescrTxt;
            end;
          Status::"On Hold",
          Status::Active:
            begin
              TestField(Description);
              MaintTaskMgt.CheckMasterTaskSetup(Rec);
              "Trigger Description" := CopyStr(FindTriggerMethodDescription,1,MaxStrLen("Trigger Description"));
            end;
          Status::Blocked:
            begin
              "Trigger Description" := CopyStr(FindTriggerMethodDescription,1,MaxStrLen("Trigger Description"));
            end;
          else
            exit;
        end;

        Status := NewStatus;
        Modify(true);
    end;

    local procedure SetLastModified()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;


    procedure IsUsedOnWorkOrder() IsInUse: Boolean
    begin
        if (Code = '') then
          exit(false);
        CalcFields("In-Use on Work Order Line");
        exit("In-Use on Work Order Line");
    end;


    procedure IsUsedByAssets() IsInUse: Boolean
    begin
        if (Code = '') then
          exit(false);
        CalcFields("In-Use by Assets");
        exit("In-Use by Assets");
    end;
}

