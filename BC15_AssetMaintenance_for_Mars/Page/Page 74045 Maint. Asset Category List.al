page 74045 "MCH Maint. Asset Category List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Category List';
    PageType = List;
    SourceTable = "MCH Maint. Asset Category";
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
            systempart(Control1101214001;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214000;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }


    procedure GetSelectionFilter(): Text
    var
        MACategory: Record "MCH Maint. Asset Category";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MACategory);
        exit(PageFilterHelper.GetSelectionFilterForMACategory(MACategory));
    end;
}

