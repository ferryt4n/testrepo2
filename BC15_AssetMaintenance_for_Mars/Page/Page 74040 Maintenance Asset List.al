page 74040 "MCH Maintenance Asset List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maintenance Asset List';
    CardPageID = "MCH Maintenance Asset Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Asset,History,Work Order,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Maintenance Asset";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a (fixed) Responsibility Group that always must be used on work orders. The assigned Responsibility Group is also used to limit viewing/processing by Maint. Users that are setup with Resp. Group view limitations. ';
                }
                field("Fixed Maint. Location Code";"Fixed Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a fixed Maintenance Location that always must be used on work orders.';
                }
                field(Make;Make)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Model;Model)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Registration No.";"Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Manufacturer Code";"Manufacturer Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Vendor No.";"Vendor No.")
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
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Posting Group that is used on posting of resource/team maintenance timesheets.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group that is used on issue/return posting of maintenance inventory.';
                }
                field("Fixed Asset No.";"Fixed Asset No.")
                {
                    AccessByPermission = TableData "Fixed Asset"=R;
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Is Parent";"Is Parent")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Parent Asset No.";"Parent Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Manufacturers Part No.";"Manufacturers Part No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Original Part No.";"Original Part No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Def. Invt. Location Code";"Def. Invt. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Fixed Asset Description";"Fixed Asset Description")
                {
                    AccessByPermission = TableData "Fixed Asset"=R;
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created By";"Created By")
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
            }
        }
        area(factboxes)
        {
            part(Control1101214039;"MCH Asset - Ongoing FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=FIELD("No.");
            }
            part(Control1101214038;"MCH Asset - Maint. Task FactBL")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("No.");
            }
            part(Control1101214011;"MCH Asset Usage Monitor FactBL")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("No.");
            }
            part(Control1101214012;"Dimensions FactBox")
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=CONST(74032),
                                      "No."=FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action(DimensionsMultiple)
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            MA: Record "MCH Maintenance Asset";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(MA);
                            DefaultDimMultiple.SetMultiRecord(MA,FieldNo("No."));
                            DefaultDimMultiple.RunModal;
                        end;
                    }
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

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxt;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(2);
    end;

    var
        [InDataSet]
        StyleTxt: Text;


    procedure SetSelection(var MA: Record "MCH Maintenance Asset")
    begin
        CurrPage.SetSelectionFilter(MA);
    end;


    procedure GetSelectionFilter(): Text
    var
        MA: Record "MCH Maintenance Asset";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MA);
        exit(PageFilterHelper.GetSelectionFilterForMaintAsset(MA));
    end;
}

