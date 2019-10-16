page 74130 "MCH AM Plan. Wksh. Templates"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maint. Planning Wksh. Templates';
    PageType = List;
    SourceTable = "MCH AM Planning Wksh. Templ.";
    UsageCategory = Administration;

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
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                action(Batches)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Batches';
                    RunObject = Page "MCH AM Planning Wksh. Names";
                    RunPageLink = "Worksheet Template Name"=FIELD(Name);
                }
            }
        }
    }
}

