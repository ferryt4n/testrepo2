codeunit 74030 "MCH AM Cost Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        Text002: Label '%1 cannot be found for the combination of %2 = %3, %4 = %5 and %6 = %7.';


    procedure FindWorkOrderBudgetDirectUnitCost(var WorkOrderBudgetLine: Record "MCH Work Order Budget Line";CalledByFieldNo: Integer)
    var
        TempReqLine: Record "Requisition Line";
        Item: Record Item;
        ResCost: Record "Resource Cost";
        MaintCost: Record "MCH Maintenance Cost";
        MaintSparePart: Record "MCH Maintenance Spare Part";
        MaintTrade: Record "MCH Maintenance Trade";
        MaintTeam: Record "MCH Maintenance Team";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        ResFindUnitCost: Codeunit "Resource-Find Cost";
        TempCalledByFieldNo: Integer;
        SearchItemPurchPrices: Boolean;
    begin
        with WorkOrderBudgetLine do begin
          if ("No." = '') then begin
            "Direct Unit Cost" := 0;
            exit;
          end;
          GetGLSetup;

          case Type of
            Type::Item,Type::"Spare Part",Type::Cost,Type::Trade:
              begin
                case Type of
                  Type::Item:
                    begin
                      Item.Get("No.");
                      SearchItemPurchPrices := true;
                    end;
                  Type::"Spare Part":
                    with MaintSparePart do begin
                      Get(WorkOrderBudgetLine."No.");
                      GetItem(Item);
                      SearchItemPurchPrices := ("Fixed Direct Unit Cost" <= 0);
                      if not SearchItemPurchPrices then
                        WorkOrderBudgetLine."Direct Unit Cost" := "Fixed Direct Unit Cost";
                    end;
                  Type::Cost:
                    with MaintCost do begin
                      Get(WorkOrderBudgetLine."No.");
                      GetItem(Item);
                      SearchItemPurchPrices := ("Fixed Direct Unit Cost" <= 0);
                      if not SearchItemPurchPrices then
                        WorkOrderBudgetLine."Direct Unit Cost" := "Fixed Direct Unit Cost";
                    end;
                  Type::Trade:
                    with MaintTrade do begin
                      Get(WorkOrderBudgetLine."No.");
                      GetItem(Item);
                      SearchItemPurchPrices := ("Fixed Direct Unit Cost" <= 0);
                      if not SearchItemPurchPrices then
                        WorkOrderBudgetLine."Direct Unit Cost" := "Fixed Direct Unit Cost";
                    end;
                end;
                if SearchItemPurchPrices then begin
                  TempReqLine.Type := TempReqLine.Type::Item;
                  TempReqLine."No." := Item."No.";
                  TempReqLine.Quantity := Quantity;
                  TempReqLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                  TempReqLine."Unit of Measure Code" := "Unit of Measure Code";
                  TempReqLine."Quantity (Base)" := "Quantity (Base)";
                  TempReqLine."Vendor No." := "Vendor No.";
                  TempReqLine."Location Code" := "Location Code";
                  TempReqLine."Variant Code" := "Variant Code";
                  TempReqLine."Direct Unit Cost" := "Direct Unit Cost";
                  if "Starting Date" <> 0D then
                    TempReqLine."Order Date" := "Starting Date"
                  else
                    TempReqLine."Order Date" := WorkDate;
                  case CalledByFieldNo of
                    FieldNo(Quantity) :
                      TempCalledByFieldNo := TempReqLine.FieldNo(Quantity);
                    FieldNo("Variant Code") :
                      TempCalledByFieldNo := TempReqLine.FieldNo("Variant Code");
                    else
                      TempCalledByFieldNo := 0;
                  end;
                  PurchPriceCalcMgt.FindReqLinePrice(TempReqLine,TempCalledByFieldNo);
                  "Direct Unit Cost" := TempReqLine."Direct Unit Cost";
                end;
              end;
            Type::Resource :
              begin
                ResCost.Init;
                ResCost.Code := "No.";
                ResCost."Work Type Code" := "Resource Work Type Code";
                ResFindUnitCost.Run(ResCost);
                "Direct Unit Cost" := ResCost."Direct Unit Cost";
              end;
            Type::Team :
              begin
                MaintTeam.Get("No.");
                "Direct Unit Cost" := MaintTeam."Direct Unit Cost";
              end;
          end;
           "Direct Unit Cost" := Round("Direct Unit Cost",GLSetup."Unit-Amount Rounding Precision");
        end;
    end;


    procedure FindMaintTaskBudgetLineDirUnitCost(var MaintTaskBudgetLine: Record "MCH Maint. Task Budget Line";CalledByFieldNo: Integer)
    var
        TempReqLine: Record "Requisition Line";
        Item: Record Item;
        ResCost: Record "Resource Cost";
        MaintCost: Record "MCH Maintenance Cost";
        MaintSparePart: Record "MCH Maintenance Spare Part";
        MaintTrade: Record "MCH Maintenance Trade";
        MaintTeam: Record "MCH Maintenance Team";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        ResFindUnitCost: Codeunit "Resource-Find Cost";
        TempCalledByFieldNo: Integer;
        SearchItemPurchPrices: Boolean;
    begin
        with MaintTaskBudgetLine do begin
          if ("No." = '') then begin
            "Direct Unit Cost" := 0;
            exit;
          end;
          GetGLSetup;

          case Type of
        Type::Item,Type::"Spare Part",Type::Cost,Type::Trade:
              begin
                case Type of
                  Type::Item:
                    begin
                      Item.Get("No.");
                      SearchItemPurchPrices := true;
                    end;
                  Type::"Spare Part":
                    with MaintSparePart do begin
                      Get(MaintTaskBudgetLine."No.");
                      GetItem(Item);
                      SearchItemPurchPrices := ("Fixed Direct Unit Cost" <= 0);
                      if not SearchItemPurchPrices then
                        MaintTaskBudgetLine."Direct Unit Cost" := "Fixed Direct Unit Cost";
                    end;
                  Type::Cost:
                    with MaintCost do begin
                      Get(MaintTaskBudgetLine."No.");
                      GetItem(Item);
                      SearchItemPurchPrices := ("Fixed Direct Unit Cost" <= 0);
                      if not SearchItemPurchPrices then
                        MaintTaskBudgetLine."Direct Unit Cost" := "Fixed Direct Unit Cost";
                    end;
                  Type::Trade:
                    with MaintTrade do begin
                      Get(MaintTaskBudgetLine."No.");
                      GetItem(Item);
                      SearchItemPurchPrices := ("Fixed Direct Unit Cost" <= 0);
                      if not SearchItemPurchPrices then
                        MaintTaskBudgetLine."Direct Unit Cost" := "Fixed Direct Unit Cost";
                    end;
                end;
                if SearchItemPurchPrices then begin
                  TempReqLine.Type := TempReqLine.Type::Item;
                  TempReqLine."No." := Item."No.";
                  TempReqLine.Quantity := Quantity;
                  TempReqLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                  TempReqLine."Unit of Measure Code" := "Unit of Measure Code";
                  TempReqLine."Quantity (Base)" := "Quantity (Base)";
                  TempReqLine."Vendor No." := "Vendor No.";
                  TempReqLine."Location Code" := "Location Code";
                  TempReqLine."Variant Code" := "Variant Code";
                  TempReqLine."Direct Unit Cost" := "Direct Unit Cost";
                  TempReqLine."Order Date" := WorkDate;
                  case CalledByFieldNo of
                    FieldNo(Quantity) :
                      TempCalledByFieldNo := TempReqLine.FieldNo(Quantity);
                    FieldNo("Variant Code") :
                      TempCalledByFieldNo := TempReqLine.FieldNo("Variant Code");
                    else
                      TempCalledByFieldNo := 0;
                  end;
                  PurchPriceCalcMgt.FindReqLinePrice(TempReqLine,TempCalledByFieldNo);
                  "Direct Unit Cost" := TempReqLine."Direct Unit Cost";
                end;
              end;
            Type::Resource :
              begin
                ResCost.Init;
                ResCost.Code := "No.";
                ResCost."Work Type Code" := "Resource Work Type Code";
                ResFindUnitCost.Run(ResCost);
                "Direct Unit Cost" := ResCost."Direct Unit Cost";
              end;
            Type::Team :
              begin
                MaintTeam.Get("No.");
                "Direct Unit Cost" := MaintTeam."Direct Unit Cost";
              end;
          end;
          "Direct Unit Cost" := Round("Direct Unit Cost",GLSetup."Unit-Amount Rounding Precision");
        end;
    end;


    procedure FindAMPostingSetup(var AMPostingSetup: Record "MCH AM Posting Setup";ShowErrorMessage: Boolean;MAPostGrp: Code[20];GenProdPostGrp: Code[20];WorkOrderType: Code[20]) Ok: Boolean
    begin
        case true of
          AMPostingSetup.Get(MAPostGrp,GenProdPostGrp,WorkOrderType) : ;
          AMPostingSetup.Get(MAPostGrp,'',WorkOrderType) : ;
          AMPostingSetup.Get(MAPostGrp,GenProdPostGrp,'') : ;
          AMPostingSetup.Get(MAPostGrp,'','') : ;
          else
            if not ShowErrorMessage then
              exit(false)
            else
              Error(
                StrSubstNo(Text002,
                AMPostingSetup.TableCaption,
                AMPostingSetup.FieldCaption("Asset Posting Group"),MAPostGrp,
                AMPostingSetup.FieldCaption("Gen. Prod. Posting Group"),GenProdPostGrp,
                AMPostingSetup.FieldCaption("Work Order Type"),WorkOrderType));
        end;
        exit(true);
    end;


    procedure CalcMaintTeamRolledUpMemberCost(var NewMaintTeam: Record "MCH Maintenance Team";Update: Boolean;ShowDialog: Boolean)
    var
        MaintTeam: Record "MCH Maintenance Team";
        MaintTeamMember: Record "MCH Maint. Team Member";
        Resource: Record Resource;
        ResUnitOfMeasure: Record "Resource Unit of Measure";
        ResCost: Record "Resource Cost";
        AMFunction: Codeunit "MCH AM Functions";
        UnitCost: Decimal;
        DirectUnitCost: Decimal;
        QtyFactor: Decimal;
        RollUpMemberCostQst: Label 'Do you want to calculate the rolled-up member costs for %1 %2 ?';
    begin
        MaintTeam := NewMaintTeam;
        if ShowDialog then
          if not Confirm(RollUpMemberCostQst,false,MaintTeam.TableCaption,MaintTeam.Code) then
            exit;
        GetGLSetup;
        if Update then begin
          MaintTeam.LockTable;
          MaintTeam.Get(MaintTeam.Code);
        end;

        MaintTeamMember.SetRange("Maint. Team Code",MaintTeam.Code);
        if MaintTeamMember.FindSet then begin
          repeat
            Resource.Get(MaintTeamMember."Resource No.");
            MaintTeamMember.TestField("Unit of Measure Code");
            MaintTeamMember.TestField("Quantity per");
            AMFunction.TestIfUOMTimeBased(MaintTeamMember."Unit of Measure Code",true);

            ResUnitOfMeasure.Get(MaintTeamMember."Resource No.",MaintTeamMember."Unit of Measure Code");
            ResUnitOfMeasure.TestField("Related to Base Unit of Meas.",true);
            QtyFactor := MaintTeamMember."Quantity per" * ResUnitOfMeasure."Qty. per Unit of Measure";

            ResCost.Init;
            ResCost.Code := MaintTeamMember."Resource No.";
            ResCost."Work Type Code" := '';
            CODEUNIT.Run(CODEUNIT::"Resource-Find Cost",ResCost);
            UnitCost := UnitCost + (QtyFactor * ResCost."Unit Cost");
            DirectUnitCost := DirectUnitCost + (QtyFactor * ResCost."Direct Unit Cost");
          until MaintTeamMember.Next = 0;
        end else
          exit;

        MaintTeam."Unit Cost" := Round(UnitCost,GLSetup."Unit-Amount Rounding Precision");
        MaintTeam."Direct Unit Cost" := Round(DirectUnitCost,GLSetup."Unit-Amount Rounding Precision");
        if MaintTeam."Direct Unit Cost" <> 0 then
          MaintTeam."Indirect Cost %" :=
            Round(100 * (MaintTeam."Unit Cost" - MaintTeam."Direct Unit Cost") / MaintTeam."Direct Unit Cost")
        else
          MaintTeam."Indirect Cost %" := 0;

        if Update then
          MaintTeam.Modify(true);
        NewMaintTeam := MaintTeam;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure CalcMAAccumulatedCost(var MaintAsset: Record "MCH Maintenance Asset";var AccumulatedCost: Decimal)
    var
        AMStructureLedgEntry: Record "MCH AM Structure Ledger Entry";
    begin
        with AMStructureLedgEntry do begin
          SetCurrentKey(
            "Asset No.","Work Order Type","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date");
          SetRange("Asset No.",MaintAsset."No.");
          SetFilter("Work Order Type",MaintAsset.GetFilter("Work Order Type Filter"));
          SetFilter("Global Dimension 1 Code",MaintAsset.GetFilter("Global Dimension 1 Filter"));
          SetFilter("Global Dimension 2 Code",MaintAsset.GetFilter("Global Dimension 2 Filter"));
          SetFilter("Posting Date",MaintAsset.GetFilter("Date Filter"));
          CalcSums("Cost Amount");
        end;
        AccumulatedCost := AMStructureLedgEntry."Cost Amount";
    end;


    procedure CalcMAAccumulatedHours(var MaintAsset: Record "MCH Maintenance Asset";var AccumulatedHours: Decimal)
    var
        AMStructureLedgEntry: Record "MCH AM Structure Ledger Entry";
    begin
        with AMStructureLedgEntry do begin
          SetCurrentKey(
            "Asset No.","Work Order Type","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date");
          SetRange("Asset No.",MaintAsset."No.");
          SetFilter("Work Order Type",MaintAsset.GetFilter("Work Order Type Filter"));
          SetFilter("Global Dimension 1 Code",MaintAsset.GetFilter("Global Dimension 1 Filter"));
          SetFilter("Global Dimension 2 Code",MaintAsset.GetFilter("Global Dimension 2 Filter"));
          SetFilter("Posting Date",MaintAsset.GetFilter("Date Filter"));
          CalcSums(Hours);
        end;
        AccumulatedHours := AMStructureLedgEntry.Hours;
    end;
}

