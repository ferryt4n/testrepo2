page 74046 "MCH Maint. Asset Cat. Lookup"
{
    Caption = 'Asset Categories';
    Editable = false;
    PageType = List;
    SourceTable = "MCH Maint. Asset Category";

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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(AdvancedView)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the Asset Category List page showing all possible columns.';

                trigger OnAction()
                var
                    MAssetCategoryList: Page "MCH Maint. Asset Category List";
                begin
                    MAssetCategoryList.SetRecord(Rec);
                    MAssetCategoryList.LookupMode := true;
                    if MAssetCategoryList.RunModal = ACTION::LookupOK then begin
                      MAssetCategoryList.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
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

