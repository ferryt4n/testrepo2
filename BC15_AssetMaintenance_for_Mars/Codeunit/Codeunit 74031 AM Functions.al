codeunit 74031 "MCH AM Functions"
{

    trigger OnRun()
    begin
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        UnitOfMeasure: Record "Unit of Measure";
        MaintUnitOfMeasure: Record "MCH Maint. Unit of Measure";
        Text001: Label '%1 cannot be %2 in %3 %4. A %3 cannot be a child of itself.';
        Text002: Label 'No. of levels in %1 structure must not exceed %2. Check the structure for circular referencing. Current %1 = %3.';
        TempHierarchyMA: Record "MCH Maintenance Asset" temporary;
        Text005: Label '%1 %2 cannot be used on %3 %4.';
        Text006: Label 'Purchasing is blocked for %1 %2 %3, with %4 %5.';
        Text007: Label 'Purchase Posting is blocked for %1 %2 %3, with %4 %5.';
        Text008: Label 'Inventory Issue is blocked for %1 %2 %3, with %4 %5.';
        Text009: Label 'Inventory Return is blocked for %1 %2 %3, with %4 %5.';
        Text010: Label 'Timesheet Entry is blocked for %1 %2 %3, with %4 %5.';
        Text011: Label 'Timesheet Posting is blocked for %1 %2 %3, with %4 %5.';
        TempWOProgressStatus: Record "MCH Work Order Progress Status" temporary;
        WOProgressStatus: Record "MCH Work Order Progress Status";
        HasSetup: Boolean;
        Text013: Label '%1 %2 cannot be deleted because it is referenced by one or more records in table %3 from field: %4.';


    procedure GetTeamQtyPerUOM(MaintTeam: Record "MCH Maintenance Team";UnitOfMeasureCode: Code[10]) QtyPerUOM: Decimal
    begin
        MaintTeam.TestField(Code);
        TestIfUOMTimeBased(UnitOfMeasureCode,true);
        if UnitOfMeasureCode in [MaintTeam."Base Unit of Measure",''] then
          exit(1);
        if (MaintUnitOfMeasure."Table Name" <> MaintUnitOfMeasure."Table Name"::Team) or
           (MaintTeam.Code <> MaintUnitOfMeasure.Code) or
           (UnitOfMeasureCode <> MaintUnitOfMeasure."Unit of Measure Code")
        then
          MaintUnitOfMeasure.Get(MaintUnitOfMeasure."Table Name"::Team,MaintTeam.Code,UnitOfMeasureCode);
        MaintUnitOfMeasure.TestField("Qty. per Unit of Measure");
        exit(MaintUnitOfMeasure."Qty. per Unit of Measure");
    end;


    procedure TestIfUOMTimeBased(UnitOfMeasureCode: Code[10];ShowError: Boolean) IsTimeBased: Boolean
    begin
        if UnitOfMeasureCode = '' then
          exit(false);
        if UnitOfMeasureCode <> UnitOfMeasure.Code then
          UnitOfMeasure.Get(UnitOfMeasureCode);
        if ShowError then begin
          UnitOfMeasure.TestField("MCH Time Unit",true);
          UnitOfMeasure.TestField("MCH Time Unit of Measure");
          UnitOfMeasure.TestField("MCH Units per Time UoM");
          exit(true);
        end else begin
          exit(
            UnitOfMeasure."MCH Time Unit" and
            (UnitOfMeasure."MCH Time Unit of Measure" <> UnitOfMeasure."MCH Time Unit of Measure"::" ") and
            (UnitOfMeasure."MCH Units per Time UoM" > 0));
        end;
    end;


    procedure GetHoursPerTimeUOM(Quantity: Decimal;UnitOfMeasureCode: Code[10]) Hours: Decimal
    var
        BaseTimeFactor: Decimal;
    begin
        if (Quantity = 0) or (UnitOfMeasureCode = '') then
          exit(0);
        BaseTimeFactor := TimeFactor(UnitOfMeasureCode);
        if BaseTimeFactor = 0 then
          exit(0);
        if UnitOfMeasureCode <> UnitOfMeasure.Code then
          UnitOfMeasure.Get(UnitOfMeasureCode);
        exit(Round((Quantity * UnitOfMeasure."MCH Units per Time UoM" * BaseTimeFactor) / 3600000, 0.00001));
    end;


    procedure GetUOMQuantityPerHour(Hours: Decimal;UnitOfMeasureCode: Code[10]) Quantity: Decimal
    var
        BaseTimeFactor: Decimal;
    begin
        if (Hours = 0) or (UnitOfMeasureCode = '') then
          exit(0);
        BaseTimeFactor := TimeFactor(UnitOfMeasureCode);
        if BaseTimeFactor = 0 then
          exit(0);
        if UnitOfMeasureCode <> UnitOfMeasure.Code then
          UnitOfMeasure.Get(UnitOfMeasureCode);
        exit(Round((Hours * 3600000) / (UnitOfMeasure."MCH Units per Time UoM" * BaseTimeFactor), 0.00001));
    end;

    local procedure TimeFactor(UnitOfMeasureCode: Code[10]): Decimal
    begin
        if not TestIfUOMTimeBased(UnitOfMeasureCode,false) then
          exit(0);
        if UnitOfMeasureCode <> UnitOfMeasure.Code then
          UnitOfMeasure.Get(UnitOfMeasureCode);

        with UnitOfMeasure do begin
          case "MCH Time Unit of Measure" of
            "MCH Time Unit of Measure"::Minute:
              exit(60000);
            "MCH Time Unit of Measure"::"100/Hour":
              exit(36000);
            "MCH Time Unit of Measure"::Hour:
              exit(3600000);
            "MCH Time Unit of Measure"::"Day (24 Hours)":
              exit(86400000);
            else
              exit(0);
          end;
        end;
    end;


    procedure VerifyAssetParentChildRelationship(CurrMA: Record "MCH Maintenance Asset")
    begin
        // Check if parent is existing child
        if CurrMA."Parent Asset No." = '' then
          exit;
        if FindAssetInStructure(CurrMA,1,CurrMA."Parent Asset No.") then
          Error(
            Text001,
            CurrMA.FieldCaption("Parent Asset No."),CurrMA."Parent Asset No.",CurrMA.TableCaption,CurrMA."No.");
    end;

    local procedure FindAssetInStructure(CurrMA: Record "MCH Maintenance Asset";RelSearchLevel: Integer;SearchMANo: Code[20]) Found: Boolean
    var
        MA2: Record "MCH Maintenance Asset";
    begin
        if RelSearchLevel > MaxAssetStructureLevels then
          Error(
            Text002,CurrMA.TableCaption,MaxAssetStructureLevels,CurrMA."No.");
        if SearchMANo = '' then
          exit(false);
        if CurrMA."Parent Asset No." = '' then
          exit(false);
        if SearchMANo = CurrMA."No." then
          exit(true);

        MA2.Get(SearchMANo);
        if FindAssetInStructure(CurrMA,RelSearchLevel+1,MA2."Parent Asset No.") then
          exit(true);
        exit(false);
    end;


    procedure UpdateAssetStructureChildren(ParentMA: Record "MCH Maintenance Asset")
    var
        ChildMA: Record "MCH Maintenance Asset";
        NewHierarchySortingOrder: Text[1024];
    begin
        ParentMA.TestField("Structure ID");
        ChildMA.SetCurrentKey("Parent Asset No.");
        ChildMA.SetRange("Parent Asset No.",ParentMA."No.");
        if ChildMA.Find('-') then begin
          repeat
            ChildMA."Structure Level" := ParentMA."Structure Level" + 1;
            if ChildMA."Structure Level" > MaxAssetStructureLevels then
              Error(
                Text002,ChildMA.TableCaption);
            ChildMA.TestField("Structure ID");
            ChildMA."Structure Position ID" := ParentMA."Structure Position ID" + '-' + ChildMA."Structure ID";
            ChildMA.Modify;
            UpdateAssetStructureChildren(ChildMA);
          until ChildMA.Next = 0;
        end;
    end;


    procedure AssignAssetStructureID(var CurrMA: Record "MCH Maintenance Asset";ModifyMA: Boolean)
    var
        MA2: Record "MCH Maintenance Asset";
    begin
        if CurrMA."Structure ID" = '' then begin
          MA2.SetCurrentKey("Structure ID");
          MA2.SetFilter("Structure ID",'<>%1','');
          if MA2.FindLast then
            CurrMA."Structure ID" := IncStr(MA2."Structure ID")
          else
            CurrMA."Structure ID" := GetAssetStartingStructureID;
          CurrMA."Structure Position ID" := CurrMA."Structure ID";
          if ModifyMA then begin
            CurrMA.Modify(true);
          end;
        end;
    end;


    procedure GetAssetStartingStructureID() StartingHierarchyID: Code[20]
    begin
        exit('100000');
    end;


    procedure MaxAssetStructureLevels() MaxLevels: Integer
    var
        MA: Record "MCH Maintenance Asset";
    begin
        exit(20)
    end;


    procedure InitializeAMReportSelection()
    var
        AMReportSelection: Record "MCH AM Report Selections";
    begin
        if not AMReportSelection.WritePermission then
          exit;
        if AMReportSelection.IsEmpty then begin
          with AMReportSelection do begin
            InsertRepSelection(Usage::"Work Order Request",'1',REPORT::"MCH Work Order Request");
            InsertRepSelection(Usage::"Planned Work Order",'1',REPORT::"MCH Planned Work Order");
            InsertRepSelection(Usage::"Released Work Order",'1',REPORT::"MCH Released Work Order");
            InsertRepSelection(Usage::"Finished Work Order",'1',REPORT::"MCH Finished Work Order");
          end;
          Commit;
        end;
    end;

    local procedure InsertRepSelection(ReportUsage: Integer;Sequence: Code[10];ReportID: Integer)
    var
        AMReportSelection: Record "MCH AM Report Selections";
    begin
        AMReportSelection.Init;
        AMReportSelection.Usage := ReportUsage;
        AMReportSelection.Sequence := Sequence;
        AMReportSelection."Report ID" := ReportID;
        AMReportSelection.Insert;
    end;

    [TryFunction]

    procedure CheckAssetMandatoryFields(MaintAsset: Record "MCH Maintenance Asset")
    begin
        if MaintAsset."No." = '' then
          exit;
        GetSetup;
        with MaintAsset do begin
          if AMSetup."Asset Category Mandatory" then
            TestField("Category Code");
          if AMSetup."Asset Fixed Maint. Loc. Mand." then
            TestField("Fixed Maint. Location Code");
          if AMSetup."Asset Resp. Group Mandatory" then
            TestField("Responsibility Group Code");
        end;
    end;


    procedure GetDefaultNewWOProgressStatus(WorkOrderStatus: Option Requested,Planned,Released) DefNewProgressStatusCode: Code[20]
    var
        ProgressStatus: Record "MCH Work Order Progress Status";
    begin
        case WorkOrderStatus of
          WorkOrderStatus::Requested :
            begin
              ProgressStatus.SetRange("Def. on WO Request",true);
              ProgressStatus.SetRange("Allow on WO Request",true);
            end;
          WorkOrderStatus::Planned :
            begin
              ProgressStatus.SetRange("Def. on Planned WO",true);
              ProgressStatus.SetRange("Allow on Planned WO",true);
            end;
          WorkOrderStatus::Released :
            begin
              ProgressStatus.SetRange("Def. on Released WO",true);
              ProgressStatus.SetRange("Allow on Released WO",true);
            end;
          else
            exit;
        end;
        if ProgressStatus.FindFirst then
          exit(ProgressStatus.Code);
    end;

    [TryFunction]

    procedure CheckAllowedWOProgressStatus(WorkOrder: Record "MCH Work Order Header")
    var
        ProgressStatus: Record "MCH Work Order Progress Status";
        ErrorFound: Boolean;
    begin
        with WorkOrder do begin
          if "Progress Status Code" = '' then
            exit;
          ProgressStatus.Get("Progress Status Code");
          case Status of
            Status::Request:
              if not ProgressStatus."Allow on WO Request" then
                ErrorFound := true;
            Status::Planned:
              if not ProgressStatus."Allow on Planned WO" then
                ErrorFound := true;
            Status::Released:
              if not ProgressStatus."Allow on Released WO" then
                ErrorFound := true;
            Status::Finished:
              if not ProgressStatus."Allow on Finished WO" then
                ErrorFound := true;
          end;
          if ErrorFound then
            Error(
              Text005,
              ProgressStatus.TableCaption,"Progress Status Code",Status,WorkOrder.TableCaption);
          if (Status <> Status::Finished) and ProgressStatus.Blocked then
            ProgressStatus.FieldError(Blocked);
        end;
    end;

    local procedure GetSetup()
    begin
        if HasSetup then
          exit;
        HasSetup := true;
        AMSetup.Get;
    end;


    procedure CheckIfPurchEntryBlocked(WorkOrderNo: Code[20];ShowBlockError: Boolean) IsBlocked: Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if WorkOrderNo = '' then
          exit(false);
        FindWorkOrderByNo(WorkOrderNo,WorkOrder);
        exit(CheckIfPurchEntryBlocked2(WorkOrder,ShowBlockError));
    end;


    procedure CheckIfPurchEntryBlocked2(var WorkOrder: Record "MCH Work Order Header";ShowBlockError: Boolean) IsBlocked: Boolean
    begin
        if (WorkOrder.Status <> WorkOrder.Status::Released) then begin
          if ShowBlockError then
            WorkOrder.TestField(Status,WorkOrder.Status::Released)
          else
            exit(true);
        end;
        if WorkOrder."Progress Status Code" = '' then begin
          GetSetup;
          if AMSetup."WO Progress Status Mandatory" then
            WorkOrder.TestField("Progress Status Code");
          exit(false);
        end;
        GetWOProgressStatus(WorkOrder."Progress Status Code");
        if not WOProgressStatus."Block Additional Purchasing" then
          exit(false)
        else begin
          if ShowBlockError then
            Error(
              StrSubstNo(Text006,WorkOrder.Status,WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"))
          else
            exit(true);
        end;
    end;


    procedure CheckIfPurchPostBlocked(WorkOrderNo: Code[20];ShowBlockError: Boolean) IsBlocked: Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if WorkOrderNo = '' then
          exit(false);
        FindWorkOrderByNo(WorkOrderNo,WorkOrder);
        exit(CheckIfPurchPostBlocked2(WorkOrder,ShowBlockError));
    end;


    procedure CheckIfPurchPostBlocked2(var WorkOrder: Record "MCH Work Order Header";ShowBlockError: Boolean) IsBlocked: Boolean
    begin
        if (WorkOrder.Status <> WorkOrder.Status::Released) then begin
          if ShowBlockError then
            WorkOrder.TestField(Status,WorkOrder.Status::Released)
          else
            exit(true);
        end;
        if WorkOrder."Progress Status Code" = '' then begin
          GetSetup;
          if AMSetup."WO Progress Status Mandatory" then
            WorkOrder.TestField("Progress Status Code");
          exit(false);
        end;
        GetWOProgressStatus(WorkOrder."Progress Status Code");
        if not WOProgressStatus."Block Purchase Posting" then
          exit(false)
        else begin
          if ShowBlockError then
            Error(
              StrSubstNo(Text007,WorkOrder.Status,WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"))
          else
            exit(true);
        end;
    end;


    procedure CheckIfInvtIssueBlocked(WorkOrderNo: Code[20];ShowBlockError: Boolean) IsBlocked: Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if WorkOrderNo = '' then
          exit(false);
        FindWorkOrderByNo(WorkOrderNo,WorkOrder);
        exit(CheckIfInvtIssueBlocked2(WorkOrder,ShowBlockError));
    end;


    procedure CheckIfInvtIssueBlocked2(var WorkOrder: Record "MCH Work Order Header";ShowBlockError: Boolean) IsBlocked: Boolean
    begin
        if (WorkOrder.Status <> WorkOrder.Status::Released) then begin
          if ShowBlockError then
            WorkOrder.TestField(Status,WorkOrder.Status::Released)
          else
            exit(true);
        end;
        if WorkOrder."Progress Status Code" = '' then begin
          GetSetup;
          if AMSetup."WO Progress Status Mandatory" then
            WorkOrder.TestField("Progress Status Code");
          exit(false);
        end;
        GetWOProgressStatus(WorkOrder."Progress Status Code");
        if not WOProgressStatus."Block Inventory Issue" then
          exit(false)
        else begin
          if ShowBlockError then
            Error(
              StrSubstNo(Text008,WorkOrder.Status,WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"))
          else
            exit(true);
        end;
    end;


    procedure CheckIfInvtReturnBlocked(WorkOrderNo: Code[20];ShowBlockError: Boolean) IsBlocked: Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if WorkOrderNo = '' then
          exit(false);
        FindWorkOrderByNo(WorkOrderNo,WorkOrder);
        exit(CheckIfInvtReturnBlocked2(WorkOrder,ShowBlockError));
    end;


    procedure CheckIfInvtReturnBlocked2(var WorkOrder: Record "MCH Work Order Header";ShowBlockError: Boolean) IsBlocked: Boolean
    begin
        if (WorkOrder.Status <> WorkOrder.Status::Released) then begin
          if ShowBlockError then
            WorkOrder.TestField(Status,WorkOrder.Status::Released)
          else
            exit(true);
        end;
        if WorkOrder."Progress Status Code" = '' then begin
          GetSetup;
          if AMSetup."WO Progress Status Mandatory" then
            WorkOrder.TestField("Progress Status Code");
          exit(false);
        end;
        GetWOProgressStatus(WorkOrder."Progress Status Code");
        if not WOProgressStatus."Block Inventory Return" then
          exit(false)
        else begin
          if ShowBlockError then
            Error(
              StrSubstNo(Text009,WorkOrder.Status,WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"))
          else
            exit(true);
        end;
    end;


    procedure CheckIfTimeEntryBlocked(WorkOrderNo: Code[20];ShowBlockError: Boolean) IsBlocked: Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if WorkOrderNo = '' then
          exit(false);
        FindWorkOrderByNo(WorkOrderNo,WorkOrder);
        exit(CheckIfTimeEntryBlocked2(WorkOrder,ShowBlockError));
    end;


    procedure CheckIfTimeEntryBlocked2(var WorkOrder: Record "MCH Work Order Header";ShowBlockError: Boolean) IsBlocked: Boolean
    begin
        if (WorkOrder.Status <> WorkOrder.Status::Released) then begin
          if ShowBlockError then
            WorkOrder.TestField(Status,WorkOrder.Status::Released)
          else
            exit(true);
        end;
        if WorkOrder."Progress Status Code" = '' then begin
          GetSetup;
          if AMSetup."WO Progress Status Mandatory" then
            WorkOrder.TestField("Progress Status Code");
          exit(false);
        end;
        GetWOProgressStatus(WorkOrder."Progress Status Code");
        if not WOProgressStatus."Block Timesheet Entry" then
          exit(false)
        else begin
          if ShowBlockError then
            Error(
              StrSubstNo(Text010,WorkOrder.Status,WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"))
          else
            exit(true);
        end;
    end;


    procedure CheckIfTimePostBlocked(WorkOrderNo: Code[20];ShowBlockError: Boolean) IsBlocked: Boolean
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if WorkOrderNo = '' then
          exit(false);
        FindWorkOrderByNo(WorkOrderNo,WorkOrder);
        exit(CheckIfTimePostBlocked2(WorkOrder,ShowBlockError));
    end;


    procedure CheckIfTimePostBlocked2(var WorkOrder: Record "MCH Work Order Header";ShowBlockError: Boolean) IsBlocked: Boolean
    begin
        if (WorkOrder.Status <> WorkOrder.Status::Released) then begin
          if ShowBlockError then
            WorkOrder.TestField(Status,WorkOrder.Status::Released)
          else
            exit(true);
        end;
        if WorkOrder."Progress Status Code" = '' then begin
          GetSetup;
          if AMSetup."WO Progress Status Mandatory" then
            WorkOrder.TestField("Progress Status Code");
          exit(false);
        end;
        GetWOProgressStatus(WorkOrder."Progress Status Code");
        if not WOProgressStatus."Block Timesheet Posting" then
          exit(false)
        else begin
          if ShowBlockError then
            Error(
              StrSubstNo(Text011,WorkOrder.Status,WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"))
          else
            exit(true);
        end;
    end;

    local procedure FindWorkOrderByNo(WorkOrderNo: Code[20];var TheWorkOrder: Record "MCH Work Order Header")
    begin
        Clear(TheWorkOrder);
        TheWorkOrder.SetCurrentKey("No.");
        TheWorkOrder.SetRange("No.",WorkOrderNo);
        TheWorkOrder.FindFirst;
    end;

    local procedure GetWOProgressStatus("Code": Code[20])
    begin
        if TempWOProgressStatus.Get(Code) then begin
          WOProgressStatus := TempWOProgressStatus;
          exit;
        end;
        WOProgressStatus.Get(Code);
        TempWOProgressStatus := WOProgressStatus;
        TempWOProgressStatus.Insert;
    end;


    procedure CheckWorkOrderDimensions(var WorkOrder: Record "MCH Work Order Header")
    var
        WorkOrderLine: Record "MCH Work Order Line";
        LineDimensionBlockedErr: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked';
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
        LineInvalidDimensionsErr: Label 'The dimensions used in %1 %2, line no. %3 are invalid';
    begin
        // Checking lines only
        WorkOrderLine.SetRange(Status,WorkOrder.Status);
        WorkOrderLine.SetRange("Work Order No.",WorkOrder."No.");
        if WorkOrderLine.FindSet then begin
          repeat
            if (WorkOrderLine."Asset No." <> '') then begin
              CheckDimComb(WorkOrderLine);
              CheckDimValuePosting(WorkOrderLine);
            end;
          until WorkOrderLine.Next = 0;
        end;
    end;

    local procedure CheckDimComb(WorkOrderLine: Record "MCH Work Order Line")
    var
        DimMgt: Codeunit DimensionManagement;
        DimCombWOLineErrMsg: Label 'The combination of dimensions used in Work Order %1, Line no. %2 is blocked. %3';
    begin
        if WorkOrderLine."Line No." <> 0 then
          if not DimMgt.CheckDimIDComb(WorkOrderLine."Dimension Set ID") then
            Error(DimCombWOLineErrMsg,WorkOrderLine."Work Order No.",WorkOrderLine."Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(WorkOrderLine: Record "MCH Work Order Line")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
        DimValueWOLineErrMsg: Label 'The dimensions that are used in Work Order %1, Line no. %2 are not valid. %3.';
    begin
        if WorkOrderLine."Line No." <> 0 then begin
          TableIDArr[1] := DATABASE::"MCH Maintenance Asset";
          NumberArr[1] := WorkOrderLine."Asset No.";
          TableIDArr[2] := DATABASE::"MCH Maintenance Location";
          NumberArr[2] := WorkOrderLine."Maint. Location Code";
          TableIDArr[3] := DATABASE::"MCH Work Order Type";
          NumberArr[3] := WorkOrderLine."Work Order Type";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,WorkOrderLine."Dimension Set ID") then
            Error(DimValueWOLineErrMsg,WorkOrderLine."Work Order No.",WorkOrderLine."Line No.",DimMgt.GetDimValuePostingErr);
        end;
    end;

    [TryFunction]

    procedure CheckIfRecordIsTableRelationReferenced(RecordVariant: Variant)
    var
        PrimaryKeyField: Record "Field";
        RelationField: Record "Field";
        SourceRecRef: RecordRef;
        SourceFieldRef: FieldRef;
        KeyRef: KeyRef;
        RefRecRef: RecordRef;
        RefRecFieldRef: FieldRef;
        i: Integer;
    begin
        SourceRecRef.GetTable(RecordVariant);
        if SourceRecRef.IsEmpty or SourceRecRef.IsTemporary then
          exit;
        if (not SourceRecRef.Find) then
          exit;
        KeyRef := SourceRecRef.KeyIndex(1);
        for i := 1 to KeyRef.FieldCount do begin
          if i > 1 then
            Error('DEV: Relationship check on rec delete can only be used for tables with 1 primary key field. Called for Tbl:%1',SourceRecRef.Number);
          SourceFieldRef := KeyRef.FieldIndex(i);
        end;
        PrimaryKeyField.Get(SourceRecRef.Number,SourceFieldRef.Number);
        RelationField.SetFilter(TableNo,'<>%1',SourceRecRef.Number);
        RelationField.SetFilter(ObsoleteState,'<>%1',RelationField.ObsoleteState::Removed);
        RelationField.SetRange(RelationTableNo,SourceRecRef.Number);
        RelationField.SetRange(Class,RelationField.Class::Normal);
        RelationField.SetRange(Type,PrimaryKeyField.Type);
        RelationField.SetRange(Len,PrimaryKeyField.Len);
        if RelationField.FindSet then begin
          repeat
            RefRecRef.Open(RelationField.TableNo);
            RefRecFieldRef := RefRecRef.Field(RelationField."No.");
            RefRecFieldRef.SetRange(SourceFieldRef.Value);
            if not RefRecRef.IsEmpty then
              Error(Text013,SourceRecRef.Caption,SourceFieldRef.Value,RefRecRef.Caption,RefRecFieldRef.Caption);
            RefRecRef.Close;
          until RelationField.Next = 0;
        end;
    end;


    procedure IsWorkOrderNoVisible(CurrDocNo: Code[20]) IsVisible: Boolean
    var
        WorkOrderHeader: Record "MCH Work Order Header";
        NoSeriesCode: Code[20];
    begin
        if CurrDocNo <> '' then
          exit(false);
        AMSetup.Get;
        CheckNumberSeries(WorkOrderHeader,AMSetup."Work Order Nos.",WorkOrderHeader.FieldNo("No."));
        NoSeriesCode := AMSetup."Work Order Nos.";
        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure IsMaintAssetNoVisible() IsVisible: Boolean
    var
        MaintenanceAsset: Record "MCH Maintenance Asset";
        NoSeriesCode: Code[20];
    begin
        AMSetup.Get;
        CheckNumberSeries(MaintenanceAsset,AMSetup."Asset Nos.",MaintenanceAsset.FieldNo("No."));
        NoSeriesCode := AMSetup."Asset Nos.";
        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure IsWorkInstructionNoVisible() IsVisible: Boolean
    var
        WorkInstructionHeader: Record "MCH Work Instruction Header";
        NoSeriesCode: Code[20];
    begin
        AMSetup.Get;
        CheckNumberSeries(WorkInstructionHeader,AMSetup."Work Instructions Nos.",WorkInstructionHeader.FieldNo("No."));
        NoSeriesCode := AMSetup."Work Instructions Nos.";
        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure IsMaintTaskCodeVisible() IsVisible: Boolean
    var
        MaintenanceProcedure: Record "MCH Master Maintenance Task";
        NoSeriesCode: Code[20];
    begin
        AMSetup.Get;
        CheckNumberSeries(MaintenanceProcedure,AMSetup."Maintenance Task Nos.",MaintenanceProcedure.FieldNo(Code));
        NoSeriesCode := AMSetup."Maintenance Task Nos.";
        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure IsSparePartNoVisible() IsVisible: Boolean
    var
        MaintenanceSparePart: Record "MCH Maintenance Spare Part";
        NoSeriesCode: Code[20];
    begin
        AMSetup.Get;
        CheckNumberSeries(MaintenanceSparePart,AMSetup."Spare Part Nos.",MaintenanceSparePart.FieldNo("No."));
        NoSeriesCode := AMSetup."Spare Part Nos.";
        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;

    local procedure ForceShowNoSeriesForDocNo(NoSeriesCode: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SeriesDate: Date;
    begin
        if not NoSeries.Get(NoSeriesCode) then
          exit(true);

        SeriesDate := WorkDate;
        NoSeriesRelationship.SetRange(Code,NoSeriesCode);
        if not NoSeriesRelationship.IsEmpty then
          exit(true);

        if NoSeries."Manual Nos." or (NoSeries."Default Nos." = false) then
          exit(true);

        exit(NoSeriesMgt.DoGetNextNo(NoSeriesCode,SeriesDate,false,true) = '');
    end;

    local procedure CheckNumberSeries(RecVariant: Variant;NoSeriesCode: Code[20];FieldNo: Integer)
    var
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        NewNo: Code[20];
    begin
        if RecVariant.IsRecord and (NoSeriesCode <> '') and NoSeries.Get(NoSeriesCode) then begin
          NewNo := NoSeriesMgt.DoGetNextNo(NoSeriesCode,0D,false,true);
          RecRef.GetTable(RecVariant);
          FieldRef := RecRef.Field(FieldNo);
          FieldRef.SetRange(NewNo);
          if RecRef.FindFirst then begin
            NoSeriesMgt.SaveNoSeries;
            CheckNumberSeries(RecRef,NoSeriesCode,FieldNo);
          end;
        end;
    end;


    procedure GeneralShowTypeAccCard(Type: Option " ",Item,"Spare Part",Cost,Resource,Team,Trade;"No.": Code[20])
    var
        Item: Record Item;
        SparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        MaintTrade: Record "MCH Maintenance Trade";
        Resource: Record Resource;
        MaintTeam: Record "MCH Maintenance Team";
    begin
        if ("No." = '') or (Type = Type::" ") then
          exit;
        case Type of
          Type::Item:
            begin
              Item.Get("No.");
              PAGE.Run(PAGE::"Item Card",Item);
            end;
          Type::"Spare Part":
            begin
              SparePart.Get("No.");
              PAGE.Run(PAGE::"MCH Maint. Spare Part Card",SparePart);
            end;
          Type::Cost:
            begin
              MaintCost.Get("No.");
              PAGE.Run(PAGE::"MCH Maint. Cost Card",MaintCost);
            end;
          Type::Trade:
            begin
              MaintTrade.Get("No.");
              PAGE.Run(PAGE::"MCH Maintenance Trade Card",MaintTrade);
            end;
          Type::Resource:
            begin
              Resource.Get("No.");
              PAGE.Run(PAGE::"Resource Card",Resource);
            end;
          Type::Team:
            begin
              MaintTeam.Get("No.");
              PAGE.Run(PAGE::"MCH Maintenance Team Card",MaintTeam);
            end;
        end;
    end;


    procedure GetTypeVisibility(var TypeItemVisible: Boolean;var TypeSparePartVisible: Boolean;var TypeCostVisible: Boolean;var TypeResourceVisible: Boolean;var TypeTeamVisible: Boolean;var TypeTradeVisible: Boolean)
    var
        SparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        MaintTrade: Record "MCH Maintenance Trade";
        MaintTeam: Record "MCH Maintenance Team";
    begin
        TypeItemVisible := true; // Always visible
        TypeSparePartVisible := not SparePart.IsEmpty;
        TypeCostVisible := not MaintCost.IsEmpty;
        TypeResourceVisible := true; // Always visible
        TypeTeamVisible := not MaintTeam.IsEmpty;
        TypeTradeVisible := not MaintTrade.IsEmpty;
    end;
}

