page 74081 "MCH WO Progress Status Lookup"
{
    Caption = 'Work Order Progress Status';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Progress Status";
    SourceTableView = SORTING("Lookup Sorting Order");

    layout
    {
        area(content)
        {
            repeater(Control1101214019)
            {
                FreezeColumn = "Code";
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Allow on WO Request";"Allow on WO Request")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Allow on Planned WO";"Allow on Planned WO")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Allow on Released WO";"Allow on Released WO")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Allow on Finished WO";"Allow on Finished WO")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Location Mandatory";"Maint. Location Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Person Responsible Mandatory";"Person Responsible Mandatory")
                {
                    ApplicationArea = Basic,Suite;
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
                field("Def. on Released WO";"Def. on Released WO")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Def. on Planned WO";"Def. on Planned WO")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Def. on WO Request";"Def. on WO Request")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
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
                ToolTip = 'Open the WO Progress Status List page showing all possible columns.';

                trigger OnAction()
                var
                    WOProgressStatusList: Page "MCH WO Progress Status List";
                begin
                    WOProgressStatusList.SetRecord(Rec);
                    WOProgressStatusList.LookupMode := true;
                    if WOProgressStatusList.RunModal = ACTION::LookupOK then begin
                      WOProgressStatusList.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
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

