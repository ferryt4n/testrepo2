codeunit 74054 "MCH AM BC BaseApp Event Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        WorkOrderLine: Record "MCH Work Order Line";

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterRecreatePurchLine', '', false, false)]
    local procedure PurchaseHeaderOnAfterRecreatePurchLine(var PurchLine: Record "Purchase Line";var TempPurchLine: Record "Purchase Line" temporary)
    begin
        if (TempPurchLine."MCH Work Order No." = '') then
          exit;
        PurchLine."MCH Work Order No." := TempPurchLine."MCH Work Order No.";
        PurchLine."MCH Work Order Line No." := TempPurchLine."MCH Work Order Line No.";
        PurchLine."MCH WO Budget Line No." := TempPurchLine."MCH WO Budget Line No.";
        PurchLine."MCH WO Purchase Type" := TempPurchLine."MCH WO Purchase Type";
        PurchLine."MCH WO Purchase Code" := TempPurchLine."MCH WO Purchase Code";
        if (PurchLine."MCH WO Purchase Code" <> '') then begin
          if (PurchLine."Gen. Prod. Posting Group" <> TempPurchLine."Gen. Prod. Posting Group") then
            PurchLine.Validate("Gen. Prod. Posting Group",TempPurchLine."Gen. Prod. Posting Group");
          if (PurchLine."Expected Receipt Date" <> TempPurchLine."Expected Receipt Date") then
            PurchLine.Validate("Expected Receipt Date",TempPurchLine."Expected Receipt Date");
          if (PurchLine."Requested Receipt Date" <> TempPurchLine."Requested Receipt Date") then
            PurchLine.Validate("Requested Receipt Date",TempPurchLine."Requested Receipt Date");

          if (PurchLine."Currency Code" = TempPurchLine."Currency Code") and (TempPurchLine."Direct Unit Cost" <> 0) then
            PurchLine.Validate("Direct Unit Cost",TempPurchLine."Direct Unit Cost");
        end;
        PurchLine.MCHUpdateDimensionsFromWorkOrderLine(PurchLine);
        PurchLine.Modify;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure ItemJnlLineOnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line";PurchLine: Record "Purchase Line")
    begin
        with PurchLine do begin
          if ("MCH Work Order No." <> '') then begin
            ItemJnlLine."MCH Work Order No." := "MCH Work Order No.";
            ItemJnlLine."MCH Work Order Line No." := "MCH Work Order Line No.";
            ItemJnlLine."MCH WO Budget Line No." := "MCH WO Budget Line No.";
            ItemJnlLine."MCH WO Purchase Type" := "MCH WO Purchase Type";
            ItemJnlLine."MCH WO Purchase Code" := "MCH WO Purchase Code";
            if WorkOrderLine.Get(WorkOrderLine.Status::Released,"MCH Work Order No.","MCH Work Order Line No.") then
              ItemJnlLine."MCH Maint. Asset No." := WorkOrderLine."Asset No.";
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5813, 'OnAfterCopyItemJnlLineFromPurchRcpt', '', false, false)]
    local procedure UndoPurchReceiptLineOnAfterCopyItemJnlLineFromPurchRcpt(var ItemJournalLine: Record "Item Journal Line";PurchRcptHeader: Record "Purch. Rcpt. Header";PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        with PurchRcptLine do begin
          if ("MCH Work Order No." <> '') then begin
            ItemJournalLine."MCH Work Order No." := "MCH Work Order No.";
            ItemJournalLine."MCH Work Order Line No." := "MCH Work Order Line No.";
            ItemJournalLine."MCH WO Budget Line No." := "MCH WO Budget Line No.";
            ItemJournalLine."MCH WO Purchase Type" := "MCH WO Purchase Type";
            ItemJournalLine."MCH WO Purchase Code" := "MCH WO Purchase Code";
            if WorkOrderLine.Get(WorkOrderLine.Status::Released,"MCH Work Order No.","MCH Work Order Line No.") then
              ItemJournalLine."MCH Maint. Asset No." := WorkOrderLine."Asset No.";
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure ItemJnlPostLineOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry";ItemJournalLine: Record "Item Journal Line")
    begin
        with ItemJournalLine do begin
          if ("MCH Work Order No." <> '') then begin
            NewItemLedgEntry."MCH Work Order No." := "MCH Work Order No.";
            NewItemLedgEntry."MCH Work Order Line No." := "MCH Work Order Line No.";
            NewItemLedgEntry."MCH WO Budget Line No." := "MCH WO Budget Line No.";
            NewItemLedgEntry."MCH WO Purchase Type" := "MCH WO Purchase Type";
            NewItemLedgEntry."MCH WO Purchase Code" := "MCH WO Purchase Code";
            NewItemLedgEntry."MCH Maint. Asset No." := "MCH Maint. Asset No.";
            NewItemLedgEntry."MCH AM Ledger Entry No." := "MCH AM Ledger Entry No.";
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure ItemJnlPostLineOnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line";ItemLedgerEntry: Record "Item Ledger Entry")
    var
        AMPurchPostManager: Codeunit "MCH AM Purchase Post Manager";
    begin
        if (ItemLedgerEntry."MCH Work Order No." = '') then
          exit;
        case ItemLedgerEntry."Entry Type" of
          ItemLedgerEntry."Entry Type"::Purchase:
            begin
              AMPurchPostManager.BufferItemLedgEntryToHandled(ItemLedgerEntry);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 203, 'OnAfterCopyFromResJnlLine', '', false, false)]
    local procedure ResLedgerEntryCopyFromResJnlLine(var ResLedgerEntry: Record "Res. Ledger Entry";ResJournalLine: Record "Res. Journal Line")
    begin
        with ResJournalLine do begin
          if ("MCH Work Order No." <> '') then begin
            ResLedgerEntry."MCH Work Order No." := "MCH Work Order No.";
            ResLedgerEntry."MCH Work Order Line No." := "MCH Work Order Line No.";
            ResLedgerEntry."MCH WO Budget Line No." := "MCH WO Budget Line No.";
            ResLedgerEntry."MCH Maint. Asset No." := "MCH Maint. Asset No.";
            ResLedgerEntry."MCH AM Ledger Entry No." := "MCH AM Ledger Entry No.";
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 352, 'OnAfterUpdateGlobalDimCode', '', false, false)]
    local procedure DefaultDimOnAfterUpdateGlobalDimCode(GlobalDimCodeNo: Integer;TableID: Integer;AccNo: Code[20];NewDimValue: Code[20])
    var
        MaintAsset: Record "MCH Maintenance Asset";
        MaintLocation: Record "MCH Maintenance Location";
        WorkOrderType: Record "MCH Work Order Type";
    begin
        if not (GlobalDimCodeNo in [1,2]) then
          exit;
        case TableID of
          DATABASE::"MCH Maintenance Asset":
            with MaintAsset do begin
              if Get(AccNo) then begin
                case GlobalDimCodeNo of
                  1: "Global Dimension 1 Code" := NewDimValue;
                  2: "Global Dimension 2 Code" := NewDimValue;
                end;
                Modify(true);
              end;
            end;
          DATABASE::"MCH Maintenance Location":
            with MaintLocation do begin
              if Get(AccNo) then begin
                case GlobalDimCodeNo of
                  1: "Global Dimension 1 Code" := NewDimValue;
                  2: "Global Dimension 2 Code" := NewDimValue;
                end;
                Modify(true);
              end;
            end;
          DATABASE::"MCH Work Order Type":
            with WorkOrderType do begin
              if Get(AccNo) then begin
                case GlobalDimCodeNo of
                  1: "Global Dimension 1 Code" := NewDimValue;
                  2: "Global Dimension 2 Code" := NewDimValue;
                end;
                Modify(true);
              end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterFindRecords', '', false, false)]
    local procedure PageNavigateOnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry";DocNoFilter: Text;PostingDateFilter: Text)
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        NoOfRecords: Integer;
    begin
        if AMLedgEntry.ReadPermission then begin
          AMLedgEntry.SetCurrentKey("Document No.","Posting Date");
          AMLedgEntry.SetFilter("Document No.",DocNoFilter);
          AMLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          NoOfRecords := AMLedgEntry.Count;
          if (NoOfRecords = 0) then
            exit;

          with DocumentEntry do begin
            Init;
            if FindLast then
              "Entry No." := "Entry No." + 1
            else
              "Entry No." := 1;
            "Table ID" := DATABASE::"MCH Asset Maint. Ledger Entry";
            "Document Type" := 0;
            "Table Name" := CopyStr(AMLedgEntry.TableCaption,1,MaxStrLen("Table Name"));
            "No. of Records" := NoOfRecords;
            Insert;
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnBeforeNavigateShowRecords', '', false, false)]
    local procedure PageNavigateOnBeforeNavigateShowRecords(TableID: Integer;DocNoFilter: Text;PostingDateFilter: Text;ItemTrackingSearch: Boolean;var TempDocumentEntry: Record "Document Entry" temporary;var IsHandled: Boolean)
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        if ItemTrackingSearch then
          exit;
        if (TableID <> DATABASE::"MCH Asset Maint. Ledger Entry") then
          exit;
        AMLedgEntry.SetCurrentKey("Document No.","Posting Date");
        AMLedgEntry.SetFilter("Document No.",DocNoFilter);
        AMLedgEntry.SetFilter("Posting Date",PostingDateFilter);
        PAGE.Run(0,AMLedgEntry);
        IsHandled := true;
    end;
}

