table 74035 "MCH Maintenance Location"
{
    Caption = 'Maintenance Location';
    DataCaptionFields = "Code",Name;
    DrillDownPageID = "MCH Maintenance Location List";
    LookupPageID = "MCH Maintenance Location List";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Name;Text[100])
        {
            Caption = 'Name';
        }
        field(3;Address;Text[30])
        {
            Caption = 'Address';
        }
        field(4;"Address 2";Text[30])
        {
            Caption = 'Address 2';
        }
        field(5;City;Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code"=CONST('')) "Post Code".City
                            ELSE IF ("Country/Region Code"=FILTER(<>'')) "Post Code".City WHERE ("Country/Region Code"=FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City,"Post Code",County,"Country/Region Code");
            end;

            trigger OnValidate()
            begin
                // PostCodeCheck.ValidateCity(
                //   CurrFieldNo,DATABASE::"MCH Maintenance Location",GetPosition,0,
                //   Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(6;"Post Code";Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code"=CONST('')) "Post Code"
                            ELSE IF ("Country/Region Code"=FILTER(<>'')) "Post Code" WHERE ("Country/Region Code"=FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City,"Post Code",County,"Country/Region Code");
            end;

            trigger OnValidate()
            begin
                // PostCodeCheck.ValidatePostCode(
                //   CurrFieldNo,DATABASE::"MCH Maintenance Location",GetPosition,0,
                //   Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(7;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City,"Post Code",County,"Country/Region Code",xRec."Country/Region Code");
            end;
        }
        field(8;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
        }
        field(9;"Fax No.";Text[30])
        {
            Caption = 'Fax No.';
        }
        field(10;"Name 2";Text[50])
        {
            Caption = 'Name 2';
        }
        field(11;Contact;Text[100])
        {
            Caption = 'Contact';
        }
        field(15;County;Text[30])
        {
            Caption = 'State';
        }
        field(20;Picture;Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(80;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(81;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(102;Email;Text[80])
        {
            Caption = 'Email';
        }
        field(103;"Home Page";Text[80])
        {
            Caption = 'Home Page';
        }
        field(110;"Def. Invt. Location Code";Code[10])
        {
            Caption = 'Def. Invt. Location Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));
        }
        field(111;"No. of Assets";Integer)
        {
            CalcFormula = Count("MCH Maintenance Asset" WHERE ("Fixed Maint. Location Code"=FIELD(Code)));
            Caption = 'No. of Assets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(112;"No. of Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE ("Maint. Location Code"=FIELD(Code)));
            Caption = 'No. of Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(121;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Name,"Name 2",City)
        {
        }
        fieldgroup(Brick;"Code",Name,"Post Code","Name 2",City,Picture)
        {
        }
    }

    trigger OnDelete()
    begin
        if (Code <> '') then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);
        DimMgt.DeleteDefaultDim(DATABASE::"MCH Maintenance Location",Code);
    end;

    trigger OnInsert()
    begin
        DimMgt.UpdateDefaultDim(
          DATABASE::"MCH Maintenance Location",Code,
          "Global Dimension 1 Code","Global Dimension 2 Code");
    end;

    trigger OnRename()
    begin
        DimMgt.RenameDefaultDim(DATABASE::"MCH Maintenance Location",xRec.Code,Code);
    end;

    var
        PostCode: Record "Post Code";
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        //PostCodeCheck: Codeunit "Post Code Check";
        DimMgt: Codeunit DimensionManagement;
        AMFunctions: Codeunit "MCH AM Functions";


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"MCH Maintenance Location",Code,FieldNumber,ShortcutDimCode);
        Modify;
    end;
}

