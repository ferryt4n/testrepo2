table 74049 "MCH Maintenance Spare Part"
{
    Caption = 'Maintenance Spare Part';
    DataCaptionFields = "No.",Description;
    DrillDownPageID = "MCH Maint. Spare Part List";
    LookupPageID = "MCH Maint. Spare Part Lookup";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  AMSetup.Get;
                  NoSeriesMgt.TestManual(AMSetup."Spare Part Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(3;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(5;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Item WHERE (Type=FILTER("Non-Inventory"|Service));

            trigger OnValidate()
            begin
                if ("Item No." <> xRec."Item No.") then begin
                  if (xRec."Item No." <> '') and (CurrFieldNo = FieldNo("Item No.")) then begin
                    if not Confirm(ConfirmChangeQst,false,FieldCaption("Item No.")) then begin
                      "Item No." := xRec."Item No.";
                      exit;
                    end;
                  end;
                  TestField("Maint. Unit of Measure",'');
                end;
            end;
        }
        field(6;"Item Description";Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;Picture;Media)
        {
            Caption = 'Picture';
        }
        field(8;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(9;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(30;"Manufacturer Code";Code[50])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(35;"Manufacturers Part No.";Code[50])
        {
            Caption = 'Manufacturers Part No.';
        }
        field(36;"Original Part No.";Code[50])
        {
            Caption = 'Original Part No.';
        }
        field(60;Comment;Boolean)
        {
            CalcFormula = Exist("MCH AM Comment Line" WHERE ("Table Name"=CONST("Spare Part"),
                                                             "No."=FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Item Purch. Unit of Measure";Code[10])
        {
            CalcFormula = Lookup(Item."Purch. Unit of Measure" WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Purch. Unit of Measure';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."));
        }
        field(101;"Item Gen. Prod. Posting Group";Code[20])
        {
            CalcFormula = Lookup(Item."Gen. Prod. Posting Group" WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Gen. Prod. Posting Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Gen. Product Posting Group";
        }
        field(103;"Item Last Direct Cost";Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Lookup(Item."Last Direct Cost" WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Last Direct Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Item Vendor No.";Code[20])
        {
            CalcFormula = Lookup(Item."Vendor No." WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Vendor No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vendor;
        }
        field(106;"Item Base Unit of Measure";Code[10])
        {
            CalcFormula = Lookup(Item."Base Unit of Measure" WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Base Unit of Measure';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."));
        }
        field(150;"Maint. Unit of Measure";Code[10])
        {
            Caption = 'Maint. Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."));
        }
        field(151;"Maint. Gen. Prod. Posting Grp.";Code[20])
        {
            Caption = 'Maint. Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";
        }
        field(152;"Fixed Direct Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Fixed Direct Unit Cost';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                //"Direct Unit Cost" := ROUND("Unit Cost" * (100 / (100 + "Indirect Cost %")));
            end;
        }
        field(154;"Maint. Vendor No.";Code[20])
        {
            Caption = 'Maint. Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Description,"Item No.")
        {
        }
    }

    trigger OnDelete()
    var
        MaintCommentLine: Record "MCH AM Comment Line";
        AMaintLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        MaintTaskBudgetLine: Record "MCH Maint. Task Budget Line";
        WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
    begin
        AMaintLedgEntry.SetRange(Type,AMaintLedgEntry.Type::"Spare Part");
        AMaintLedgEntry.SetRange("No.","No.");
        if not AMaintLedgEntry.IsEmpty then
          Error(CannotDeleteErr,TableCaption,"No.",AMaintLedgEntry.TableCaption);

        MaintTaskBudgetLine.SetRange(Type,MaintTaskBudgetLine.Type::"Spare Part");
        MaintTaskBudgetLine.SetRange("No.","No.");
        if not MaintTaskBudgetLine.IsEmpty then
          Error(CannotDeleteErr,TableCaption,"No.",MaintTaskBudgetLine.TableCaption);

        WorkOrderBudgetLine.SetRange(Type,WorkOrderBudgetLine.Type::"Spare Part");
        WorkOrderBudgetLine.SetRange("No.","No.");
        if not WorkOrderBudgetLine.IsEmpty then
          Error(CannotDeleteErr,TableCaption,"No.",WorkOrderBudgetLine.TableCaption);

        if ("No." <> '') then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);

        MaintCommentLine.SetRange("Table Name",MaintCommentLine."Table Name"::"Spare Part");
        MaintCommentLine.SetRange("No.","No.");
        MaintCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        AMSetup.Get ;
        if "No." = '' then begin
          AMSetup.TestField("Spare Part Nos.");
          NoSeriesMgt.InitSeries(AMSetup."Spare Part Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ConfirmChangeQst: Label 'Do you really want to change the %1 ?';
        AMFunctions: Codeunit "MCH AM Functions";
        CannotDeleteErr: Label '%1 %2 cannot be deleted because it is referenced by one or more %3 records.';


    procedure AssistEdit(OldSparePart: Record "MCH Maintenance Spare Part"): Boolean
    var
        CurrSparePart: Record "MCH Maintenance Spare Part";
    begin
        with CurrSparePart do begin
          CurrSparePart := Rec;
          AMSetup.Get;
          AMSetup.TestField("Spare Part Nos.");
          if NoSeriesMgt.SelectSeries(AMSetup."Spare Part Nos.",OldSparePart."No. Series","No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := CurrSparePart;
            exit(true);
          end;
        end;
    end;

    [TryFunction]

    procedure GetItem(var Item: Record Item)
    begin
        Clear(Item);
        TestField("Item No.");
        Item.Get("Item No.");
    end;

    [TryFunction]

    procedure GetItemWithEffectiveValues(var Item: Record Item;CheckItem: Boolean)
    begin
        GetItem(Item);
        if ("Maint. Unit of Measure" <> '') then
          Item."Purch. Unit of Measure" := "Maint. Unit of Measure";
        if ("Maint. Gen. Prod. Posting Grp." <> '') then
          Item."Gen. Prod. Posting Group" := "Maint. Gen. Prod. Posting Grp.";
        if ("Maint. Vendor No." <> '') then
          Item."Vendor No." := "Maint. Vendor No.";
        if (Description <> '') then
          Item.Description := Description;
        if ("Description 2" <> '') then
          Item."Description 2" := "Description 2";

        if CheckItem then begin
          if (Item.Type = Item.Type::Inventory) then
            Item.FieldError(Type);
          Item.TestField(Blocked,false);
          Item.TestField("Gen. Prod. Posting Group");
          Item.TestField("Base Unit of Measure");
        end;
    end;


    procedure FindEffectiveUnitOfMeasure() EffectivePurchUnitOfMeasure: Code[10]
    begin
        if ("Maint. Unit of Measure" <> '') then
          exit("Maint. Unit of Measure");
        CalcFields("Item Purch. Unit of Measure","Item Base Unit of Measure");
        if ("Item Purch. Unit of Measure" <> '') then
          exit("Item Purch. Unit of Measure")
        else
          exit("Item Base Unit of Measure");
    end;


    procedure FindEffectiveGenProdPostingGroup() EffectiveGenProdPostingGroup: Code[20]
    begin
        if ("Maint. Gen. Prod. Posting Grp." <> '') then
          exit("Maint. Gen. Prod. Posting Grp.");
        CalcFields("Item Gen. Prod. Posting Group");
        exit("Item Gen. Prod. Posting Group");
    end;


    procedure FindEffectiveVendorNo() EffectiveVendorNo: Code[20]
    begin
        if ("Maint. Vendor No." <> '') then
          exit("Maint. Vendor No.");
        CalcFields("Item Vendor No.");
        exit("Item Vendor No.");
    end;


    procedure ShowPurchasePrices()
    var
        Item: Record Item;
        PurchasePrice: Record "Purchase Price";
        PurchasePricesPage: Page "Purchase Prices";
    begin
        if not GetItem(Item) then
          exit;
        PurchasePrice.SetCurrentKey("Item No.");
        PurchasePrice.SetRange("Item No.",Item."No.");
        PurchasePrice.SetFilter("Vendor No.",FindEffectiveVendorNo);
        PurchasePricesPage.SetTableView(PurchasePrice);
        PurchasePricesPage.RunModal;
    end;


    procedure ShowPurchaseDiscounts()
    var
        Item: Record Item;
        PurchaseLineDiscount: Record "Purchase Line Discount";
        PurchaseLineDiscountsPage: Page "Purchase Line Discounts";
    begin
        if not GetItem(Item) then
          exit;
        PurchaseLineDiscount.SetCurrentKey("Item No.");
        PurchaseLineDiscount.SetRange("Item No.",Item."No.");
        PurchaseLineDiscount.SetFilter("Vendor No.",FindEffectiveVendorNo);
        PurchaseLineDiscountsPage.SetTableView(PurchaseLineDiscount);
        PurchaseLineDiscountsPage.RunModal;
    end;


    procedure ShowPurchPricesDiscountsOverview()
    var
        Item: Record Item;
        PurchasesPriceAndLineDisc: Page "Purchases Price and Line Disc.";
    begin
        if not GetItem(Item) then
          exit;
        PurchasesPriceAndLineDisc.LoadItem(Item);
        PurchasesPriceAndLineDisc.RunModal;
    end;
}

