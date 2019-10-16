table 74092 "MCH AM Purch. Suggest Buffer"
{
    Caption = 'AM Purch. Suggest Buffer';

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
            Editable = false;
            TableRelation = "MCH Work Order Header"."No." WHERE (Status=CONST(Released));
        }
        field(3;"Budget Line No.";Integer)
        {
            Caption = 'Budget Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "MCH Work Order Budget Line"."Line No." WHERE (Status=CONST(Released),
                                                                           "Work Order No."=FIELD("Work Order No."));
        }
        field(5;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            Editable = false;
            TableRelation = "MCH Maintenance Asset";
        }
        field(6;"Work Order Line No.";Integer)
        {
            Caption = 'Work Order Line No.';
            Editable = false;
            TableRelation = "MCH Work Order Line"."Line No." WHERE (Status=CONST(Released),
                                                                    "Work Order No."=FIELD("Work Order No."));
        }
        field(7;"Maint. Task Code";Code[20])
        {
            Caption = 'Maint. Task Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MCH Master Maintenance Task";
        }
        field(9;Selected;Boolean)
        {
            Caption = 'Selected';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MissingValueOnSelectMsg: Label 'You must specify a %1.';
            begin
                if Selected then begin
                  if ("Vendor No." = '') then
                    "Vendor No." := "Default Vendor No."; // Called from Purchase Order
                  if ("Vendor No." = '') then
                    Error(MissingValueOnSelectMsg,FieldCaption("Vendor No."));
                  if ("Quantity to Order" <= 0) then
                    Validate("Quantity to Order","Remaining Budget Qty.");
                end else begin
                  "Vendor No." := "Org. Budget Vendor No.";
                end;
            end;
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ',,Spare Part,Cost,,,Trade';
            OptionMembers = " ",,"Spare Part",Cost,,,Trade;
        }
        field(11;"No.";Code[20])
        {
            Caption = 'No.';
            Editable = false;
            TableRelation = IF (Type=CONST("Spare Part")) "MCH Maintenance Spare Part"
                            ELSE IF (Type=CONST(Cost)) "MCH Maintenance Cost"
                            ELSE IF (Type=CONST(Trade)) "MCH Maintenance Trade";
        }
        field(12;Description;Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(13;"Description 2";Text[50])
        {
            Caption = 'Description 2';
            Editable = false;
        }
        field(15;"Budget Quantity";Decimal)
        {
            Caption = 'Budget Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(17;"Direct Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            Editable = false;
            MinValue = 0;
        }
        field(18;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
            MinValue = 0;
        }
        field(19;"Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
        }
        field(21;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = IF (Type=CONST("Spare Part")) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Cost)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Trade)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE "Unit of Measure";
        }
        field(25;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(26;"Budget Qty. (Base)";Decimal)
        {
            Caption = 'Budget Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;Hours;Decimal)
        {
            BlankZero = true;
            Caption = 'Hours';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(50;"Starting Date";Date)
        {
            Caption = 'Starting Date';
            Editable = false;
        }
        field(53;"Ending Date";Date)
        {
            Caption = 'Ending Date';
            Editable = false;
        }
        field(68;"Default Vendor No.";Code[20])
        {
            Caption = 'Default Vendor No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor;
        }
        field(69;"Org. Budget Vendor No.";Code[20])
        {
            Caption = 'Org. Budget Vendor No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor;
        }
        field(70;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Selected and ("Vendor No." = '') then
                  Validate(Selected,false);
            end;
        }
        field(71;"Vendor Name";Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Item;
        }
        field(91;"Order Qty. Outst. (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Order Qty. Outst. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(92;"Received Qty. (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Received Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(95;"Order Qty. Outstanding";Decimal)
        {
            BlankZero = true;
            Caption = 'Order Qty. Outstanding';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(96;"Received Quantity";Decimal)
        {
            BlankZero = true;
            Caption = 'Received Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(97;"Remaining Budget Qty.";Decimal)
        {
            Caption = 'Remaining Budget Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(98;"Quantity to Order";Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity to Order';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            var
                OrderQtyErrMsg: Label 'You cannot order more than %1 (%2).';
            begin
                if ("Quantity to Order" = 0) then begin
                  Validate(Selected,false);
                  "Quantity to Order (Base)" := 0;
                end else begin
                  if ("Quantity to Order" > "Remaining Budget Qty.") then
                    Error(OrderQtyErrMsg,FieldCaption("Remaining Budget Qty."),"Remaining Budget Qty.");
                  "Quantity to Order (Base)" := CalcBaseQty("Quantity to Order","Qty. per Unit of Measure");
                  if (not Selected) and ("Vendor No." <> '') then
                    Validate(Selected,true);
                end;
            end;
        }
        field(99;"Quantity to Order (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity to Order (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            var
                OrderQtyErrMsg: Label 'You cannot order more than %2 (%3).';
            begin
                if ("Quantity to Order" = 0) then begin
                  Validate(Selected,false);
                end else begin
                  if ("Quantity to Order" > "Remaining Budget Qty.") then
                    Error(OrderQtyErrMsg,FieldCaption("Remaining Budget Qty."),"Remaining Budget Qty.");
                  if (not Selected) and ("Vendor No." <> '') then
                    Validate(Selected,true);
                end;
            end;
        }
        field(100;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "MCH Work Order Type";
        }
        field(101;"Progress Status Code";Code[20])
        {
            Caption = 'Progress Status Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "MCH Work Order Progress Status".Code WHERE ("Allow on Released WO"=CONST(true),
                                                                         Blocked=CONST(false));
        }
        field(102;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "MCH Maintenance Location";
        }
        field(103;"Responsibility Group Code";Code[20])
        {
            Caption = 'Responsibility Group Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "MCH Asset Responsibility Group";
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetSelectionStyleTxt(): Text
    begin
        if ("Vendor No." = '') then
          exit('Attention');
        if Selected then
          exit('Favorable');
    end;


    procedure DrilldownPurchLine()
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetCurrentKey("MCH Work Order No.","MCH WO Budget Line No.");
        PurchLine.SetRange("MCH Work Order No.","Work Order No.");
        PurchLine.SetRange("MCH WO Budget Line No.","Budget Line No.");
        PAGE.Run(0,PurchLine);
    end;


    procedure DrilldownAMLedgerEntry()
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        AMLedgEntry.SetCurrentKey("Work Order No.","Work Order Budget Line No.");
        AMLedgEntry.SetRange("Work Order No.","Work Order No.");
        AMLedgEntry.SetRange("Work Order Budget Line No.","Budget Line No.");
        PAGE.Run(0,AMLedgEntry);
    end;


    procedure CalcUnitOfMeasureQtyFromBase(BaseQty: Decimal;QtyPerUnitOfMeasure: Decimal) Qty: Decimal
    begin
        if (QtyPerUnitOfMeasure = 0) then
          exit(0)
        else
          exit(Round(BaseQty / QtyPerUnitOfMeasure,0.00001));
    end;


    procedure CalcBaseQty(Qty: Decimal;QtyPerUnitOfMeasure: Decimal) BaseQty: Decimal
    begin
        exit(Round(Qty * QtyPerUnitOfMeasure,0.00001));
    end;
}

