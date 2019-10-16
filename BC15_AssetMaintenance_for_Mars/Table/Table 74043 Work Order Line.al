table 74043 "MCH Work Order Line"
{
    Caption = 'Work Order Line';
    DataCaptionFields = "Work Order No.";
    DrillDownPageID = "MCH Work Order Lines";
    LookupPageID = "MCH Work Order Lines";
    PasteIsValid = false;

    fields
    {
        field(1;Status;Option)
        {
            Caption = 'Work Order Status';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(2;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
            TableRelation = "MCH Work Order Header"."No." WHERE (Status=FIELD(Status));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(11;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            NotBlank = true;
            TableRelation = IF (Status=CONST(Finished)) "MCH Maintenance Asset"
                            ELSE "MCH Maintenance Asset" WHERE (Blocked=CONST(false));

            trigger OnValidate()
            var
                TempWorkOrderLine: Record "MCH Work Order Line" temporary;
            begin
                CheckAndErrorIfStatusFinished;
                if "Asset No." <> xRec."Asset No."  then begin
                  TestField("Completion Date",0D);

                  if "Asset No." <> '' then begin
                    GetWorkOrderHeader;
                    GetMaintAsset;
                    if not MaintUserMgt.UserHasAccessToRespGroup(UserId,MaintAsset."Responsibility Group Code") then
                      Error(Text015,
                        MaintAsset.TableCaption,MaintAsset."No.",
                        MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
                    CheckWorkOrderLineRestrictionOnNewAsset;
                  end;

                  TestNoPostedEntries(FieldCaption("Asset No."));
                  DeleteRelations;
                  if ("Task Code" <> '') then
                    Validate("Task Code",'');

                  TempWorkOrderLine := Rec;
                  Init;
                  "Asset No." := TempWorkOrderLine."Asset No.";
                  SetCreatedDateTimeUser;
                end;

                if "Asset No." <> '' then begin
                  UpdateHeaderRespGroupMaintLocation(Rec);
                  GetWorkOrderHeader;
                  GetMaintAsset;

                  InitLineWithHeaderFields(WorkOrder,false);
                  CopyFromMaintAsset;
                  "Def. Invt. Location Code" := FindInvtLocationCode;
                end;
                CreateDim(
                  DATABASE::"MCH Maintenance Asset","Asset No.",
                  DATABASE::"MCH Maintenance Location","Maint. Location Code",
                  DATABASE::"MCH Work Order Type","Work Order Type");
            end;
        }
        field(12;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(13;"Description 2";Text[100])
        {
            Caption = 'Description 2';
        }
        field(14;Priority;Option)
        {
            Caption = 'Priority';
            Editable = false;
            OptionCaption = 'Very High,High,Medium,Low,Very Low';
            OptionMembers = "Very High",High,Medium,Low,"Very Low";
        }
        field(15;"Category Code";Code[20])
        {
            Caption = 'Category Code';
            Editable = false;
            TableRelation = "MCH Maint. Asset Category";
        }
        field(18;"Def. Invt. Location Code";Code[10])
        {
            Caption = 'Def. Invt. Location Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));
        }
        field(19;"Posting Group";Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = "MCH Maint. Asset Posting Group";
        }
        field(31;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            TableRelation = "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("Asset No."));

            trigger OnValidate()
            var
                MaintProcedure: Record "MCH Master Maintenance Task";
                AssetMaintProcedure: Record "MCH Asset Maintenance Task";
            begin
                if "Task Code" <> xRec."Task Code" then begin
                  TestNoPostedEntries(FieldCaption("Task Code"));
                  TestField("Completion Date",0D);

                  // Check new MP
                  if "Task Code" <> '' then begin
                    TestField("Asset No.");
                    GetMaintAsset;
                    AssetMaintProcedure.Get("Asset No.","Task Code");
                    AssetMaintProcedure.TestField(Blocked,false);
                    MaintProcedure.Get("Task Code");
                    MaintProcedure.TestField(Status,MaintProcedure.Status::Active);

                    if (Status = Status::Request) then begin
                      if (MaintProcedure."Trigger Method" <> MaintProcedure."Trigger Method"::Manual) then
                        Error(Text008,
                          MaintProcedure.TableCaption,MaintProcedure.Code,
                          MaintProcedure.FieldCaption("Trigger Method"),MaintProcedure."Trigger Method",
                          WorkOrder.TableCaption,Status);
                    end;
                  end;

                  if (xRec."Task Code" <> '') then
                    RemoveBudgetForMaintProcedure(xRec."Task Code",Rec,(CurrFieldNo=FieldNo("Task Code")));

                  Validate("Task Scheduled Date",0D);
                  Validate("Task Scheduled Usage Value",0);
                  Validate("Usage on Completion",0);

                  if "Task Code" <> '' then begin
                    "Task Description" := MaintProcedure.Description;
                    "Task Trigger Method" := MaintProcedure."Trigger Method";
                    "Expected Duration (Hours)" := MaintProcedure."Expected Duration (Hours)";
                    "Expected Downtime (Hours)" := MaintProcedure."Expected Downtime (Hours)";

                    CopyMaintProcedureBudget("Task Code",Rec);
                  end else begin
                    "Task Description" := '';
                    Validate("Task Trigger Method","Task Trigger Method"::Manual);
                  end;
                end;
            end;
        }
        field(32;"Task Description";Text[100])
        {
            Caption = 'Task Description';
        }
        field(33;"Task Trigger Method";Option)
        {
            Caption = 'Task Trigger Method';
            Editable = false;
            OptionCaption = 'Manual,Calendar (Recurring),Fixed Date,Usage (Recurring),Fixed Usage';
            OptionMembers = Manual,"Calendar (Recurring)","Fixed Date","Usage (Recurring)","Fixed Usage";

            trigger OnValidate()
            begin
                if "Task Trigger Method" = "Task Trigger Method"::Manual then begin
                  Validate("Task Scheduled Date",0D);
                  Validate("Task Scheduled Usage Value",0);
                  Validate("Usage on Completion",0);
                end;
            end;
        }
        field(34;"Task Scheduled Date";Date)
        {
            Caption = 'Task Scheduled Date';

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Task Scheduled Date") then begin
                  if "Task Scheduled Date" <> 0D then
                    if Status = Status::Request then
                      FieldError(Status);
                  if ("Task Code" <> '') and
                     ("Task Scheduled Date" <> xRec."Task Scheduled Date")
                  then
                    if not Confirm(
                      Text006 + Text007,false,
                      FieldCaption("Task Scheduled Date"),xRec."Task Scheduled Date","Task Scheduled Date")
                    then begin
                      "Task Scheduled Date" := xRec."Task Scheduled Date";
                      exit;
                    end;
                end;
            end;
        }
        field(35;"Task Scheduled Usage Value";Decimal)
        {
            BlankZero = true;
            Caption = 'Task Scheduled Usage';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Task Scheduled Usage Value") then begin
                  if "Task Scheduled Usage Value" <> 0 then
                    if Status = Status::Request then
                      FieldError(Status);
                  if ("Task Code" <> '') and
                     ("Task Scheduled Usage Value" <> xRec."Task Scheduled Usage Value")
                  then
                    if not Confirm(
                      Text006 + Text007,false,
                      FieldCaption("Task Scheduled Usage Value"),xRec."Task Scheduled Usage Value","Task Scheduled Usage Value")
                    then begin
                      "Task Scheduled Usage Value" := xRec."Task Scheduled Usage Value";
                      exit;
                    end;
                end;
            end;
        }
        field(36;"Usage on Completion";Decimal)
        {
            BlankZero = true;
            Caption = 'Usage on Completion';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Usage on Completion") then begin
                  if "Usage on Completion" <> 0 then
                    if Status = Status::Request then
                      FieldError(Status);
                end;
            end;
        }
        field(39;Comment;Boolean)
        {
            CalcFormula = Exist("MCH Work Order Comment Line" WHERE ("Table Name"=CONST("Work Order Line"),
                                                                     "Table Subtype"=FIELD(Status),
                                                                     "No."=FIELD("Work Order No."),
                                                                     "Table Line No."=FIELD("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Expected Duration (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expected Duration (Hours)';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(41;"Expected Downtime (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Expected Downtime (Hours)';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(50;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                CheckDates(FieldCaption("Starting Date"));
            end;
        }
        field(53;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                CheckDates(FieldCaption("Ending Date"));
            end;
        }
        field(60;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(61;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(63;"Completion Date";Date)
        {
            Caption = 'Completion Date';

            trigger OnValidate()
            begin
                if (Status = Status::Request) and ("Completion Date" <> 0D) then
                  FieldError(Status);
                CheckDates(FieldCaption("Completion Date"));
            end;
        }
        field(70;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(71;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(72;"Created Date";Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(73;"Created Time";Time)
        {
            Caption = 'Created Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(74;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(75;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(76;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(77;"Last Time Modified";Time)
        {
            Caption = 'Last Time Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(91;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(92;"Resource Filter";Code[20])
        {
            Caption = 'Resource Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(99;"Resource Group Filter";Code[20])
        {
            Caption = 'Resource Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "Resource Group";
        }
        field(100;"Work Order Description";Text[100])
        {
            CalcFormula = Lookup("MCH Work Order Header".Description WHERE (Status=FIELD(Status),
                                                                            "No."=FIELD("Work Order No.")));
            Caption = 'Work Order Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            Editable = false;
            TableRelation = "MCH Work Order Type";
        }
        field(102;"Progress Status Code";Code[20])
        {
            Caption = 'Progress Status Code';
            Editable = false;
            TableRelation = IF (Status=CONST(Request)) "MCH Work Order Progress Status".Code WHERE ("Allow on WO Request"=CONST(true),
                                                                                                    Blocked=CONST(false))
                                                                                                    ELSE IF (Status=CONST(Planned)) "MCH Work Order Progress Status".Code WHERE ("Allow on Planned WO"=CONST(true),
                                                                                                                                                                                 Blocked=CONST(false))
                                                                                                                                                                                 ELSE IF (Status=CONST(Released)) "MCH Work Order Progress Status".Code WHERE ("Allow on Released WO"=CONST(true),
                                                                                                                                                                                                                                                               Blocked=CONST(false))
                                                                                                                                                                                                                                                               ELSE IF (Status=CONST(Finished)) "MCH Work Order Progress Status".Code;
            ValidateTableRelation = false;
        }
        field(103;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MCH Maintenance Location";
        }
        field(104;"Responsibility Group Code";Code[20])
        {
            Caption = 'Responsibility Group Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MCH Asset Responsibility Group";
        }
        field(105;"Order Date";Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(106;"Requested Starting Date";Date)
        {
            Caption = 'Requested Starting Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(300;"No. of Attachments";Integer)
        {
            CalcFormula = Count("MCH AM Document Attachment" WHERE ("Table ID"=CONST(74043),
                                                                    "No."=FIELD("Work Order No."),
                                                                    "Document Status"=FIELD(Status)));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
            InitValue = 0;

            trigger OnLookup()
            begin
                Rec.ShowDocumentAttachments;
            end;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDims;
            end;

            trigger OnValidate()
            begin
                CheckAndErrorIfStatusFinished;
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1;Status,"Work Order No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Work Order No.","Line No.",Status)
        {
        }
        key(Key3;"Asset No.")
        {
        }
        key(Key4;"Asset No.","Task Code","Task Scheduled Date")
        {
        }
        key(Key5;"Asset No.","Task Code","Task Scheduled Usage Value")
        {
        }
        key(Key6;"Asset No.","Task Code","Usage on Completion")
        {
        }
        key(Key7;"Asset No.","Task Code","Completion Date")
        {
        }
        key(Key8;"Task Code")
        {
        }
        key(Key9;Priority,"Starting Date")
        {
        }
        key(Key10;"Responsibility Group Code")
        {
        }
        key(Key11;"Maint. Location Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;Status,"Work Order No.","Line No.","Asset No.",Description,"Task Code")
        {
        }
        fieldgroup(Brick;Status,"Work Order No.","Asset No.",Description,"Task Code")
        {
        }
    }

    trigger OnDelete()
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        CheckAndErrorIfStatusFinished;
        if (Status = Status::Released) then begin
          AMLedgEntry.Reset;
          AMLedgEntry.SetCurrentKey("Work Order No.","Work Order Line No.");
          AMLedgEntry.SetRange("Work Order No.","Work Order No.");
          AMLedgEntry.SetRange("Work Order Line No.","Line No.");
          if not AMLedgEntry.IsEmpty then
            Error(Text000,Status,TableCaption,"Work Order No.",AMLedgEntry.TableCaption);
        end;
        DeleteRelations;
        UpdateHeaderDates(Rec,true);
    end;

    trigger OnInsert()
    begin
        WorkOrder."No." := '';
        CheckAndErrorIfStatusFinished;
        CheckOnInsert;
        SetCreatedDateTimeUser;
    end;

    trigger OnModify()
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        CheckAndErrorIfStatusFinished;
        if ("Asset No." <> xRec."Asset No.") or
           ("Task Code" <> xRec."Task Code")
        then begin
          if Status = Status::Released then begin
            AMLedgEntry.Reset;
            AMLedgEntry.SetCurrentKey("Work Order No.","Work Order Line No.");
            AMLedgEntry.SetRange("Work Order No.","Work Order No.");
            AMLedgEntry.SetRange("Work Order Line No.","Line No.");
            if not AMLedgEntry.IsEmpty then
              Error(
                Text004,
                FieldCaption("Asset No."),FieldCaption("Task Code"),
                Status,TableCaption,"Work Order No.",AMLedgEntry.TableCaption);
          end;

          WOBudgetLine.Reset;
          WOBudgetLine.SetCurrentKey(Status,"Work Order No.","Work Order Line No.");
          WOBudgetLine.SetRange(Status,Status);
          WOBudgetLine.SetRange("Work Order No.","Work Order No.");
          WOBudgetLine.SetRange("Work Order Line No.","Line No.");
          if WOBudgetLine.FindSet(true,false) then
            repeat
              if (WOBudgetLine."Asset No." <> "Asset No.") or
                 (WOBudgetLine."Maint. Task Code" <> "Task Code")
              then begin
                WOBudgetLine."Asset No." := "Asset No.";
                WOBudgetLine."Maint. Task Code" := "Task Code";
                WOBudgetLine.Modify;
              end;
            until WOBudgetLine.Next = 0;
        end;

        SetLastModifiedDateTimeUser;
        UpdateHeaderDates(Rec,false);
        if ("Starting Date" <> xRec."Starting Date") or ("Ending Date" <> xRec."Ending Date") then
          UpdateDatesOnBudgetLines;
    end;

    trigger OnRename()
    begin
        Error(Text002,TableCaption);
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        WorkOrder: Record "MCH Work Order Header";
        MaintAsset: Record "MCH Maintenance Asset";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'You cannot delete %1 %2 %3 because there exists at least one %4 associated with it.';
        Text001: Label '%1 %2 has %3 = %4 and cannot be inserted, modified, or deleted.';
        Text002: Label 'You cannot rename a %1.';
        Text003: Label 'You cannot delete %1 %2,%3, because %4 is attached to it.';
        Text004: Label 'You cannot change the %1 in %2 %3 %4 because this line has one or more posted entries.';
        Text005: Label 'Do you want to delete the existing %1(s) for %2 %3 ?';
        Text006: Label 'Changing %1 from %2 to %3 may affect maintenance scheduling.\';
        Text007: Label 'Do you want to continue?';
        Text008: Label '%1 %2 (%3 = %4) cannot be used in a %5 %6.';
        Text010: Label 'cannot be later than %1';
        Text011: Label '%1 in %2 %3 must be %4 which is the %5 for %6 %7.';
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        Text012: Label 'Only 1 Line is allowed per %1.';
        Text013: Label 'Only 1 %1 is allowed per %2.';
        Text014: Label 'Asset %1 and %2 cannot be processed on the same work order because they are setup with a different %3 (%4 <> %5).';
        Text015: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
        Text022: Label 'cannot be after %1 (%2)';
        Text023: Label 'cannot be before %1 (%2)';
        HeaderUpdateSuppressed: Boolean;
        HideValidationDialog: Boolean;

    local procedure GetMaintAsset()
    begin
        TestField("Asset No.");
        if ("Asset No." <> MaintAsset."No.") then
          MaintAsset.Get("Asset No.");
    end;

    local procedure FindInvtLocationCode() DefLocationCode: Code[10]
    var
        MaintLocation: Record "MCH Maintenance Location";
    begin
        if "Asset No." = '' then
          exit('');
        if "Def. Invt. Location Code" <> '' then
          exit("Def. Invt. Location Code");
        if MaintLocation.Get("Maint. Location Code") then
          if (MaintLocation."Def. Invt. Location Code" <> '') then
            exit(MaintLocation."Def. Invt. Location Code");
        GetMaintAsset;
        if MaintAsset."Def. Invt. Location Code" <> '' then
          exit(MaintAsset."Def. Invt. Location Code");
        AMSetup.Get;
        exit(AMSetup."Def. Inventory Location Code");
    end;

    local procedure TestNoPostedEntries(ChangedFieldName: Text[80])
    var
        WorkOrderLine2: Record "MCH Work Order Line";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        WorkOrderLine2 := Rec;
        if not WorkOrderLine2.Find then
          exit;
        if ChangedFieldName in [FieldCaption("Asset No."),FieldCaption("Task Code")] then begin
          if Status = Status::Released then begin
            AMLedgEntry.Reset;
            AMLedgEntry.SetCurrentKey("Work Order No.","Work Order Line No.");
            AMLedgEntry.SetRange("Work Order No.","Work Order No.");
            AMLedgEntry.SetRange("Work Order Line No.","Line No.");
            if not AMLedgEntry.IsEmpty then
              Error(Text004,
                ChangedFieldName,Status,TableCaption,"Work Order No.",AMLedgEntry.TableCaption);
          end;
        end;
    end;


    procedure DeleteRelations()
    var
        WorkOrderLine: Record "MCH Work Order Line";
        WOBudgetLine: Record "MCH Work Order Budget Line";
        WorkOrderCommentLine: Record "MCH Work Order Comment Line";
    begin
        WOBudgetLine.Reset;
        WOBudgetLine.SetCurrentKey(Status,"Work Order No.","Work Order Line No.");
        WOBudgetLine.SetRange(Status,Status);
        WOBudgetLine.SetRange("Work Order No.","Work Order No.");
        WOBudgetLine.SetRange("Work Order Line No.","Line No.");
        WOBudgetLine.DeleteAll(true);

        WorkOrderCommentLine.Reset;
        WorkOrderCommentLine.SetRange("Table Name",WorkOrderCommentLine."Table Name"::"Work Order Line");
        WorkOrderCommentLine.SetRange("Table Subtype",Status);
        WorkOrderCommentLine.SetRange("No.","Work Order No.");
        WorkOrderCommentLine.SetRange("Table Line No.","Line No.");
        WorkOrderCommentLine.DeleteAll;
    end;

    [TryFunction]

    procedure CheckOnInsert()
    begin
        AMSetup.Get;
        case AMSetup."Work Order Line Restriction" of
          AMSetup."Work Order Line Restriction"::"Single Line Only" :
            begin
              if not IsFirstWorkOrderLine then
                Error(Text012,WorkOrder.TableCaption);
            end;
          AMSetup."Work Order Line Restriction"::"One Asset Only" :
            begin
              if ("Asset No." <> '') then begin
                if not IsFirstWorkOrderLine then
                  if WorkOrderLineWithDiffAssetExists("Asset No.") then
                    Error(Text013,MaintAsset.TableCaption,WorkOrder.TableCaption);
              end;
            end;
          AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location" :
            begin
            end;
        end;
    end;

    local procedure IsFirstWorkOrderLine() IsFirstLine: Boolean
    var
        WorkOrderLine2: Record "MCH Work Order Line";
    begin
        WorkOrderLine2.SetRange(Status,Status);
        WorkOrderLine2.SetRange("Work Order No.","Work Order No.");
        WorkOrderLine2.SetFilter("Line No.",'<>%1',"Line No.");
        exit(WorkOrderLine2.IsEmpty);
    end;

    local procedure WorkOrderLineWithDiffAssetExists(ThisAssetNo: Code[20]) HasDiffAsset: Boolean
    var
        WorkOrderLine2: Record "MCH Work Order Line";
    begin
        WorkOrderLine2.SetRange(Status,Status);
        WorkOrderLine2.SetRange("Work Order No.","Work Order No.");
        WorkOrderLine2.SetFilter("Line No.",'<>%1',"Line No.");
        WorkOrderLine2.SetFilter("Asset No.",'<>%1',ThisAssetNo);
        exit(not WorkOrderLine2.IsEmpty);
    end;

    local procedure CheckWorkOrderLineRestrictionOnNewAsset()
    var
        WorkOrderLine2: Record "MCH Work Order Line";
        MaintAsset2: Record "MCH Maintenance Asset";
    begin
        if ("Asset No." = '') then
          exit;
        CheckOnInsert;
        GetMaintAsset;
        case AMSetup."Work Order Line Restriction" of
          AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location" :
            begin
              WorkOrderLine2.SetRange(Status,Status);
              WorkOrderLine2.SetRange("Work Order No.","Work Order No.");
              WorkOrderLine2.SetFilter("Line No.",'<>%1',"Line No.");
              WorkOrderLine2.SetFilter("Asset No.",'<>%1','');
              if WorkOrderLine2.FindSet then begin
                repeat
                  if ("Asset No." <> WorkOrderLine2."Asset No.") then begin
                    MaintAsset2.Get(WorkOrderLine2."Asset No.");
                    // Same Responsibility Group
                    if (MaintAsset."Responsibility Group Code" <> '') and (MaintAsset2."Responsibility Group Code" <> '') and
                       (MaintAsset."Responsibility Group Code" <> MaintAsset2."Responsibility Group Code")
                    then
                      Error(Text014,
                        MaintAsset."No.",MaintAsset2."No.",MaintAsset.FieldCaption("Responsibility Group Code"),
                        MaintAsset."Responsibility Group Code", MaintAsset2."Responsibility Group Code");

                    // Same Fixed Maint. Location
                    if (MaintAsset."Fixed Maint. Location Code" <> '') and (MaintAsset2."Fixed Maint. Location Code" <> '') and
                       (MaintAsset."Fixed Maint. Location Code" <> MaintAsset2."Fixed Maint. Location Code")
                    then
                      Error(Text014,
                        MaintAsset."No.",MaintAsset2."No.",MaintAsset.FieldCaption("Fixed Maint. Location Code"),
                        MaintAsset."Fixed Maint. Location Code",MaintAsset2."Fixed Maint. Location Code");
                  end;
                until WorkOrderLine2.Next = 0;
              end;
            end;
        end;
    end;

    local procedure CopyMaintProcedureBudget(MaintTaskCode: Code[20];WorkOrderLine: Record "MCH Work Order Line")
    var
        MaintTaskBudgetLine: Record "MCH Maint. Task Budget Line";
        WOBudgetLine: Record "MCH Work Order Budget Line";
        OK: Boolean;
        LineNo: Integer;
    begin
        if MaintTaskCode = '' then
          exit;
        with WorkOrderLine do begin
          if "Line No." <> 0 then begin
            MaintTaskBudgetLine.SetRange("Task Code",MaintTaskCode);
            if MaintTaskBudgetLine.FindSet then begin
              WOBudgetLine.Reset;
              WOBudgetLine.SetRange(Status,Status);
              WOBudgetLine.SetRange("Work Order No.","Work Order No.");
              WOBudgetLine.LockTable;
              if WOBudgetLine.FindLast then
                LineNo := WOBudgetLine."Line No.";
              repeat
                LineNo := LineNo + 10000;
                WOBudgetLine.Init;
                WOBudgetLine.Status := Status;
                WOBudgetLine."Work Order No." := "Work Order No.";
                WOBudgetLine."Line No." := LineNo;
                WOBudgetLine."Work Order Line No." := "Line No.";
                WOBudgetLine.TransferFromWorkOrderLine(WorkOrderLine);
                WOBudgetLine.TransferFromMaintTaskBudgLine(MaintTaskBudgetLine);
                WOBudgetLine.Insert(true);
              until MaintTaskBudgetLine.Next = 0;
            end;
          end;
        end;
    end;

    local procedure RemoveBudgetForMaintProcedure(MaintProcedureCode: Code[20];WorkOrderLine: Record "MCH Work Order Line";ConfirmDeletion: Boolean)
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
        DoDelete: Boolean;
    begin
        if MaintProcedureCode = '' then
          exit;
        with WorkOrderLine do begin
          WOBudgetLine.Reset;
          WOBudgetLine.SetCurrentKey(Status,"Work Order No.","Work Order Line No.");
          WOBudgetLine.SetRange(Status,Status);
          WOBudgetLine.SetRange("Work Order No.","Work Order No.");
          WOBudgetLine.SetRange("Work Order Line No.","Line No.");
          WOBudgetLine.SetRange("Maint. Task Code",MaintProcedureCode);
          if WOBudgetLine.IsEmpty then
            exit;
          if (not ConfirmDeletion) or HideValidationDialog then
            DoDelete := true
          else begin
            DoDelete :=
              Confirm(Text005,true,WOBudgetLine.TableCaption,FieldCaption("Task Code"),MaintProcedureCode);
          end;

          if WOBudgetLine.FindSet(true) then begin
            repeat
              if DoDelete then begin
                WOBudgetLine.Delete(true);
              end else begin
                WOBudgetLine.Validate("Maint. Task Code",'');
                WOBudgetLine.Modify;
              end;
            until WOBudgetLine.Next = 0;
            Modify;
          end;
        end;
    end;

    local procedure CheckDates(ChangedFieldCaption: Text[100])
    begin
        case ChangedFieldCaption of
          FieldCaption("Starting Date") :
            begin
              if ("Starting Date" = 0D) then begin
                TestField("Ending Date",0D);
                TestField("Completion Date",0D);
              end;
            end;
          FieldCaption("Ending Date") :
            begin
              if ("Ending Date" <> 0D) then
                TestField("Starting Date");
            end;
          FieldCaption("Completion Date") :
            begin
              if ("Completion Date" <> 0D) then begin
                TestField("Starting Date");
              end;
            end;
        end;

        if (("Starting Date" <> 0D) and ("Order Date" > "Starting Date")) then
          FieldError("Starting Date",
            StrSubstNo(Text023,FieldCaption("Order Date"),"Order Date"));

        if (("Ending Date" <> 0D) and ("Starting Date" > "Ending Date")) then
          FieldError("Starting Date",
            StrSubstNo(Text022,FieldCaption("Ending Date"),"Ending Date"));

        if (("Starting Date" <> 0D) and ("Completion Date" <> 0D) and ("Starting Date" > "Completion Date")) then
          FieldError("Completion Date",
            StrSubstNo(Text023,FieldCaption("Starting Date"),"Starting Date"));
    end;

    local procedure GetWorkOrderHeader()
    begin
        TestField("Work Order No.");
        if (Status <> WorkOrder.Status) or ("Work Order No." <> WorkOrder."No.") then
          WorkOrder.Get(Status,"Work Order No.");
    end;


    procedure InitLineWithHeaderFields(var TheWorkOrder: Record "MCH Work Order Header";CalledOnHeaderUpdate: Boolean)
    begin
        UpdateDuplicateFieldsFromHeader(TheWorkOrder,CalledOnHeaderUpdate);
        if ("Starting Date" = 0D) then
          "Starting Date" := TheWorkOrder."Starting Date";
        if ("Ending Date" = 0D) then
          "Ending Date" := TheWorkOrder."Ending Date";
    end;


    procedure UpdateDuplicateFieldsFromHeader(var TheWorkOrder: Record "MCH Work Order Header";CalledOnHeaderUpdate: Boolean)
    begin
        if CalledOnHeaderUpdate and ("Asset No." <> '') then begin
          GetMaintAsset;
          if (MaintAsset."Responsibility Group Code" <> '') and
             (MaintAsset."Responsibility Group Code" <> TheWorkOrder."Responsibility Group Code")
          then
            Error(Text011,
              TheWorkOrder.FieldCaption("Responsibility Group Code"),TheWorkOrder.TableCaption,TheWorkOrder."No.",
              MaintAsset."Responsibility Group Code",MaintAsset.FieldCaption("Responsibility Group Code"),
              MaintAsset.TableCaption,MaintAsset."No.");

          if (MaintAsset."Fixed Maint. Location Code" <> '') and
             (MaintAsset."Fixed Maint. Location Code" <> TheWorkOrder."Maint. Location Code")
          then
            Error(Text011,
              TheWorkOrder.FieldCaption("Maint. Location Code"),TheWorkOrder.TableCaption,TheWorkOrder."No.",
              MaintAsset."Fixed Maint. Location Code",MaintAsset.FieldCaption("Fixed Maint. Location Code"),
              MaintAsset.TableCaption,MaintAsset."No.");
        end;

        "Responsibility Group Code" := TheWorkOrder."Responsibility Group Code";
        "Maint. Location Code" := TheWorkOrder."Maint. Location Code";
        "Work Order Type" := TheWorkOrder."Work Order Type";
        "Progress Status Code" := TheWorkOrder."Progress Status Code";
        Priority := TheWorkOrder.Priority;
        "Order Date" := TheWorkOrder."Order Date";
        "Requested Starting Date" := TheWorkOrder."Requested Starting Date";
    end;

    local procedure UpdateHeaderRespGroupMaintLocation(var WorkOrderLine2: Record "MCH Work Order Line")
    var
        DoModify: Boolean;
    begin
        if ("Asset No." = '') then
          exit;
        GetMaintAsset;
        if (MaintAsset."Responsibility Group Code" = '') and
          (MaintAsset."Fixed Maint. Location Code" = '')
        then
          exit;
        WorkOrder.Get(Status,"Work Order No.");
        WorkOrder.SetUpdatingFromLine(true);

        if (MaintAsset."Responsibility Group Code" <> '') and
           (MaintAsset."Responsibility Group Code" <> WorkOrder."Responsibility Group Code")
        then begin
          WorkOrder.Validate("Responsibility Group Code",MaintAsset."Responsibility Group Code");
          DoModify := true;
        end;
        if (MaintAsset."Fixed Maint. Location Code" <> '') and
           (MaintAsset."Fixed Maint. Location Code" <> WorkOrder."Maint. Location Code")
        then begin
          WorkOrder.Validate("Maint. Location Code",MaintAsset."Fixed Maint. Location Code");
          DoModify := true;
        end;

        if DoModify then begin
          WorkOrder.Modify(true);
          WorkOrder."No." := '';
        end;
    end;

    local procedure UpdateHeaderDates(var TheWorkOrderLine: Record "MCH Work Order Line";OnLineDeletion: Boolean)
    var
        WorkOrderLine2: Record "MCH Work Order Line";
        FirstStartingDate: Date;
        LastEndingDate: Date;
        LastCompletionDate: Date;
        HasBlankCompletionDate: Boolean;
        HasBlankEndingDate: Boolean;
        NoOfLines: Integer;
        DoModify: Boolean;
    begin
        if HeaderUpdateSuppressed then
          exit;
        if (not OnLineDeletion) then begin
          NoOfLines := 1;
          with TheWorkOrderLine do begin
            FirstStartingDate := "Starting Date";
            LastEndingDate := "Ending Date";
            LastCompletionDate := "Completion Date";
            HasBlankEndingDate := (LastEndingDate = 0D);
            HasBlankCompletionDate := (LastCompletionDate = 0D);
          end;
        end;

        with WorkOrderLine2 do begin
          SetRange(Status,TheWorkOrderLine.Status);
          SetRange("Work Order No.",TheWorkOrderLine."Work Order No.");
          SetFilter("Line No.",'<>%1',TheWorkOrderLine."Line No.");
          if FindSet then begin
            repeat
              NoOfLines := NoOfLines + 1;
              if ("Starting Date" <> 0D) and
                 ((FirstStartingDate > "Starting Date") or (FirstStartingDate = 0D))
              then
                FirstStartingDate := "Starting Date";

              if ("Ending Date" <> 0D) then begin
                if (LastEndingDate < "Ending Date") then
                  LastEndingDate := "Ending Date";
              end else
                HasBlankEndingDate := true;

              if ("Completion Date" <> 0D) then begin
                if (LastCompletionDate < "Completion Date") then
                  LastCompletionDate := "Completion Date";
              end else
                HasBlankCompletionDate := true;
            until Next = 0;
          end;
        end;
        if (LastCompletionDate = 0D) then
          HasBlankCompletionDate := true;
        if HasBlankCompletionDate then
          LastCompletionDate := 0D;
        if (LastEndingDate = 0D) then
          HasBlankEndingDate := true;
        if HasBlankEndingDate then
          LastEndingDate := 0D;

        Clear(WorkOrder);
        if not WorkOrder.Get(TheWorkOrderLine.Status,TheWorkOrderLine."Work Order No.") then
          exit;
        WorkOrder.SetUpdatingFromLine(true);
        WorkOrder.SetHideValidationDialog(true);
        if (NoOfLines > 0) and
           ((WorkOrder."Starting Date" <> FirstStartingDate) or
            (WorkOrder."Ending Date" <> LastEndingDate))
        then begin
          WorkOrder."Starting Date" := FirstStartingDate;
          WorkOrder."Ending Date" := LastEndingDate;
          DoModify := true;
        end;
        if (WorkOrder."Completion Date" <> LastCompletionDate) then begin
          WorkOrder."Completion Date" := LastCompletionDate;
          DoModify := true;
        end;

        if DoModify then begin
          WorkOrder.Modify(true);
          WorkOrder."No." := '';
        end;
    end;


    procedure UpdateDatesOnBudgetLines()
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
    begin
        WOBudgetLine.Reset;
        WOBudgetLine.SetCurrentKey(Status,"Work Order No.","Work Order Line No.");
        WOBudgetLine.SetRange(Status,Status);
        WOBudgetLine.SetRange("Work Order No.","Work Order No.");
        WOBudgetLine.SetRange("Work Order Line No.","Line No.");
        if WOBudgetLine.FindSet(true,false) then
          repeat
            if (WOBudgetLine."Starting Date" <> "Starting Date") or
               (WOBudgetLine."Ending Date" <> "Ending Date")
            then begin
              WOBudgetLine."Starting Date" := "Starting Date";
              WOBudgetLine."Ending Date" := "Ending Date";
              WOBudgetLine.Modify;
            end;
          until WOBudgetLine.Next = 0;
    end;

    local procedure CopyFromMaintAsset()
    begin
        GetMaintAsset;
        MaintAsset.CheckMandatoryFields;
        MaintAsset.TestField(Blocked,false);
        Description := MaintAsset.Description;
        "Description 2" := MaintAsset."Description 2";
        "Category Code" := MaintAsset."Category Code";
        "Posting Group" := MaintAsset."Posting Group";
    end;


    procedure SetSuppresHeaderUpdate(NewHeaderUpdateSuppressed: Boolean)
    begin
        HeaderUpdateSuppressed := NewHeaderUpdateSuppressed;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure SetSecurityFilterOnResponsibilityGroup(FilterGrpNo: Integer)
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
          FilterGroup(FilterGrpNo);
          SetFilter("Responsibility Group Code",MaintUserMgt.GetAssetRespGroupFilter);
          FilterGroup(0);
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


    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20])
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        CheckAndErrorIfStatusFinished;
        AMSetup.Get;
        AMSetup.TestField("Source Code");
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type1;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetWorkOrderHeader;
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec,CurrFieldNo,TableID,No,AMSetup."Source Code",
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",WorkOrder."Dimension Set ID",DATABASE::"MCH Maintenance Location");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        CheckAndErrorIfStatusFinished;
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        if (Status <> Status::Finished) then
          ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;


    procedure ShowDims() IsChanged: Boolean
    var
        OldDimSetID: Integer;
    begin
        if Status = Status::Finished then begin
          DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2 %3',Status,"Work Order No.","Line No."));
        end else begin
          OldDimSetID := "Dimension Set ID";
          "Dimension Set ID" :=
            DimMgt.EditDimensionSet("Dimension Set ID",StrSubstNo('%1 %2 %3',Status,"Work Order No.","Line No."));
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
          IsChanged := OldDimSetID <> "Dimension Set ID";
        end;
    end;

    local procedure CheckAndErrorIfStatusFinished()
    begin
        if Status = Status::Finished then
          Error(Text001,WorkOrder.TableCaption,"Work Order No.",FieldCaption(Status),Status);
    end;


    procedure GetPriorityStyleTxt() StyleTxt: Text
    begin
        case Priority of
          Priority::"Very High" :
            exit('Strong');
          Priority::High :
            exit('StrongAccent');
          else
            exit('');
        end;
    end;


    procedure GetOverdueEndingDateStyleTxt() StyleTxt: Text
    begin
        case true of
          ("Ending Date" > WorkDate) or ("Ending Date" = 0D) :
            exit('');
          ("Ending Date" = WorkDate) :
            exit('AttentionAccent');
          ("Ending Date" < WorkDate) :
            exit('Unfavorable')
        end;
    end;


    procedure ShowCommentLines()
    var
        WorkOrderCommentLine: Record "MCH Work Order Comment Line";
    begin
        WorkOrderCommentLine.Reset;
        WorkOrderCommentLine.SetRange("Table Name",WorkOrderCommentLine."Table Name"::"Work Order Line");
        WorkOrderCommentLine.SetRange("Table Subtype",Status);
        WorkOrderCommentLine.SetRange("No.","Work Order No.");
        WorkOrderCommentLine.SetRange("Table Line No.","Line No.");
        PAGE.RunModal(PAGE::"MCH Work Order Comment Sheet",WorkOrderCommentLine);
    end;


    procedure ShowDocumentAttachments()
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
        AMDocAttachDetails: Page "MCH AM Doc.Attach. Details";
    begin
        if ("Work Order No." = '') or ("Line No." = 0) then
          exit;
        AMDocumentAttachment.FilterGroup(4);
        AMDocumentAttachment.SetRange("Table ID",DATABASE::"MCH Work Order Line");
        AMDocumentAttachment.SetRange("Document Status",Status);
        AMDocumentAttachment.SetRange("No.","Work Order No.");
        AMDocumentAttachment.SetRange("Line No.","Line No.");
        AMDocumentAttachment.FilterGroup(0);
        AMDocAttachDetails.SetTableView(AMDocumentAttachment);
        AMDocAttachDetails.SetCaption(StrSubstNo('%1 %2 - %3 %4',Status,TableCaption,"Work Order No.","Line No."));
        AMDocAttachDetails.RunModal;
    end;


    procedure ShowBudget()
    var
        WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
    begin
        if ("Work Order No." = '') or ("Line No." = 0) then
          exit;
        WorkOrderBudgetLine.OpenBudgetPage(Status,"Work Order No.","Line No.");
    end;
}

