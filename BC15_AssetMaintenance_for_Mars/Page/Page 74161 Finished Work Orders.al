page 74161 "MCH Finished Work Orders"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Finished Work Orders';
    CardPageID = "MCH Finished Work Order";
    Editable = false;
    InstructionalText = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchasing,Labour,Inventory';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchasing,Labour,Inventory';
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=FILTER(Finished));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1101216000)
            {
                FreezeColumn = "Completion Date";
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Lookup = false;
                }
                field("Completion Date";"Completion Date")
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
                field("Last Posting Date";"Last Posting Date")
                {
                    ApplicationArea = Basic,Suite;
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
                field("Status Changed Date-Time";"Status Changed Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Status Changed By";"Status Changed By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Work Order Lines";"No. of Work Order Lines")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
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
            part(Control1101214025;"MCH WO Work Descr. FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
                Visible = WorkDescriptionFactboxVisible;
            }
            part(Control1101214033;"MCH Rel.-Fin. WO Cost FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            part(Control1101214032;"MCH Rel.-Fin. WO Hour FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            systempart(Control1101214030;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214029;Notes)
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
                }
            }
            group(Labour)
            {
                Caption = 'Labour';
                action("Resource Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Resource Ledger Entries';
                    Image = ResourceLedger;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of resource ledger entries related to the work order.';
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Item Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entries';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "MCH Work Order No."=FIELD("No.");
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.");
                    ToolTip = 'Open the list of item ledger entries related to the work order.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        WorkDescriptionFactboxVisible := "Work Description".HasValue;
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
        [InDataSet]
        AssetNoVisible: Boolean;
        [InDataSet]
        TaskCodeVisible: Boolean;
        [InDataSet]
        WorkDescriptionFactboxVisible: Boolean;
}

