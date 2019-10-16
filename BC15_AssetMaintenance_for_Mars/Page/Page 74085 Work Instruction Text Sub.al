page 74085 "MCH Work Instruction Text Sub"
{
    AutoSplitKey = true;
    Caption = 'Text Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "MCH Work Instruction Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Text;Text)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
    }
}

