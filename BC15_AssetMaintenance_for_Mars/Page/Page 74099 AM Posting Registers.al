page 74099 "MCH AM Posting Registers"
{
    Caption = 'Asset Maint. Posting Registers';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entries';
    SourceTable = "MCH AM Posting Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Creation Time";"Creation Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Entries)
            {
                Caption = 'Entries';
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ShowAMLedgEntries;
                    end;
                }
            }
        }
    }
}

