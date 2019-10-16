page 74123 "MCH Maint. Jnl. Template List"
{
    Caption = 'Maintenance Journal Template List';
    Editable = false;
    PageType = List;
    SourceTable = "MCH Maint. Journal Template";

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

