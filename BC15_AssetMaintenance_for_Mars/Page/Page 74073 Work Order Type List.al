page 74073 "MCH Work Order Type List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Work Order Type List';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Dimensions';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Type";
    UsageCategory = Administration;

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
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214001;Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            part(Control1101214006;"Dimensions FactBox")
            {
                ApplicationArea = Dimensions;
                SubPageLink = "Table ID"=CONST(74046),
                              "No."=FIELD(Code);
            }
            systempart(Control1101214000;Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Posting Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Posting Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "MCH AM Posting Setup";
                RunPageLink = "Work Order Type"=FIELD(Code);
                RunPageView = SORTING("Work Order Type");
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                action(DimensionsSingle)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions-Single';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=CONST(74046),
                                  "No."=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                }
                action(DimensionsMultiple)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions-&Multiple';
                    Image = DimensionSets;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                    trigger OnAction()
                    var
                        WorkOrderType: Record "MCH Work Order Type";
                        DefaultDimMultiple: Page "Default Dimensions-Multiple";
                    begin
                        CurrPage.SetSelectionFilter(WorkOrderType);
                        DefaultDimMultiple.SetMultiRecord(WorkOrderType,FieldNo(Code));
                        DefaultDimMultiple.RunModal;
                    end;
                }
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

