page 74117 "MCH Maintenance Team Card"
{
    Caption = 'Maintenance Team Card';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Team,Periodic Activities';
    SourceTable = "MCH Maintenance Team";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        Get(Code);
                    end;
                }
                group(Control1101214003)
                {
                    ShowCaption = false;
                    field("Direct Unit Cost";"Direct Unit Cost")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Indirect Cost %";"Indirect Cost %")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Unit Cost";"Unit Cost")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    field("No. of Team Members";"No. of Team Members")
                    {
                        ApplicationArea = Basic,Suite;
                        Visible = false;
                    }
                    field(Blocked;Blocked)
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
            }
            part(TeamMembers;"MCH Maintenance Team Sub")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Team Members';
                SubPageLink = "Maint. Team Code"=FIELD(Code);
            }
        }
        area(factboxes)
        {
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214002;Notes)
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
                    AMCostCalcMgt: Codeunit "MCH AM Cost Mgt.";
                begin
                    if Code = '' then
                      exit;
                    CalcFields("No. of Team Members");
                    TestField("No. of Team Members");
                    AMCostCalcMgt.CalcMaintTeamRolledUpMemberCost(Rec,true,true);
                end;
            }
        }
    }
}

