page 74068 "MCH Work Order List"
{
    Caption = 'Work Order List';
    DataCaptionFields = Status;
    Editable = false;
    PageType = List;
    SourceTable = "MCH Work Order Header";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Status;
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Lookup = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Progress Status Code";"Progress Status Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = AssetNoVisible;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = TaskCodeVisible;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    StyleExpr = PriorityStyleTxt;
                }
                field("Requested Starting Date";"Requested Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Ending Date";"Expected Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Location Code";"Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Person Responsible";"Person Responsible")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Work Order Lines";"No. of Work Order Lines")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = NOT TaskCodeVisible;
                }
                field("Completion Date";"Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created Date";"Created Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created Time";"Created Time")
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
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Time Modified";"Last Time Modified")
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
            action(ShowWorkOrder)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Work Order';
                Image = ViewServiceOrder;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                begin
                    Rec.ShowCard();
                end;
            }
            action(AdvancedView)
            {
                ApplicationArea = All;
                Caption = 'Advanced List View';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the Work Order List page showing all possible columns.';

                trigger OnAction()
                var
                    WorkOrderRequests: Page "MCH Work Order Requests";
                    PlannedWorkOrders: Page "MCH Planned Work Orders";
                    ReleasedWorkOrders: Page "MCH Released Work Orders";
                    FinishedWorkOrders: Page "MCH Finished Work Orders";
                begin
                    if ("No." = '') then
                      exit;
                    case Status of
                      Status::Request:
                        begin
                          WorkOrderRequests.SetRecord(Rec);
                          WorkOrderRequests.LookupMode := true;
                          if WorkOrderRequests.RunModal = ACTION::LookupOK then begin
                            WorkOrderRequests.GetRecord(Rec);
                            CurrPage.Close;
                          end;
                        end;
                      Status::Planned:
                        begin
                          PlannedWorkOrders.SetRecord(Rec);
                          PlannedWorkOrders.LookupMode := true;
                          if PlannedWorkOrders.RunModal = ACTION::LookupOK then begin
                            PlannedWorkOrders.GetRecord(Rec);
                            CurrPage.Close;
                          end;
                        end;
                      Status::Released:
                        begin
                          ReleasedWorkOrders.SetRecord(Rec);
                          ReleasedWorkOrders.LookupMode := true;
                          if ReleasedWorkOrders.RunModal = ACTION::LookupOK then begin
                            ReleasedWorkOrders.GetRecord(Rec);
                            CurrPage.Close;
                          end;
                        end;
                      Status::Finished:
                        begin
                          FinishedWorkOrders.SetRecord(Rec);
                          FinishedWorkOrders.LookupMode := true;
                          if FinishedWorkOrders.RunModal = ACTION::LookupOK then begin
                            FinishedWorkOrders.GetRecord(Rec);
                            CurrPage.Close;
                          end;
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PriorityStyleTxt := GetPriorityStyleTxt;
    end;

    trigger OnOpenPage()
    begin
        AMSetup.Get;
        AssetNoVisible :=
          (AMSetup."Work Order Line Restriction" in
            [AMSetup."Work Order Line Restriction"::"Single Line Only",
             AMSetup."Work Order Line Restriction"::"One Asset Only"]);
        TaskCodeVisible :=
          (AMSetup."Work Order Line Restriction" in
            [AMSetup."Work Order Line Restriction"::"Single Line Only"]);

        SetSecurityFilterOnResponsibilityGroup(2);
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        PriorityStyleTxt: Text;
        [InDataSet]
        AssetNoVisible: Boolean;
        [InDataSet]
        TaskCodeVisible: Boolean;


    procedure GetSelectionFilter(): Text
    var
        WorkOrderHeader: Record "MCH Work Order Header";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(WorkOrderHeader);
        exit(PageFilterHelper.GetSelectionFilterForWorkOrder(WorkOrderHeader));
    end;
}

