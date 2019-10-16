page 74032 "MCH Maintenance Asset Card"
{
    Caption = 'Maintenance Asset Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Asset,History,Work Order,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Maintenance Asset";

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

                        trigger OnAssistEdit()
                        begin
                            if AssistEdit(xRec) then
                              CurrPage.Update;
                        end;
                    }
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    field("Description 2";"Description 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Visible = false;
                    }
                    field("Category Code";"Category Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ShowMandatory = CategoryCodeMandatory;
                    }
                    field("Parent Asset No.";"Parent Asset No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintAsset: Record "MCH Maintenance Asset";
                            MaintAssetLookup: Page "MCH Maintenance Asset Lookup";
                        begin
                            if ("No." = '')  then
                              exit;
                            MaintAsset.SetCurrentKey("Structure Position ID");
                            MaintAsset.FilterGroup(2);
                            MaintAsset.SetFilter("No.",'<>%1',"No.");
                            MaintAsset.FilterGroup(0);
                            MaintAssetLookup.SetShowAsStructure(true);
                            if MaintAsset.Get("Parent Asset No.") then
                              MaintAssetLookup.SetRecord(MaintAsset);
                            if CurrPage.Editable then begin
                              MaintAssetLookup.LookupMode := true;
                              if MaintAssetLookup.RunModal = ACTION::LookupOK then begin
                                MaintAssetLookup.GetRecord(MaintAsset);
                                Text := MaintAsset."No.";
                                exit(true);
                              end;
                            end else begin
                              MaintAssetLookup.Run;
                            end;
                            exit(false);
                        end;

                        trigger OnValidate()
                        begin
                            CurrPage.Update(false);
                        end;
                    }
                    field("Is Parent";"Is Parent")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;

                        trigger OnDrillDown()
                        begin
                            OnParentShowChildren;
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
                }
                group(GeneralGroup2)
                {
                    ShowCaption = false;
                    field("Responsibility Group Code";"Responsibility Group Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ShowMandatory = RespGroupCodeMandatory;
                        ToolTip = 'Specifies a (fixed) Responsibility Group that always must be used on work orders. The assigned Responsibility Group is also used to limit viewing/processing by Maint. Users that are setup with Resp. Group view limitations. ';
                    }
                    field("Fixed Maint. Location Code";"Fixed Maint. Location Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ShowMandatory = MaintLocationCodeMandatory;
                        ToolTip = 'Specifies a fixed Maintenance Location that always must be used on work orders.';
                    }
                    field("Def. Invt. Location Code";"Def. Invt. Location Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        Visible = false;
                    }
                    field("Posting Group";"Posting Group")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the posting group that is used when posting resource/team maintenance timesheets.';
                    }
                    field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the Gen. Bus. Posting Group that is used on issue/return posting of maintenance inventory.';
                    }
                    field("No. of Attachments";"No. of Attachments")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowDocumentAttachments;
                        end;
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
                    field(Blocked;Blocked)
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Fixed Asset No.";"Fixed Asset No.")
                {
                    AccessByPermission = TableData "Fixed Asset"=R;
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                }
                field("Fixed Asset Description";"Fixed Asset Description")
                {
                    AccessByPermission = TableData "Fixed Asset"=R;
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies where the asset located.';
                }
                field("Manufacturer Code";"Manufacturer Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Manufacturers Part No.";"Manufacturers Part No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Original Part No.";"Original Part No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Registration No.";"Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                }
                field(Make;Make)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                }
                field(Model;Model)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            part(MaintenanceTasks;"MCH Asset - Maint. Task Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("No.");
            }
            part(UsageMonitors;"MCH Asset - Usage Monitor Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("No.");
            }
            part(Control1101214009;"MCH Work Instr. Setup Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Table Name"=CONST(Asset),
                              Code=FIELD("No.");
            }
        }
        area(factboxes)
        {
            part(Control1101214021;"MCH Asset - Ongoing FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=FIELD("No.");
            }
            part(AssetMaintTaskFactbox;"MCH Asset Maint. Task FactBC")
            {
                ApplicationArea = Basic,Suite;
                Provider = MaintenanceTasks;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
                UpdatePropagation = Both;
                Visible = AssetMaintTaskFactboxVisible;
            }
            part(Control1101214004;"Dimensions FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Table ID"=CONST(74032),
                              "No."=FIELD("No.");
            }
            systempart(Control1101214000;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            part(MaintenanceAssetPicture;"MCH Maintenance Asset Picture")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Asset)
            {
                Caption = 'Asset';
                action("Maintenance Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maintenance Tasks';
                    Image = ServiceTasks;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "MCH Asset Maint. Task List";
                    RunPageLink = "Asset No."=FIELD("No.");
                }
                action("Usage Monitors")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitors';
                    Image = Capacity;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "MCH Asset Usage Monitors";
                    RunPageLink = "Asset No."=FIELD("No.");
                }
                action(Attachments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocumentAttachments;
                    end;
                }
                action(WorkInstructions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Instructions';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "MCH Work Instrution Setup";
                    RunPageLink = Code=FIELD("No.");
                    RunPageView = SORTING("Table Name",Code,"Work Instruction No.")
                                  WHERE("Table Name"=CONST(Asset));
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=CONST(74032),
                                  "No."=FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "MCH Maint. Asset Entry Stat.";
                    RunPageLink = "No."=FIELD("No.");
                }
                action("Asset Structure")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Structure';
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "MCH Maint. Asset Struct. List";
                    ToolTip = 'View the maintenance asset structure.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "MCH Maint. Comment Sheet";
                    RunPageLink = "No."=FIELD("No.");
                    RunPageView = WHERE("Table Name"=CONST("Maint. Asset"));
                }
            }
            group(History)
            {
                Caption = 'History';
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("AM Structure Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Structure Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "MCH AM Structure Ledg. Entries";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.","Posting Date");
                }
                action("Usage Monitor Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitor Entries';
                    Image = CapacityLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "MCH Usage Monitor Entries";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.","Monitor Code","Reading Date","Reading Time");
                }
                action("Finished Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Finished Work Orders';
                    Image = PostedServiceOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.")
                                  WHERE(Status=CONST(Finished));
                }
            }
            group("Work Order")
            {
                Caption = 'Work Order';
                action("Work Order Requests")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Order Requests';
                    Image = ServiceLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.")
                                  WHERE(Status=CONST(Request));
                }
                action("Planned Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Planned Work Orders';
                    Image = ServiceLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.")
                                  WHERE(Status=CONST(Planned));
                }
                action("Released Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Released Work Orders';
                    Image = ServiceLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.")
                                  WHERE(Status=CONST(Released));
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Create New Work Order")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create New Work Order';
                    Ellipsis = true;
                    Image = NewOrder;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction()
                    var
                        CreateWorkOrder: Report "MCH Create Work Order";
                    begin
                        if "No." = '' then
                          exit;
                        CreateWorkOrder.SetMANo("No.");
                        CreateWorkOrder.RunModal;
                    end;
                }
                action("Maintenance Forecast")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Maint. Forecast';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction()
                    begin
                        Rec.ShowMaintForecastOverview;
                    end;
                }
                action("Calculate Scheduled Maintenance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calc. Scheduled Maintenance';
                    Ellipsis = true;
                    Image = MachineCenterCalendar;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction()
                    var
                        MaintAsset: Record "MCH Maintenance Asset";
                        CalcScheduledMaint: Report "MCH Calc Scheduled Maint.";
                    begin
                        MaintAsset.Get("No.");
                        MaintAsset.SetRecFilter;
                        CalcScheduledMaint.SetTableView(MaintAsset);
                        CalcScheduledMaint.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableControls;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if GuiAllowed then begin
          EnableControls;
        end;
    end;

    trigger OnOpenPage()
    begin
        EnableControls;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        HasSetup: Boolean;
        [InDataSet]
        CategoryCodeMandatory: Boolean;
        [InDataSet]
        MaintLocationCodeMandatory: Boolean;
        [InDataSet]
        RespGroupCodeMandatory: Boolean;
        [InDataSet]
        AssetMaintTaskFactboxVisible: Boolean;

    local procedure EnableControls()
    begin
        GetSetup;
        if ("No." <> '') then begin
          CalcFields("No. of Maintenance Tasks");
          AssetMaintTaskFactboxVisible := ("No. of Maintenance Tasks" > 0);
        end else
          AssetMaintTaskFactboxVisible := false;

        CategoryCodeMandatory := AMSetup."Asset Category Mandatory";
        RespGroupCodeMandatory := AMSetup."Asset Resp. Group Mandatory";
        MaintLocationCodeMandatory := AMSetup."Asset Fixed Maint. Loc. Mand.";
    end;

    local procedure GetSetup()
    begin
        if HasSetup then
          exit;
        AMSetup.Get;
        HasSetup := true;
    end;
}

