page 74084 "MCH Work Instruction Card"
{
    Caption = 'Work Instruction Card';
    PageType = ListPlus;
    SourceTable = "MCH Work Instruction Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                group(Control1101214002)
                {
                    ShowCaption = false;
                    field("No. of Maint. Assets";"No. of Maint. Assets")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            ShowUsedByMaintAssets;
                        end;
                    }
                    field("No. of Master Maint. Tasks";"No. of Master Maint. Tasks")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            ShowUsedByMasterMaintTasks;
                        end;
                    }
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
            }
            part(InstructionLines;"MCH Work Instruction Text Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Work Instruction No."=FIELD("No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1101214003;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214004;Links)
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

    trigger OnDeleteRecord(): Boolean
    begin
        exit(ConfirmInUseManualDeletion);
    end;
}

