page 74066 "MCH Finished Work Order"
{
    Caption = 'Finished Work Order';
    Editable = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchase,Labour,Inventory';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=FILTER(Finished));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(GeneralGroup1)
                {
                    ShowCaption = false;
                    field("No.";"No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Lookup = false;
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
                    field("Work Order Type";"Work Order Type")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field(Priority;Priority)
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field("Maint. Location Code";"Maint. Location Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field("Responsibility Group Code";"Responsibility Group Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field("Requested Starting Date";"Requested Starting Date")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("No. of Attachments";"No. of Attachments")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowDocumentAttachments;
                        end;
                    }
                    field("Created Date-Time";"Created Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Created By";"Created By")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Last Modified Date-Time";"Last Modified Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        Visible = false;
                    }
                    field("Last Modified By";"Last Modified By")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        Visible = false;
                    }
                }
                group(GeneralGroup2)
                {
                    ShowCaption = false;
                    field("Order Date";"Order Date")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Starting Date";"Starting Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field("Ending Date";"Ending Date")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Expected Ending Date";"Expected Ending Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
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
                    field("Progress Status Code";"Progress Status Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field("Status Changed By";"Status Changed By")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Status Changed Date-Time";"Status Changed Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    group(WorkDescriptionGroup)
                    {
                        Caption = 'Work Description';
                        field(WorkDescription;WorkDescription)
                        {
                            ApplicationArea = Basic,Suite;
                            Importance = Additional;
                            MultiLine = true;
                            ShowCaption = false;
                            ToolTip = 'Specifies the extended work order description';
                        }
                    }
                }
            }
            part(WorkOrderLines;"MCH Finished Work Order Sub")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Lines';
                SubPageLink = "Work Order No."=FIELD("No.");
            }
            part(WorkOrderLineBudget;"MCH WO Finished Budget Sub")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Line Budget';
                Editable = false;
                Provider = WorkOrderLines;
                SubPageLink = Status=FIELD(Status),
                              "Work Order No."=FIELD("Work Order No."),
                              "Work Order Line No."=FIELD("Line No.");
                SubPageView = SORTING(Status,"Work Order No.","Work Order Line No.");
                UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part(Control1101214004;"MCH Rel.-Fin. WO Cost FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            part(Control1101214003;"MCH Rel.-Fin. WO Hour FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            part(Control1101214000;"MCH Work Order Line Dim. FactB")
            {
                ApplicationArea = Basic,Suite;
                Provider = WorkOrderLines;
                SubPageLink = "Dimension Set ID"=FIELD("Dimension Set ID");
            }
            systempart(Control1101214002;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214001;Notes)
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
                Caption = 'Purchase';
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

    trigger OnAfterGetRecord()
    begin
        WorkDescription := GetWorkDescription;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(2);
    end;

    var
        WorkDescription: Text;
}

