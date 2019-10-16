page 74082 "MCH WO Progress Status List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'WO Progress Status List';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Progress Status";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101214019)
            {
                FreezeColumn = Description;
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("In-Use on Work Order";"In-Use on Work Order")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Lookup Sorting Order";"Lookup Sorting Order")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Allow on WO Request";"Allow on WO Request")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Def. on WO Request";"Def. on WO Request")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Allow on Planned WO";"Allow on Planned WO")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Def. on Planned WO";"Def. on Planned WO")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Allow on Released WO";"Allow on Released WO")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Def. on Released WO";"Def. on Released WO")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Allow on Finished WO";"Allow on Finished WO")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Maint. Location Mandatory";"Maint. Location Mandatory")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Person Responsible Mandatory";"Person Responsible Mandatory")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Block Additional Purchasing";"Block Additional Purchasing")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Block Purchase Posting";"Block Purchase Posting")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Block Inventory Issue";"Block Inventory Issue")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Block Inventory Return";"Block Inventory Return")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Block Timesheet Entry";"Block Timesheet Entry")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Block Timesheet Posting";"Block Timesheet Posting")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214000;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(WorkOrdersList)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Used-by Work Orders';
                Image = OrderList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "MCH Work Order List";
                RunPageLink = "Progress Status Code"=FIELD(Code);
                RunPageView = SORTING("Progress Status Code");
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        WOProgressStatus: Record "MCH Work Order Progress Status";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(WOProgressStatus);
        exit(PageFilterHelper.GetSelectionFilterForWOProgressStatus(WOProgressStatus));
    end;
}

