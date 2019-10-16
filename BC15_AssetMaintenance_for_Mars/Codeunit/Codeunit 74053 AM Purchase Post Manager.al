codeunit 74053 "MCH AM Purchase Post Manager"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        SavedHasLinesForWorkOrderToPost: Boolean;

    [EventSubscriber(ObjectType::Codeunit, 415, 'OnBeforeCalcInvDiscount', '', false, false)]
    local procedure ReleasePurchaseDocumentOnBeforeCalcInvDiscount(var PurchaseHeader: Record "Purchase Header";PreviewMode: Boolean)
    var
        PurchLine: Record "Purchase Line";
        TempPurchLineLocal: Record "Purchase Line" temporary;
        AMPurchPost: Codeunit "MCH AM Purch.-Post";
    begin
        // Raised in CU 415 OnBeforeCalcInvDiscount on Release
        ClearBufferedTempItemLedgEntry();
        PurchLine.SetRange("Document Type",PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchaseHeader."No.");
        PurchLine.SetFilter("MCH Work Order No.",'<>%1','');
        if not PurchLine.FindSet then begin
          SavedHasLinesForWorkOrderToPost := false;
          exit;
        end;
        if PreviewMode then
          SavedHasLinesForWorkOrderToPost := false;
        repeat
          TempPurchLineLocal := PurchLine;
          TempPurchLineLocal.Insert;
        until PurchLine.Next = 0;
        AMPurchPost.CheckPurchDocument(0,PurchaseHeader,TempPurchLineLocal,PreviewMode);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure PurchPostOnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PreviewMode: Boolean;ModifyHeader: Boolean;CommitIsSupressed: Boolean;var TempPurchLineGlobal: Record "Purchase Line" temporary)
    var
        TempPurchLineLocal: Record "Purchase Line" temporary;
        AMPurchPost: Codeunit "MCH AM Purch.-Post";
    begin
        // Raised in CU90 CheckAndUpdate(PurchHeader)
        // ..after standard checks and before Auto-Release and Posting.
        SavedHasLinesForWorkOrderToPost := false;
        ClearBufferedTempItemLedgEntry();
        TempPurchLineLocal.Reset;
        TempPurchLineLocal.Copy(TempPurchLineGlobal,true);
        TempPurchLineLocal.SetFilter("MCH Work Order No.",'<>%1','');
        if TempPurchLineLocal.IsEmpty then
          exit;

        // WO Budget Link- TempPurchLine Local/Global buffer may return with assigned new WO Budget Line No.
        AMPurchPost.CheckPurchDocument(1,PurchaseHeader,TempPurchLineLocal,PreviewMode);

        if (not PreviewMode) then begin
          SavedHasLinesForWorkOrderToPost := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure PurchPostOnAfterFinalizePostingOnBeforeCommit(var PurchHeader: Record "Purchase Header";var PurchRcptHeader: Record "Purch. Rcpt. Header";var PurchInvHeader: Record "Purch. Inv. Header";var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";var ReturnShptHeader: Record "Return Shipment Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PreviewMode: Boolean;CommitIsSupressed: Boolean)
    begin
        // SingleInstance CU
        // Raised in CU90 when Posting completed.
        if SavedHasLinesForWorkOrderToPost then begin
          SavedHasLinesForWorkOrderToPost := false;
          if (not PreviewMode) then begin
            if not TempItemLedgEntry.IsEmpty then begin
              PostToAM;
            end;
          end;
        end;
        ClearBufferedTempItemLedgEntry();
    end;

    [EventSubscriber(ObjectType::Codeunit, 5813, 'OnAfterCode', '', false, false)]
    local procedure UndoPurchReceiptLineOnAfterCode(var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchRcptLine2: Record "Purch. Rcpt. Line";
    begin
        // Raised in CU 5813 after Receipt Line Undo Posting completed
        if not TempItemLedgEntry.IsEmpty then begin
          PurchRcptLine2.SetRange("Document No.",PurchRcptLine."Document No.");
          if PurchRcptLine2.FindFirst then begin
            PostToAM;
          end;
          ClearBufferedTempItemLedgEntry();
        end;
    end;

    local procedure PostToAM()
    var
        AMPurchPost: Codeunit "MCH AM Purch.-Post";
    begin
        AMPurchPost.PostItemLedgerEntries(TempItemLedgEntry);
    end;


    procedure BufferItemLedgEntryToHandled(var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        if (ItemLedgEntry."MCH Work Order No." = '') then
          exit;
        TempItemLedgEntry := ItemLedgEntry;
        if TempItemLedgEntry.Insert then ;
    end;

    local procedure ClearBufferedTempItemLedgEntry()
    begin
        TempItemLedgEntry.Reset;
        if not TempItemLedgEntry.IsEmpty then
          TempItemLedgEntry.DeleteAll;
    end;
}

