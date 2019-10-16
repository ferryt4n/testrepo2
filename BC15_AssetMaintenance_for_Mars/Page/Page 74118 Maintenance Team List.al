page 74118 "MCH Maintenance Team List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maintenance Team List';
    CardPageID = "MCH Maintenance Team Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Team,Periodic Activities';
    RefreshOnActivate = true;
    SourceTable = "MCH Maintenance Team";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Code";
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Team Members";"No. of Team Members")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214002;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214000;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Units of Measure")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Units of Measure';
                Image = UnitOfMeasure;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "MCH Maint. Units of Measure";
                RunPageLink = "Table Name"=CONST(Team),
                              Code=FIELD(Code);
                ToolTip = 'View or edit the time based units of measure that are set up for the maintenace team.';
            }
            action("Co&mments")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "MCH Maint. Comment Sheet";
                RunPageLink = "Table Name"=CONST(Team),
                              "No."=FIELD(Code);
            }
            action(CalculateRolledUpCost)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Calculate Rolled-up Cost';
                Ellipsis = true;
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'Calculate the unit cost of the Maint. Team by rolling up the unit cost of each Resource Team Member. The unit cost of the team should equal the total of the unit costs of its members.';

                trigger OnAction()
                var
                    SelectedMaintTeam: Record "MCH Maintenance Team";
                    MaintTeam: Record "MCH Maintenance Team";
                    AMCostCalcMgt: Codeunit "MCH AM Cost Mgt.";
                    RollUpMemberCostQst: Label 'Do you want to calculate the rolled-up member costs for the selected Maintenance Team(s) ?';
                begin
                    if (Code = '') then
                      exit;
                    CurrPage.SetSelectionFilter(SelectedMaintTeam);
                    if SelectedMaintTeam.FindFirst then begin
                      if not Confirm(RollUpMemberCostQst,false) then
                        exit;
                      SelectedMaintTeam.FindSet;
                      repeat
                        MaintTeam.Get(SelectedMaintTeam.Code);
                        AMCostCalcMgt.CalcMaintTeamRolledUpMemberCost(MaintTeam,true,false);
                      until SelectedMaintTeam.Next = 0;
                    end;
                end;
            }
        }
    }
}

