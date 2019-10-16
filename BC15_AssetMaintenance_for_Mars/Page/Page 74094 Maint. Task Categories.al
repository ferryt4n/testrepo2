page 74094 "MCH Maint. Task Categories"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maintenance Task Categories';
    PageType = List;
    SourceTable = "MCH Maintenance Task Category";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Master Tasks";"No. of Master Tasks")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214007;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214006;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }
}

