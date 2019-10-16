codeunit 74048 "MCH Maint. Jnl.-Post Line"
{
    Permissions = TableData "Item Ledger Entry"=rm,
                  TableData "Res. Ledger Entry"=rm,
                  TableData "MCH Work Order Budget Line"=rim,
                  TableData "MCH Asset Maint. Ledger Entry"=rim,
                  TableData "MCH AM Posting Register"=rim;
    TableNo = "MCH Maint. Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        AMSetup: Record "MCH Asset Maintenance Setup";
        AMReg: Record "MCH AM Posting Register";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        AMPostingSetup: Record "MCH AM Posting Setup";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        WorkOrder: Record "MCH Work Order Header";
        WorkOrderLine: Record "MCH Work Order Line";
        MaintAsset: Record "MCH Maintenance Asset";
        MaintSparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        MaintTrade: Record "MCH Maintenance Trade";
        MaintTeamMember: Record "MCH Maint. Team Member";
        ItemJnlLine: Record "Item Journal Line";
        ResJnlLine: Record "Res. Journal Line";
        ResLedgEntry: Record "Res. Ledger Entry";
        Item: Record Item;
        TempResource: Record Resource temporary;
        TempMaintTeam: Record "MCH Maintenance Team" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        MaintJnlCheckLine: Codeunit "MCH Maint. Jnl.-Check Line";
        AMStructureEntryPost: Codeunit "MCH AM Structure Entry-Post";
        AMCostCalcMgt: Codeunit "MCH AM Cost Mgt.";
        AMFunctions: Codeunit "MCH AM Functions";
        AMLedgEntryNo: Integer;
        SetupRead: Boolean;


    procedure RunWithCheck(var MaintJnlLine2: Record "MCH Maint. Journal Line")
    begin
        MaintJnlLine.Copy(MaintJnlLine2);
        Code;
        MaintJnlLine2 := MaintJnlLine;
    end;

    local procedure "Code"()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Resource: Record Resource;
        MaintTeam: Record "MCH Maintenance Team";
        PostingSignFactor: Decimal;
    begin
        with MaintJnlLine do begin
          if EmptyLine then
            exit;
          GetSetup;
          MaintJnlCheckLine.RunCheck(MaintJnlLine);

          if AMLedgEntryNo = 0 then begin
            AMLedgEntry.LockTable;
            if AMLedgEntry.FindLast then
              AMLedgEntryNo := AMLedgEntry."Entry No.";
          end;

          if "Document Date" = 0D then
            "Document Date" := "Posting Date";

          WorkOrder.Get(WorkOrder.Status::Released,"Work Order No.");
          WorkOrderLine.Get(WorkOrderLine.Status::Released,"Work Order No.","Work Order Line No.");

          if ("Work Order Budget Line No." = 0) then
            LinkWOBudgetLineFromMaintJnlLine(MaintJnlLine);

          if (WorkOrderLine."Asset No." <> MaintAsset."No.") then
            MaintAsset.Get(WorkOrderLine."Asset No.");

          InitAMLedgerEntry;
          "AM Ledger Entry No." := AMLedgEntry."Entry No.";

          case "Entry Type" of
            "Entry Type"::Issue,"Entry Type"::Return:
              begin
                if Type = Type::Item then begin
                  "Source Code" := AMSetup."Source Code";
                  if ("Entry Type" = "Entry Type"::Issue) then
                    PostingSignFactor := -1
                  else
                    PostingSignFactor := 1;
                  Amount := PostingSignFactor * Amount;
                  PostItemJnlLine;
                  Amount := PostingSignFactor * Amount;
                  ItemLedgEntry.FindLast;
                  AMLedgEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
                end;
              end;
            "Entry Type"::Timesheet:
              begin
                "Source Code" := AMSetup."Source Code";
                case Type of
                  Type::Resource:
                    begin
                      GetResource("No.",Resource);
                      PostResourceJnlLine(Resource);
                      PostMaintTimesheetToGL;
                  end;
                Type::Team:
                  begin
                    if AMSetup."Post Team Timesheet Res. Ledg." then begin
                      GetMaintTeam("No.",MaintTeam);
                      PostMaintTeamMemberResJnlLines(MaintTeam);
                    end;
                    PostMaintTimesheetToGL;
                  end;
                end;
              end;
            "Entry Type"::Purchase:
              begin
                if ItemLedgEntry.Get(AMLedgEntry."Item Ledger Entry No.") and
                   (ItemLedgEntry."MCH AM Ledger Entry No." = 0)
                then begin
                  ItemLedgEntry."MCH AM Ledger Entry No." := AMLedgEntry."Entry No.";
                  ItemLedgEntry.Modify;
                end;
              end;
          end;

          AMLedgEntry.Insert;
          AMStructureEntryPost.FromAMLedgEntry(AMLedgEntry);

          InsertAMRegister(AMLedgEntryNo);

          Clear(GenJnlPostLine);
          Clear(ItemJnlPostLine);
          Clear(ResJnlPostLine);
        end;
    end;

    local procedure PostResourceJnlLine(var Resource: Record Resource)
    var
        ResJnlLine: Record "Res. Journal Line";
    begin
        with MaintJnlLine do begin
          ResJnlLine.Reset;
          ResJnlLine.Init;
          ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
          ResJnlLine."Posting Date" := "Posting Date";
          ResJnlLine."Document Date" := "Document Date";
          ResJnlLine."Document No." := "Document No.";
          ResJnlLine."External Document No." := "External Document No.";
          ResJnlLine."Resource No." := "No.";
          ResJnlLine."Resource Group No." := Resource."Resource Group No.";
          ResJnlLine.Description := Description;
          ResJnlLine."Work Type Code" := "Resource Work Type Code";
          ResJnlLine."Unit of Measure Code" := "Unit of Measure Code";
          ResJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ResJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ResJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          ResJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          ResJnlLine."Dimension Set ID" := MaintJnlLine."Dimension Set ID";
          ResJnlLine."Source Code" := AMSetup."Source Code";

          ResJnlLine.Quantity := Quantity;
          ResJnlLine."Unit Cost" := "Unit Cost";
          ResJnlLine."Total Cost" := Round("Unit Cost" * Quantity);

          ResJnlLine."MCH Work Order No." := AMLedgEntry."Work Order No.";
          ResJnlLine."MCH Work Order Line No." := AMLedgEntry."Work Order Line No.";
          ResJnlLine."MCH WO Budget Line No." := AMLedgEntry."Work Order Budget Line No.";
          ResJnlLine."MCH Maint. Asset No." := AMLedgEntry."Asset No.";
          ResJnlLine."MCH AM Ledger Entry No." := AMLedgEntry."Entry No.";

          ResJnlPostLine.RunWithCheck(ResJnlLine);

          ResLedgEntry.FindLast;
          AMLedgEntry."Resource Ledger Entry No." := ResLedgEntry."Entry No.";
          AMLedgEntry."Last Res. Ledger Entry No." := ResLedgEntry."Entry No.";
        end;
    end;

    local procedure PostMaintTeamMemberResJnlLines(var MaintTeam: Record "MCH Maintenance Team")
    var
        ResJnlLine: Record "Res. Journal Line";
        Resource: Record Resource;
        ResUnitOfMeasure: Record "Resource Unit of Measure";
        ResCost: Record "Resource Cost";
        FirstResLedgEntryNo: Integer;
        LastResLedgEntryNo: Integer;
    begin
        MaintTeamMember.SetRange("Maint. Team Code",MaintTeam.Code);
        MaintTeamMember.FindSet;
        repeat
          GetResource(MaintTeamMember."Resource No.",Resource);
          ResUnitOfMeasure.Get(Resource."No.",MaintTeamMember."Unit of Measure Code");

          with MaintJnlLine do begin
            ResJnlLine.Reset;
            ResJnlLine.Init;
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
            ResJnlLine."Posting Date" := "Posting Date";
            ResJnlLine."Document Date" := "Document Date";
            ResJnlLine."Document No." := "Document No.";
            ResJnlLine."External Document No." := "External Document No.";
            ResJnlLine."Resource No." := Resource."No.";
            ResJnlLine."Resource Group No." := Resource."Resource Group No.";
            ResJnlLine.Description := Description;
            ResJnlLine."Work Type Code" := '';
            ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ResJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            ResJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            ResJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            ResJnlLine."Dimension Set ID" := MaintJnlLine."Dimension Set ID";
            ResJnlLine."Source Code" := AMSetup."Source Code";

            ResJnlLine."Unit of Measure Code" := ResUnitOfMeasure.Code;
            ResJnlLine."Qty. per Unit of Measure" := ResUnitOfMeasure."Qty. per Unit of Measure";
            ResJnlLine.Quantity :=
              Round(MaintTeamMember."Quantity per" * AMFunctions.GetUOMQuantityPerHour(Hours,MaintTeamMember."Unit of Measure Code"),0.00001);

            ResCost.Init;
            ResCost.Code := Resource."No.";
            ResCost."Work Type Code" := '';
            CODEUNIT.Run(CODEUNIT::"Resource-Find Cost",ResCost);
            ResJnlLine."Direct Unit Cost" := ResCost."Direct Unit Cost" * ResJnlLine."Qty. per Unit of Measure";
            ResJnlLine."Unit Cost" := ResCost."Unit Cost" * ResJnlLine."Qty. per Unit of Measure";
            ResJnlLine."Total Cost" := Round(ResJnlLine."Unit Cost" * ResJnlLine.Quantity);

            ResJnlLine."MCH Maint. Team Code" := MaintTeam.Code;
            ResJnlLine."MCH Work Order No." := AMLedgEntry."Work Order No.";
            ResJnlLine."MCH Work Order Line No." := AMLedgEntry."Work Order Line No.";
            ResJnlLine."MCH WO Budget Line No." := AMLedgEntry."Work Order Budget Line No.";
            ResJnlLine."MCH Maint. Asset No." := AMLedgEntry."Asset No.";
            ResJnlLine."MCH AM Ledger Entry No." := AMLedgEntry."Entry No.";

            ResJnlPostLine.RunWithCheck(ResJnlLine);

            ResLedgEntry.FindLast;
            LastResLedgEntryNo := ResLedgEntry."Entry No.";
            if (FirstResLedgEntryNo = 0) then
              FirstResLedgEntryNo := LastResLedgEntryNo;
          end;
        until MaintTeamMember.Next = 0;
        AMLedgEntry."Resource Ledger Entry No." := FirstResLedgEntryNo;
        AMLedgEntry."Last Res. Ledger Entry No." := LastResLedgEntryNo;
    end;

    local procedure PostItemJnlLine()
    begin
        with ItemJnlLine do begin
          Init;
          "Item No." := MaintJnlLine."No.";
          "Posting Date" := MaintJnlLine."Posting Date";
          "Document Date" := MaintJnlLine."Document Date";
          "Document No." := MaintJnlLine."Document No.";
          "External Document No." := MaintJnlLine."External Document No.";
          Description := MaintJnlLine.Description;
          "Location Code" := MaintJnlLine."Location Code";
          "Applies-to Entry" := MaintJnlLine."Applies-to Item Entry";
          "Applies-from Entry" := MaintJnlLine."Applies-from Item Entry";
          "Shortcut Dimension 1 Code" := MaintJnlLine."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := MaintJnlLine."Shortcut Dimension 2 Code";
          "Dimension Set ID" := MaintJnlLine."Dimension Set ID";
          case MaintJnlLine."Entry Type" of
            MaintJnlLine."Entry Type"::Issue:
              "Entry Type" := "Entry Type"::"Negative Adjmt.";
            MaintJnlLine."Entry Type"::Return:
              "Entry Type" := "Entry Type"::"Positive Adjmt.";
          end;
          "Source Code" := AMSetup."Source Code";
          "Gen. Bus. Posting Group" := MaintJnlLine."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := MaintJnlLine."Gen. Prod. Posting Group";
          "Posting No. Series" := MaintJnlLine."Posting No. Series";
          "Variant Code" := MaintJnlLine."Variant Code";
          "Bin Code" := MaintJnlLine."Bin Code";
          "Unit of Measure Code" := MaintJnlLine."Unit of Measure Code";
          "Reason Code" := MaintJnlLine."Reason Code";
          "Invoiced Quantity" := MaintJnlLine.Quantity;
          "Invoiced Qty. (Base)" := MaintJnlLine."Quantity (Base)";
          Quantity := MaintJnlLine.Quantity;
          "Quantity (Base)" := MaintJnlLine."Quantity (Base)";
          "Qty. per Unit of Measure" := MaintJnlLine."Qty. per Unit of Measure";
          "Unit Cost" := MaintJnlLine."Unit Cost";
          Amount := MaintJnlLine.Amount;
          "Value Entry Type" := "Value Entry Type"::"Direct Cost";
        end;

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;

    local procedure PostMaintTimesheetToGL()
    var
        GenJnlLine: Record "Gen. Journal Line";
        BalAccNo: Code[20];
    begin
        with MaintJnlLine do begin
          AMCostCalcMgt.FindAMPostingSetup(
            AMPostingSetup,true,"Asset Posting Group","Gen. Prod. Posting Group",WorkOrder."Work Order Type");
          AMPostingSetup.TestField("Expense Account");
          case Type of
            Type::Resource:
              begin
                AMPostingSetup.TestField("Resource Account");
                BalAccNo :=  AMPostingSetup."Resource Account";
              end;
            Type::Team:
              begin
                AMPostingSetup.TestField("Maint. Team Account");
                BalAccNo := AMPostingSetup."Maint. Team Account";
              end;
          end;

          GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
          GenJnlLine."Account No." := AMPostingSetup."Expense Account";
          GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
          GenJnlLine."Bal. Account No." := BalAccNo;

          GenJnlLine."Posting Date" := "Posting Date";
          GenJnlLine."Document Date" := "Document Date";
          GenJnlLine."External Document No." := "External Document No.";
          GenJnlLine."Document No." := "Document No.";
          GenJnlLine.Description :=  Description;
          GenJnlLine.Amount := Amount;
          GenJnlLine."Amount (LCY)" := Amount;

          GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          GenJnlLine."Dimension Set ID" := "Dimension Set ID";
          GenJnlLine."Posting No. Series" := "Posting No. Series";
          GenJnlLine."Source Code" := AMSetup."Source Code";
          GenJnlLine."System-Created Entry" := true;

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure InitAMLedgerEntry()
    begin
        with MaintJnlLine do begin
          AMLedgEntry.Init;
          AMLedgEntryNo := AMLedgEntryNo + 1;
          "AM Ledger Entry No." := AMLedgEntryNo;
          AMLedgEntry."Entry No." := AMLedgEntryNo;
          AMLedgEntry."Posting Date" := "Posting Date";
          AMLedgEntry."Document No." := "Document No.";
          AMLedgEntry."Document Date" := "Document Date";
          AMLedgEntry."External Document No." := "External Document No.";
          AMLedgEntry.Description := Description;

          AMLedgEntry."Work Order No." := "Work Order No.";
          AMLedgEntry."Work Order Line No." := "Work Order Line No.";
          AMLedgEntry."Work Order Budget Line No." := "Work Order Budget Line No.";
          AMLedgEntry."Asset No." := MaintAsset."No.";
          AMLedgEntry."Maint. Location Code" := WorkOrderLine."Maint. Location Code";
          AMLedgEntry."Work Order Type" := WorkOrderLine."Work Order Type";
          AMLedgEntry."Maint. Task Code" := WorkOrderLine."Task Code";
          AMLedgEntry."Asset Posting Group" := MaintAsset."Posting Group";
          AMLedgEntry."Asset Category Code" := MaintAsset."Category Code";

          AMLedgEntry.Type := Type;
          AMLedgEntry."No." := "No.";
          AMLedgEntry."Unit Cost" := "Unit Cost";
          AMLedgEntry.Quantity := Signed(Quantity);
          AMLedgEntry."Quantity (Base)" := Signed("Quantity (Base)");
          AMLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
          AMLedgEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";

          AMLedgEntry."Cost Amount" := Signed(Amount);

          AMLedgEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          AMLedgEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          AMLedgEntry."Reason Code" := "Reason Code";
          AMLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
          AMLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
          AMLedgEntry."Dimension Set ID" := "Dimension Set ID";
          AMLedgEntry."Source Code" := AMSetup."Source Code";
          AMLedgEntry."Posted By" := UserId;
          AMLedgEntry."Posted Date-Time" := CurrentDateTime;
          AMLedgEntry."Posted System Date" := Today;

          case "Entry Type" of
            "Entry Type"::Issue,"Entry Type"::Return:
              begin
                AMLedgEntry."Posting Entry Type" := AMLedgEntry."Posting Entry Type"::Inventory;
                AMLedgEntry."Resource No. (Issue/Return)" := "Resource No. (Issue/Return)";
                AMLedgEntry."Item No." := "No.";
                AMLedgEntry."Location Code" := "Location Code";
                AMLedgEntry."Bin Code" := "Bin Code";
                AMLedgEntry."Variant Code" := "Variant Code";
                if ("Entry Type" = "Entry Type"::Issue) then
                  AMLedgEntry."Inventory Entry Type" := AMLedgEntry."Inventory Entry Type"::Issue
                else
                  AMLedgEntry."Inventory Entry Type" := AMLedgEntry."Inventory Entry Type"::Return;
                AMLedgEntry."Qty. Invoiced" := Signed(Quantity);
                AMLedgEntry."Qty. Invoiced (Base)" := Signed("Quantity (Base)");
                AMLedgEntry."Item Ledger Entry No." := "Item Ledger Entry No.";
              end;
            "Entry Type"::Timesheet:
              begin
                AMLedgEntry."Posting Entry Type" := AMLedgEntry."Posting Entry Type"::Timesheet;
                AMLedgEntry."Resource Work Type Code" := "Resource Work Type Code";
                AMLedgEntry.Hours := Hours;
                AMLedgEntry."Qty. Invoiced" := Signed(Quantity);
                AMLedgEntry."Qty. Invoiced (Base)" := Signed("Quantity (Base)");
              end;
            "Entry Type"::Purchase:
              begin
                AMLedgEntry."Posting Entry Type" := AMLedgEntry."Posting Entry Type"::Purchase;
                AMLedgEntry."Item No." := "Item No.";
                AMLedgEntry."Variant Code" := "Variant Code";
                AMLedgEntry."Document Type" := "Document Type";
                AMLedgEntry."Document Line No." := "Document Line No.";
                AMLedgEntry."Vendor No." := "Vendor No.";
                AMLedgEntry."Qty. Invoiced" := "Qty. Invoiced";
                AMLedgEntry."Qty. Invoiced (Base)" := "Qty. Invoiced (Base)";
                AMLedgEntry."Source Code" := "Source Code";
                AMLedgEntry."Item Ledger Entry No." := "Item Ledger Entry No.";
              end;
          end;
        end;
    end;

    local procedure Signed(Value: Decimal): Decimal
    begin
        with MaintJnlLine do begin
          case "Entry Type" of
            "Entry Type"::Return:
              exit(-Value);
            else
              exit(Value);
          end;
        end;
    end;

    local procedure LinkWOBudgetLineFromMaintJnlLine(var MaintJnlLine2: Record "MCH Maint. Journal Line")
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
        FindCreateBudgetLink: Boolean;
    begin
        with MaintJnlLine2 do begin
          if "Work Order Budget Line No." <> 0 then begin
            WOBudgetLine.Get(WOBudgetLine.Status::Released,"Work Order No.","Work Order Budget Line No.");
            exit;
          end else begin
            case Type of
              Type::Item:
                FindCreateBudgetLink := (AMSetup."WO Invt. Usage to Budget Link" = AMSetup."WO Invt. Usage to Budget Link"::"Auto Create on Posting");
              Type::Resource,
              Type::Team:
                FindCreateBudgetLink := (AMSetup."WO Timesheet to Budget Link" = AMSetup."WO Timesheet to Budget Link"::"Auto Create on Posting");
              Type::"Spare Part",
              Type::Cost,
              Type::Trade:
                exit; // Handled on purchase AM posting
            end;
          end;

          WOBudgetLine.Reset;
          WOBudgetLine.SetRange(Status,WOBudgetLine.Status::Released);
          WOBudgetLine.SetRange("Work Order No.","Work Order No.");
          WOBudgetLine.SetRange("Work Order Line No.","Work Order Line No.");
          WOBudgetLine.SetRange(Type,Type);
          WOBudgetLine.SetRange("No.","No.");
          if (Type = Type::Item) then begin
            WOBudgetLine.SetFilter("Location Code",'%1|%2','',"Location Code");
            WOBudgetLine.SetFilter("Variant Code",'%1|%2','',"Variant Code");
          end;
          WOBudgetLine.LockTable;
          if (not WOBudgetLine.FindFirst) then begin
            // Create new
            WOBudgetLine.Reset;
            WOBudgetLine.SetRange(Status,WOBudgetLine.Status::Released);
            WOBudgetLine.SetRange("Work Order No.","Work Order No.");
            if WOBudgetLine.FindLast then
              WOBudgetLine."Line No." := WOBudgetLine."Line No." + 10000
            else
              WOBudgetLine."Line No." := 10000;
            WOBudgetLine.Init;
            WOBudgetLine.Status := WOBudgetLine.Status::Released;
            WOBudgetLine."Work Order No." := "Work Order No.";
            WOBudgetLine."Work Order Line No." := "Work Order Line No.";
            WOBudgetLine.Insert(true);
            WOBudgetLine.AutoCreateOnMaintJnlLinePosting(MaintJnlLine2);
            WOBudgetLine.Modify(true);
          end;
          "Work Order Budget Line No." := WOBudgetLine."Line No."
        end;
    end;


    procedure LinkWOBudgetLineFromPurchaseLine(var TempPurchLine: Record "Purchase Line" temporary;UpdateActualPurchLine: Boolean)
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
        PurchLine: Record "Purchase Line";
    begin
        with TempPurchLine do begin
          if "MCH WO Budget Line No." <> 0 then
            exit;
          WOBudgetLine.Reset;
          WOBudgetLine.SetRange(Status,WOBudgetLine.Status::Released);
          WOBudgetLine.SetRange("Work Order No.","MCH Work Order No.");
          WOBudgetLine.SetRange("Work Order Line No.","MCH Work Order Line No.");
          case "MCH WO Purchase Type" of
            "MCH WO Purchase Type"::Cost:
              WOBudgetLine.SetRange(Type,WOBudgetLine.Type::Cost);
            "MCH WO Purchase Type"::"Spare Part":
              WOBudgetLine.SetRange(Type,WOBudgetLine.Type::"Spare Part");
            "MCH WO Purchase Type"::Trade:
              WOBudgetLine.SetRange(Type,WOBudgetLine.Type::Trade);
          end;
          WOBudgetLine.SetRange("No.","MCH WO Purchase Code");
          WOBudgetLine.SetFilter("Vendor No.",'%1|%2','',"Buy-from Vendor No.");
          WOBudgetLine.LockTable;
          if (not WOBudgetLine.FindFirst) then begin
            // Create new
            WOBudgetLine.Reset;
            WOBudgetLine.SetRange(Status,WOBudgetLine.Status::Released);
            WOBudgetLine.SetRange("Work Order No.","MCH Work Order No.");
            if WOBudgetLine.FindLast then
              WOBudgetLine."Line No." := WOBudgetLine."Line No." + 10000
            else
              WOBudgetLine."Line No." := 10000;
            WOBudgetLine.Init;
            WOBudgetLine.Status := WOBudgetLine.Status::Released;
            WOBudgetLine."Work Order No." := "MCH Work Order No.";
            WOBudgetLine."Work Order Line No." := "MCH Work Order Line No.";
            WOBudgetLine.Insert(true);
            WOBudgetLine.AutoCreateOnPurchaseLinePost(TempPurchLine);
            WOBudgetLine.Modify(true);
          end;

          "MCH WO Budget Line No." := WOBudgetLine."Line No.";
          if UpdateActualPurchLine then begin
            if PurchLine.Get("Document Type","Document No.","Line No.") and
              (PurchLine."MCH Work Order No." = "MCH Work Order No.") and
              (PurchLine."MCH Work Order Line No." = "MCH Work Order Line No.") and
              (PurchLine."MCH WO Budget Line No." <> "MCH WO Budget Line No.")
            then begin
              PurchLine."MCH WO Budget Line No." := "MCH WO Budget Line No.";
              PurchLine.Modify;
            end;
          end;
        end;
    end;


    procedure AdjustAMLedgEntryItemCost(ItemLedgEntry: Record "Item Ledger Entry") AMLedgEntryUpdated: Boolean
    var
        ValueEntryCostAmount: Decimal;
    begin
        if (ItemLedgEntry."MCH AM Ledger Entry No." = 0) then
          exit;
        if (not AMLedgEntry.Get(ItemLedgEntry."MCH AM Ledger Entry No.")) or
           (AMLedgEntry."Item Ledger Entry No." <> ItemLedgEntry."Entry No.")
        then
          exit;

        if (Item."No." <> ItemLedgEntry."Item No.") then
          Item.Get(ItemLedgEntry."Item No.");
        if (Item.Type = Item.Type::Inventory) then begin
          ItemLedgEntry.CalcFields("Cost Amount (Actual)");
          ValueEntryCostAmount := ItemLedgEntry."Cost Amount (Actual)";
        end else begin
          ItemLedgEntry.CalcFields("Cost Amount (Non-Invtbl.)");
          ValueEntryCostAmount := ItemLedgEntry."Cost Amount (Non-Invtbl.)";
        end;

        if (AMLedgEntry."Qty. Invoiced (Base)" = ItemLedgEntry."Invoiced Quantity") and
           (AMLedgEntry."Cost Amount" = ValueEntryCostAmount)
        then
          exit;

        AMLedgEntry."Qty. Invoiced (Base)" := ItemLedgEntry."Invoiced Quantity";
        AMLedgEntry."Qty. Invoiced" := Round(AMLedgEntry."Qty. Invoiced (Base)" / AMLedgEntry."Qty. per Unit of Measure",0.00001);
        AMLedgEntry."Cost Amount" := ValueEntryCostAmount;
        if (AMLedgEntry."Qty. Invoiced" = 0) then
          AMLedgEntry."Unit Cost" := 0
        else
          AMLedgEntry."Unit Cost" := Round(ValueEntryCostAmount / AMLedgEntry."Qty. Invoiced",GLSetup."Unit-Amount Rounding Precision");

        AMLedgEntry.Adjusted := true;
        AMLedgEntry."Adjustment Date-Time" := CurrentDateTime;
        AMLedgEntry.Modify;
        AMStructureEntryPost.UpdateStructureEntryCost(AMLedgEntry);
        exit(true);
    end;

    local procedure InsertAMRegister(NewAMLedgEntryNo: Integer)
    begin
        with MaintJnlLine do begin
          if AMReg."No." = 0 then begin
            AMReg.LockTable;
            if AMReg.FindLast then
              AMReg."No." := AMReg."No." + 1
            else
              AMReg."No." := 1;
            AMReg.Init;
            AMReg."From Entry No." := NewAMLedgEntryNo;
            AMReg."To Entry No." := NewAMLedgEntryNo;
            AMReg."Creation Date" := Today;
            AMReg."Creation Time" := Time;
            AMReg."Creation Date-Time" := CurrentDateTime;
            AMReg."User ID" := UserId;
            AMReg."Source Code" := "Source Code";
            AMReg."Journal Batch Name" := "Journal Batch Name";
            AMReg.Insert;
          end else begin
            if ((NewAMLedgEntryNo < AMReg."From Entry No.") and (NewAMLedgEntryNo <> 0)) or
               ((AMReg."From Entry No." = 0) and (NewAMLedgEntryNo > 0))
            then
              AMReg."From Entry No." := NewAMLedgEntryNo;
            if NewAMLedgEntryNo > AMReg."To Entry No." then
              AMReg."To Entry No." := NewAMLedgEntryNo;
            AMReg.Modify;
          end;
        end;
    end;

    local procedure GetSetup()
    begin
        if SetupRead then
          exit;
        SetupRead := true;
        GLSetup.Get;
        AMSetup.Get;
        AMSetup.TestField("Source Code");
    end;

    local procedure GetResource(ResNo: Code[20];var Resource: Record Resource)
    begin
        if TempResource.Get(ResNo) then begin
          Resource := TempResource;
          exit;
        end;
        Resource.Get(ResNo);
        TempResource := Resource;
        TempResource.Insert;
    end;

    local procedure GetMaintTeam(TeamCode: Code[20];var MaintTeam: Record "MCH Maintenance Team")
    begin
        if TempMaintTeam.Get(TeamCode) then begin
          MaintTeam := TempMaintTeam;
          exit;
        end;
        MaintTeam.Get(TeamCode);
        TempMaintTeam := MaintTeam;
        TempMaintTeam.Insert;
    end;
}

