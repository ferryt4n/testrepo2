page 74186 "MCH Ongoing WO Lines Sub"
{
    Caption = 'Header';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchase';
    SourceTable = "MCH Work Order Header";

    layout
    {
        area(content)
        {
            group(Control1101214028)
            {
                ShowCaption = false;
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Progress Status Code";"Progress Status Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                }
                field("Requested Starting Date";"Requested Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Previous Status";"Previous Status")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Status Changed By";"Status Changed By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Status Changed Date-Time";"Status Changed Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Ending Date";"Expected Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Completion Date";"Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Person Responsible";"Person Responsible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who is responsible for the work order.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(WorkDescription;WorkDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Description';
                    MultiLine = true;
                    ToolTip = 'Specifies the extended work order description';
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
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
    var
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
    begin
    end;

    trigger OnAfterGetRecord()
    begin
        WorkDescription := GetWorkDescription;
        IsReleased := (Status = Status::Released);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
    begin
    end;

    trigger OnOpenPage()
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
    end;

    var
        WorkDescription: Text;
        [InDataSet]
        IsReleased: Boolean;
}

