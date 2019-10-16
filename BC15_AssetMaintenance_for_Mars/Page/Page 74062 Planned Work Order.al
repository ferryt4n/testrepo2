page 74062 "MCH Planned Work Order"
{
    Caption = 'Planned Work Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approval,Work Order,Functions,Print,Purchasing,Labour,Inventory';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=CONST(Planned));

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
            part(WorkOrderLines;"MCH Planned Work Order Sub")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Lines';
                Editable = DynamicEditable;
                SubPageLink = "Work Order No."=FIELD("No.");
            }
            part(LineBudget;"MCH WO Rqst.-Plan. Budget Sub")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'LineBudget';
                Provider = WorkOrderLines;
                ShowFilter = false;
                SubPageLink = Status=FIELD(Status),
                              "Work Order No."=FIELD("Work Order No."),
                              "Work Order Line No."=FIELD("Line No.");
                UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part(Control1101214006;"MCH Rqst.-Plan. WO Budg. FactB")
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
            systempart(Control1101214008;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214007;Notes)
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

