page 74185 "MCH Ongoing WO Lines"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Ongoing Work Order Lines';
    DataCaptionFields = Status,"Work Order No.","Asset No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "MCH Work Order Line";
    SourceTableView = WHERE(Status=FILTER(Request..Released));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Asset No.";
                ShowCaption = false;
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
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
                field("Work Order Description";"Work Order Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Description";"Task Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Duration (Hours)";"Expected Duration (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Task Trigger Method";"Task Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = "Task Code"='';
                }
                field("Task Scheduled Date";"Task Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Scheduled Usage Value";"Task Scheduled Usage Value")
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
                field("Maint. Location Code";"Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Completion Date";"Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage on Completion";"Usage on Completion")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Def. Invt. Location Code";"Def. Invt. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    QuickEntry = false;
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    QuickEntry = false;
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3;ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    QuickEntry = false;
                    Visible = DimVisible3;
                }
                field(ShortcutDimCode4;ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    QuickEntry = false;
                    Visible = DimVisible4;
                }
                field(ShortcutDimCode5;ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    QuickEntry = false;
                    Visible = DimVisible5;
                }
                field(ShortcutDimCode6;ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    QuickEntry = false;
                    Visible = DimVisible6;
                }
                field(ShortcutDimCode7;ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    QuickEntry = false;
                    Visible = DimVisible7;
                }
                field(ShortcutDimCode8;ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    QuickEntry = false;
                    Visible = DimVisible8;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
            group("Work Order")
            {
                Caption = 'Work Order';
                part(Control1101214012;"MCH Ongoing WO Lines Sub")
                {
                    ApplicationArea = Basic,Suite;
                    ShowFilter = false;
                    SubPageLink = Status=FIELD(Status),
                                  "No."=FIELD("Work Order No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Work Order")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Work Order';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    WorkOrder: Record "MCH Work Order Header";
                begin
                    WorkOrder.Get(Status,"Work Order No.");
                    WorkOrder.ShowCard;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(2);
        SetDimensionsVisibility;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        ShortcutDimCode: array [8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1,DimVisible2,DimVisible3,DimVisible4,DimVisible5,DimVisible6,DimVisible7,DimVisible8);
        Clear(DimMgt);
    end;
}

