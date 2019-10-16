table 74042 "MCH Work Order Header"
{
    Caption = 'Work Order';
    DataCaptionFields = Status, "No.", Description;
    DrillDownPageID = "MCH Work Order List";
    LookupPageID = "MCH Work Order List";

    fields
    {
        field(1; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "MCH Work Order Header"."No." WHERE(Status = FIELD(Status));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    AMSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(20; "Work Order Type"; Code[20])
        {
            Caption = 'Work Order Type';
            TableRelation = "MCH Work Order Type";

            trigger OnValidate()
            var
                WorkOrderType: Record "MCH Work Order Type";
                OldDimSetID: Integer;
            begin
                CheckAndErrorIfStatusFinished;
                if ("Work Order Type" <> '') then begin
                    WorkOrderType.Get("Work Order Type");
                    WorkOrderType.TestField(Blocked, false);
                end;

                if ("Work Order Type" <> xRec."Work Order Type") then begin
                    if ("Work Order Type" <> '') then begin
                        if (WorkOrderType."Def. Work Order Priority" > WorkOrderType."Def. Work Order Priority"::" ") then
                            Priority := WorkOrderType."Def. Work Order Priority" - 1;
                    end else begin
                        AMSetup.Get;
                        Priority := AMSetup."Def. Work Order Priority";
                    end;
                end;

                CreateDim(
                  DATABASE::"MCH Work Order Type", "Work Order Type",
                  DATABASE::"MCH Maintenance Location", "Maint. Location Code",
                  false);

                if ("Work Order Type" <> xRec."Work Order Type") or (Priority <> xRec.Priority) then begin
                    if UpdateDuplicateLineFields(Rec) then
                        Modify(true);
                end;
            end;
        }
        field(21; "Progress Status Code"; Code[20])
        {
            Caption = 'Progress Status Code';
            TableRelation = IF (Status = CONST(Request)) "MCH Work Order Progress Status".Code WHERE("Allow on WO Request" = CONST(true),
                                                                                                    Blocked = CONST(false))
            ELSE
            IF (Status = CONST(Planned)) "MCH Work Order Progress Status".Code WHERE("Allow on Planned WO" = CONST(true),
                                                                                                                                                                                 Blocked = CONST(false))
            ELSE
            IF (Status = CONST(Released)) "MCH Work Order Progress Status".Code WHERE("Allow on Released WO" = CONST(true),
                                                                                                                                                                                                                                                               Blocked = CONST(false))
            ELSE
            IF (Status = CONST(Finished)) "MCH Work Order Progress Status".Code;

            trigger OnValidate()
            begin
                if ("Progress Status Code" <> '') then
                    AMFunctions.CheckAllowedWOProgressStatus(Rec);

                if ("Progress Status Code" <> xRec."Progress Status Code") then begin
                    if UpdateDuplicateLineFields(Rec) then
                        Modify(true);
                end;
            end;
        }
        field(22; Priority; Option)
        {
            Caption = 'Priority';
            OptionCaption = 'Very High,High,Medium,Low,Very Low';
            OptionMembers = "Very High",High,Medium,Low,"Very Low";

            trigger OnValidate()
            begin
                if (Priority <> xRec.Priority) then begin
                    if UpdateDuplicateLineFields(Rec) then
                        Modify(true);
                end;
            end;
        }
        field(23; "Maint. Location Code"; Code[20])
        {
            Caption = 'Maint. Location Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Maintenance Location";

            trigger OnValidate()
            begin
                CheckAndErrorIfStatusFinished;

                CreateDim(
                  DATABASE::"MCH Maintenance Location", "Maint. Location Code",
                  DATABASE::"MCH Work Order Type", "Work Order Type",
                  false);

                if ("Maint. Location Code" <> xRec."Maint. Location Code") then begin
                    if UpdateDuplicateLineFields(Rec) then
                        Modify(true);
                end;
            end;
        }
        field(24; "Responsibility Group Code"; Code[20])
        {
            Caption = 'Responsibility Group Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Asset Responsibility Group";

            trigger OnValidate()
            var
                AssetResponsibilityGroup: Record "MCH Asset Responsibility Group";
            begin
                CheckAndErrorIfStatusFinished;

                if ("Responsibility Group Code" <> xRec."Responsibility Group Code") then begin
                    if AssetWorkOrderLinesExist then begin
                        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
                            if not UpdatingFromLine then
                                Error(Text004, FieldCaption("Responsibility Group Code"), TableCaption, "No.");
                        end else begin
                            if UpdateDuplicateLineFields(Rec) then
                                Modify(true);
                        end;
                    end else begin
                        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
                            if ("Responsibility Group Code" = '') then
                                Error(Text005, FieldCaption("Responsibility Group Code"), TableCaption, "No.")
                            else begin
                                if (xRec."Responsibility Group Code" <> '') then begin
                                    if not MaintUserMgt.UserHasAccessToRespGroup(UserId, xRec."Responsibility Group Code") then
                                        Error(Text006, FieldCaption("Responsibility Group Code"), xRec."Responsibility Group Code");
                                end;
                                if not MaintUserMgt.UserHasAccessToRespGroup(UserId, "Responsibility Group Code") then
                                    Error(Text006, FieldCaption("Responsibility Group Code"), "Responsibility Group Code");
                            end;
                        end;
                    end;

                    if ("Person Responsible" <> '') then begin
                        if not MaintUserMgt.UserHasAccessToRespGroup("Person Responsible", "Responsibility Group Code") then
                            "Person Responsible" := '';
                    end;
                    if ("Person Responsible" = '') and ("Responsibility Group Code" <> '') then begin
                        AssetResponsibilityGroup.Get("Responsibility Group Code");
                        if (AssetResponsibilityGroup."Responsible User ID" <> '') then begin
                            if MaintUserMgt.UserHasAccessToRespGroup(AssetResponsibilityGroup."Responsible User ID", "Responsibility Group Code") then
                                "Person Responsible" := AssetResponsibilityGroup."Responsible User ID";
                        end;
                    end;
                    if ("Assigned User ID" <> '') then begin
                        if not MaintUserMgt.UserHasAccessToRespGroup("Assigned User ID", "Responsibility Group Code") then
                            "Assigned User ID" := '';
                    end;
                end;
            end;
        }
        field(28; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            begin
                CheckDates(FieldCaption("Order Date"));

                if ("Order Date" <> xRec."Order Date") then begin
                    if UpdateDuplicateLineFields(Rec) then
                        Modify(true);
                end;
            end;
        }
        field(29; "Expected Ending Date"; Date)
        {
            Caption = 'Expected Ending Date';
        }
        field(30; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                CheckDates(FieldCaption("Starting Date"));
                if ("Starting Date" <> xRec."Starting Date") then begin
                    if UpdateLineDate(FieldCaption("Starting Date")) then
                        Modify(true);
                end;
            end;
        }
        field(33; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                CheckDates(FieldCaption("Ending Date"));
                if ("Ending Date" <> xRec."Ending Date") then begin
                    if UpdateLineDate(FieldCaption("Ending Date")) then
                        Modify(true);
                end;
            end;
        }
        field(34; "Requested Starting Date"; Date)
        {
            Caption = 'Requested Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("Requested Starting Date" <> xRec."Requested Starting Date") then begin
                    if UpdateDuplicateLineFields(Rec) then
                        Modify(true);
                end;
            end;
        }
        field(40; Comment; Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist ("MCH Work Order Comment Line" WHERE("Table Name" = CONST("Work Order"),
                                                                     "Table Subtype" = FIELD(Status),
                                                                     "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "Asset No."; Code[20])
        {
            CalcFormula = Min ("MCH Work Order Line"."Asset No." WHERE(Status = FIELD(Status),
                                                                       "Work Order No." = FIELD("No.")));
            Caption = 'Asset No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "MCH Maintenance Asset";
            ValidateTableRelation = false;
        }
        field(46; "Task Code"; Code[20])
        {
            CalcFormula = Min ("MCH Work Order Line"."Task Code" WHERE(Status = FIELD(Status),
                                                                       "Work Order No." = FIELD("No.")));
            Caption = 'Task Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Person Responsible"; Code[50])
        {
            Caption = 'Person Responsible';
            TableRelation = "MCH Asset Maintenance User";

            trigger OnValidate()
            begin
                if ("Person Responsible" <> '') then begin
                    if not MaintUserMgt.UserHasAccessToRespGroup("Person Responsible", "Responsibility Group Code") then
                        Error(Text009, FieldCaption("Person Responsible"), "Person Responsible", FieldCaption("Responsibility Group Code"), "Responsibility Group Code");
                end;
            end;
        }
        field(52; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "MCH Asset Maintenance User";

            trigger OnValidate()
            begin
                if ("Assigned User ID" <> '') then begin
                    if not MaintUserMgt.UserHasAccessToRespGroup("Assigned User ID", "Responsibility Group Code") then
                        Error(Text009, FieldCaption("Assigned User ID"), "Assigned User ID", FieldCaption("Responsibility Group Code"), "Responsibility Group Code");
                end;
            end;
        }
        field(60; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(61; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(71; "No. of Purch. Order Lines"; Integer)
        {
            CalcFormula = Count ("Purchase Line" WHERE("Document Type" = CONST(Order),
                                                       "MCH Work Order No." = FIELD("No.")));
            Caption = 'No. of Purch. Order Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "No. of Maint. Tmsh. Jnl. Lines"; Integer)
        {
            CalcFormula = Count ("MCH Maint. Journal Line" WHERE("Entry Type" = CONST(Timesheet),
                                                                 "Work Order No." = FIELD("No.")));
            Caption = 'No. of Maint. Timesheet Jnl. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "No. of Maint. Invt. Jnl. Lines"; Integer)
        {
            CalcFormula = Count ("MCH Maint. Journal Line" WHERE("Entry Type" = FILTER(Issue | Return),
                                                                 "Work Order No." = FIELD("No.")));
            Caption = 'No. of Maint. Invt. Jnl. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "No. of Work Order Lines"; Integer)
        {
            CalcFormula = Count ("MCH Work Order Line" WHERE(Status = FIELD(Status),
                                                             "Work Order No." = FIELD("No.")));
            Caption = 'No. of Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(90; "Completion Date"; Date)
        {
            Caption = 'Completion Date';

            trigger OnValidate()
            begin
                CheckDates(FieldCaption("Completion Date"));
                if ("Completion Date" <> xRec."Completion Date") then begin
                    if UpdateLineDate(FieldCaption("Completion Date")) then
                        Modify(true);
                end;
            end;
        }
        field(97; "Budgeted Hours"; Decimal)
        {
            CalcFormula = Sum ("MCH Work Order Budget Line".Hours WHERE(Status = FIELD(Status),
                                                                        "Work Order No." = FIELD("No."),
                                                                        Type = FIELD("Type Filter")));
            Caption = 'Budgeted Hours';
            DecimalPlaces = 2 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "Budgeted Quantity"; Decimal)
        {
            CalcFormula = Sum ("MCH Work Order Budget Line"."Quantity (Base)" WHERE(Status = FIELD(Status),
                                                                                    "Work Order No." = FIELD("No."),
                                                                                    Type = FIELD("Type Filter")));
            Caption = 'Budgeted Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Actual Quantity"; Decimal)
        {
            CalcFormula = Sum ("MCH Asset Maint. Ledger Entry"."Qty. Invoiced (Base)" WHERE("Work Order No." = FIELD("No."),
                                                                                            Type = FIELD("Type Filter"),
                                                                                            "Posting Date" = FIELD("Date Filter")));
            Caption = 'Actual Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Type Filter"; Option)
        {
            Caption = 'Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(101; "Budgeted Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("MCH Work Order Budget Line"."Cost Amount" WHERE(Status = FIELD(Status),
                                                                                "Work Order No." = FIELD("No."),
                                                                                Type = FIELD("Type Filter")));
            Caption = 'Budgeted Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Actual Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("MCH Asset Maint. Ledger Entry"."Cost Amount" WHERE("Work Order No." = FIELD("No."),
                                                                                   Type = FIELD("Type Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter")));
            Caption = 'Actual Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Resource Filter"; Code[20])
        {
            Caption = 'Resource Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(105; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(107; "Actual Hours"; Decimal)
        {
            CalcFormula = Sum ("MCH Asset Maint. Ledger Entry".Hours WHERE("Work Order No." = FIELD("No."),
                                                                           Type = FIELD("Type Filter"),
                                                                           "Posting Date" = FIELD("Date Filter")));
            Caption = 'Actual Hours';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Last Posting Date"; Date)
        {
            CalcFormula = Min ("MCH Asset Maint. Ledger Entry"."Posting Date" WHERE("Work Order No." = FIELD("No.")));
            Caption = 'Last Posting Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(121; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(122; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(123; "Created Time"; Time)
        {
            Caption = 'Created Time';
            Editable = false;
        }
        field(124; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(125; "Last Modified Date-Time"; DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(126; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(127; "Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
            Editable = false;
        }
        field(130; "Previous Status"; Option)
        {
            Caption = 'Previous Status';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(131; "Status Changed By"; Code[50])
        {
            Caption = 'Status Changed By';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(132; "Status Changed Date-Time"; DateTime)
        {
            Caption = 'Status Changed Date-Time';
            Editable = false;
        }
        field(200; "Work Description"; BLOB)
        {
            Caption = 'Work Description';
            DataClassification = CustomerContent;
        }
        field(300; "No. of Attachments"; Integer)
        {
            CalcFormula = Count ("MCH AM Document Attachment" WHERE("Table ID" = CONST(74042),
                                                                    "No." = FIELD("No."),
                                                                    "Document Status" = FIELD(Status)));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
            InitValue = 0;

            trigger OnLookup()
            begin
                Rec.ShowDocumentAttachments;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                CheckAndErrorIfStatusFinished;
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; Status, "No.")
        {
            Clustered = true;
        }
        key(Key2; "No.")
        {
            Unique = true;
        }
        key(Key3; Description)
        {
        }
        key(Key4; Priority, "Starting Date")
        {
        }
        key(Key5; "Starting Date")
        {
        }
        key(Key6; "Progress Status Code")
        {
        }
        key(Key7; "Work Order Type")
        {
        }
        key(Key8; "Responsibility Group Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Status, "Starting Date", "Progress Status Code", "Maint. Location Code", "Work Order Type", "Responsibility Group Code")
        {
        }
        fieldgroup(Brick; "Starting Date", "No.", "Progress Status Code", "Maint. Location Code", "Work Order Type")
        {
        }
    }

    trigger OnDelete()
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        PurchLine: Record "Purchase Line";
    begin
        CheckAndErrorIfStatusFinished;

        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
            if ("Responsibility Group Code" = '') or
               (not MaintUserMgt.UserHasAccessToRespGroup(UserId, "Responsibility Group Code"))
            then
                Error(Text011, TableCaption, "No.", FieldCaption("Responsibility Group Code"), "Responsibility Group Code");
        end;

        AMLedgEntry.Reset;
        AMLedgEntry.SetCurrentKey("Work Order No.", "Work Order Line No.");
        AMLedgEntry.SetRange("Work Order No.", "No.");
        if not AMLedgEntry.IsEmpty then
            Error(Text000, Status, TableCaption, "No.", AMLedgEntry.TableCaption);

        PurchLine.Reset;
        PurchLine.SetCurrentKey("MCH Work Order No.");
        PurchLine.SetRange("MCH Work Order No.", "No.");
        if not PurchLine.IsEmpty then
            Error(
             Text000,
             Status, TableCaption, "No.", PurchLine.TableCaption);

        DeleteRelations;
    end;

    trigger OnInsert()
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        AMSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Starting Date", "No.", "No. Series");
        end;

        WorkOrder.Reset;
        WorkOrder.SetCurrentKey("No.");
        WorkOrder.SetRange("No.", "No.");
        WorkOrder.LockTable;
        if WorkOrder.FindFirst then
            Error(Text001, Status, TableCaption, WorkOrder."No.", WorkOrder.Status, FieldCaption("No."));

        InitRecord;
        SetCreatedDateTimeUser;
    end;

    trigger OnModify()
    begin
        CheckAndErrorIfStatusFinished;
        SetLastModifiedDateTimeUser;
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        AMFunctions: Codeunit "MCH AM Functions";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'You cannot delete %1 %2 %3 because there exists at least one %4 associated with it.';
        Text001: Label '%1 %2 %3 cannot be created, because a %4 %2 %3 already exists with the same %5.';
        Text002: Label '%1 %2 has %3 = %4 and cannot be inserted, modified, or deleted.';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label '%1 cannot be changed because %2 %3 already has one or more asset lines.';
        Text005: Label 'You must specify a %1 for %2 %3. The field cannot be blank.';
        Text006: Label 'Your identification is not setup for %1 %2.';
        Text007: Label 'Do you want to change %1?';
        Text008: Label 'You must delete the existing work order lines before you can change %1.';
        Text009: Label '%1 %2 is not setup to process for %3 %4.';
        Text010: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        HideValidationDialog: Boolean;
        Text011: Label 'You cannot delete %1 %2 with %3 = %4.';
        Text012: Label 'cannot be after %1 (%2)';
        Text013: Label 'cannot be before %1 (%2)';
        UpdatingFromLine: Boolean;
        Text014: Label '%1 can only be changed on the %2 because different line dates are used for %3 %4.';

    local procedure DeleteRelations()
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
        WorkOrderLine: Record "MCH Work Order Line";
        WorkOrderCommentLine: Record "MCH Work Order Comment Line";
    begin
        WOBudgetLine.Reset;
        WOBudgetLine.SetCurrentKey(Status, "Work Order No.", "Work Order Line No.");
        WOBudgetLine.SetRange(Status, Status);
        WOBudgetLine.SetRange("Work Order No.", "No.");
        if not WOBudgetLine.IsEmpty then
            WOBudgetLine.DeleteAll(true);

        Clear(WorkOrderLine);
        WorkOrderLine.SetRange(Status, Status);
        WorkOrderLine.SetRange("Work Order No.", "No.");
        if WorkOrderLine.FindSet(true) then begin
            repeat
                WorkOrderLine.SetSuppresHeaderUpdate(true);
                WorkOrderLine.Delete(true);
            until WorkOrderLine.Next = 0;
        end;

        WorkOrderCommentLine.Reset;
        WorkOrderCommentLine.SetRange("Table Name", WorkOrderCommentLine."Table Name"::"Work Order");
        WorkOrderCommentLine.SetRange("Table Subtype", Status);
        WorkOrderCommentLine.SetRange("No.", "No.");
        if not WorkOrderCommentLine.IsEmpty then
            WorkOrderCommentLine.DeleteAll;
    end;

    local procedure InitRecord()
    var
        DefaultMaintLocationCode: Code[20];
        DefaultResponsibilityGroupCode: Code[20];
    begin
        AMSetup.Get;
        "Order Date" := WorkDate;
        if (Status <> Status::Request) then begin
            "Starting Date" := WorkDate;
            "Ending Date" := WorkDate;
            "Expected Ending Date" := "Ending Date";
        end;

        Priority := AMSetup."Def. Work Order Priority";
        "Progress Status Code" := AMFunctions.GetDefaultNewWOProgressStatus(Status);

        if (Status = Status::Request) and (AMSetup."Def. WO Type on Request" <> '') then
            Validate("Work Order Type", AMSetup."Def. WO Type on Request");

        DefaultMaintLocationCode := MaintUserMgt.GetDefaultMaintLocationCode;
        DefaultResponsibilityGroupCode := MaintUserMgt.GetDefaultAssetRespGroupCode;
        if (DefaultMaintLocationCode <> '') then
            Validate("Maint. Location Code", DefaultMaintLocationCode);
        if (DefaultResponsibilityGroupCode <> '') then
            Validate("Responsibility Group Code", DefaultResponsibilityGroupCode);
    end;

    local procedure TestNoSeries()
    begin
        AMSetup.Get;
        AMSetup.TestField("Work Order Nos.");
    end;


    procedure AssistEdit(OldWorkOrder: Record "MCH Work Order Header"): Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        with WorkOrder do begin
            WorkOrder := Rec;
            AMSetup.Get;
            TestNoSeries;
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldWorkOrder."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := WorkOrder;
                exit(true);
            end;
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        AMSetup.Get;
        exit(AMSetup."Work Order Nos.");
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; AskUpdateLineConfirmQuestion: Boolean)
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        CheckAndErrorIfStatusFinished;
        AMSetup.Get;
        AMSetup.TestField("Source Code");
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, TableID, No, AMSetup."Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and WorkOrderLinesExist then begin
            Modify;
            if not UpdatingFromLine then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID, AskUpdateLineConfirmQuestion);
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        CheckAndErrorIfStatusFinished;
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if ("No." <> '') or (OldDimSetID <> "Dimension Set ID") then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            if WorkOrderLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID, true);
        end;
    end;


    procedure ChangeWorkOrderStatus(var SelectedWorkOrder: Record "MCH Work Order Header")
    var
        ChangeWorkOrderStatusBatch: Report "MCH Change Work Order Status";
    begin
        ChangeWorkOrderStatusBatch.SetWorkOrder(SelectedWorkOrder);
        ChangeWorkOrderStatusBatch.RunModal;
    end;


    procedure SetSecurityFilterOnResponsibilityGroup(FilterGrpNo: Integer)
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
            FilterGroup(FilterGrpNo);
            SetFilter("Responsibility Group Code", MaintUserMgt.GetAssetRespGroupFilter);
            FilterGroup(0);
        end;
    end;


    procedure ShowCard()
    begin
        if "No." = '' then
            exit;
        case Status of
            Status::Request:
                PAGE.Run(PAGE::"MCH Work Order Request", Rec);
            Status::Planned:
                PAGE.Run(PAGE::"MCH Planned Work Order", Rec);
            Status::Released:
                PAGE.Run(PAGE::"MCH Released Work Order", Rec);
            Status::Finished:
                PAGE.Run(PAGE::"MCH Finished Work Order", Rec);
        end;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        if ("No." = '') then
            exit;
        if Status = Status::Finished then begin
            DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
        end else begin
            OldDimSetID := "Dimension Set ID";
            TestField("No.");
            "Dimension Set ID" :=
              DimMgt.EditDimensionSet(
                "Dimension Set ID", StrSubstNo('%1 %2 %3', Status, TableCaption, "No."),
                "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            if OldDimSetID <> "Dimension Set ID" then begin
                Modify;
                if WorkOrderLinesExist then
                    UpdateAllLineDim("Dimension Set ID", OldDimSetID, true);
            end;
        end;
    end;


    procedure ShowBudget()
    var
        WorkOrderLine: Record "MCH Work Order Line";
        WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
    begin
        if ("No." = '') then
            exit;
        WorkOrderLine.SetRange(Status, Status);
        WorkOrderLine.SetRange("Work Order No.", "No.");
        if not WorkOrderLine.FindSet then
            exit;
        if (WorkOrderLine.Next <> 0) then
            WorkOrderLine."Line No." := 0;
        WorkOrderBudgetLine.OpenBudgetPage(Status, "No.", WorkOrderLine."Line No.");
    end;


    procedure ShowStatistics()
    var
        WorkOrder: Record "MCH Work Order Header";
        RqstPlanWOStatistics: Page "MCH Rqst.-Plan. WO Statistics";
        ReleasedWOStatistics: Page "MCH Released WO Statistics";
        FinishedWOStatistics: Page "MCH Finished WO Statistics";
    begin
        if ("No." = '') then
            exit;
        WorkOrder := Rec;
        WorkOrder.SetRecFilter;
        CopyFilter("Date Filter", WorkOrder."Date Filter");
        case Status of
            Status::Request, Status::Planned:
                begin
                    RqstPlanWOStatistics.SetTableView(WorkOrder);
                    RqstPlanWOStatistics.Run;
                end;
            Status::Released:
                begin
                    ReleasedWOStatistics.SetTableView(WorkOrder);
                    ReleasedWOStatistics.Run;
                end;
            Status::Finished:
                begin
                    FinishedWOStatistics.SetTableView(WorkOrder);
                    FinishedWOStatistics.Run;
                end;
        end;
    end;


    procedure ShowWorkOrderCommentSheet()
    var
        WOCommentLine: Record "MCH Work Order Comment Line";
        WOCommentSheet: Page "MCH Work Order Comment Sheet";
    begin
        if "No." = '' then
            exit;
        WOCommentLine.FilterGroup(2);
        WOCommentLine.SetRange("Table Name", WOCommentLine."Table Name"::"Work Order");
        WOCommentLine.SetRange("Table Subtype", Status);
        WOCommentLine.SetRange("No.", "No.");
        WOCommentLine.FilterGroup(0);
        WOCommentSheet.SetTableView(WOCommentLine);
        if WOCommentLine.FindLast then
            WOCommentSheet.SetRecord(WOCommentLine);
        WOCommentSheet.RunModal;
    end;


    procedure ShowDocumentAttachments()
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
        AMDocAttachDetails: Page "MCH AM Doc.Attach. Details";
    begin
        if ("No." = '') then
            exit;
        AMDocumentAttachment.FilterGroup(4);
        AMDocumentAttachment.SetRange("Table ID", DATABASE::"MCH Work Order Header");
        AMDocumentAttachment.SetRange("Document Status", Status);
        AMDocumentAttachment.SetRange("No.", "No.");
        AMDocumentAttachment.FilterGroup(0);
        AMDocAttachDetails.SetTableView(AMDocumentAttachment);
        AMDocAttachDetails.SetCaption(StrSubstNo('%1 %2 - %3', Status, TableCaption, "No."));
        AMDocAttachDetails.RunModal;
    end;


    procedure WorkOrderLinesExist(): Boolean
    var
        WorkOrderLine2: Record "MCH Work Order Line";
    begin
        WorkOrderLine2.Reset;
        WorkOrderLine2.SetRange(Status, Status);
        WorkOrderLine2.SetRange("Work Order No.", "No.");
        exit(not WorkOrderLine2.IsEmpty);
    end;


    procedure AssetWorkOrderLinesExist(): Boolean
    var
        WorkOrderLine2: Record "MCH Work Order Line";
    begin
        WorkOrderLine2.Reset;
        WorkOrderLine2.SetRange(Status, Status);
        WorkOrderLine2.SetRange("Work Order No.", "No.");
        WorkOrderLine2.SetFilter("Asset No.", '<>%1', '');
        exit(not WorkOrderLine2.IsEmpty);
    end;


    procedure MultipleAssetWorkOrderLinesExist(): Boolean
    var
        WorkOrderLine2: Record "MCH Work Order Line";
    begin
        WorkOrderLine2.Reset;
        WorkOrderLine2.SetRange(Status, Status);
        WorkOrderLine2.SetRange("Work Order No.", "No.");
        WorkOrderLine2.SetFilter("Asset No.", '<>%1', '');
        exit(WorkOrderLine2.Count > 1);
    end;

    local procedure CheckDates(ChangedFieldCaption: Text[100])
    begin
        case ChangedFieldCaption of
            FieldCaption("Starting Date"):
                begin
                    if ("Starting Date" = 0D) then begin
                        TestField("Ending Date", 0D);
                        TestField("Completion Date", 0D);
                    end;
                end;
            FieldCaption("Ending Date"):
                begin
                    if ("Ending Date" <> 0D) then
                        TestField("Starting Date");
                end;
            FieldCaption("Completion Date"):
                begin
                    if ("Completion Date" <> 0D) then begin
                        TestField("Starting Date");
                    end;
                end;
        end;

        if (("Starting Date" <> 0D) and ("Order Date" > "Starting Date")) then
            FieldError("Starting Date",
              StrSubstNo(Text013, FieldCaption("Order Date"), "Order Date"));

        if (("Ending Date" <> 0D) and ("Starting Date" > "Ending Date")) then
            FieldError("Starting Date",
              StrSubstNo(Text012, FieldCaption("Ending Date"), "Ending Date"));

        if (("Starting Date" <> 0D) and ("Completion Date" <> 0D) and ("Starting Date" > "Completion Date")) then
            FieldError("Completion Date",
              StrSubstNo(Text013, FieldCaption("Starting Date"), "Starting Date"));
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer; AskConfirmQuestion: Boolean)
    var
        WorkOrderLine: Record "MCH Work Order Line";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if AskConfirmQuestion and (not UpdatingFromLine) and GuiAllowed then
            if not Confirm(Text010) then
                exit;
        WorkOrderLine.SetRange(Status, Status);
        WorkOrderLine.SetRange("Work Order No.", "No.");
        WorkOrderLine.LockTable;
        if WorkOrderLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(WorkOrderLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if WorkOrderLine."Dimension Set ID" <> NewDimSetID then begin
                    WorkOrderLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      WorkOrderLine."Dimension Set ID", WorkOrderLine."Shortcut Dimension 1 Code", WorkOrderLine."Shortcut Dimension 2 Code");
                    WorkOrderLine.Modify;
                end;
            until WorkOrderLine.Next = 0;
    end;


    procedure UpdateDuplicateLineFields(TheWorkOrder: Record "MCH Work Order Header") LineUpdated: Boolean
    var
        WorkOrderLine: Record "MCH Work Order Line";
        xWorkOrderLine: Record "MCH Work Order Line";
    begin
        if UpdatingFromLine then
            exit;
        WorkOrderLine.SetRange(Status, Status);
        WorkOrderLine.SetRange("Work Order No.", "No.");
        if WorkOrderLine.FindSet then begin
            WorkOrderLine.LockTable;
            repeat
                xWorkOrderLine := WorkOrderLine;
                WorkOrderLine.UpdateDuplicateFieldsFromHeader(TheWorkOrder, true);
                if Format(WorkOrderLine) <> Format(xWorkOrderLine) then begin
                    WorkOrderLine.Modify;
                    LineUpdated := true;
                end;
            until WorkOrderLine.Next = 0;
        end;
    end;

    local procedure UpdateLineDate(ChangedFieldCaption: Text) LineUpdated: Boolean
    var
        WorkOrderLine: Record "MCH Work Order Line";
        xWorkOrderLine: Record "MCH Work Order Line";
        DiffDatesOnLines: Boolean;
    begin
        if UpdatingFromLine then
            exit;
        WorkOrderLine.SetRange(Status, Status);
        WorkOrderLine.SetRange("Work Order No.", "No.");
        if WorkOrderLine.FindSet then begin
            WorkOrderLine.LockTable;
            xWorkOrderLine := WorkOrderLine;
            repeat
                case ChangedFieldCaption of
                    FieldCaption("Starting Date"):
                        DiffDatesOnLines := (WorkOrderLine."Starting Date" <> xWorkOrderLine."Starting Date");
                    FieldCaption("Ending Date"):
                        DiffDatesOnLines := (WorkOrderLine."Ending Date" <> xWorkOrderLine."Ending Date");
                    FieldCaption("Completion Date"):
                        DiffDatesOnLines := (WorkOrderLine."Completion Date" <> xWorkOrderLine."Completion Date");
                end;
                if DiffDatesOnLines then
                    Error(Text014, ChangedFieldCaption, WorkOrderLine.TableCaption, TableCaption, "No.");
                xWorkOrderLine := WorkOrderLine;
            until WorkOrderLine.Next = 0;

            WorkOrderLine.FindSet;
            repeat
                xWorkOrderLine := WorkOrderLine;
                case ChangedFieldCaption of
                    FieldCaption("Starting Date"):
                        if (WorkOrderLine."Starting Date" <> "Starting Date") then
                            WorkOrderLine.Validate("Starting Date", "Starting Date");
                    FieldCaption("Ending Date"):
                        if (WorkOrderLine."Ending Date" <> "Ending Date") then
                            WorkOrderLine.Validate("Ending Date", "Ending Date");
                    FieldCaption("Completion Date"):
                        if (WorkOrderLine."Completion Date" <> "Completion Date") then
                            WorkOrderLine.Validate("Completion Date", "Completion Date");
                end;
                if Format(WorkOrderLine) <> Format(xWorkOrderLine) then begin
                    WorkOrderLine.UpdateDatesOnBudgetLines;
                    WorkOrderLine.Modify;
                    LineUpdated := true;
                end;
            until WorkOrderLine.Next = 0;
        end;
    end;

    local procedure CheckAndErrorIfStatusFinished()
    begin
        if Status = Status::Finished then
            Error(Text002, TableCaption, "No.", FieldCaption(Status), Status);
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure SetUpdatingFromLine(NewUpdatingFromLine: Boolean)
    begin
        UpdatingFromLine := NewUpdatingFromLine;
    end;


    procedure GetPriorityStyleTxt() StyleTxt: Text
    begin
        case Priority of
            Priority::"Very High":
                exit('Strong');
            Priority::High:
                exit('StrongAccent');
            else
                exit('');
        end;
    end;


    procedure GetOverdueEndingDateStyleTxt() StyleTxt: Text
    begin
        case true of
            ("Ending Date" > WorkDate) or ("Ending Date" = 0D):
                exit('');
            ("Ending Date" = WorkDate):
                exit('StrongAccent');
            ("Ending Date" < WorkDate):
                exit('Unfavorable');
        end;
    end;


    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Work Description");
        if NewWorkDescription = '' then
            exit;
        "Work Description".CreateOutStream(OutStream, TEXTENCODING::Windows);
        OutStream.WriteText(NewWorkDescription);
        Modify(true);
    end;


    procedure GetWorkDescription() Text: Text
    begin
        CalcFields("Work Description");
        exit(GetWorkDescriptionWithCR);
    end;


    procedure GetWorkDescriptionWithCR() Content: Text
    var
        InStream: InStream;
        CR: Text[1];
        ContentLine: Text;
    begin
        if not "Work Description".HasValue then
            exit('');
        CR[1] := 10;
        "Work Description".CreateInStream(InStream, TEXTENCODING::Windows);
        InStream.ReadText(Content);
        while not InStream.EOS do begin
            InStream.ReadText(ContentLine);
            Content += CR + ContentLine;
        end;
    end;


    procedure SetCreatedDateTimeUser()
    begin
        "Created Date" := Today;
        "Created Time" := Time;
        "Created Date-Time" := CurrentDateTime;
        "Created By" := UserId;
    end;


    procedure SetLastModifiedDateTimeUser()
    begin
        "Last Date Modified" := Today;
        "Last Time Modified" := Time;
        "Last Modified Date-Time" := CurrentDateTime;
        "Last Modified By" := UserId;
    end;


    procedure PrintWorkOrder(ShowRequestPage: Boolean)
    var
        AMReportMgt: Codeunit "MCH AM Report Mgt.";
    begin
        AMReportMgt.PrintWorkOrder(Rec, ShowRequestPage);
    end;
}

