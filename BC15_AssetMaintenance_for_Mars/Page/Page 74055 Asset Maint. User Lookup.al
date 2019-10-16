page 74055 "MCH Asset Maint. User Lookup"
{
    Caption = 'Asset Maintenance Users';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance User";

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
                    StyleExpr = StyleTxt;
                }
                field("Default Resp. Group Code";"Default Resp. Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Change WO Status to Planned";"Change WO Status to Planned")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Change WO Status to Released";"Change WO Status to Released")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Change WO Status to Finished";"Change WO Status to Finished")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Reopen Finished WO to Released";"Reopen Finished WO to Released")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Allow Cancel Usage Mon. Entry";"Allow Cancel Usage Mon. Entry")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
                ToolTip = 'Open the Maintenance User List page showing all possible columns.';

                trigger OnAction()
                var
                    AssetMaintUserList: Page "MCH Asset Maint. User List";
                begin
                    AssetMaintUserList.SetRecord(Rec);
                    AssetMaintUserList.LookupMode := true;
                    if AssetMaintUserList.RunModal = ACTION::LookupOK then begin
                      AssetMaintUserList.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxtForRespGroupView;
    end;

    var
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

