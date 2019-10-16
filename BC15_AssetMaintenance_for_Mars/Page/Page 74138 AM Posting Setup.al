page 74138 "MCH AM Posting Setup"
{
    ApplicationArea = Basic,Suite;
    Caption = 'AM Posting Setup';
    DataCaptionFields = "Asset Posting Group","Gen. Prod. Posting Group","Work Order Type";
    PageType = List;
    SourceTable = "MCH AM Posting Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Work Order Type";
                ShowCaption = false;
                field("Asset Posting Group";"Asset Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expense Account";"Expense Account")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource Account";"Resource Account")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Team Account";"Maint. Team Account")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214000;Notes)
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

