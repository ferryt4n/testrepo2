page 74063 "MCH Planned Work Order Sub"
{
    AutoSplitKey = true;
    Caption = 'Planned Work Order Line Subf.';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Work Order Line";
    SourceTableView = WHERE(Status=FILTER(Planned));

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

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow;
                        CurrPage.Update(true);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    Visible = AllowMultipleLines;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    Visible = AllowMultipleLines;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Task Description";"Task Description")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                }
                field("Task Trigger Method";"Task Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = "Task Code"='';
                }
                field("Task Scheduled Date";"Task Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                }
                field("Task Scheduled Usage Value";"Task Scheduled Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo AND IsUsageTask;
                    Enabled = NOT IsBlankAssetNo AND IsUsageTask;
                }
                field("Expected Duration (Hours)";"Expected Duration (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                }
                field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3;ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible3;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3,ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4;ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible4;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4,ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5;ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible5;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5,ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6;ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible6;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6,ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7;ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible7;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7,ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8;ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    Editable = NOT IsBlankAssetNo;
                    Enabled = NOT IsBlankAssetNo;
                    QuickEntry = false;
                    Visible = DimVisible8;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8,ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
            group(LineActionGroup)
            {
                Caption = 'Line';
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
                action(LineDimensions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDims;
                    end;
                }
                action(LineComments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.ShowCommentLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateEditableOnRow;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
        UpdateEditableOnRow;
        Priority := AMSetup."Def. Work Order Priority";
    end;

    trigger OnOpenPage()
    begin
        AMSetup.Get;
        AllowMultipleLines := not (AMSetup."Work Order Line Restriction" = AMSetup."Work Order Line Restriction"::"Single Line Only");
        SetDimensionsVisibility;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        [InDataSet]
        AllowMultipleLines: Boolean;
        ShortcutDimCode: array [8] of Code[20];
        IsBlankAssetNo: Boolean;
        [InDataSet]
        IsUsageTask: Boolean;
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;

    local procedure UpdateEditableOnRow()
    begin
        IsBlankAssetNo := ("Asset No." = '');
        IsUsageTask := "Task Trigger Method" in ["Task Trigger Method"::"Fixed Usage","Task Trigger Method"::"Usage (Recurring)"];
    end;

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

