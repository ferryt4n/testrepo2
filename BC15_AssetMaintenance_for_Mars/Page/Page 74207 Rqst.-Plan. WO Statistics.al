page 74207 "MCH Rqst.-Plan. WO Statistics"
{
    Caption = 'Work Order Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=FILTER(Request|Planned));

    layout
    {
        area(content)
        {
            group(Budget)
            {
                Caption = 'Budget';
                fixed(Control1101214000)
                {
                    ShowCaption = false;
                    group("Cost Amount")
                    {
                        Caption = 'Cost Amount';
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
                    group(Hours)
                    {
                        Caption = 'Hours';
                        field(HideHourItemBudget;BudgetHour[1])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'HideHourItemBudget';
                            Visible = false;
                        }
                        field(HideHourSparePartBudget;BudgetHour[2])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'HideHourSparePartBudget';
                            Visible = false;
                        }
                        field(HourResourceBudget;BudgetHour[4])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Resource';
                            DecimalPlaces = 0:5;
                            Visible = TypeResourceVisible;

                            trigger OnDrillDown()
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
          CalcFields("Budgeted Cost Amount","Budgeted Hours");
          BudgetHour[i] := "Budgeted Hours";
          BudgetHour[8] := BudgetHour[8] + BudgetHour[i];
          BudgetCost[i] := "Budgeted Cost Amount";
          BudgetCost[8] := BudgetCost[8] + BudgetCost[i];
        end;
        SetRange("Type Filter");
    end;

    trigger OnOpenPage()
    begin
        SetTypeVisibility;
    end;

    var
        IsFiltered: Boolean;
        i: Integer;
        BudgetCost: array [8] of Decimal;
        BudgetHour: array [8] of Decimal;
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

    local procedure DrillDownBudgetHour(TheType: Integer)
    var
        WOBudgetLine: Record "MCH Work Order Budget Line";
    begin
        with WOBudgetLine do begin
          WOBudgetLine.SetCurrentKey(Status,"Work Order No.",Type,"No.");
          if TheType in [1..6] then
            SetRange(Type,TheType);
          SetRange(Status,Rec.Status);
          SetRange("Work Order No.",Rec."No.");
        end;
        PAGE.Run(0,WOBudgetLine);
    end;

    local procedure SetTypeVisibility()
    var
        AMFunction: Codeunit "MCH AM Functions";
    begin
        AMFunction.GetTypeVisibility(TypeItemVisible,TypeSparePartVisible,TypeCostVisible,TypeResourceVisible,TypeTeamVisible,TypeTradeVisible);
    end;
}

