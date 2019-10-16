page 74219 "MCH MA Struct.Cost Overv. Mtrx"
{
    Caption = 'Matrix';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Maintenance Asset";
    SourceTableView = SORTING("Structure Position ID");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                FreezeColumn = Description;
                IndentationColumn = AssetStructureLevel;
                IndentationControls = Description;
                ShowAsTree = true;
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        ShowCard;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = DescriptionStyleTxt;
                }
                field(Field1;MATRIX_CellData[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[1];
                    Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(1);
                    end;
                }
                field(Field2;MATRIX_CellData[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[2];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field2Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(2);
                    end;
                }
                field(Field3;MATRIX_CellData[3])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[3];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field3Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(3);
                    end;
                }
                field(Field4;MATRIX_CellData[4])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[4];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field4Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(4);
                    end;
                }
                field(Field5;MATRIX_CellData[5])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[5];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field5Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(5);
                    end;
                }
                field(Field6;MATRIX_CellData[6])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[6];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field6Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(6);
                    end;
                }
                field(Field7;MATRIX_CellData[7])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[7];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field7Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(7);
                    end;
                }
                field(Field8;MATRIX_CellData[8])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[8];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field8Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(8);
                    end;
                }
                field(Field9;MATRIX_CellData[9])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[9];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field9Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(9);
                    end;
                }
                field(Field10;MATRIX_CellData[10])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[10];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field10Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(10);
                    end;
                }
                field(Field11;MATRIX_CellData[11])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[11];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field11Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(11);
                    end;
                }
                field(Field12;MATRIX_CellData[12])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[12];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field12Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(12);
                    end;
                }
                field(Field13;MATRIX_CellData[13])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[13];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field13Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(13);
                    end;
                }
                field(Field14;MATRIX_CellData[14])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[14];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field14Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(14);
                    end;
                }
                field(Field15;MATRIX_CellData[15])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[15];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field15Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(15);
                    end;
                }
                field(Field16;MATRIX_CellData[16])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[16];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field16Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(16);
                    end;
                }
                field(Field17;MATRIX_CellData[17])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[17];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field17Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(17);
                    end;
                }
                field(Field18;MATRIX_CellData[18])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[18];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field18Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(18);
                    end;
                }
                field(Field19;MATRIX_CellData[19])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[19];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field19Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(19);
                    end;
                }
                field(Field20;MATRIX_CellData[20])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[20];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field20Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(20);
                    end;
                }
                field(Field21;MATRIX_CellData[21])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[21];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field21Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(21);
                    end;
                }
                field(Field22;MATRIX_CellData[22])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[22];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field22Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(22);
                    end;
                }
                field(Field23;MATRIX_CellData[23])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[23];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field23Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(23);
                    end;
                }
                field(Field24;MATRIX_CellData[24])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[24];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field24Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(24);
                    end;
                }
                field(Field25;MATRIX_CellData[25])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[25];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field25Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(25);
                    end;
                }
                field(Field26;MATRIX_CellData[26])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[26];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field26Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(26);
                    end;
                }
                field(Field27;MATRIX_CellData[27])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[27];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field27Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(27);
                    end;
                }
                field(Field28;MATRIX_CellData[28])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[28];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field28Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(28);
                    end;
                }
                field(Field29;MATRIX_CellData[29])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[29];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field29Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(29);
                    end;
                }
                field(Field30;MATRIX_CellData[30])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[30];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field30Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(30);
                    end;
                }
                field(Field31;MATRIX_CellData[31])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[31];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field31Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(31);
                    end;
                }
                field(Field32;MATRIX_CellData[32])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CellFormatExpression;
                    AutoFormatType = 10;
                    BlankZero = true;
                    CaptionClass = '3,' + MatrixColumnCaptions[32];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field32Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(32);
                    end;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a (fixed) Responsibility Group that always must be used on work orders. The assigned Responsibility Group is also used to limit viewing/processing by Maint. Users that are setup with Resp. Group view limitations. ';
                    Visible = false;
                }
                field("Fixed Maint. Location Code";"Fixed Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a fixed Maintenance Location that always must be used on work orders.';
                    Visible = false;
                }
                field(Make;Make)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Model;Model)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Registration No.";"Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Manufacturer Code";"Manufacturer Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Posting Group that is used on posting of resource/team maintenance timesheets.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group that is used on issue/return posting of maintenance inventory.';
                    Visible = false;
                }
                field("Fixed Asset No.";"Fixed Asset No.")
                {
                    AccessByPermission = TableData "Fixed Asset"=R;
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Is Parent";"Is Parent")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("Parent Asset No.";"Parent Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Manufacturers Part No.";"Manufacturers Part No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Original Part No.";"Original Part No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified By";"Last Modified By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        Clear(MATRIX_CellData);
        for MATRIX_CurrentColumnOrdinal := 1 to MaxNoOfColumns do begin
          if (MatrixColumnCaptions[MATRIX_CurrentColumnOrdinal] <> '') then begin
            SetDateFilter(MATRIX_CurrentColumnOrdinal);
            case ValueType of
              ValueType::"Rolled-up Cost Amount":
                begin
                  CalcFields("Rolled-up Cost Amount");
                  MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := "Rolled-up Cost Amount";
                end;
              ValueType::"Asset Cost Amount":
                begin
                  CalcFields("Cost Amount");
                  MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := "Cost Amount";
                end;
              ValueType::"Rolled-up Hours":
                begin
                  CalcFields("Rolled-up Hours");
                  MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := "Rolled-up Hours";
                end;
              ValueType::"Asset Hours":
                begin
                  CalcFields(Hours);
                  MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := Hours;
                end;
            end;
          end;
        end;
        SetRange("Date Filter");

        AssetStructureLevel := "Structure Level";
        Emphasize := "Is Parent";
        DescriptionStyleTxt := '';
        case true of
          "Is Parent":
            DescriptionStyleTxt := 'Strong';
          Blocked:
            DescriptionStyleTxt := 'Unfavorable';
        end;
    end;

    trigger OnOpenPage()
    begin
        GLSetup.Get;
        SetSecurityFilterOnResponsibilityGroup(99);
        MaxNoOfColumns := ArrayLen(MATRIX_CellData);
        SetAutoCalcFields("Is Parent");
    end;

    var
        GLSetup: Record "General Ledger Setup";
        MatrixRecords: array [32] of Record Date;
        MATRIX_CellData: array [32] of Decimal;
        MatrixColumnCaptions: array [32] of Text[80];
        PKFirstRecInCurrSet: Text[80];
        CaptionRange: Text;
        CurrSetLength: Integer;
        MaxNoOfColumns: Integer;
        ShowNoOfColumns: Integer;
        CellFormatExpression: Text;
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Balance at Date","Net Change";
        ValueType: Option "Rolled-up Cost Amount","Rolled-up Hours","Asset Cost Amount","Asset Hours";
        [InDataSet]
        Field1Visible: Boolean;
        [InDataSet]
        Field2Visible: Boolean;
        [InDataSet]
        Field3Visible: Boolean;
        [InDataSet]
        Field4Visible: Boolean;
        [InDataSet]
        Field5Visible: Boolean;
        [InDataSet]
        Field6Visible: Boolean;
        [InDataSet]
        Field7Visible: Boolean;
        [InDataSet]
        Field8Visible: Boolean;
        [InDataSet]
        Field9Visible: Boolean;
        [InDataSet]
        Field10Visible: Boolean;
        [InDataSet]
        Field11Visible: Boolean;
        [InDataSet]
        Field12Visible: Boolean;
        [InDataSet]
        Field13Visible: Boolean;
        [InDataSet]
        Field14Visible: Boolean;
        [InDataSet]
        Field15Visible: Boolean;
        [InDataSet]
        Field16Visible: Boolean;
        [InDataSet]
        Field17Visible: Boolean;
        [InDataSet]
        Field18Visible: Boolean;
        [InDataSet]
        Field19Visible: Boolean;
        [InDataSet]
        Field20Visible: Boolean;
        [InDataSet]
        Field21Visible: Boolean;
        [InDataSet]
        Field22Visible: Boolean;
        [InDataSet]
        Field23Visible: Boolean;
        [InDataSet]
        Field24Visible: Boolean;
        [InDataSet]
        Field25Visible: Boolean;
        [InDataSet]
        Field26Visible: Boolean;
        [InDataSet]
        Field27Visible: Boolean;
        [InDataSet]
        Field28Visible: Boolean;
        [InDataSet]
        Field29Visible: Boolean;
        [InDataSet]
        Field30Visible: Boolean;
        [InDataSet]
        Field31Visible: Boolean;
        [InDataSet]
        Field32Visible: Boolean;
        Emphasize: Boolean;
        AssetStructureLevel: Integer;
        [InDataSet]
        DescriptionStyleTxt: Text;


    procedure LoadData(var MatrixRecords2: array [32] of Record Date;MatrixColumnCaptions2: array [32] of Text[80];PeriodType2: Option Day,Week,Month,Quarter,Year,"Accounting Period";AmountType2: Option "Balance at Date","Net Change";ValueType2: Option "Cost Amount",Hour)
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(MatrixColumnCaptions) do begin
          MatrixRecords[i] := MatrixRecords2[i];
          MatrixColumnCaptions[i] := MatrixColumnCaptions2[i];
        end;
        PeriodType := PeriodType2;
        AmountType := AmountType2;
        ValueType := ValueType2;

        SetColumnVisible;

        case ValueType of
          ValueType::"Rolled-up Cost Amount",ValueType::"Asset Cost Amount":
            CellFormatExpression := StrSubstNo('<Precision,%1><Standard Format,0>',GLSetup."Amount Decimal Places");
          ValueType::"Rolled-up Hours",ValueType::"Asset Hours":
            CellFormatExpression := '<Precision,0:5><Standard Format,0>';
        end;
        CurrPage.Update(false);
    end;

    local procedure MatrixOnDrillDown(MATRIX_ColumnOrdinal: Integer)
    var
        AMStructureLedgEntry: Record "MCH AM Structure Ledger Entry";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        case ValueType of
          ValueType::"Rolled-up Cost Amount",
          ValueType::"Rolled-up Hours":
            begin
              AMStructureLedgEntry.SetCurrentKey("Asset No.","Posting Date");
              AMStructureLedgEntry.SetRange("Asset No.",Rec."No.");
              if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
                AMStructureLedgEntry.SetRange("Posting Date",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
              else
                AMStructureLedgEntry.SetRange("Posting Date",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End");
              PAGE.RunModal(PAGE::"MCH AM Structure Ledg. Entries",AMStructureLedgEntry);
            end;
          ValueType::"Asset Cost Amount",
          ValueType::"Asset Hours":
            begin
              AMLedgEntry.SetCurrentKey("Asset No.","Posting Date");
              AMLedgEntry.SetRange("Asset No.",Rec."No.");
              if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
                AMLedgEntry.SetRange("Posting Date",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
              else
                AMLedgEntry.SetRange("Posting Date",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End");
              PAGE.RunModal(PAGE::"MCH AM Ledger Entries",AMLedgEntry);
            end;
        end;
    end;

    local procedure SetDateFilter(MATRIX_ColumnOrdinal: Integer)
    begin
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
          Rec.SetRange("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
          Rec.SetRange("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End")
    end;

    local procedure SetColumnVisible()
    begin
        Field1Visible := MatrixColumnCaptions[1] <> '';
        Field2Visible := MatrixColumnCaptions[2] <> '';
        Field3Visible := MatrixColumnCaptions[3] <> '';
        Field4Visible := MatrixColumnCaptions[4] <> '';
        Field5Visible := MatrixColumnCaptions[5] <> '';
        Field6Visible := MatrixColumnCaptions[6] <> '';
        Field7Visible := MatrixColumnCaptions[7] <> '';
        Field8Visible := MatrixColumnCaptions[8] <> '';
        Field9Visible := MatrixColumnCaptions[9] <> '';
        Field10Visible := MatrixColumnCaptions[10] <> '';
        Field11Visible := MatrixColumnCaptions[11] <> '';
        Field12Visible := MatrixColumnCaptions[12] <> '';
        Field13Visible := MatrixColumnCaptions[13] <> '';
        Field14Visible := MatrixColumnCaptions[14] <> '';
        Field15Visible := MatrixColumnCaptions[15] <> '';
        Field16Visible := MatrixColumnCaptions[16] <> '';
        Field17Visible := MatrixColumnCaptions[17] <> '';
        Field18Visible := MatrixColumnCaptions[18] <> '';
        Field19Visible := MatrixColumnCaptions[19] <> '';
        Field20Visible := MatrixColumnCaptions[20] <> '';
        Field21Visible := MatrixColumnCaptions[21] <> '';
        Field22Visible := MatrixColumnCaptions[22] <> '';
        Field23Visible := MatrixColumnCaptions[23] <> '';
        Field24Visible := MatrixColumnCaptions[24] <> '';
        Field25Visible := MatrixColumnCaptions[25] <> '';
        Field26Visible := MatrixColumnCaptions[26] <> '';
        Field27Visible := MatrixColumnCaptions[27] <> '';
        Field28Visible := MatrixColumnCaptions[28] <> '';
        Field29Visible := MatrixColumnCaptions[29] <> '';
        Field30Visible := MatrixColumnCaptions[30] <> '';
        Field31Visible := MatrixColumnCaptions[31] <> '';
        Field32Visible := MatrixColumnCaptions[32] <> '';
    end;
}

