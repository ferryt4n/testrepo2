page 74109 "MCH Usage Journal"
{
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Usage Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Registering,Data,Page';
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "MCH Usage Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    AMJnlMgt.UsageLookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    AMJnlMgt.UsageCheckName(CurrentJnlBatchName, Rec);
                    CurrPage.SaveRecord;
                    AMJnlMgt.UsageSetName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Reading Date"; "Reading Date")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                }
                field("Reading Time"; "Reading Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Asset No."; "Asset No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Monitor Code"; "Monitor Code")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Reading Value"; "Reading Value")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                }
                field("Closing Meter Reading"; "Closing Meter Reading")
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                }
                field("Identifier Code"; "Identifier Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Reading Date-Time"; "Reading Date-Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    QuickEntry = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214018; "MCH Asset Usage Monitor FactBC")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Asset No." = FIELD("Asset No."),
                              "Monitor Code" = FIELD("Monitor Code");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Maint. Asset")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Maint. Asset';
                Image = ServiceItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "MCH Maintenance Asset Card";
                RunPageLink = "No." = FIELD("Asset No.");
                ShortCutKey = 'Shift+F7';
            }
            action(ShowUsageMonitor)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage Monitor';
                Image = Capacity;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MAUsageMonitor: Record "MCH Asset Usage Monitor";
                begin
                    if MAUsageMonitor.Get("Asset No.", "Monitor Code") then
                        MAUsageMonitor.ShowCard;
                end;
            }
            action(ShowUsageEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage E&ntries';
                Image = CapacityLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+F7';

                trigger OnAction()
                var
                    MAUsageMonitor: Record "MCH Asset Usage Monitor";
                begin
                    if MAUsageMonitor.Get("Asset No.", "Monitor Code") then
                        MAUsageMonitor.ShowUsageEntries;
                end;
            }
        }
        area(processing)
        {
            group("&Registering")
            {
                Caption = '&Registering';
                action(Register)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Register';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"MCH Usage Jnl.-Register", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Page")
            {
                Caption = 'Page';
                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Send the data in the journal to an Excel file for analysis or editing.';
                    Visible = IsSaasExcelAddinEnabled;

                    trigger OnAction()
                    var
                        ODataUtility: Codeunit ODataUtility;
                    begin
                        ODataUtility.EditJournalWorksheetInExcel(CurrPage.Caption, CurrPage.ObjectId(false), "Journal Batch Name", "Journal Template Name");
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        IsSaasExcelAddinEnabled := AMJnlMgt.IsSaasExcelAddinEnabled;
        if ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 then
            exit;

        if IsOpenedFromBatch then begin
            CurrentJnlBatchName := "Journal Batch Name";
            AMJnlMgt.UsageOpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        AMJnlMgt.UsageTemplateSelection(PAGE::"MCH Usage Journal", 0, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        AMJnlMgt.UsageOpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        ClientTypeManagement: Codeunit "Client Type Management";
        CurrentJnlBatchName: Code[10];
        IsSaasExcelAddinEnabled: Boolean;
}

