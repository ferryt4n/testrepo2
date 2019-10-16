page 74183 "MCH Ongoing Work Orders"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Ongoing Work Orders';
    DataCaptionFields = Status;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchase';
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=FILTER(Request..Released));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Starting Date";
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
                    DrillDown = false;
                    Visible = AssetNoVisible;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
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
            group("Work Order Lines")
            {
                Caption = 'Work Order Lines';
                part(Control1101214009;"MCH Ongoing Work Orders Sub")
                {
                    ApplicationArea = Basic,Suite;
                    SubPageLink = Status=FIELD(Status),
                                  "Work Order No."=FIELD("No.");
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214034;"MCH Released WO Ongoing FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = IsReleased;
            }
            part(Control1101214033;"MCH WO Work Descr. FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = WorkDescriptionFactboxVisible;
            }
            part(Control1101214036;"MCH Rqst.-Plan. WO Budg. FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = NOT IsReleased;
            }
            part(Control1101214032;"MCH Rel.-Fin. WO Cost FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = IsReleased;
            }
            part(Control1101214031;"MCH Rel.-Fin. WO Hour FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = IsReleased;
            }
            systempart(Control1101214030;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214029;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
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
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Work Order No."=FIELD("No.");
                    RunPageView = SORTING("Work Order No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    Visible = IsReleased;
                }
                action("Resource Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Resource Ledger Entries';
                    Image = ResourceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of resource ledger entries related to the work order.';
                    Visible = IsReleased;
                }
                action("Item Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entries';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of item ledger entries related to the work order.';
                    Visible = IsReleased;
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
                Visible = IsReleased;
                action(SuggestInventoryIssue)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Suggest Inventory Issue';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Open a wizard that will assist creating inventory issue journal lines based on the work order budget lines.';
                    Visible = IsReleased;

                    trigger OnAction()
                    var
                        WorkOrderHeader: Record "MCH Work Order Header";
                        InventoryIssueWizard: Page "MCH AM Inventory Issue Wizard";
                    begin
                        if "No." = '' then
                          exit;
                        WorkOrderHeader := Rec;
                        CurrPage.SetSelectionFilter(WorkOrderHeader);
                        InventoryIssueWizard.SetCalledFromWorkOrder(WorkOrderHeader);
                        InventoryIssueWizard.RunModal;
                    end;
                }
                action(SuggestPurchase)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Suggest Purchase';
                    Ellipsis = true;
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Open a wizard that will assist creating purchase order(s) based on the work order budget lines.';
                    Visible = IsReleased;

                    trigger OnAction()
                    var
                        WorkOrderHeader: Record "MCH Work Order Header";
                        MaintPurchaseWizard: Page "MCH AM Purchase Wizard";
                    begin
                        if "No." = '' then
                          exit;
                        WorkOrderHeader := Rec;
                        CurrPage.SetSelectionFilter(WorkOrderHeader);
                        MaintPurchaseWizard.SetCalledFromWorkOrder(WorkOrderHeader);
                        MaintPurchaseWizard.RunModal;
                    end;
                }
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
                Caption = 'Purchase';
                Visible = IsReleased;
                action("Ongoing Purchase Lines")
                {
                    AccessByPermission = TableData "Purchase Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ongoing Purchase Lines';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    RunObject = Page "Purchase Lines";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of ongoing purchase lines related to the work order.';
                    Visible = IsReleased;
                }
                action("Posted Purch. Receipt Lines")
                {
                    AccessByPermission = TableData "Purch. Rcpt. Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purch. Receipt Lines';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    RunObject = Page "Posted Purchase Receipt Lines";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of posted purchase receipt lines related to the work order.';
                    Visible = IsReleased;
                }
                action("Posted Purch. Invoice Lines")
                {
                    AccessByPermission = TableData "Purch. Inv. Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purch. Invoice Lines';
                    Image = PostedTaxInvoice;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    RunObject = Page "Posted Purchase Invoice Lines";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of posted purchase invoice lines related to the work order.';
                    Visible = IsReleased;
                }
                action("Posted Return Shipment Lines")
                {
                    AccessByPermission = TableData "Return Shipment Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Return Shipment Lines';
                    Image = PostedReturnReceipt;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    RunObject = Page "Posted Return Shipment Lines";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of posted return shipment lines related to the work order.';
                    Visible = IsReleased;
                }
                action("Posted Purch. CR/Adj Note Lines")
                {
                    AccessByPermission = TableData "Purch. Cr. Memo Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted Purch. CR/Adj Note Lines';
                    Image = PostedCreditMemo;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    RunObject = Page "Posted Purchase Cr. Memo Lines";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of posted purchase CR/Adj Note lines related to the work order.';
                    Visible = IsReleased;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        WorkDescriptionFactboxVisible := "Work Description".HasValue;
        IsReleased := (Status = Status::Released);
    end;

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

        IsReleased := false;
        SetSecurityFilterOnResponsibilityGroup(2);
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        PriorityStyleTxt: Text;
        [InDataSet]
        AssetNoVisible: Boolean;
        [InDataSet]
        TaskCodeVisible: Boolean;
        [InDataSet]
        IsReleased: Boolean;
        [InDataSet]
        WorkDescriptionFactboxVisible: Boolean;


    procedure GetSelectionFilter(): Text
    var
        WorkOrderHeader: Record "MCH Work Order Header";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(WorkOrderHeader);
        exit(PageFilterHelper.GetSelectionFilterForWorkOrder(WorkOrderHeader));
    end;
}

