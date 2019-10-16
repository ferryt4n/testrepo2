codeunit 74032 "MCH AM Suggest Wizard Helper"
{

    trigger OnRun()
    begin
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MultiSelectedWorkOrder: Record "MCH Work Order Header";
        NextBufferEntryNo: Integer;
        [InDataSet]
        ForMultipleWorkOrder: Boolean;
        WorkOrderNoFilter: Text;
        WOTypeFilter: Text;
        ProgressStatusFilter: Text;
        MaintLocationFilter: Text;
        AssetRespGroupFilter: Text;
        PersonReponsibleFilter: Text;
        AssignedToUserIDFilter: Text;
        DefaultPurchOrderVendorNo: Code[20];
        VendorNoFilter: Text;
        StartingDateFilter: Text;
        MaintAssetFilter: Text;
        IncludeSparePart: Boolean;
        SparePartFilter: Text;
        IncludeMaintCost: Boolean;
        MaintCostFilter: Text;
        IncludeTrade: Boolean;
        TradeFilter: Text;
        ItemNoFilter: Text;
        LocationCodeFilter: Text;
        CreatedPurchOrderNoFilter: Text;


    procedure PurchaseCalculateSuggestion(var Buffer: Record "MCH AM Purch. Suggest Buffer" temporary)
    var
        WorkOrder: Record "MCH Work Order Header";
        BudgetLine: Record "MCH Work Order Budget Line";
        WOProgressStatus: Record "MCH Work Order Progress Status";
        Continue: Boolean;
        Win: Dialog;
        ProgressDialogText: Label '\Reading work order budget lines...\Work Order #1########';
    begin
        Buffer.Reset;
        Buffer.DeleteAll;

        AMSetup.Get;
        if ForMultipleWorkOrder then begin
          WorkOrder.Copy(MultiSelectedWorkOrder);
        end else begin
          PurchaseApplyWorkOrderFilters(WorkOrder);
        end;
        WorkOrder.SetSecurityFilterOnResponsibilityGroup(99);
        WorkOrder.FilterGroup(99);
        WorkOrder.SetRange(Status,WorkOrder.Status::Released);
        if AMSetup."Work Order Type Mandatory" then
          WorkOrder.SetFilter("Work Order Type",'<>%1','');
        if AMSetup."WO Progress Status Mandatory" then
          WorkOrder.SetFilter("Progress Status Code",'<>%1','');
        if AMSetup."WO Person Respons. Mandatory" then
          WorkOrder.SetFilter("Person Responsible",'<>%1','');
        WorkOrder.FilterGroup(0);

        if not WorkOrder.FindSet then
          exit;
        Win.Open(ProgressDialogText);
        NextBufferEntryNo := 0;
        repeat
          Win.Update(1,WorkOrder."No.");
          Continue := true;
          if (WorkOrder."Progress Status Code" <> '') then begin
            WOProgressStatus.Get(WorkOrder."Progress Status Code");
            Continue :=
              (not WOProgressStatus."Block Additional Purchasing") and
              WOProgressStatus."Allow on Released WO";
          end;
          if Continue then begin
            BudgetLine.Reset;
            BudgetLine.SetCurrentKey(Status,"Work Order No.",Type,"No.");
            BudgetLine.SetRange(Status,BudgetLine.Status::Released);
            BudgetLine.SetRange("Work Order No.",WorkOrder."No.");
            BudgetLine.SetFilter("Asset No.",MaintAssetFilter);
            BudgetLine.SetFilter("Vendor No.",VendorNoFilter);
            BudgetLine.SetFilter("Starting Date",StartingDateFilter);

            if IncludeSparePart then begin
              BudgetLine.SetRange(Type,BudgetLine.Type::"Spare Part");
              BudgetLine.SetFilter("No.",SparePartFilter);
              PurchaseProcessBudgetLine(Buffer,BudgetLine,WorkOrder);
            end;
            if IncludeMaintCost then begin
              BudgetLine.SetRange(Type,BudgetLine.Type::Cost);
              BudgetLine.SetFilter("No.",MaintCostFilter);
              PurchaseProcessBudgetLine(Buffer,BudgetLine,WorkOrder);
            end;
            if IncludeTrade then begin
              BudgetLine.SetRange(Type,BudgetLine.Type::Trade);
              BudgetLine.SetFilter("No.",TradeFilter);
              PurchaseProcessBudgetLine(Buffer,BudgetLine,WorkOrder);
            end;
          end;
        until WorkOrder.Next = 0;
        Win.Close;
    end;

    local procedure PurchaseProcessBudgetLine(var Buffer: Record "MCH AM Purch. Suggest Buffer" temporary;var BudgetLine: Record "MCH Work Order Budget Line";var WorkOrder: Record "MCH Work Order Header")
    begin
        BudgetLine.SetAutoCalcFields("Posted Qty. (Base)","Purch. Order Qty. Outst.");
        if not BudgetLine.FindSet then
          exit;
        repeat
          if (BudgetLine."No." <> '') and (BudgetLine.Quantity > 0) then begin
            BudgetLine.TestField("Qty. per Unit of Measure");
            if ((BudgetLine."Quantity (Base)" - BudgetLine."Posted Qty. (Base)" - BudgetLine."Purch. Order Qty. Outst.") > 0) then
              PurchaseTransferBudgetLineToBuffer(Buffer,BudgetLine,WorkOrder);
          end;
        until BudgetLine.Next = 0;
    end;

    local procedure PurchaseTransferBudgetLineToBuffer(var Buffer: Record "MCH AM Purch. Suggest Buffer" temporary;var BudgetLine: Record "MCH Work Order Budget Line";var WorkOrder: Record "MCH Work Order Header")
    begin
        NextBufferEntryNo := NextBufferEntryNo + 1;
        Buffer."Entry No." := NextBufferEntryNo;
        Buffer.Init;
        with BudgetLine do begin
          Buffer."Work Order No." := "Work Order No.";
          Buffer."Budget Line No." := "Line No.";
          Buffer."Asset No." := "Asset No.";
          Buffer."Work Order Line No." := "Work Order Line No.";
          Buffer."Maint. Task Code" := "Maint. Task Code";
          Buffer.Type := Type;
          Buffer."No." := "No.";
          Buffer.Description := Description;
          Buffer."Description 2" := "Description 2";
          Buffer."Direct Unit Cost" := "Direct Unit Cost";
          Buffer."Unit Cost" := "Unit Cost";
          Buffer."Cost Amount" := "Cost Amount";
          Buffer."Unit of Measure Code" := "Unit of Measure Code";
          Buffer."Qty. per Unit of Measure" := "Qty. per Unit of Measure";

          Buffer."Budget Quantity" := Quantity;
          Buffer."Budget Qty. (Base)" := "Quantity (Base)";
          Buffer."Order Qty. Outst. (Base)" := "Purch. Order Qty. Outst.";
          Buffer."Order Qty. Outstanding" := Buffer.CalcUnitOfMeasureQtyFromBase(Buffer."Order Qty. Outst. (Base)",Buffer."Qty. per Unit of Measure");
          Buffer."Received Qty. (Base)" := "Posted Qty. (Base)";
          Buffer."Received Quantity" := Buffer.CalcUnitOfMeasureQtyFromBase(Buffer."Received Qty. (Base)",Buffer."Qty. per Unit of Measure");
          Buffer."Remaining Budget Qty." := Buffer."Budget Quantity" - Buffer."Received Quantity" - Buffer."Order Qty. Outstanding";
          Buffer."Quantity to Order" := Buffer."Remaining Budget Qty.";
          Buffer."Quantity to Order (Base)" := Buffer.CalcBaseQty(Buffer."Quantity to Order",Buffer."Qty. per Unit of Measure");

          Buffer."Vendor No." := "Vendor No.";
          Buffer."Org. Budget Vendor No." := "Vendor No.";
          Buffer."Default Vendor No." := DefaultPurchOrderVendorNo;

          Buffer.Hours := Hours;
          Buffer."Starting Date" := "Starting Date";
          Buffer."Ending Date" := "Ending Date";
          Buffer."Item No." := "Item No.";
          Buffer."Work Order Type" := WorkOrder."Work Order Type";
          Buffer."Progress Status Code" := WorkOrder."Progress Status Code";
          Buffer."Maint. Location Code" := WorkOrder."Maint. Location Code";
          Buffer."Responsibility Group Code" := WorkOrder."Responsibility Group Code";
          Buffer.Insert;
        end;
    end;


    procedure PurchaseSetWorkOrderParameters(var MultiSelectedWorkOrder2: Record "MCH Work Order Header";ForMultipleWorkOrder2: Boolean;WorkOrderNoFilter2: Text;WOTypeFilter2: Text;ProgressStatusFilter2: Text;MaintLocationFilter2: Text;AssetRespGroupFilter2: Text;PersonReponsibleFilter2: Text;AssignedToUserIDFilter2: Text)
    begin
        MultiSelectedWorkOrder.Copy(MultiSelectedWorkOrder2);
        ForMultipleWorkOrder := ForMultipleWorkOrder2;
        WorkOrderNoFilter := WorkOrderNoFilter2;
        WOTypeFilter := WOTypeFilter2;
        ProgressStatusFilter := ProgressStatusFilter2;
        MaintLocationFilter := MaintLocationFilter2;
        AssetRespGroupFilter := AssetRespGroupFilter2;
        PersonReponsibleFilter := PersonReponsibleFilter2;
        AssignedToUserIDFilter := AssignedToUserIDFilter2;
    end;


    procedure PurchaseSetBudgetParameters(DefaultPurchOrderVendorNo2: Code[20];VendorNoFilter2: Text;StartingDateFilter2: Text;MaintAssetFilter2: Text;IncludeSparePart2: Boolean;SparePartFilter2: Text;IncludeMaintCost2: Boolean;MaintCostFilter2: Text;IncludeTrade2: Boolean;TradeFilter2: Text)
    begin
        DefaultPurchOrderVendorNo := DefaultPurchOrderVendorNo2;
        VendorNoFilter := VendorNoFilter2;
        StartingDateFilter := StartingDateFilter2;
        MaintAssetFilter := MaintAssetFilter2;
        IncludeSparePart := IncludeSparePart2;
        SparePartFilter := SparePartFilter2;
        IncludeMaintCost := IncludeMaintCost2;
        MaintCostFilter := MaintCostFilter2;
        IncludeTrade := IncludeTrade2;
        TradeFilter := TradeFilter2;
    end;

    local procedure PurchaseApplyWorkOrderFilters(var WorkOrder: Record "MCH Work Order Header")
    begin
        WorkOrder.SetFilter("No.",WorkOrderNoFilter);
        WorkOrder.SetFilter("Work Order Type",WOTypeFilter);
        WorkOrder.SetFilter("Progress Status Code",ProgressStatusFilter);
        WorkOrder.SetFilter("Maint. Location Code",MaintLocationFilter);
        WorkOrder.SetFilter("Responsibility Group Code",AssetRespGroupFilter);
        WorkOrder.SetFilter("Person Responsible",PersonReponsibleFilter);
        WorkOrder.SetFilter("Assigned User ID",AssignedToUserIDFilter);
    end;


    procedure PreCheckWorkOrderForPurchasing(WorkOrder: Record "MCH Work Order Header")
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        AMSetup.Get;
        WorkOrder.TestField(Status,WorkOrder.Status::Released);
        if AMSetup."Work Order Type Mandatory" then
          WorkOrder.TestField("Work Order Type");
        if AMSetup."WO Person Respons. Mandatory" then
          WorkOrder.TestField("Person Responsible");
        AMFunctions.CheckIfPurchEntryBlocked2(WorkOrder,true);
    end;


    procedure CreatePurchase(var Buffer: Record "MCH AM Purch. Suggest Buffer" temporary;AddToExistingPurchOrder: Boolean;ExistingPurchOrderNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        NextLineNo: Integer;
    begin
        Buffer.Reset;
        Buffer.SetRange(Selected,true);
        Buffer.SetCurrentKey("Vendor No.");
        CreatedPurchOrderNoFilter := '';

        if AddToExistingPurchOrder then begin
          PurchHeader.Get(PurchHeader."Document Type"::Order,ExistingPurchOrderNo);
          PurchHeader.TestStatusOpen;
          PurchHeader.TestField("Buy-from Vendor No.");

          PurchLine.SetRange("Document Type",PurchHeader."Document Type");
          PurchLine.SetRange("Document No.",PurchHeader."No.");
          if PurchLine.FindLast then
            NextLineNo := PurchLine."Line No.";
        end;

        Buffer.FindSet;
        repeat
          if (Buffer."Vendor No." <> PurchHeader."Buy-from Vendor No.") then begin
            PurchHeader.Init;
            PurchHeader."No." := '';
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader.Insert(true);
            PurchHeader.Validate("Buy-from Vendor No.",Buffer."Vendor No.");
            PurchHeader.Modify;
            BuildCreatedPurchOrderNoFilter(CreatedPurchOrderNoFilter,PurchHeader."No.");
            NextLineNo := 0;
          end;
          InsertPurchaseOrderLine(Buffer,PurchHeader,NextLineNo);
        until Buffer.Next = 0;
    end;

    local procedure InsertPurchaseOrderLine(var Buffer: Record "MCH AM Purch. Suggest Buffer" temporary;var PurchHeader: Record "Purchase Header";var NextLineNo: Integer)
    var
        PurchLine: Record "Purchase Line";
    begin
        NextLineNo := NextLineNo + 10000;
        with PurchLine do begin
          Init;
          "Document Type" := PurchHeader."Document Type";
          "Document No." := PurchHeader."No.";
          "Line No." := NextLineNo;
          Insert(true);

          Validate("MCH Work Order No.",Buffer."Work Order No.");
          Validate("MCH WO Budget Line No.",Buffer."Budget Line No.");

          if ("Unit of Measure Code" <> Buffer."Unit of Measure Code") then
            Validate("Unit of Measure Code", Buffer."Unit of Measure Code");
          if (Quantity <> Buffer."Quantity to Order") then
            Validate(Quantity, Buffer."Quantity to Order");
          Modify(true);
        end;
    end;

    local procedure BuildCreatedPurchOrderNoFilter(var InitialFilter: Text;NewValue: Text)
    begin
        if StrPos(InitialFilter,NewValue) = 0 then begin
          if StrLen(InitialFilter) > 0 then
            InitialFilter += '|';
          InitialFilter += NewValue;
        end;
    end;


    procedure GetCreatedPurchOrderNoFilter() NewCreatedPurchOrderNoFilter: Text
    begin
        exit(CreatedPurchOrderNoFilter);
    end;


    procedure InvtIssueCalculateSuggestion(var Buffer: Record "MCH AM Invt. Issue Suggest Buf" temporary)
    var
        WorkOrder: Record "MCH Work Order Header";
        BudgetLine: Record "MCH Work Order Budget Line";
        WOProgressStatus: Record "MCH Work Order Progress Status";
        Continue: Boolean;
        Win: Dialog;
        ProgressDialogText: Label '\Reading work order budget lines...\Work Order #1########';
    begin
        Buffer.Reset;
        Buffer.DeleteAll;

        AMSetup.Get;
        if ForMultipleWorkOrder then begin
          WorkOrder.Copy(MultiSelectedWorkOrder);
        end else begin
          InvtIssueApplyWorkOrderFilters(WorkOrder);
        end;
        WorkOrder.SetSecurityFilterOnResponsibilityGroup(99);
        WorkOrder.FilterGroup(99);
        WorkOrder.SetRange(Status,WorkOrder.Status::Released);
        if AMSetup."Work Order Type Mandatory" then
          WorkOrder.SetFilter("Work Order Type",'<>%1','');
        if AMSetup."WO Progress Status Mandatory" then
          WorkOrder.SetFilter("Progress Status Code",'<>%1','');
        if AMSetup."WO Person Respons. Mandatory" then
          WorkOrder.SetFilter("Person Responsible",'<>%1','');
        WorkOrder.FilterGroup(0);

        if not WorkOrder.FindSet then
          exit;
        Win.Open(ProgressDialogText);
        NextBufferEntryNo := 0;
        repeat
          Win.Update(1,WorkOrder."No.");
          Continue := true;
          if (WorkOrder."Progress Status Code" <> '') then begin
            WOProgressStatus.Get(WorkOrder."Progress Status Code");
            Continue :=
              (not WOProgressStatus."Block Inventory Issue") and
              WOProgressStatus."Allow on Released WO";
          end;
          if Continue then begin
            BudgetLine.Reset;
            BudgetLine.SetCurrentKey(Status,"Work Order No.",Type,"No.");
            BudgetLine.SetRange(Status,BudgetLine.Status::Released);
            BudgetLine.SetRange("Work Order No.",WorkOrder."No.");
            BudgetLine.SetFilter("Asset No.",MaintAssetFilter);
            BudgetLine.SetFilter("Starting Date",StartingDateFilter);
            BudgetLine.SetRange(Type,BudgetLine.Type::Item);
            BudgetLine.SetFilter("No.",ItemNoFilter);
            BudgetLine.SetFilter("Location Code",LocationCodeFilter);

            InvtIssueProcessBudgetLine(Buffer,BudgetLine,WorkOrder);
          end;
        until WorkOrder.Next = 0;
        Win.Close;
    end;

    local procedure InvtIssueProcessBudgetLine(var Buffer: Record "MCH AM Invt. Issue Suggest Buf" temporary;var BudgetLine: Record "MCH Work Order Budget Line";var WorkOrder: Record "MCH Work Order Header")
    var
        MaintJnlLine: Record "MCH Maint. Journal Line";
        TotalQtyBaseOnJnlLine: Decimal;
    begin
        BudgetLine.SetAutoCalcFields("Posted Qty. (Base)");
        if not BudgetLine.FindSet then
          exit;
        repeat
          if (BudgetLine."No." <> '') and (BudgetLine.Quantity > 0) then begin
            BudgetLine.TestField("Qty. per Unit of Measure");

            TotalQtyBaseOnJnlLine := 0;
            MaintJnlLine.SetCurrentKey("Work Order No.","Work Order Line No.","Work Order Budget Line No.");
            MaintJnlLine.SetRange("Work Order No.",BudgetLine."Work Order No.");
            MaintJnlLine.SetRange("Work Order Line No.",BudgetLine."Work Order Line No.");
            MaintJnlLine.SetRange("Work Order Budget Line No.",BudgetLine."Line No.");
            if (not MaintJnlLine.IsEmpty) then begin
              MaintJnlLine.SetRange("Entry Type",MaintJnlLine."Entry Type"::Issue);
              MaintJnlLine.CalcSums("Quantity (Base)");
              TotalQtyBaseOnJnlLine := MaintJnlLine."Quantity (Base)";
              MaintJnlLine.SetRange("Entry Type",MaintJnlLine."Entry Type"::Return);
              MaintJnlLine.CalcSums("Quantity (Base)");
              TotalQtyBaseOnJnlLine := TotalQtyBaseOnJnlLine - MaintJnlLine."Quantity (Base)";
            end;

            if ((BudgetLine."Quantity (Base)" - BudgetLine."Posted Qty. (Base)" - TotalQtyBaseOnJnlLine) > 0) then
              InvtIssueTransferBudgetLineToBuffer(Buffer,BudgetLine,WorkOrder,TotalQtyBaseOnJnlLine);
          end;
        until BudgetLine.Next = 0;
    end;

    local procedure InvtIssueTransferBudgetLineToBuffer(var Buffer: Record "MCH AM Invt. Issue Suggest Buf" temporary;var BudgetLine: Record "MCH Work Order Budget Line";var WorkOrder: Record "MCH Work Order Header";TotalQtyBaseOnJnlLine: Decimal)
    begin
        NextBufferEntryNo := NextBufferEntryNo + 1;
        Buffer."Entry No." := NextBufferEntryNo;
        Buffer.Init;
        with BudgetLine do begin
          Buffer."Work Order No." := "Work Order No.";
          Buffer."Budget Line No." := "Line No.";
          Buffer."Asset No." := "Asset No.";
          Buffer."Work Order Line No." := "Work Order Line No.";
          Buffer."Maint. Task Code" := "Maint. Task Code";
          Buffer."Item No." := "No.";
          Buffer."Variant Code" := "Variant Code";
          Buffer.Description := Description;
          Buffer."Description 2" := "Description 2";
          Buffer."Unit of Measure Code" := "Unit of Measure Code";
          Buffer."Qty. per Unit of Measure" := "Qty. per Unit of Measure";

          Buffer."Budget Quantity" := Quantity;
          Buffer."Budget Qty. (Base)" := "Quantity (Base)";
          Buffer."Journal Line Qty. (Base)" := TotalQtyBaseOnJnlLine;
          Buffer."Journal Line Quantity" := Buffer.CalcUnitOfMeasureQtyFromBase(Buffer."Journal Line Qty. (Base)",Buffer."Qty. per Unit of Measure");

          Buffer."Issued Qty. (Base)" := "Posted Qty. (Base)";
          Buffer."Issued Quantity" := Buffer.CalcUnitOfMeasureQtyFromBase(Buffer."Issued Qty. (Base)",Buffer."Qty. per Unit of Measure");
          Buffer."Remaining Budget Qty." := Buffer."Budget Quantity" - Buffer."Issued Quantity" - Buffer."Journal Line Quantity";

          Buffer."Quantity to Issue" := Buffer."Remaining Budget Qty.";
          Buffer."Quantity to Issue (Base)" := Buffer.CalcBaseQty(Buffer."Quantity to Issue",Buffer."Qty. per Unit of Measure");

          Buffer."Starting Date" := "Starting Date";
          Buffer."Ending Date" := "Ending Date";
          Buffer."Work Order Type" := WorkOrder."Work Order Type";
          Buffer."Progress Status Code" := WorkOrder."Progress Status Code";
          Buffer."Maint. Location Code" := WorkOrder."Maint. Location Code";
          Buffer."Responsibility Group Code" := WorkOrder."Responsibility Group Code";
          Buffer.Insert;
        end;
    end;


    procedure InvtIssueSetWorkOrderParameters(var MultiSelectedWorkOrder2: Record "MCH Work Order Header";ForMultipleWorkOrder2: Boolean;WorkOrderNoFilter2: Text;WOTypeFilter2: Text;ProgressStatusFilter2: Text;MaintLocationFilter2: Text;AssetRespGroupFilter2: Text;PersonReponsibleFilter2: Text;AssignedToUserIDFilter2: Text)
    begin
        MultiSelectedWorkOrder.Copy(MultiSelectedWorkOrder2);
        ForMultipleWorkOrder := ForMultipleWorkOrder2;
        WorkOrderNoFilter := WorkOrderNoFilter2;
        WOTypeFilter := WOTypeFilter2;
        ProgressStatusFilter := ProgressStatusFilter2;
        MaintLocationFilter := MaintLocationFilter2;
        AssetRespGroupFilter := AssetRespGroupFilter2;
        PersonReponsibleFilter := PersonReponsibleFilter2;
        AssignedToUserIDFilter := AssignedToUserIDFilter2;
    end;


    procedure InvtIssueSetBudgetParameters(ItemNoFilter2: Text;LocationCodeFilter2: Text;StartingDateFilter2: Text;MaintAssetFilter2: Text)
    begin
        ItemNoFilter := ItemNoFilter2;
        LocationCodeFilter := LocationCodeFilter2;
        StartingDateFilter := StartingDateFilter2;
        MaintAssetFilter := MaintAssetFilter2;
    end;

    local procedure InvtIssueApplyWorkOrderFilters(var WorkOrder: Record "MCH Work Order Header")
    begin
        WorkOrder.SetFilter("No.",WorkOrderNoFilter);
        WorkOrder.SetFilter("Work Order Type",WOTypeFilter);
        WorkOrder.SetFilter("Progress Status Code",ProgressStatusFilter);
        WorkOrder.SetFilter("Maint. Location Code",MaintLocationFilter);
        WorkOrder.SetFilter("Responsibility Group Code",AssetRespGroupFilter);
        WorkOrder.SetFilter("Person Responsible",PersonReponsibleFilter);
        WorkOrder.SetFilter("Assigned User ID",AssignedToUserIDFilter);
    end;


    procedure PreCheckWorkOrderForInvtIssue(WorkOrder: Record "MCH Work Order Header")
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        AMSetup.Get;
        WorkOrder.TestField(Status,WorkOrder.Status::Released);
        if AMSetup."Work Order Type Mandatory" then
          WorkOrder.TestField("Work Order Type");
        if AMSetup."WO Person Respons. Mandatory" then
          WorkOrder.TestField("Person Responsible");
        AMFunctions.CheckIfInvtIssueBlocked2(WorkOrder,true);
    end;


    procedure CreateInvtIssueJnlLines(var Buffer: Record "MCH AM Invt. Issue Suggest Buf" temporary;MaintJnlBatch: Record "MCH Maint. Journal Batch";IssueToResourceNo: Code[20];LocationCode: Code[10])
    var
        MaintJnlLine: Record "MCH Maint. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextLineNo: Integer;
        DocumentNo: Code[20];
        PostingDate: Date;
    begin
        AMSetup.Get;
        MaintJnlBatch.Get(MaintJnlBatch."Journal Template Name",MaintJnlBatch.Name);
        MaintJnlLine.SetRange("Journal Template Name",MaintJnlBatch."Journal Template Name");
        MaintJnlLine.SetRange("Journal Batch Name",MaintJnlBatch.Name);
        PostingDate := WorkDate;
        if MaintJnlLine.FindLast then begin
          NextLineNo := MaintJnlLine."Line No.";
          if (IssueToResourceNo = '') then
            IssueToResourceNo := MaintJnlLine."Resource No. (Issue/Return)";
          if not AMSetup."Use WO No. as Posting Doc. No." then
            DocumentNo := MaintJnlLine."Document No.";
        end else begin
          if not AMSetup."Use WO No. as Posting Doc. No." then
            if (MaintJnlBatch."No. Series" <> '') then
              DocumentNo := NoSeriesMgt.GetNextNo(MaintJnlBatch."No. Series",PostingDate,false);
        end;

        Buffer.Reset;
        Buffer.SetRange(Selected,true);
        if not Buffer.FindSet then
          exit;
        MaintJnlLine."Journal Template Name" := MaintJnlBatch."Journal Template Name";
        MaintJnlLine."Journal Batch Name" := MaintJnlBatch.Name;
        repeat
          NextLineNo := NextLineNo + 10000;
          MaintJnlLine."Line No." := NextLineNo;
          MaintJnlLine.Init;
          MaintJnlLine.Insert(true);
          MaintJnlLine."Posting Date" := PostingDate;
          MaintJnlLine."Document Date" := PostingDate;
          MaintJnlLine."Document No." := DocumentNo;
          MaintJnlLine."Reason Code" := MaintJnlBatch."Reason Code";
          MaintJnlLine."Posting No. Series" := MaintJnlBatch."Posting No. Series";
          MaintJnlLine."Entry Type" := MaintJnlLine."Entry Type"::Issue;

          MaintJnlLine.Validate("Work Order No.",Buffer."Work Order No.");
          MaintJnlLine.Validate("Work Order Line No.",Buffer."Work Order Line No.");
          MaintJnlLine.Validate("Work Order Budget Line No.",Buffer."Budget Line No.");

          if (MaintJnlLine."Unit of Measure Code" <> Buffer."Unit of Measure Code") then
            MaintJnlLine.Validate("Unit of Measure Code", Buffer."Unit of Measure Code");
          if (MaintJnlLine.Quantity <> Buffer."Quantity to Issue") then
            MaintJnlLine.Validate(Quantity, Buffer."Quantity to Issue");
          if (LocationCode <> '') and (MaintJnlLine."Location Code" <> LocationCode) then begin
            if (not MaintJnlLine.IsItemNonInventoriable(MaintJnlLine."No.")) then
              MaintJnlLine.Validate("Location Code",LocationCode);
          end;
          MaintJnlLine."Resource No. (Issue/Return)" := IssueToResourceNo;
          MaintJnlLine.Modify;
        until Buffer.Next = 0;
    end;
}

