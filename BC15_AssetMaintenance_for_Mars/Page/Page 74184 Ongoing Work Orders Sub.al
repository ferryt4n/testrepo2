page 74184 "MCH Ongoing Work Orders Sub"
{
    Caption = 'Line';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Asset No.";
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
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
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Completion Date";"Completion Date")
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
                field("Usage on Completion";"Usage on Completion")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Duration (Hours)";"Expected Duration (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                {
                    ApplicationArea = Basic,Suite;
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
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MaintAsset)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Maint. Asset';
                Image = ServiceItem;

                trigger OnAction()
                var
                    MaintAsset: Record "MCH Maintenance Asset";
                begin
                    if MaintAsset.Get("Asset No.") then
                      MaintAsset.ShowCard;
                end;
            }
            action("AM Ledger Entries")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'AM Ledger Entries';
                Image = ServiceLedger;
                RunObject = Page "MCH AM Ledger Entries";
                RunPageLink = "Work Order No."=FIELD("Work Order No."),
                              "Work Order Line No."=FIELD("Line No.");
                RunPageView = SORTING("Work Order No.","Posting Date");
            }
            action(LineBudget)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Budget';
                Image = LedgerBudget;

                trigger OnAction()
                begin
                    Rec.ShowBudget;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    begin
        AMSetup.Get;
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

