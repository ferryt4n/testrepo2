page 74202 "MCH Rel.-Fin. WO Hour FactB"
{
    Caption = 'Hours - Summary';
    PageType = CardPart;
    SourceTable = "MCH Work Order Header";

    layout
    {
        area(content)
        {
            group(Control1101214003)
            {
                ShowCaption = false;
                group(Budget)
                {
                    Caption = 'Budget';
                    field(ResourceBudget;BudgetHour[4])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Resource';
                        DecimalPlaces = 0:5;
                        Visible = TypeResourceVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(4);
                        end;
                    }
                    field(TeamBudget;BudgetHour[5])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Team';
                        DecimalPlaces = 0:5;
                        Visible = TypeTeamVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(5);
                        end;
                    }
                    field(TradeBudget;BudgetHour[6])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Trade';
                        DecimalPlaces = 0:5;
                        Visible = TypeTradeVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(6);
                        end;
                    }
                    field(CostBudget;BudgetHour[3])
                    {
                        ApplicationArea = Basic,Suite;
                        BlankZero = true;
                        Caption = 'Cost';
                        DecimalPlaces = 0:5;
                        Visible = TypeCostVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(3);
                        end;
                    }
                    field(TotalBudget;BudgetHour[8])
                    {
                        ApplicationArea = Basic,Suite;
                        DecimalPlaces = 0:5;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = TRUE;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(8);
                        end;
                    }
                }
                group(Actual)
                {
                    Caption = 'Actual';
                    field(ResourceActual;ActualHour[4])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Resource';
                        DecimalPlaces = 0:5;
                        Visible = TypeResourceVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(4);
                        end;
                    }
                    field(TeamActual;ActualHour[5])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Team';
                        DecimalPlaces = 0:5;
                        Visible = TypeTeamVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(5);
                        end;
                    }
                    field(TradeActual;ActualHour[6])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Trade';
                        DecimalPlaces = 0:5;
                        Visible = TypeTradeVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(6);
                        end;
                    }
                    field(CostActual;ActualHour[3])
                    {
                        ApplicationArea = Basic,Suite;
                        BlankZero = true;
                        Caption = 'Cost';
                        DecimalPlaces = 0:5;
                        Visible = TypeCostVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(3);
                        end;
                    }
                    field(TotalActual;ActualHour[8])
                    {
                        ApplicationArea = Basic,Suite;
                        DecimalPlaces = 0:5;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = TRUE;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(8);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetRange("No.");
        ClearAll;
        for i := 3 to 6 do begin
          SetRange("Type Filter",i);
          CalcFields("Budgeted Hours","Actual Hours");
          BudgetHour[i] := "Budgeted Hours";
          ActualHour[i] := "Actual Hours";

          BudgetHour[8] := BudgetHour[8] + BudgetHour[i];
          ActualHour[8] := ActualHour[8] + ActualHour[i];
        end;
        SetRange("Type Filter");
    end;

    trigger OnOpenPage()
    begin
        SetTypeVisibility;
    end;

    var
        i: Integer;
        BudgetHour: array [8] of Decimal;
        ActualHour: array [8] of Decimal;
        [InDataSet]
        TypeItemVisible: Boolean;
        [InDataSet]
        TypeSparePartVisible: Boolean;
        [InDataSet]
        TypeCostVisible: Boolean;
        [InDataSet]
        TypeResourceVisible: Boolean;
        [InDataSet]
        TypeTeamVisible: Boolean;
        [InDataSet]
        TypeTradeVisible: Boolean;

    local procedure DrillDownBudget(TheType: Integer)
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
    begin
        if TheType in [1..6] then begin
          WOBudgetLine.SetCurrentKey(Status,"Work Order No.",Type,"No.");
          WOBudgetLine.SetRange(Type,TheType);
        end;
        WOBudgetLine.SetRange(Status,Status);
        WOBudgetLine.SetRange("Work Order No.","No.");
        PAGE.Run(0,WOBudgetLine);
    end;

    local procedure DrillDownActual(TheType: Integer)
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        if TheType in [1..6] then begin
          AMLedgEntry.SetCurrentKey("Work Order No.",Type);
          AMLedgEntry.SetRange(Type,TheType);
        end;
        AMLedgEntry.SetRange("Work Order No.","No.");
        PAGE.Run(0,AMLedgEntry);
    end;

    local procedure SetTypeVisibility()
    var
        AMFunction: Codeunit "MCH AM Functions";
    begin
        AMFunction.GetTypeVisibility(TypeItemVisible,TypeSparePartVisible,TypeCostVisible,TypeResourceVisible,TypeTeamVisible,TypeTradeVisible);
    end;
}

