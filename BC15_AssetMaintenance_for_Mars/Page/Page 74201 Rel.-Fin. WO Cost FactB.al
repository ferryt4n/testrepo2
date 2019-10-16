page 74201 "MCH Rel.-Fin. WO Cost FactB"
{
    Caption = 'Cost - Summary';
    PageType = CardPart;
    SourceTable = "MCH Work Order Header";

    layout
    {
        area(content)
        {
            group(Control1101214020)
            {
                ShowCaption = false;
                group(Budget)
                {
                    Caption = 'Budget';
                    field(ItemBudget;BudgetCost[1])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Item';
                        Visible = TypeItemVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(1);
                        end;
                    }
                    field(SparePartBudget;BudgetCost[2])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Spare Part';
                        Visible = TypeSparePartVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(2);
                        end;
                    }
                    field(ResourceBudget;BudgetCost[4])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Resource';
                        Visible = TypeResourceVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(4);
                        end;
                    }
                    field(TeamBudget;BudgetCost[5])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Team';
                        Visible = TypeTeamVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(5);
                        end;
                    }
                    field(TradeBudget;BudgetCost[6])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Trade';
                        Visible = TypeTradeVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(6);
                        end;
                    }
                    field(CostBudget;BudgetCost[3])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Cost';
                        Visible = TypeCostVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownBudget(3);
                        end;
                    }
                    field(TotalBudget;BudgetCost[8])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
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
                    field(ItemActual;ActualCost[1])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Item';
                        Visible = TypeItemVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(1);
                        end;
                    }
                    field(SparePartActual;ActualCost[2])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Spare Part';
                        Visible = TypeSparePartVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(2);
                        end;
                    }
                    field(ResourceActual;ActualCost[4])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Resource';
                        Visible = TypeResourceVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(4);
                        end;
                    }
                    field(TeamActual;ActualCost[5])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Team';
                        Visible = TypeTeamVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(5);
                        end;
                    }
                    field(TradeActual;ActualCost[6])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Trade';
                        Visible = TypeTradeVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(6);
                        end;
                    }
                    field(CostActual;ActualCost[3])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
                        Caption = 'Cost';
                        Visible = TypeCostVisible;

                        trigger OnDrillDown()
                        begin
                            DrillDownActual(3);
                        end;
                    }
                    field(TotalActual;ActualCost[8])
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 2;
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
        for i := 1 to 6 do begin
          SetRange("Type Filter",i);
          CalcFields("Budgeted Cost Amount","Actual Cost Amount");
          BudgetCost[i] := "Budgeted Cost Amount";
          ActualCost[i] := "Actual Cost Amount";
          BudgetCost[8] := BudgetCost[8] + BudgetCost[i];
          ActualCost[8] := ActualCost[8] + "Actual Cost Amount";
        end;
        SetRange("Type Filter");
    end;

    trigger OnOpenPage()
    begin
        SetTypeVisibility;
    end;

    var
        i: Integer;
        BudgetCost: array [8] of Decimal;
        ActualCost: array [8] of Decimal;
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

