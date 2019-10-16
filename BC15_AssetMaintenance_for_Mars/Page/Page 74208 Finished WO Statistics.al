page 74208 "MCH Finished WO Statistics"
{
    Caption = 'Work Order Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=CONST(Finished));

    layout
    {
        area(content)
        {
            group("Cost Amount")
            {
                Caption = 'Cost Amount';
                fixed(Control1101214000)
                {
                    ShowCaption = false;
                    group(CostBudget)
                    {
                        Caption = 'Budget';
                        field(CostItemBudget;BudgetCost[1])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Item';
                            Visible = TypeItemVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(1);
                            end;
                        }
                        field(CostSparePartBudget;BudgetCost[2])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Spare Part';
                            Visible = TypeSparePartVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(2);
                            end;
                        }
                        field(CostResourceBudget;BudgetCost[4])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Resource';
                            Visible = TypeResourceVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(4);
                            end;
                        }
                        field(CostTeamBudget;BudgetCost[5])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Team';
                            Visible = TypeTeamVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(5);
                            end;
                        }
                        field(CostTradeBudget;BudgetCost[6])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Trade';
                            Visible = TypeTradeVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(6);
                            end;
                        }
                        field(CostCostBudget;BudgetCost[3])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Cost';
                            Visible = TypeCostVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(3);
                            end;
                        }
                        field("BudgetCost[8]";BudgetCost[8])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            ShowCaption = false;
                            Style = Strong;
                            StyleExpr = TRUE;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetCost(8);
                            end;
                        }
                    }
                    group(CostActual)
                    {
                        Caption = 'Actual';
                        field(CostItemActual;ActualCost[1])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Item';
                            Visible = TypeItemVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualCost(1);
                            end;
                        }
                        field(CostSparePartActual;ActualCost[2])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Spare Part';
                            Visible = TypeSparePartVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualCost(2);
                            end;
                        }
                        field(CostResourceActual;ActualCost[4])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Resource';
                            Visible = TypeResourceVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualCost(4);
                            end;
                        }
                        field(CostTeamActual;ActualCost[5])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Team';
                            Visible = TypeTeamVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualCost(5);
                            end;
                        }
                        field(CostTradeActual;ActualCost[6])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Trade';
                            Visible = TypeTradeVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualCost(6);
                            end;
                        }
                        field(CostCostActual;ActualCost[3])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Cost';
                            Visible = TypeCostVisible;

                            trigger OnAssistEdit()
                            begin
                                DrillDownActualCost(3);
                            end;
                        }
                        field("ActualCost[8]";ActualCost[8])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            ShowCaption = false;
                            Style = Strong;
                            StyleExpr = TRUE;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualCost(8);
                            end;
                        }
                    }
                    group(CostVariance)
                    {
                        Caption = 'Variance';
                        field(VarCostItemActual;VarianceCost[1])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Item';
                            Visible = TypeItemVisible;
                        }
                        field(VarCostSparePartActual;VarianceCost[2])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Spare Part';
                            Visible = TypeSparePartVisible;
                        }
                        field(VarCostResourceActual;VarianceCost[4])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Resource';
                            Visible = TypeResourceVisible;
                        }
                        field(VarCostTeamActual;VarianceCost[5])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Team';
                            Visible = TypeTeamVisible;
                        }
                        field(VarCostTradeActual;VarianceCost[6])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Trade';
                            Visible = TypeTradeVisible;
                        }
                        field(VarCostCostActual;VarianceCost[3])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            Caption = 'Cost';
                            Visible = TypeCostVisible;
                        }
                        field("VarianceCost[8]";VarianceCost[8])
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatType = 2;
                            ShowCaption = false;
                            Style = Strong;
                            StyleExpr = TRUE;
                        }
                    }
                }
            }
            group(Hours)
            {
                Caption = 'Hours';
                fixed(Control1101214033)
                {
                    ShowCaption = false;
                    group(HourBudget)
                    {
                        Caption = 'Budget';
                        field(HourResourceBudget;BudgetHour[4])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Resource';
                            DecimalPlaces = 0:5;
                            Visible = TypeResourceVisible;

                            trigger OnAssistEdit()
                            begin
                                DrillDownBudgetHour(4);
                            end;
                        }
                        field(HourTeamBudget;BudgetHour[5])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Team';
                            DecimalPlaces = 0:5;
                            Visible = TypeTeamVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetHour(5);
                            end;
                        }
                        field(HourTradeBudget;BudgetHour[6])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Trade';
                            DecimalPlaces = 0:5;
                            Visible = TypeTradeVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetHour(6);
                            end;
                        }
                        field(HourCostBudget;BudgetHour[3])
                        {
                            ApplicationArea = Basic,Suite;
                            BlankZero = true;
                            Caption = 'Cost';
                            DecimalPlaces = 0:5;
                            Visible = TypeCostVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetHour(3);
                            end;
                        }
                        field("BudgetHour[8]";BudgetHour[8])
                        {
                            ApplicationArea = Basic,Suite;
                            DecimalPlaces = 0:5;
                            ShowCaption = false;
                            Style = Strong;
                            StyleExpr = TRUE;

                            trigger OnDrillDown()
                            begin
                                DrillDownBudgetHour(8);
                            end;
                        }
                    }
                    group(HourActual)
                    {
                        Caption = 'Actual';
                        field(HourResourceActual;ActualHour[4])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Resource';
                            DecimalPlaces = 0:5;
                            Visible = TypeResourceVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualHour(4);
                            end;
                        }
                        field(HourTeamActual;ActualHour[5])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Team';
                            DecimalPlaces = 0:5;
                            Visible = TypeTeamVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualHour(5);
                            end;
                        }
                        field(HourTradeActual;ActualHour[6])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Trade';
                            DecimalPlaces = 0:5;
                            Visible = TypeTradeVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualHour(6);
                            end;
                        }
                        field(HourCostActual;ActualHour[3])
                        {
                            ApplicationArea = Basic,Suite;
                            BlankZero = true;
                            Caption = 'Cost';
                            DecimalPlaces = 0:5;
                            Visible = TypeCostVisible;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualHour(3);
                            end;
                        }
                        field("ActualHour[8]";ActualHour[8])
                        {
                            ApplicationArea = Basic,Suite;
                            DecimalPlaces = 0:5;
                            ShowCaption = false;
                            Style = Strong;
                            StyleExpr = TRUE;

                            trigger OnDrillDown()
                            begin
                                DrillDownActualHour(8);
                            end;
                        }
                    }
                    group(HourVariance)
                    {
                        Caption = 'Variance';
                        field(VarResourceActual;VarianceHour[4])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Resource';
                            DecimalPlaces = 0:5;
                            Visible = TypeResourceVisible;
                        }
                        field(VarTeamActual;VarianceHour[5])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Team';
                            DecimalPlaces = 0:5;
                            Visible = TypeTeamVisible;
                        }
                        field(VarTradeActual;VarianceHour[6])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Trade';
                            DecimalPlaces = 0:5;
                            Visible = TypeTradeVisible;
                        }
                        field(VarCostActual;VarianceHour[3])
                        {
                            ApplicationArea = Basic,Suite;
                            BlankZero = true;
                            Caption = 'Cost';
                            DecimalPlaces = 0:5;
                            Visible = TypeCostVisible;
                        }
                        field("VarianceHour[8]";VarianceHour[8])
                        {
                            ApplicationArea = Basic,Suite;
                            DecimalPlaces = 0:5;
                            ShowCaption = false;
                            Style = Strong;
                            StyleExpr = TRUE;
                        }
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
        if not IsFiltered then begin
          FilterGroup(2);
          SetRange(Status,Status);
          SetRange("No.","No.");
          FilterGroup(0);
          IsFiltered := true;
        end;

        ClearAll;
        // "Type Filter": ' ,Item,Spare Part,Cost,Resource,Team,Trade'
        for i := 1 to 6 do begin
          SetRange("Type Filter",i);
          CalcFields("Budgeted Cost Amount","Actual Cost Amount","Budgeted Hours","Actual Hours");
          BudgetHour[i] := "Budgeted Hours";
          ActualHour[i] := "Actual Hours";

          BudgetHour[8] := BudgetHour[8] + BudgetHour[i];
          ActualHour[8] := ActualHour[8] + ActualHour[i];
          BudgetCost[i] := "Budgeted Cost Amount";
          BudgetCost[8] := BudgetCost[8] + BudgetCost[i];
          ActualCost[i] := "Actual Cost Amount";
          ActualCost[8] := ActualCost[8] + "Actual Cost Amount";

          VarianceHour[i] := BudgetHour[i] - ActualHour[i];
          VarianceHour[8] := VarianceHour[8] + VarianceHour[i];

          VarianceCost[i] := BudgetCost[i] - ActualCost[i];
          VarianceCost[8] := VarianceCost[8] + VarianceCost[i];
        end;

        SetRange("Type Filter");
    end;

    trigger OnOpenPage()
    begin
        SetTypeVisibility;
    end;

    var
        AMFunction: Codeunit "MCH AM Functions";
        IsFiltered: Boolean;
        i: Integer;
        MaintCostType: Option " ","Spare Part",Cost,Trade;
        BudgetCost: array [8] of Decimal;
        ActualCost: array [8] of Decimal;
        BudgetHour: array [8] of Decimal;
        ActualHour: array [8] of Decimal;
        VarianceCost: array [8] of Decimal;
        VarianceHour: array [8] of Decimal;
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

    local procedure DrillDownBudgetCost(TheType: Integer)
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

    local procedure DrillDownActualCost(TheType: Integer)
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        with AMLedgEntry do begin
          if TheType in [1..6] then begin
            SetCurrentKey("Work Order No.",Type);
            SetRange(Type,TheType);
          end;
          AMLedgEntry.SetRange("Work Order No.","No.");
        end;
        PAGE.Run(0,AMLedgEntry);
    end;

    local procedure DrillDownBudgetHour(TheType: Integer)
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
    begin
        with WOBudgetLine do begin
          WOBudgetLine.SetCurrentKey(Status,"Work Order No.",Type,"No.");
          if TheType in [1..6] then
            SetRange(Type,TheType)
          else
            SetFilter(Type,'%1..%2',Type::Cost,Type::Trade);
          SetRange(Status,Rec.Status);
          SetRange("Work Order No.",Rec."No.");
        end;
        PAGE.Run(0,WOBudgetLine);
    end;

    local procedure DrillDownActualHour(TheType: Integer)
    var
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
    begin
        with AMLedgEntry do begin
          SetCurrentKey("Work Order No.",Type);
          if TheType in [1..6] then
            SetRange(Type,TheType)
          else
            SetFilter(Type,'%1..%2',Type::Cost,Type::Trade);
          SetRange("Work Order No.",Rec."No.");
        end;
        PAGE.Run(0,AMLedgEntry);
    end;

    local procedure SetTypeVisibility()
    var
        AMFunction: Codeunit "MCH AM Functions";
    begin
        AMFunction.GetTypeVisibility(TypeItemVisible,TypeSparePartVisible,TypeCostVisible,TypeResourceVisible,TypeTeamVisible,TypeTradeVisible);
    end;
}

