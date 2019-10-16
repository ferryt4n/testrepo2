page 74089 "MCH Work Instr. Categories"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Work Instruction Categories';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "MCH Work Instruction Category";
    UsageCategory = Lists;

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
                field("No. of Work Instructions";"No. of Work Instructions")
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

