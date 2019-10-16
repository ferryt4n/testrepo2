page 74064 "MCH Released Work Order"
{
    Caption = 'Released Work Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchase,Labour,Inventory';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=FILTER(Released));

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
                        Visible = DocNoVisible;

                        trigger OnAssistEdit()
                        begin
                            if AssistEdit(xRec) then
                              CurrPage.Update;
                        end;
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
                        ShowMandatory = WOTypeMandatory;

                        trigger OnValidate()
                        begin
                            if GetFilter("Work Order Type") = xRec."Work Order Type" then
                              if "Work Order Type" <> xRec."Work Order Type" then
                                SetRange("Work Order Type");
                            CurrPage.Update;
                        end;
                    }
                    field(Priority;Priority)
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Maint. Location Code";"Maint. Location Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ShowMandatory = MaintLocationMandatory;

                        trigger OnValidate()
                        begin
                            if GetFilter("Maint. Location Code") = xRec."Maint. Location Code" then
                              if "Maint. Location Code" <> xRec."Maint. Location Code" then
                                SetRange("Maint. Location Code");
                            CurrPage.Update;
                        end;
                    }
                    field("Responsibility Group Code";"Responsibility Group Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = RespGroupCodeEditable;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            if GetFilter("Responsibility Group Code") = xRec."Responsibility Group Code" then
                              if "Responsibility Group Code" <> xRec."Responsibility Group Code" then
                                SetRange("Responsibility Group Code");
                            CurrPage.Update;
                        end;
                    }
                    field("Requested Starting Date";"Requested Starting Date")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Last Posting Date";"Last Posting Date")
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
                    field("Previous Status";"Previous Status")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        Visible = false;
                    }
                    field("Status Changed By";"Status Changed By")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        Visible = false;
                    }
                    field("Status Changed Date-Time";"Status Changed Date-Time")
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
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Starting Date";"Starting Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Ending Date";"Ending Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Expected Ending Date";"Expected Ending Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;

                        trigger OnValidate()
                        begin
                            SetRange("Expected Ending Date");
                            CurrPage.Update;
                        end;
                    }
                    field("Completion Date";"Completion Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Person Responsible";"Person Responsible")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = PersonResponsibleMandatory;
                        ToolTip = 'Specifies the ID of the user who is responsible for the work order.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Assigned User ID";"Assigned User ID")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Progress Status Code";"Progress Status Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ShowMandatory = ProgressStatusMandatory;

                        trigger OnValidate()
                        begin
                            if GetFilter("Progress Status Code") = xRec."Progress Status Code" then
                              if "Progress Status Code" <> xRec."Progress Status Code" then
                                SetRange("Progress Status Code");
                            CurrPage.Update;
                        end;
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

                            trigger OnValidate()
                            begin
                                SetWorkDescription(WorkDescription);
                            end;
                        }
                    }
                }
            }
            part(WorkOrderLines;"MCH Released Work Order Sub")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Lines';
                Editable = DynamicEditable;
                SubPageLink = "Work Order No."=FIELD("No.");
                UpdatePropagation = Both;
            }
            part(WorkOrderLineBudget;"MCH WO Released Budget Sub")
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
            part(Control1101214032;"MCH Released WO Ongoing FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            part(Control1101214020;"MCH Rel.-Fin. WO Cost FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            part(Control1101214021;"MCH Rel.-Fin. WO Hour FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Status=FIELD(Status),
                              "No."=FIELD("No.");
            }
            part(Control1101214003;"MCH Work Order Line Dim. FactB")
            {
                ApplicationArea = Basic,Suite;
                Provider = WorkOrderLines;
                SubPageLink = "Dimension Set ID"=FIELD("Dimension Set ID");
            }
            systempart(Control1101214019;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214018;Links)
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
    var
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
    begin
        DynamicEditable := CurrPage.Editable;
        RespGroupCodeEditable := DynamicEditable;
        if RespGroupCodeEditable then begin
          if MaintUserMgt.UserHasAssetRespGroupFilter then
            RespGroupCodeEditable := not WorkOrderLinesExist;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
        WorkDescription := GetWorkDescription;
    end;

    trigger OnInit()
    begin
        SetFieldMandatoryCondition;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
    begin
        xRec.Init;
        "Responsibility Group Code" := MaintUserMgt.GetDefaultAssetRespGroupCode;
        "Maint. Location Code" := MaintUserMgt.GetDefaultMaintLocationCode;

        AMSetup.Get;
        WorkDescription := '';
        RespGroupCodeEditable := true;

        Priority := AMSetup."Def. Work Order Priority";
    end;

    trigger OnOpenPage()
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        SetSecurityFilterOnResponsibilityGroup(2);
        RespGroupCodeEditable := true;
        DocNoVisible := AMFunctions.IsWorkOrderNoVisible("No.");
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        WorkDescription: Text;
        DynamicEditable: Boolean;
        DocNoVisible: Boolean;
        WOTypeMandatory: Boolean;
        ProgressStatusMandatory: Boolean;
        PersonResponsibleMandatory: Boolean;
        RespGroupCodeEditable: Boolean;
        MaintLocationMandatory: Boolean;

    local procedure SetControlVisibility()
    begin
        SetFieldMandatoryCondition;
    end;

    local procedure SetFieldMandatoryCondition()
    var
        WOProgressStatus: Record "MCH Work Order Progress Status";
    begin
        AMSetup.Get;
        WOTypeMandatory := AMSetup."Work Order Type Mandatory";
        ProgressStatusMandatory := AMSetup."WO Progress Status Mandatory";
        PersonResponsibleMandatory := AMSetup."WO Person Respons. Mandatory";

        MaintLocationMandatory := false;
        if "Progress Status Code" <> '' then begin
          if WOProgressStatus.Get("Progress Status Code") then begin
            MaintLocationMandatory := WOProgressStatus."Maint. Location Mandatory";
            PersonResponsibleMandatory := PersonResponsibleMandatory or WOProgressStatus."Person Responsible Mandatory";
          end;
        end;
    end;
}

