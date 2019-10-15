page 50100 test
{

    PageType = List;
    SourceTable = Customer;
    Caption = 'Ini Fork Test';
    ApplicationArea = Basic;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Style = Ambiguous;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Caption', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                begin
                    Message('test');
                end;
            }
        }
    }
}
