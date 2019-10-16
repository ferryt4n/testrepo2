codeunit 74040 "MCH AM Purch.-Post"
{
    Permissions = TableData "MCH Asset Maint. Ledger Entry"=rimd,
                  TableData "MCH AM Posting Register"=rimd;

    trigger OnRun()
    begin
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        GLSetup: Record "General Ledger Setup";
        AMFunctions: Codeunit "MCH AM Functions";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        SetupRead: Boolean;
        UserHasLimitedAssetRespGroupAccess: Boolean;


    procedure PostItemLedgerEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        WorkOrderLine: Record "MCH Work Order Line";
        WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        MaintJnlPostLine: Codeunit "MCH Maint. Jnl.-Post Line";
        DoPostNewAMLedgerEntry: Boolean;
    begin
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.SetFilter("MCH Work Order No.",'<>%1','');
        if TempItemLedgEntry.IsEmpty then
          exit;
        TempItemLedgEntry.FindSet;
        GetSetup;
        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ItemLedgEntry.SetAutoCalcFields("Cost Amount (Non-Invtbl.)");

        repeat
          if ItemLedgEntry.Get(TempItemLedgEntry."Entry No.") then begin
            if (ItemLedgEntry."MCH AM Ledger Entry No." = 0) then begin
              DoPostNewAMLedgerEntry := true;
            end else begin
              AMLedgEntry.Get(ItemLedgEntry."MCH AM Ledger Entry No.");
              DoPostNewAMLedgerEntry := (AMLedgEntry."Item Ledger Entry No." <> ItemLedgEntry."Entry No.");
              if DoPostNewAMLedgerEntry then begin
                ItemLedgEntry2.Get(AMLedgEntry."Item Ledger Entry No.");
              end else
                ItemLedgEntry2 := ItemLedgEntry;

              MaintJnlPostLine.AdjustAMLedgEntryItemCost(ItemLedgEntry2);
            end;

            if DoPostNewAMLedgerEntry then begin
              with ItemLedgEntry do begin
                ValueEntry.SetRange("Item Ledger Entry No.","Entry No.");
                ValueEntry.FindFirst;

                MaintJnlLine.Init;
                MaintJnlLine."Item Ledger Entry No." := "Entry No.";
                MaintJnlLine."Entry Type" := MaintJnlLine."Entry Type"::Purchase;
                MaintJnlLine."Posting Date" := "Posting Date";
                MaintJnlLine."Document No." := "Document No.";
                MaintJnlLine."Document Date" := "Document Date";
                MaintJnlLine."External Document No." := "External Document No.";
                MaintJnlLine."Document Type" := "Document Type";
                MaintJnlLine."Document Line No." := "Document Line No.";
                MaintJnlLine."Vendor No." := "Source No.";

                WorkOrderLine.Get(WorkOrderLine.Status::Released,"MCH Work Order No.","MCH Work Order Line No.");
                MaintJnlLine."Work Order No." := "MCH Work Order No.";
                MaintJnlLine."Work Order Line No." := "MCH Work Order Line No.";
                MaintJnlLine."Work Order Budget Line No." := "MCH WO Budget Line No.";
                MaintJnlLine."Asset No." := WorkOrderLine."Asset No.";

                if (Description <> '') then begin
                  MaintJnlLine.Description := Description;
                end else begin
                  if ("MCH WO Budget Line No." <> 0) then begin
                    WorkOrderBudgetLine.Get(WorkOrderBudgetLine.Status::Released,"MCH Work Order No.","MCH WO Budget Line No.");
                    MaintJnlLine.Description := WorkOrderBudgetLine.Description;
                  end;
                end;

                case "MCH WO Purchase Type" of
                  "MCH WO Purchase Type"::"Spare Part":
                    MaintJnlLine.Type := MaintJnlLine.Type::"Spare Part";
                  "MCH WO Purchase Type"::Cost:
                    MaintJnlLine.Type := MaintJnlLine.Type::Cost;
                  "MCH WO Purchase Type"::Trade:
                    MaintJnlLine.Type := MaintJnlLine.Type::Trade;
                end;
                MaintJnlLine."No." := "MCH WO Purchase Code";
                MaintJnlLine."Item No." := "Item No.";
                MaintJnlLine."Variant Code" := "Variant Code";
                MaintJnlLine."Unit of Measure Code" := "Unit of Measure Code";
                MaintJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";

                MaintJnlLine."Quantity (Base)" := Quantity;
                MaintJnlLine.Quantity := Round(MaintJnlLine."Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
                MaintJnlLine."Qty. Invoiced (Base)" := "Invoiced Quantity";
                MaintJnlLine."Qty. Invoiced" := Round(MaintJnlLine."Qty. Invoiced (Base)" / "Qty. per Unit of Measure",0.00001);
                if (MaintJnlLine."Qty. Invoiced" <> 0) then begin
                  MaintJnlLine.Amount := "Cost Amount (Non-Invtbl.)";
                  MaintJnlLine."Unit Cost" := Round(MaintJnlLine.Amount / MaintJnlLine."Qty. Invoiced",GLSetup."Unit-Amount Rounding Precision");
                end;
                if (MaintJnlLine.Type = MaintJnlLine.Type::Trade) then
                  MaintJnlLine.Hours := AMFunctions.GetHoursPerTimeUOM(MaintJnlLine.Quantity,MaintJnlLine."Unit of Measure Code");

                MaintJnlLine."Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
                MaintJnlLine."Gen. Bus. Posting Group" := ValueEntry."Gen. Bus. Posting Group";
                MaintJnlLine."Source Code" := ValueEntry."Source Code";

                MaintJnlLine."Reason Code" := "Return Reason Code";
                MaintJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                MaintJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                MaintJnlLine."Dimension Set ID" := "Dimension Set ID";

                MaintJnlPostLine.RunWithCheck(MaintJnlLine);
              end;
            end;
          end;
        until TempItemLedgEntry.Next = 0;
    end;


    procedure CheckPurchDocument(CallingContext: Option OnRelease,OnPosting;var PurchHeader: Record "Purchase Header";var TempPurchLineGlobal: Record "Purchase Line" temporary;PurchPostPreviewMode: Boolean) HasLinesForWorkOrderProcessing: Boolean
    var
        TempPurchLine: Record "Purchase Line" temporary;
        MissingLinkTempPurchLine: Record "Purchase Line" temporary;
        WorkOrder: Record "MCH Work Order Header";
        WorkOrder2: Record "MCH Work Order Header";
        WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
        WorkOrderLine: Record "MCH Work Order Line";
        MaintAsset: Record "MCH Maintenance Asset";
        WOProgressStatus: Record "MCH Work Order Progress Status";
        SparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        MaintTrade: Record "MCH Maintenance Trade";
        Item: Record Item;
        DimMgt: Codeunit DimensionManagement;
        MaintJnlPostLine: Codeunit "MCH Maint. Jnl.-Post Line";
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
        CheckLine: Boolean;
        DimValuePostingErrMsg: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        WOPurchPostingBlockedErrMsg: Label 'Purchase Posting is blocked for %1 %2 with %3 %4.';
        MissingRespGroupErrMsg: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
        MissingBudgetLinkErrMsg: Label 'Purchase %1 Line %2 must be linked to a %3 for %4 %5.';
    begin
        with TempPurchLine do begin
          Reset;
          Copy(TempPurchLineGlobal,true);
          SetFilter("MCH Work Order No.",'<>%1','');

          if FindSet then begin
            GetSetup;
            repeat
              TestField("MCH Work Order Line No.");
              TestField("MCH WO Purchase Type");
              TestField("MCH WO Purchase Code");
              TestField("Job No.",'');

              case CallingContext of
                CallingContext::OnRelease:
                  CheckLine := ("Outstanding Quantity" <> 0) or ("Qty. Rcd. Not Invoiced" <> 0) or ("Return Qty. Shipped Not Invd." <> 0);
                else //CallingContext::OnPosting:
                  CheckLine := ("Qty. to Invoice" <> 0) or ("Qty. to Receive" <> 0) or ("Return Qty. to Ship" <> 0);
              end;
              HasLinesForWorkOrderProcessing := HasLinesForWorkOrderProcessing or CheckLine;

              if CheckLine then begin
                TestField(Type,Type::Item);
                if "MCH Work Order No." <> WorkOrder."No." then begin
                  if not WorkOrder.Get(WorkOrder.Status::Released,"MCH Work Order No.") then begin
                    WorkOrder2.SetCurrentKey("No.");
                    WorkOrder2.SetRange("No.","MCH Work Order No.");
                    if not WorkOrder2.FindFirst then
                      WorkOrder.Get(WorkOrder.Status::Released,"MCH Work Order No.")
                    else
                      WorkOrder2.TestField(Status,WorkOrder2.Status::Released);
                  end;

                  if AMSetup."Work Order Type Mandatory" then
                    WorkOrder.TestField("Work Order Type");
                  if AMSetup."WO Person Respons. Mandatory" then
                    WorkOrder.TestField("Person Responsible");
                  if AMSetup."WO Progress Status Mandatory" then
                    WorkOrder.TestField("Progress Status Code");

                  if (WorkOrder."Progress Status Code" <> '') then begin
                    WOProgressStatus.Get(WorkOrder."Progress Status Code");
                    if WOProgressStatus."Maint. Location Mandatory" then
                      WorkOrder.TestField("Maint. Location Code");
                    if WOProgressStatus."Person Responsible Mandatory" then
                      WorkOrder.TestField("Person Responsible");
                    if WOProgressStatus."Block Purchase Posting" then
                      Error(WOPurchPostingBlockedErrMsg,
                        WorkOrder.TableCaption,WorkOrder."No.",
                        WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code");
                  end;
                  if UserHasLimitedAssetRespGroupAccess then begin
                    if not MaintUserMgt.UserHasAccessToRespGroup(UserId,WorkOrder."Responsibility Group Code") then
                      Error(MissingRespGroupErrMsg,
                        WorkOrder.TableCaption,WorkOrder."No.",
                        WorkOrder.FieldCaption("Responsibility Group Code"),WorkOrder."Responsibility Group Code");
                  end;
                  AMFunctions.CheckIfPurchPostBlocked2(WorkOrder,true);
                end;

                WorkOrderLine.Get(WorkOrderLine.Status::Released,"MCH Work Order No.","MCH Work Order Line No.");
                WorkOrderLine.TestField("Asset No.");
                MaintAsset.Get(WorkOrderLine."Asset No.");
                MaintAsset.TestField(Blocked,false);
                if UserHasLimitedAssetRespGroupAccess and
                   (MaintAsset."Responsibility Group Code" <> WorkOrder."Responsibility Group Code")
                then begin
                  if not MaintUserMgt.UserHasAccessToRespGroup(UserId,WorkOrder."Responsibility Group Code") then
                    Error(MissingRespGroupErrMsg,
                      MaintAsset.TableCaption,MaintAsset."No.",
                      MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
                end;

                if "MCH WO Budget Line No." <> 0 then begin
                  WorkOrderBudgetLine.Get(WorkOrderBudgetLine.Status::Released,"MCH Work Order No.","MCH WO Budget Line No.");
                  TestField("MCH Work Order Line No.",WorkOrderBudgetLine."Work Order Line No.");
                end else begin
                  TestField("MCH Work Order Line No.");
                  // Check budget link
                  case AMSetup."WO Purchase to Budget Link" of
                    AMSetup."WO Purchase to Budget Link"::Optional: ; // Do nothing
                    AMSetup."WO Purchase to Budget Link"::"Mandatory on Entry":
                      Error(
                        MissingBudgetLinkErrMsg,
                        "Document Type","Document No.","Line No.",WorkOrderBudgetLine.TableCaption,WorkOrder.TableCaption,WorkOrder."No.");
                    AMSetup."WO Purchase to Budget Link"::"Auto Create on Posting":
                      begin
                        MissingLinkTempPurchLine := TempPurchLine;
                        MissingLinkTempPurchLine.Insert;
                      end;
                  end;
                end;

                if "MCH WO Budget Line No." <> 0 then begin
                  case WorkOrderBudgetLine.Type of
                    WorkOrderBudgetLine.Type::"Spare Part":
                      begin
                        TestField("MCH WO Purchase Type","MCH WO Purchase Type"::"Spare Part");
                        TestField("MCH WO Purchase Code",WorkOrderBudgetLine."No.");
                      end;
                    WorkOrderBudgetLine.Type::Cost:
                      begin
                        TestField("MCH WO Purchase Type","MCH WO Purchase Type"::Cost);
                        TestField("MCH WO Purchase Code",WorkOrderBudgetLine."No.");
                      end;
                    WorkOrderBudgetLine.Type::Trade:
                      begin
                        TestField("MCH WO Purchase Type","MCH WO Purchase Type"::Trade);
                        TestField("MCH WO Purchase Code",WorkOrderBudgetLine."No.");
                      end;
                  end;
                end;

                case "MCH WO Purchase Type" of
                  "MCH WO Purchase Type"::"Spare Part":
                    begin
                      SparePart.Get("MCH WO Purchase Code");
                      SparePart.TestField(Blocked,false);
                      SparePart.GetItemWithEffectiveValues(Item,true);
                    end;
                  "MCH WO Purchase Type"::Cost:
                    begin
                      MaintCost.Get("MCH WO Purchase Code");
                      MaintCost.TestField(Blocked,false);
                      MaintCost.GetItemWithEffectiveValues(Item,true);
                    end;
                  "MCH WO Purchase Type"::Trade:
                    begin
                      MaintTrade.Get("MCH WO Purchase Code");
                      MaintTrade.TestField(Blocked,false);
                      MaintTrade.GetItemWithEffectiveValues(Item,true);
                    end;
                end;
                TestField("No.",Item."No.");
                TestField("Gen. Prod. Posting Group",Item."Gen. Prod. Posting Group");

                TableIDArr[1] := DATABASE::"MCH Maintenance Asset";
                NumberArr[1] := WorkOrderLine."Asset No.";
                TableIDArr[2] := DATABASE::"MCH Maintenance Location";
                NumberArr[2] := WorkOrderLine."Maint. Location Code";
                TableIDArr[3] := DATABASE::"MCH Work Order Type";
                NumberArr[3] := WorkOrderLine."Work Order Type";
                if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") then
                  Error(
                    DimValuePostingErrMsg,
                    PurchHeader."Document Type",PurchHeader."No.",TempPurchLine."Line No.",DimMgt.GetDimValuePostingErr);
              end;
            until Next = 0;

            // Create missing WO Budget Link
            if (not PurchPostPreviewMode) and
               (AMSetup."WO Purchase to Budget Link" = AMSetup."WO Purchase to Budget Link"::"Auto Create on Posting")
            then begin
              if MissingLinkTempPurchLine.FindSet then begin
                repeat
                  if TempPurchLineGlobal.Get(
                    MissingLinkTempPurchLine."Document Type",MissingLinkTempPurchLine."Document No.",MissingLinkTempPurchLine."Line No.")
                  then begin
                    MaintJnlPostLine.LinkWOBudgetLineFromPurchaseLine(MissingLinkTempPurchLine,true);
                    if (TempPurchLineGlobal."MCH WO Budget Line No." <> MissingLinkTempPurchLine."MCH WO Budget Line No.") then begin
                      TempPurchLineGlobal."MCH WO Budget Line No." := MissingLinkTempPurchLine."MCH WO Budget Line No.";
                      TempPurchLineGlobal.Modify;
                    end;
                  end;
                until MissingLinkTempPurchLine.Next = 0;
              end;
            end;
          end;
        end;
    end;

    local procedure GetSetup()
    begin
        if SetupRead then
          exit;
        AMSetup.Get;
        GLSetup.Get;
        SetupRead := true;
        UserHasLimitedAssetRespGroupAccess := MaintUserMgt.UserHasAssetRespGroupFilter;
    end;
}

