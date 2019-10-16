table 74047 "MCH Asset Maint. Ledger Entry"
{
    Caption = 'Asset Maint. Ledger Entry';
    DrillDownPageID = "MCH AM Ledger Entries";
    LookupPageID = "MCH AM Ledger Entries";

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
            TableRelation = "MCH Work Order Header"."No." WHERE (Status=FILTER(Released|Finished));
        }
        field(3;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "MCH Maintenance Asset";
        }
        field(4;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(5;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST("Spare Part")) "MCH Maintenance Spare Part"
                            ELSE IF (Type=CONST(Cost)) "MCH Maintenance Cost"
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Team)) "MCH Maintenance Team"
                            ELSE IF (Type=CONST(Trade)) "MCH Maintenance Trade";
        }
        field(6;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(7;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(8;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(9;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(10;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(11;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(12;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(13;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(14;"Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
        }
        field(18;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(19;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(20;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,,,,,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase CR/Adj Note';
            OptionMembers = " ",,,,,"Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo";
        }
        field(21;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(25;"Document Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(28;Hours;Decimal)
        {
            BlankZero = true;
            Caption = 'Hours';
            DecimalPlaces = 0:5;
        }
        field(30;"Maint. Task Code";Code[20])
        {
            Caption = 'Maint. Task Code';
            TableRelation = "MCH Master Maintenance Task";
        }
        field(35;"Posting Entry Type";Option)
        {
            Caption = 'Posting Entry Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Purchase,Inventory,Timesheet';
            OptionMembers = Purchase,Inventory,Timesheet;
        }
        field(36;"Inventory Entry Type";Option)
        {
            Caption = 'Inventory Entry Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Issue,Return';
            OptionMembers = " ",Issue,Return;
        }
        field(41;"Asset Posting Group";Code[20])
        {
            Caption = 'Asset Posting Group';
            TableRelation = "MCH Maint. Asset Posting Group";
        }
        field(42;"Gen. Prod. Posting Group";Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(43;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(44;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."))
                            ELSE IF (Type=CONST("Spare Part")) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Cost)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Trade)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE ("Resource No."=FIELD("No."))
                            ELSE IF (Type=CONST(Team)) "MCH Maint. Unit of Measure"."Unit of Measure Code" WHERE ("Table Name"=CONST(Team),
                                                                                                                  Code=FIELD("No."))
                                                                                                                  ELSE "Unit of Measure";
        }
        field(45;"Resource Work Type Code";Code[10])
        {
            Caption = 'Resource Work Type Code';
            TableRelation = "Work Type";
        }
        field(46;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE ("Location Code"=FIELD("Location Code"));
        }
        field(47;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE ("Item No."=FIELD("No."));
        }
        field(48;"Gen. Bus. Posting Group";Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(49;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(51;"Resource No. (Issue/Return)";Code[20])
        {
            Caption = 'Resource No. (Issue/Return)';
            TableRelation = Resource;
        }
        field(52;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(53;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
        field(60;"Asset Category Code";Code[20])
        {
            Caption = 'Asset Category Code';
            TableRelation = "MCH Maint. Asset Category";
        }
        field(61;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            TableRelation = "MCH Maintenance Location";
        }
        field(63;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            TableRelation = "MCH Work Order Type";
        }
        field(70;"Asset Description";Text[100])
        {
            CalcFormula = Lookup("MCH Maintenance Asset".Description WHERE ("No."=FIELD("Asset No.")));
            Caption = 'Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(80;"Qty. Invoiced";Decimal)
        {
            Caption = 'Qty. Invoiced';
            DecimalPlaces = 0:5;
        }
        field(81;"Qty. Invoiced (Base)";Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0:5;
        }
        field(90;"Work Order Line No.";Integer)
        {
            Caption = 'Work Order Line No.';
            TableRelation = "MCH Work Order Line"."Line No." WHERE ("Work Order No."=FIELD("Work Order No."));
        }
        field(91;"Work Order Budget Line No.";Integer)
        {
            Caption = 'Work Order Budget Line No.';
        }
        field(95;"Item Ledger Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(96;"Resource Ledger Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Resource Ledger Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "Res. Ledger Entry";
        }
        field(97;"Last Res. Ledger Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Last Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(100;Adjusted;Boolean)
        {
            Caption = 'Adjusted';
        }
        field(101;"Adjustment Date-Time";DateTime)
        {
            Caption = 'Adjustment Date-Time';
        }
        field(125;"Posted By";Code[50])
        {
            Caption = 'Posted By';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(126;"Posted Date-Time";DateTime)
        {
            Caption = 'Posted Date-Time';
            DataClassification = CustomerContent;
        }
        field(127;"Posted System Date";Date)
        {
            Caption = 'Posted System Date';
            DataClassification = CustomerContent;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Asset No.","Posting Date")
        {
        }
        key(Key3;"Asset No.","Maint. Task Code",Type,"Posting Date")
        {
            SumIndexFields = "Cost Amount",Hours,"Quantity (Base)","Qty. Invoiced (Base)";
        }
        key(Key4;"Asset No.","Work Order Type","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        {
            SumIndexFields = "Cost Amount",Hours;
        }
        key(Key5;"Document No.","Posting Date")
        {
        }
        key(Key6;"Work Order No.","Posting Date")
        {
        }
        key(Key7;"Work Order No.","Asset No.","Maint. Task Code",Type,"No.","Posting Date")
        {
            SumIndexFields = "Cost Amount","Quantity (Base)","Qty. Invoiced (Base)",Hours;
        }
        key(Key8;"Work Order No.","Work Order Budget Line No.")
        {
            SumIndexFields = "Cost Amount","Quantity (Base)","Qty. Invoiced (Base)",Hours;
        }
        key(Key9;"Work Order No.",Type)
        {
            SumIndexFields = "Cost Amount","Quantity (Base)","Qty. Invoiced (Base)",Hours;
        }
    }

    fieldgroups
    {
    }


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2',TableCaption,"Entry No."));
    end;


    procedure ShowResourceLedgerEntries()
    var
        ResLedgerEntry: Record "Res. Ledger Entry";
    begin
        if ("Resource Ledger Entry No." = 0) then
          exit;
        if ("Last Res. Ledger Entry No." = 0) then
          ResLedgerEntry.SetRange("Entry No.","Resource Ledger Entry No.")
        else
          ResLedgerEntry.SetRange("Entry No.","Resource Ledger Entry No.","Last Res. Ledger Entry No.");
        PAGE.Run(0,ResLedgerEntry);
    end;


    procedure ShowItemLedgerEntries()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        if ("Item Ledger Entry No." = 0) then
          exit;
        ItemLedgEntry.Get("Item Ledger Entry No.");
        ItemLedgEntry.SetRecFilter;
        PAGE.Run(0,ItemLedgEntry);
    end;


    procedure ShowValueEntries()
    var
        ValueEntry: Record "Value Entry";
    begin
        if ("Item Ledger Entry No." = 0) then
          exit;
        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.","Item Ledger Entry No.");
        PAGE.Run(0,ValueEntry);
    end;
}

