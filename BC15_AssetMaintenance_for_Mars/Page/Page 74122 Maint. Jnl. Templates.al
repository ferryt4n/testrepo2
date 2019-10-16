page 74122 "MCH Maint. Jnl. Templates"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maintenance Journal Templates';
    PageType = List;
    SourceTable = "MCH Maint. Journal Template";
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
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
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
                    RunObject = Page "MCH Maint. Jnl. Batches";
                    RunPageLink = "Journal Template Name"=FIELD(Name);
                    ToolTip = 'View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.';
                }
            }
        }
    }
}

