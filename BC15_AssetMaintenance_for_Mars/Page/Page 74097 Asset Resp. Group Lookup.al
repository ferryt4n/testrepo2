page 74097 "MCH Asset Resp. Group Lookup"
{
    Caption = 'Asset Responsibility Groups';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Responsibility Group";

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
                ToolTip = 'Open the Asset Responsibility Group List page showing all possible columns.';

                trigger OnAction()
                var
                    AssetResponsibilityGrps: Page "MCH Asset Resp. Group List";
                begin
                    AssetResponsibilityGrps.SetRecord(Rec);
                    AssetResponsibilityGrps.LookupMode := true;
                    if AssetResponsibilityGrps.RunModal = ACTION::LookupOK then begin
                      AssetResponsibilityGrps.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(0);
    end;


    procedure GetSelectionFilter(): Text
    var
        AssetResponsibilityGroup: Record "MCH Asset Responsibility Group";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(AssetResponsibilityGroup);
        exit(PageFilterHelper.GetSelectionFilterForAssetResponsibilityGroup(AssetResponsibilityGroup));
    end;
}

