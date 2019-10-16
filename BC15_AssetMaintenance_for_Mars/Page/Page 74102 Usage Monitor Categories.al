page 74102 "MCH Usage Monitor Categories"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Usage Monitor Categories';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "MCH Usage Monitor Category";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Monitors";"No. of Monitors")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214002;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }
}

