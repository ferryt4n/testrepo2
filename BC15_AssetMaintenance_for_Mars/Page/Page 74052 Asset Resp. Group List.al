page 74052 "MCH Asset Resp. Group List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Responsibility Group List';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Responsibility Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Code";
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsible User ID";"Responsible User ID")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Assets";"No. of Assets")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Users with Filter View";"No. of Users with Filter View")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214007;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214008;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MaintUserFilterSetup)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Maint. User Filter Setup';
                Ellipsis = true;
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    UserAssetRespGrpSetup: Page "MCH User-Asset Resp.Grp Setup";
                begin
                    if Code = '' then
                      exit;
                    UserAssetRespGrpSetup.SetCalledFromAssetRespGrpCode(Code);
                    UserAssetRespGrpSetup.RunModal;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then
          CurrPage.Editable(false);

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

