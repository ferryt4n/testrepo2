page 74210 "MCH Released WO Ongoing FactB"
{
    Caption = 'Work Order - Ongoing';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "MCH Work Order Header";
    SourceTableView = WHERE(Status=FILTER(Released));

    layout
    {
        area(content)
        {
            cuegroup(Control1101214000)
            {
                ShowCaption = false;
                field("No. of Purch. Order Lines";"No. of Purch. Order Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Order Lines';
                }
                field("No. of Maint. Invt. Jnl. Lines";"No. of Maint. Invt. Jnl. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maint. Invt. Journal Lines';
                }
                field("No. of Maint. Tmsh. Jnl. Lines";"No. of Maint. Tmsh. Jnl. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maint. Timesheet Jnl. Lines';
                }
            }
        }
    }

    actions
    {
    }
}

