page 74131 "MCH AM Plan. Wksh. Templ. List"
{
    Caption = 'Maint. Planning Wksh. Template List';
    Editable = false;
    PageType = List;
    SourceTable = "MCH AM Planning Wksh. Templ.";

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

