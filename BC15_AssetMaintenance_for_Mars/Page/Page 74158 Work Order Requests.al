page 74158 "MCH Work Order Requests"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Work Order Requests';
    CardPageID = "MCH Work Order Request";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchasing,Labour,Inventory';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=CONST(Request));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101216000)
            {
                FreezeColumn = "Work Order Type";
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Lookup = false;
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
                    StyleExpr = OverdueEndingDateStyleTxt;
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
                    StyleExpr = OverdueEndingDateStyleTxt;
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
                field("No. of Attachments";"No. of Attachments")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowDocumentAttachments;
                    end;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
        area(factboxes)
        {
            part(Control1101214036;"MCH WO Work Descr. FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = WorkDescriptionFactboxVisible;
            }
            part(Control1101214002;"MCH Rqst.-Plan. WO Budg. FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            systempart(Control1101214004;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214003;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Change Status")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Change Status';
                Ellipsis = true;
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+F9';

                trigger OnAction()
                var
                    SelectedWorkOrder: Record "MCH Work Order Header";
                begin
                    if "No." = '' then
                      exit;
                    CurrPage.SetSelectionFilter(SelectedWorkOrder);
                    Rec.ChangeWorkOrderStatus(SelectedWorkOrder);
                    CurrPage.Update(false);
                end;
            }
            group("Work Order")
            {
                Caption = 'Work Order';
                action(Budget)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Budget';
                    Image = LedgerBudget;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowBudget;
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        Rec.ShowStatistics;
                    end;
                }
                action(Attachments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocumentAttachments;
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ShowWorkOrderCommentSheet;
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
            }
            group(Functions)
            {
                Caption = 'Functions';
            }
            group(Print)
            {
                Caption = 'Print';
                action("Print Work Order")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Print Work Order';
                    Ellipsis = true;
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        WorkOrderHeader: Record "MCH Work Order Header";
                    begin
                        WorkOrderHeader := Rec;
                        CurrPage.SetSelectionFilter(WorkOrderHeader);
                        WorkOrderHeader.PrintWorkOrder(true);
                    end;
                }
            }
            group(Purchase)
            {
                Caption = 'Purchasing';
            }
            group(Labour)
            {
                Caption = 'Labour';
            }
            group(Inventory)
            {
                Caption = 'Inventory';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        WorkDescriptionFactboxVisible := "Work Description".HasValue;
    end;

    trigger OnAfterGetRecord()
    begin
        PriorityStyleTxt := GetPriorityStyleTxt;
        OverdueEndingDateStyleTxt := GetOverdueEndingDateStyleTxt;
    end;

    trigger OnOpenPage()
    var
        AMSetup: Record "MCH Asset Maintenance Setup";
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
        PriorityStyleTxt: Text;
        [InDataSet]
        OverdueEndingDateStyleTxt: Text;
        [InDataSet]
        AssetNoVisible: Boolean;
        [InDataSet]
        TaskCodeVisible: Boolean;
        [InDataSet]
        WorkDescriptionFactboxVisible: Boolean;
}

