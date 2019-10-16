page 74107 "MCH Usage Jnl. Templ. List"
{
    Caption = 'Usage Journal Template List';
    Editable = false;
    PageType = List;
    SourceTable = "MCH Usage Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
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

