tableextension 74031 "MCH AM Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(74030; "MCH Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = CustomerContent;
            TableRelation = "MCH Work Order Header"."No." WHERE (Status = CONST (Released));

            trigger OnValidate()
            var
                WorkOrderLine: Record "MCH Work Order Line";
            begin
                IF ("MCH Work Order No." <> xRec."MCH Work Order No.") THEN BEGIN
                    TestStatusOpen;
                    TESTFIELD("Qty. Rcd. Not Invoiced", 0);
                    TESTFIELD("Return Qty. Shipped Not Invd.", 0);
                    "MCH WO Budget Line No." := 0;
                    "MCH Work Order Line No." := 0;
                    "MCH WO Purchase Code" := '';
                    "MCH WO Purchase Type" := "MCH WO Purchase Type"::" ";
                    IF ("MCH Work Order No." <> '') THEN BEGIN
                        IF (CurrFieldNo = FIELDNO("MCH Work Order No.")) THEN
                            MCHCheckWorkOrderPurchEntryAllowed("MCH Work Order No.");
                        WorkOrderLine.SETRANGE(Status, WorkOrderLine.Status::Released);
                        WorkOrderLine.SETRANGE("Work Order No.", "MCH Work Order No.");
                        WorkOrderLine.SETFILTER("Asset No.", '<>%1', '');
                        IF WorkOrderLine.FINDSET THEN
                            IF (WorkOrderLine.NEXT = 0) THEN
                                "MCH Work Order Line No." := WorkOrderLine."Line No.";
                    END;
                END;
            end;
        }
        field(74031; "MCH Work Order Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Work Order Line No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("MCH Work Order No." = FILTER (<> '')) "MCH Work Order Line"."Line No." WHERE (Status = CONST (Released),
                                                                                                           "Work Order No." = FIELD ("MCH Work Order No."));

            trigger OnValidate()
            var
                WorkOrderLine: Record "MCH Work Order Line";
            begin
                IF ("MCH Work Order Line No." <> xRec."MCH Work Order Line No.") THEN BEGIN
                    TestStatusOpen;
                    TESTFIELD("Qty. Rcd. Not Invoiced", 0);
                    TESTFIELD("Return Qty. Shipped Not Invd.", 0);
                    IF ("MCH Work Order Line No." <> 0) THEN BEGIN
                        TESTFIELD("MCH Work Order No.");
                        WorkOrderLine.GET(WorkOrderLine.Status::Released, "MCH Work Order No.", "MCH Work Order Line No.");
                        WorkOrderLine.TESTFIELD("Asset No.");
                    END;
                    IF ("MCH WO Budget Line No." <> 0) THEN
                        VALIDATE("MCH WO Budget Line No.", 0);
                END;
            end;
        }
        field(74032; "MCH WO Budget Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'WO Budget Line No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("MCH Work Order No." = FILTER (<> ''),
                                "MCH Work Order Line No." = FILTER (<> 0)) "MCH Work Order Budget Line"."Line No." WHERE (Status = CONST (Released),
                                                                                                                      "Work Order No." = FIELD ("MCH Work Order No."),
                                                                                                                      "Work Order Line No." = FIELD ("MCH Work Order Line No."),
                                                                                                                      Type = FILTER ("Spare Part" | Cost | Trade))
            ELSE
            IF ("MCH Work Order No." = FILTER (<> '')) "MCH Work Order Budget Line"."Line No." WHERE (Status = CONST (Released),
                                                                                                  "Work Order No." = FIELD ("MCH Work Order No."),
                                                                                                  Type = FILTER ("Spare Part" | Cost | Trade));

            trigger OnValidate()
            var
                WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
            begin
                IF ("MCH WO Budget Line No." <> xRec."MCH WO Budget Line No.") THEN BEGIN
                    TestStatusOpen;
                    TESTFIELD("Qty. Rcd. Not Invoiced", 0);
                    TESTFIELD("Return Qty. Shipped Not Invd.", 0);
                    IF ("MCH WO Budget Line No." <> 0) THEN BEGIN
                        TESTFIELD("MCH Work Order No.");
                        TESTFIELD("Line No.");
                        WorkOrderBudgetLine.GET(WorkOrderBudgetLine.Status::Released, "MCH Work Order No.", "MCH WO Budget Line No.");
                        MCHTransferFromWorkOrderBudgetLine(WorkOrderBudgetLine);
                    END ELSE
                        VALIDATE("MCH WO Purchase Type", "MCH WO Purchase Type"::" ");
                END;
            end;
        }
        field(74033; "MCH WO Purchase Type"; Option)
        {
            Caption = 'WO Purchase Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Spare Part,Cost,Trade';
            OptionMembers = " ","Spare Part",Cost,Trade;

            trigger OnValidate()
            begin
                IF ("MCH WO Purchase Type" <> xRec."MCH WO Purchase Type") THEN
                    VALIDATE("MCH WO Purchase Code", '');
            end;
        }
        field(74034; "MCH WO Purchase Code"; Code[20])
        {
            Caption = 'WO Purchase Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("MCH WO Purchase Type" = CONST ("Spare Part")) "MCH Maintenance Spare Part"
            ELSE
            IF ("MCH WO Purchase Type" = CONST (Cost)) "MCH Maintenance Cost"
            ELSE
            IF ("MCH WO Purchase Type" = CONST (Trade)) "MCH Maintenance Trade";

            trigger OnValidate()
            var
                TempPurchLine: Record "Purchase Line" temporary;
                SparePart: Record "MCH Maintenance Spare Part";
                MaintCost: Record "MCH Maintenance Cost";
                MaintTrade: Record "MCH Maintenance Trade";
                Item: Record Item;
                PurchHeader: Record "Purchase Header";
                GLSetup: Record "General Ledger Setup";
                Currency: Record Currency;
                CurrExchRate: Record "Currency Exchange Rate";
                ExchRateDate: Date;
                DirUnitCost: Decimal;
            begin
                IF ("MCH WO Purchase Code" = xRec."MCH WO Purchase Code") THEN
                    EXIT;
                TestStatusOpen;
                TESTFIELD("Qty. Rcd. Not Invoiced", 0);
                TESTFIELD("Return Qty. Shipped Not Invd.", 0);
                IF "MCH WO Purchase Code" = '' THEN
                    EXIT;
                TESTFIELD("MCH Work Order No.");
                TESTFIELD("MCH Work Order Line No.");
                TESTFIELD("MCH WO Purchase Type");
                IF (CurrFieldNo <> 0) THEN
                    MCHCheckWorkOrderPurchEntryAllowed("MCH Work Order No.");

                CASE "MCH WO Purchase Type" OF
                    "MCH WO Purchase Type"::"Spare Part":
                        BEGIN
                            SparePart.GET("MCH WO Purchase Code");
                            SparePart.TESTFIELD(Blocked, FALSE);
                            SparePart.GetItemWithEffectiveValues(Item, TRUE);
                            DirUnitCost := SparePart."Fixed Direct Unit Cost";
                        END;
                    "MCH WO Purchase Type"::Cost:
                        BEGIN
                            MaintCost.GET("MCH WO Purchase Code");
                            MaintCost.TESTFIELD(Blocked, FALSE);
                            MaintCost.GetItemWithEffectiveValues(Item, TRUE);
                            DirUnitCost := MaintCost."Fixed Direct Unit Cost";
                        END;
                    "MCH WO Purchase Type"::Trade:
                        BEGIN
                            MaintTrade.GET("MCH WO Purchase Code");
                            MaintTrade.TESTFIELD(Blocked, FALSE);
                            MaintTrade.GetItemWithEffectiveValues(Item, TRUE);
                            DirUnitCost := MaintTrade."Fixed Direct Unit Cost";
                        END;
                    ELSE
                        FIELDERROR("MCH WO Purchase Type");
                END;

                TempPurchLine := Rec;
                IF (Type <> Type::Item) THEN
                    VALIDATE(Type, Type::Item);
                IF ("No." <> Item."No.") THEN
                    VALIDATE("No.", Item."No.");

                "MCH Work Order No." := TempPurchLine."MCH Work Order No.";
                "MCH WO Budget Line No." := TempPurchLine."MCH WO Budget Line No.";
                "MCH Work Order Line No." := TempPurchLine."MCH Work Order Line No.";
                "MCH WO Purchase Type" := TempPurchLine."MCH WO Purchase Type";
                "MCH WO Purchase Code" := TempPurchLine."MCH WO Purchase Code";

                Description := Item.Description;
                "Description 2" := Item."Description 2";
                IF (Item."Purch. Unit of Measure" <> '') AND ("Unit of Measure Code" <> Item."Purch. Unit of Measure") THEN
                    VALIDATE("Unit of Measure Code", Item."Purch. Unit of Measure");
                IF ("Gen. Prod. Posting Group" <> Item."Gen. Prod. Posting Group") THEN
                    VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");

                IF (DirUnitCost <> 0) THEN BEGIN
                    PurchHeader.GET("Document Type", "Document No.");
                    IF (PurchHeader."Currency Code" <> '') THEN BEGIN
                        Currency.GET(PurchHeader."Currency Code");
                        Currency.TESTFIELD("Unit-Amount Rounding Precision");
                        PurchHeader.TESTFIELD("Currency Factor");
                        ExchRateDate := PurchHeader."Posting Date";
                        IF ExchRateDate = 0D THEN
                            ExchRateDate := WORKDATE;
                    END ELSE
                        GLSetup.GET;

                    IF PurchHeader."Prices Including VAT" THEN
                        DirUnitCost := DirUnitCost * (1 + "VAT %" / 100);

                    IF (PurchHeader."Currency Code" <> '') THEN BEGIN
                        DirUnitCost := CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, DirUnitCost, PurchHeader."Currency Factor");
                        DirUnitCost := ROUND(DirUnitCost, Currency."Unit-Amount Rounding Precision");
                    END ELSE
                        DirUnitCost := ROUND(DirUnitCost, GLSetup."Unit-Amount Rounding Precision");
                    VALIDATE("Direct Unit Cost", DirUnitCost);
                END;

                MCHUpdateDimensionsFromWorkOrderLine(Rec);
            end;
        }
    }

    keys
    {
        key(MCHAssetMaintenanceKey1; "MCH Work Order No.", "MCH WO Budget Line No.", "MCH Work Order Line No.")
        {
        }
    }
    procedure MCHTransferFromWorkOrderBudgetLine(WOBudgetLine: Record "MCH Work Order Budget Line")
    var
        TempPurchLine: Record "Purchase Line" temporary;
        MaintCost: Record "MCH Maintenance Cost";
        SparePart: Record "MCH Maintenance Spare Part";
        MaintTrade: Record "MCH Maintenance Trade";
        Item: Record Item;
        PurchHeader: Record "Purchase Header";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ExchRateDate: Date;
        DirUnitCost: Decimal;
    begin
        WOBudgetLine.GET(WOBudgetLine.Status::Released, "MCH Work Order No.", "MCH WO Budget Line No.");
        IF NOT (WOBudgetLine.Type IN [WOBudgetLine.Type::"Spare Part", WOBudgetLine.Type::Cost, WOBudgetLine.Type::Trade]) THEN
            WOBudgetLine.FIELDERROR(Type);
        WOBudgetLine.TESTFIELD("No.");

        "MCH Work Order Line No." := WOBudgetLine."Work Order Line No.";
        CASE WOBudgetLine.Type OF
            WOBudgetLine.Type::"Spare Part":
                BEGIN
                    "MCH WO Purchase Type" := "MCH WO Purchase Type"::"Spare Part";
                    "MCH WO Purchase Code" := WOBudgetLine."No.";
                    SparePart.GET("MCH WO Purchase Code");
                    SparePart.TESTFIELD(Blocked, FALSE);
                    SparePart.GetItemWithEffectiveValues(Item, TRUE);
                END;
            WOBudgetLine.Type::Cost:
                BEGIN
                    "MCH WO Purchase Type" := "MCH WO Purchase Type"::Cost;
                    "MCH WO Purchase Code" := WOBudgetLine."No.";
                    MaintCost.GET("MCH WO Purchase Code");
                    MaintCost.TESTFIELD(Blocked, FALSE);
                    MaintCost.GetItemWithEffectiveValues(Item, TRUE);
                END;
            "MCH WO Purchase Type"::Trade:
                BEGIN
                    "MCH WO Purchase Type" := "MCH WO Purchase Type"::Trade;
                    "MCH WO Purchase Code" := WOBudgetLine."No.";
                    MaintTrade.GET("MCH WO Purchase Code");
                    MaintTrade.TESTFIELD(Blocked, FALSE);
                    MaintTrade.GetItemWithEffectiveValues(Item, TRUE);
                END;
        END;
        TempPurchLine := Rec;
        IF (Type <> Type::Item) THEN
            VALIDATE(Type, Type::Item);
        IF ("No." <> Item."No.") THEN
            VALIDATE("No.", Item."No.");
        "MCH Work Order No." := TempPurchLine."MCH Work Order No.";
        "MCH WO Budget Line No." := TempPurchLine."MCH WO Budget Line No.";
        "MCH Work Order Line No." := TempPurchLine."MCH Work Order Line No.";
        "MCH WO Purchase Type" := TempPurchLine."MCH WO Purchase Type";
        "MCH WO Purchase Code" := TempPurchLine."MCH WO Purchase Code";

        Description := WOBudgetLine.Description;
        "Description 2" := WOBudgetLine."Description 2";
        IF ("Gen. Prod. Posting Group" <> Item."Gen. Prod. Posting Group") THEN
            VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");

        IF "Unit of Measure Code" <> WOBudgetLine."Unit of Measure Code" THEN
            VALIDATE("Unit of Measure Code", WOBudgetLine."Unit of Measure Code");
        IF Quantity <> WOBudgetLine.Quantity THEN
            VALIDATE(Quantity, WOBudgetLine.Quantity);

        DirUnitCost := WOBudgetLine."Direct Unit Cost";
        IF (DirUnitCost <> 0) THEN BEGIN
            PurchHeader.GET("Document Type", "Document No.");
            IF (PurchHeader."Currency Code" <> '') THEN BEGIN
                Currency.GET(PurchHeader."Currency Code");
                Currency.TESTFIELD("Unit-Amount Rounding Precision");
                PurchHeader.TESTFIELD("Currency Factor");
                ExchRateDate := PurchHeader."Posting Date";
                IF ExchRateDate = 0D THEN
                    ExchRateDate := WORKDATE;
            END ELSE
                GLSetup.GET;

            IF PurchHeader."Prices Including VAT" THEN
                DirUnitCost := DirUnitCost * (1 + "VAT %" / 100);

            IF (PurchHeader."Currency Code" <> '') THEN BEGIN
                DirUnitCost := CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, DirUnitCost, PurchHeader."Currency Factor");
                DirUnitCost := ROUND(DirUnitCost, Currency."Unit-Amount Rounding Precision");
            END ELSE
                DirUnitCost := ROUND(DirUnitCost, GLSetup."Unit-Amount Rounding Precision");
            VALIDATE("Direct Unit Cost", DirUnitCost);
        END;

        MCHUpdateDimensionsFromWorkOrderLine(Rec);
    end;

    procedure MCHUpdateDimensionsFromWorkOrderLine(var PurchLine: Record "Purchase Line")
    var
        WorkOrderLine: Record "MCH Work Order Line";
        DimMgt: Codeunit DimensionManagement;
        DimSetArrID: array[10] of Integer;
    begin
        with PurchLine do begin
            IF ("MCH Work Order No." = '') OR ("MCH Work Order Line No." = 0) THEN
                EXIT;
            IF NOT WorkOrderLine.GET(WorkOrderLine.Status::Released, "MCH Work Order No.", "MCH Work Order Line No.") THEN
                EXIT;
            DimSetArrID[1] := "Dimension Set ID";
            DimSetArrID[2] := WorkOrderLine."Dimension Set ID";
            "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetArrID, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        end;
    end;

    local procedure MCHCheckWorkOrderPurchEntryAllowed(WONo: Code[20])
    var
        WorkOrder: Record "MCH Work Order Header";
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        WorkOrder.GET(WorkOrder.Status::Released, WONo);
        AMFunctions.CheckIfPurchEntryBlocked2(WorkOrder, TRUE);
    end;

    procedure MCHShowWorkOrder()
    var
        WorkOrder: Record "MCH Work Order Header";
        AMUserMgt: codeunit "MCH AM User Mgt.";
        UserRespGrpAccesErrMsg: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
    begin
        IF ("MCH Work Order No." = '') THEN
            EXIT;
        WorkOrder.GET(WorkOrder.Status::Released, "MCH Work Order No.");
        IF NOT AMUserMgt.UserHasAccessToRespGroup(USERID, WorkOrder."Responsibility Group Code") THEN BEGIN
            ERROR(UserRespGrpAccesErrMsg,
              WorkOrder.TABLECAPTION, WorkOrder."No.",
              WorkOrder.FIELDCAPTION("Responsibility Group Code"), WorkOrder."Responsibility Group Code");
        END;
        WorkOrder.ShowCard;
    end;
}