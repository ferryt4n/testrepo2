page 74086 "MCH Work Instruction List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Work Instruction List';
    CardPageID = "MCH Work Instruction Card";
    Editable = false;
    PageType = List;
    SourceTable = "MCH Work Instruction Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Unfavorable;
                    StyleExpr = Blocked;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Maint. Assets";"No. of Maint. Assets")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        ShowUsedByMaintAssets;
                    end;
                }
                field("No. of Master Maint. Tasks";"No. of Master Maint. Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        ShowUsedByMasterMaintTasks;
                    end;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214004;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214002;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(WhereUsed)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Where-Used List';
                Image = Track;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ShowWhereUsed(0);
                end;
            }
        }
    }
}

