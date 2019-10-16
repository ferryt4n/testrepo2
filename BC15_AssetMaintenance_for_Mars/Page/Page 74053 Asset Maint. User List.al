page 74053 "MCH Asset Maint. User List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Maintenance User List';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance User";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "User ID";
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = "User Lookup";
                    ShowMandatory = true;
                }
                field("User Full Name";"User Full Name")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Default Maint. Location Code";"Default Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Resp. Group View";"Asset Resp. Group View")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = AssetRespGroupViewEditable;
                    StyleExpr = StyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Default Resp. Group Code";"Default Resp. Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("No. of Resp. Groups (Limited)";"No. of Resp. Groups (Limited)")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Change WO Status to Planned";"Change WO Status to Planned")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Change WO Status to Released";"Change WO Status to Released")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Change WO Status to Finished";"Change WO Status to Finished")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reopen Finished WO to Released";"Reopen Finished WO to Released")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Allow Cancel Usage Mon. Entry";"Allow Cancel Usage Mon. Entry")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AssetRespGroupFilterSetup)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Resp. Group Filter Setup';
                Ellipsis = true;
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    UserAssetRespGrpSetup: Page "MCH User-Asset Resp.Grp Setup";
                begin
                    if "User ID" = '' then
                      exit;
                    UserAssetRespGrpSetup.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        AssetRespGroupViewEditable := ("Asset Resp. Group View" = "Asset Resp. Group View"::Limited);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxtForRespGroupView;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetRange("Asset Resp. Group View");
        "Asset Resp. Group View" := "Asset Resp. Group View"::Unrestricted;
    end;

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then
          CurrPage.Editable(false);
    end;

    var
        [InDataSet]
        AssetRespGroupViewEditable: Boolean;
        [InDataSet]
        StyleTxt: Text;


    procedure GetSelectionFilter(): Text
    var
        MaintUser: Record "MCH Asset Maintenance User";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MaintUser);
        exit(PageFilterHelper.GetSelectionFilterForMaintUser(MaintUser));
    end;
}

