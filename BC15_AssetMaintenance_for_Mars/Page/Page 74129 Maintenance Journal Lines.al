page 74129 "MCH Maintenance Journal Lines"
{
    Caption = 'Maintenance Journal Lines';
    Editable = false;
    PageType = List;
    SourceTable = "MCH Maint. Journal Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Entry Type";
                ShowCaption = false;
                field("Journal Template Name";"Journal Template Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Line No.";"Work Order Line No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Budget Line No.";"Work Order Budget Line No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Resource No. (Issue/Return)";"Resource No. (Issue/Return)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit Amount";"Unit Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(ShortcutDimCode3;ShortcutDimCode[3])
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4;ShortcutDimCode[4])
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5;ShortcutDimCode[5])
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6;ShortcutDimCode[6])
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7;ShortcutDimCode[7])
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8;ShortcutDimCode[8])
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8,ShortcutDimCode[8]);
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
                action("Show Batch")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Batch';
                    Image = ViewDescription;
                    ToolTip = 'Show the maintenance journal batch that the journal line is based on.';

                    trigger OnAction()
                    var
                        MaintJnlTemplate: Record "MCH Maint. Journal Template";
                        MaintJnlLine: Record "MCH Maint. Journal Line";
                    begin
                        if "Line No." = 0 then
                          exit;
                        MaintJnlTemplate.Get("Journal Template Name");
                        MaintJnlLine := Rec;
                        MaintJnlLine.FilterGroup(2);
                        MaintJnlLine.SetRange("Journal Template Name","Journal Template Name");
                        MaintJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                        MaintJnlLine.FilterGroup(0);
                        PAGE.Run(MaintJnlTemplate."Page ID",MaintJnlLine);
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        ShortcutDimCode: array [8] of Code[20];
}

