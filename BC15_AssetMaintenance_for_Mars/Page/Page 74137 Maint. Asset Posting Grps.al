page 74137 "MCH Maint. Asset Posting Grps"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Posting Groups';
    PageType = List;
    SourceTable = "MCH Maint. Asset Posting Group";
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
                field("No. of Assets";"No. of Assets")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
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
        area(processing)
        {
            action("Posting &Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Posting &Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "MCH AM Posting Setup";
                RunPageLink = "Asset Posting Group"=FIELD(Code);
            }
        }
    }
}

