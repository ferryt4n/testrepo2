page 74125 "MCH Maint. Inventory Journal"
{
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Maintenance Inventory Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Page,Post/Print,Line,Item,Work Order,Functions';
    SaveValues = true;
    SourceTable = "MCH Maint. Journal Line";
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
                    AMJnlMgt.MaintLookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    AMJnlMgt.MaintCheckName(CurrentJnlBatchName, Rec);
                    CurrPage.SaveRecord;
                    AMJnlMgt.MaintSetName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;
            }
            repeater(Control1)
            {
                FreezeColumn = "Work Order Budget Line No.";
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Work Order No."; "Work Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                }
                field("Work Order Budget Line No."; "Work Order Budget Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Work Order Line No."; "Work Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                }
                field("Asset No."; "Asset No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = 'Issue,Return';
                    StyleExpr = IsReturnStyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item No.';
                    ShowMandatory = true;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if "Location Code" <> '' then
                            if (Type = Type::Item) and Item.Get("No.") then
                                Item.TestField(Type, Item.Type::Inventory);
                    end;
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    StyleExpr = IsReturnStyleTxt;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Amount"; "Unit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Resource No. (Issue/Return)"; "Resource No. (Issue/Return)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Asset Description"; "Asset Description")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("Maint. Location Code"; "Maint. Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Work Order Type"; "Work Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,3';
                    QuickEntry = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,4';
                    QuickEntry = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,5';
                    QuickEntry = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,6';
                    QuickEntry = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,7';
                    QuickEntry = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,2,8';
                    QuickEntry = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action("Item Card")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View the item card.';
                }
                action("Item Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected item.';
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(ShowAvailByEvent)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ShowItemAvailability(4);
                        end;
                    }
                    action(ShowAvailByDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';

                        trigger OnAction()
                        begin
                            ShowItemAvailability(0);
                        end;
                    }
                    action(ShowAvailByVariant)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ShowItemAvailability(1);
                        end;
                    }
                    action(ShowAvailByLocation)
                    {
                        AccessByPermission = TableData Location = R;
                        ApplicationArea = Location;
                        Caption = 'Location';
                        Image = Warehouse;
                        ToolTip = 'View the actual and projected quantity of the item per location.';

                        trigger OnAction()
                        begin
                            ShowItemAvailability(2);
                        end;
                    }
                }
            }
            group("Work O&rder")
            {
                Caption = 'Work O&rder';
                Image = "Order";
                action("Work Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Work Order';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "MCH Released Work Order";
                    RunPageLink = Status = CONST(Released),
                                  "No." = FIELD("Work Order No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("AM Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'AM Ledger E&ntries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Work Order No." = FIELD("Work Order No.");
                    RunPageView = SORTING("Work Order No.", Type)
                                  WHERE(Type = CONST(Item));
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Image = "Action";
                action(SuggestInventoryIssue)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suggest Inventory Issue';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Open a wizard that will assist creating issue journal lines based on the work order budget lines.';

                    trigger OnAction()
                    var
                        MaintJnlLine: Record "MCH Maint. Journal Line";
                        InventoryIssueWizard: Page "MCH AM Inventory Issue Wizard";
                    begin
                        MaintJnlLine.Copy(Rec);
                        InventoryIssueWizard.SetCalledFromIssueJournal(MaintJnlLine);
                        InventoryIssueWizard.RunModal;
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        AMPrintReport.PrintMaintJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"MCH Maint. Jnl.-Post", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"MCH Maint. Jnl.-Post+Print", Rec);
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
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
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

    trigger OnAfterGetCurrRecord()
    begin
        SetReturnStyleTxt;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        SetReturnStyleTxt;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Type = Type::" ") then
            Type := Type::Item;
        if (Type <> Type::Item) then
            Error(Text000, FieldCaption(Type), Type);
        if not ("Entry Type" in ["Entry Type"::Issue, "Entry Type"::Return]) then
            Error(Text000, FieldCaption("Entry Type"), "Entry Type");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        SetReturnStyleTxt;
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
            AMJnlMgt.MaintOpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        AMJnlMgt.MaintTemplateSelection(PAGE::"MCH Maint. Inventory Journal", 0, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        AMJnlMgt.MaintOpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        AMPrintReport: Codeunit "MCH AM Report Mgt.";
        ClientTypeManagement: Codeunit "Client Type Management";
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        IsSaasExcelAddinEnabled: Boolean;
        Text000: Label 'You cannot use %1 = %2 in this journal.';
        IsReturnStyleTxt: Text;

    local procedure SetReturnStyleTxt()
    begin
        IsReturnStyleTxt := '';
        if ("Entry Type" = "Entry Type"::Return) then
            IsReturnStyleTxt := 'Unfavorable';
    end;
}

