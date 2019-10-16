page 74173 "MCH AM Invt. Issue Wiz. Sub"
{
    Caption = 'Work Order Budget Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "MCH AM Invt. Issue Suggest Buf";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Budget Quantity";
                field(Selected;Selected)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if a purchase order line shall be created.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = SelectionStyleTxt;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = SelectionStyleTxt;
                }
                field("Quantity to Issue";"Quantity to Issue")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = SelectionStyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Remaining Budget Qty.";"Remaining Budget Qty.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Budget Quantity";"Budget Quantity")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Issued Quantity";"Issued Quantity")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnDrillDown()
                    begin
                        DrilldownAMLedgerEntry;
                    end;
                }
                field("Journal Line Quantity";"Journal Line Quantity")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnDrillDown()
                    begin
                        DrilldownMaintJnlLine;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Task Code";"Maint. Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Type";"Work Order Type")
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
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Budget Qty. (Base)";"Budget Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Quantity to Issue (Base)";"Quantity to Issue (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Issued Qty. (Base)";"Issued Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrilldownAMLedgerEntry;
                    end;
                }
                field("Journal Line Qty. (Base)";"Journal Line Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrilldownMaintJnlLine;
                    end;
                }
                field("Progress Status Code";"Progress Status Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Work Order Line No.";"Work Order Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Budget Line No.";"Budget Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select All Lines")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Select All Lines';
                Image = SelectLineToApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SetRange(Selected);
                    TempRecord := Rec;
                    if FindSet then
                      repeat
                        if (not Selected) then begin
                          Validate(Selected,true);
                          Modify;
                        end;
                      until Next = 0;
                    if Get(TempRecord."Entry No.") then ;
                    CurrPage.Update(false);
                end;
            }
            action("Unselect All Lines")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Unselect All Lines';
                Image = CancelLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SetRange(Selected);
                    TempRecord := Rec;
                    if FindSet then
                      repeat
                        if Selected then begin
                          Validate(Selected,false);
                          Modify;
                        end;
                      until Next = 0;
                    if Get(TempRecord."Entry No.") then ;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SelectionStyleTxt := GetSelectionStyleTxt;
    end;

    var
        TempRecord: Record "MCH AM Invt. Issue Suggest Buf" temporary;
        [InDataSet]
        SelectionStyleTxt: Text;


    procedure SetPageSourceTempRecords(var SuggestionBuffer: Record "MCH AM Invt. Issue Suggest Buf" temporary)
    begin
        Reset;
        Copy(SuggestionBuffer,true);
        if FindFirst then ;
    end;


    procedure GetSelectedLines(var SuggestionBuffer: Record "MCH AM Invt. Issue Suggest Buf" temporary)
    begin
        Reset;
        SuggestionBuffer.Copy(Rec,true);
    end;
}

