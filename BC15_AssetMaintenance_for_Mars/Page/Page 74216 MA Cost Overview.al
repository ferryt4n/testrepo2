page 74216 "MCH MA Cost Overview"
{
    Caption = 'Asset Cost Overview';
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View by';
                    Importance = Promoted;
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period values are displayed.';

                    trigger OnValidate()
                    begin
                        GenerateColumnCaptions(SetWanted::First);
                        UpdateMatrixSubform;
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View as';
                    Importance = Promoted;
                    OptionCaption = 'Balance at Date,Net Change';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
                field(ValueType;ValueType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Value of';
                    Importance = Promoted;
                    OptionCaption = 'Cost Amount,Hour';

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
                field(ShowNoOfColumns;ShowNoOfColumns)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of Columns';

                    trigger OnValidate()
                    begin
                        ValidateShowNoOfColumns;
                        GenerateColumnCaptions(SetWanted::First);
                        UpdateMatrixSubform;
                    end;
                }
            }
            part(MatrixSubpage;"MCH MA Cost Overview Matrix")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    GenerateColumnCaptions(SetWanted::Previous);
                    UpdateMatrixSubform;
                end;
            }
            action(PreviousColumn)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous column.';

                trigger OnAction()
                begin
                    GenerateColumnCaptions(SetWanted::PreviousColumn);
                    UpdateMatrixSubform;
                end;
            }
            action(NextColumn)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next column.';

                trigger OnAction()
                begin
                    GenerateColumnCaptions(SetWanted::NextColumn);
                    UpdateMatrixSubform;
                end;
            }
            action(NextSet)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    GenerateColumnCaptions(SetWanted::Next);
                    UpdateMatrixSubform;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
    end;

    trigger OnOpenPage()
    begin
        MaxNoOfColumns := ArrayLen(MATRIX_CellData);
        ValidateShowNoOfColumns;
        GenerateColumnCaptions(SetWanted::First);
        UpdateMatrixSubform;
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
        ValueType: Option "Cost Amount",Hour;

    local procedure GenerateColumnCaptions(SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        ValidateShowNoOfColumns;
        MatrixMgt.GeneratePeriodMatrixData(
          SetWanted,ShowNoOfColumns,false,PeriodType,'',
          PKFirstRecInCurrSet,MatrixColumnCaptions,CaptionRange,CurrSetLength,MatrixRecords);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixSubpage.PAGE.LoadData(MatrixRecords,MatrixColumnCaptions,PeriodType,AmountType,ValueType);
    end;

    local procedure ValidateShowNoOfColumns()
    begin
        if not (ShowNoOfColumns in [1..MaxNoOfColumns]) then
          ShowNoOfColumns := 12;
    end;
}

