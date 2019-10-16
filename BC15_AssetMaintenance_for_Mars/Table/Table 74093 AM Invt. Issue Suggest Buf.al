table 74093 "MCH AM Invt. Issue Suggest Buf"
{
    Caption = 'AM Inventory Issue Suggest Buffer';

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
                MissingValueOnSelectMsg: Label 'You must specify %1.';
            begin
                if Selected then begin
                  if ("Quantity to Issue" <= 0) then
                    Validate("Quantity to Issue","Remaining Budget Qty.");
                end;
            end;
        }
        field(11;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
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
        field(14;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE ("Item No."=FIELD("Item No."));
        }
        field(15;"Budget Quantity";Decimal)
        {
            Caption = 'Budget Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(20;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location;
        }
        field(21;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."));
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
        field(91;"Journal Line Qty. (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Journal Line Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(92;"Issued Qty. (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Issued Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(95;"Journal Line Quantity";Decimal)
        {
            BlankZero = true;
            Caption = 'Journal Line Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(96;"Issued Quantity";Decimal)
        {
            BlankZero = true;
            Caption = 'Issued Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(97;"Remaining Budget Qty.";Decimal)
        {
            Caption = 'Remaining Budget Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(98;"Quantity to Issue";Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity to Issue';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            var
                IssueQtyErrMsg: Label 'You cannot issue more than %1 (%2).';
            begin
                if ("Quantity to Issue" = 0) then begin
                  Validate(Selected,false);
                  "Quantity to Issue (Base)" := 0;
                end else begin
                  if ("Quantity to Issue" > "Remaining Budget Qty.") then
                    Error(IssueQtyErrMsg,FieldCaption("Remaining Budget Qty."),"Remaining Budget Qty.");
                  "Quantity to Issue (Base)" := CalcBaseQty("Quantity to Issue","Qty. per Unit of Measure");
                  if (not Selected) then
                    Validate(Selected,true);
                end;
            end;
        }
        field(99;"Quantity to Issue (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity to Issue (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            var
                IssueQtyErrMsg: Label 'You cannot issue more than %2 (%3).';
            begin
                if ("Quantity to Issue" = 0) then begin
                  Validate(Selected,false);
                end else begin
                  if ("Quantity to Issue" > "Remaining Budget Qty.") then
                    Error(IssueQtyErrMsg,FieldCaption("Remaining Budget Qty."),"Remaining Budget Qty.");
                  if (not Selected) then
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
        if Selected then
          exit('Favorable');
    end;


    procedure DrilldownMaintJnlLine()
    var
        MaintJnlLine: Record "MCH Maint. Journal Line";
    begin
        MaintJnlLine.SetCurrentKey("Work Order No.","Work Order Line No.","Work Order Budget Line No.");
        MaintJnlLine.SetRange("Work Order No.","Work Order No.");
        MaintJnlLine.SetRange("Work Order Line No.","Work Order Line No.");
        MaintJnlLine.SetRange("Work Order Budget Line No.","Budget Line No.");
        MaintJnlLine.FilterGroup(2);
        MaintJnlLine.SetFilter("Entry Type",'%1|%2',MaintJnlLine."Entry Type"::Issue,MaintJnlLine."Entry Type"::Return);
        MaintJnlLine.FilterGroup(0);
        PAGE.Run(0,MaintJnlLine);
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

