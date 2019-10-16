page 74187 "MCH AM Structure Ledg. Entries"
{
    ApplicationArea = Basic,Suite;
    Caption = 'AM Structure Ledger Entries';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry,Related Entries';
    SourceTable = "MCH AM Structure Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Source Asset No.";
                ShowCaption = false;
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Source Asset No.";"Source Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting Entry Type";"Posting Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Description";"Asset Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Source Asset Description";"Source Asset Description")
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
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Hours;Hours)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Location Code";"Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Dimension Set ID";"Dimension Set ID")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("AM Ledger Entry No.";"AM Ledger Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Structure Level";"Asset Structure Level")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting Date-Time";"Posting Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Entry';
                Image = Entry;
                action("AM Ledger Entry")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entry';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Entry No."=FIELD("AM Ledger Entry No.");
                    RunPageView = SORTING("Work Order No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(SetDimensionFilter)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Set Dimension Filter';
                    Ellipsis = true;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Limit the entries according to the dimension filters that you specify. NOTE: If you use a high number of dimension combinations, this function may not work and can result in a message that the SQL server only supports a maximum of 2100 parameters.';

                    trigger OnAction()
                    begin
                        SetFilter("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                    end;
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not CurrPage.LookupMode then
          if FindLast then ;
    end;

    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
}

