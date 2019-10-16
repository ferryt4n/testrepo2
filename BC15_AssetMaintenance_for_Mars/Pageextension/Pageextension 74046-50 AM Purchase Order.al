pageextension 74046 "MCH-AM Purchase Order" extends "Purchase Order"
{
    actions
    {
        addlast("F&unctions")
        {
            action(MCHAMGetWorkOrderPurchaseLines)
            {
                Caption = 'Get Work Order Purch. Lines';
                ToolTip = 'Open a wizard that will assist you adding purchase line(s) based on work order budget lines.';
                Ellipsis = true;
                ApplicationArea = Suite;
                Promoted = true;
                PromotedCategory = Process;
                Image = SuggestLines;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    MaintPurchaseWizard: page "MCH AM Purchase Wizard";
                begin
                    IF "No." = '' THEN
                        EXIT;
                    PurchHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchHeader);
                    MaintPurchaseWizard.SetCalledFromPurchDocument(PurchHeader);
                    MaintPurchaseWizard.RUNMODAL;
                end;
            }
        }
    }
}