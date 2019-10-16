page 74106 "MCH Usage Jnl. Templates"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Usage Journal Templates';
    PageType = List;
    SourceTable = "MCH Usage Journal Template";
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
        area(factboxes)
        {
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
            }
            systempart(Control1101214000;Notes)
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
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
                Image = Template;
                action(Batches)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "MCH Usage Jnl. Batches";
                    RunPageLink = "Journal Template Name"=FIELD(Name);
                    ToolTip = 'View or edit multiple journals for a specific template.';
                }
            }
        }
    }
}

