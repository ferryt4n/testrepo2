page 74074 "MCH Work Order Type Lookup"
{
    Caption = 'Work Order Types';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Dimensions';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Type";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    Style = Unfavorable;
                    StyleExpr = Blocked;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Unfavorable;
                    StyleExpr = Blocked;
                }
                field("Def. Work Order Priority";"Def. Work Order Priority")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(AdvancedView)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the Work Order Type List page showing all possible columns.';

                trigger OnAction()
                var
                    WorkOrderTypeList: Page "MCH Work Order Type List";
                begin
                    WorkOrderTypeList.SetRecord(Rec);
                    WorkOrderTypeList.LookupMode := true;
                    if WorkOrderTypeList.RunModal = ACTION::LookupOK then begin
                      WorkOrderTypeList.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        WorkOrderType: Record "MCH Work Order Type";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(WorkOrderType);
        exit(PageFilterHelper.GetSelectionFilterForWOType(WorkOrderType));
    end;
}

