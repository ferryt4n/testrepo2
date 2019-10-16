table 74091 "MCH AM Structure Ledger Entry"
{
    Caption = 'AM Structure Ledger Entry';
    DrillDownPageID = "MCH AM Structure Ledg. Entries";
    LookupPageID = "MCH AM Structure Ledg. Entries";

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2;"AM Ledger Entry No.";Integer)
        {
            Caption = 'AM Ledger Entry No.';
            TableRelation = "MCH Asset Maint. Ledger Entry";
        }
        field(3;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "MCH Maintenance Asset";
        }
        field(4;"Asset Structure Level";Integer)
        {
            Caption = 'Asset Structure Level';
        }
        field(5;"Source Asset No.";Code[20])
        {
            Caption = 'Source Asset No.';
            DataClassification = CustomerContent;
            TableRelation = "MCH Maintenance Asset";
        }
        field(8;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(9;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(11;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST("Spare Part")) "MCH Maintenance Spare Part"
                            ELSE IF (Type=CONST(Cost)) "MCH Maintenance Cost"
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Team)) "MCH Maintenance Team"
                            ELSE IF (Type=CONST(Trade)) "MCH Maintenance Trade";
        }
        field(14;"Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
        }
        field(15;Hours;Decimal)
        {
            Caption = 'Hours';
            DecimalPlaces = 0:5;
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
        field(20;"Posting Entry Type";Option)
        {
            Caption = 'Posting Entry Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Purchase,Inventory,Timesheet';
            OptionMembers = Purchase,Inventory,Timesheet;
        }
        field(21;"Document Type";Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,,,,,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase CR/Adj Note';
            OptionMembers = " ",,,,,"Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo";
        }
        field(40;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = CustomerContent;
            TableRelation = "MCH Work Order Header"."No.";
        }
        field(45;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            TableRelation = "MCH Work Order Type";
        }
        field(61;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            TableRelation = "MCH Maintenance Location";
        }
        field(100;"Asset Description";Text[100])
        {
            CalcFormula = Lookup("MCH Maintenance Asset".Description WHERE ("No."=FIELD("Asset No.")));
            Caption = 'Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Source Asset Description";Text[100])
        {
            CalcFormula = Lookup("MCH Maintenance Asset".Description WHERE ("No."=FIELD("Source Asset No.")));
            Caption = 'Source Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Posted By";Code[50])
        {
            Caption = 'Posted By';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(106;"Posting Date-Time";DateTime)
        {
            Caption = 'Posting Date-Time';
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
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"AM Ledger Entry No.","Asset Structure Level")
        {
        }
        key(Key3;"Asset No.","Posting Date")
        {
            SumIndexFields = "Cost Amount",Hours;
        }
        key(Key4;"Asset No.","Work Order Type","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        {
            SumIndexFields = "Cost Amount",Hours;
        }
        key(Key5;"AM Ledger Entry No.","Work Order Type","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Posted By" := UserId;
        "Posting Date-Time" := CurrentDateTime;
    end;


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2',TableCaption,"AM Ledger Entry No."));
    end;
}

