page 74039 "MCH Maintenance Asset Lookup"
{
    Caption = 'Maintenance Assets';
    CardPageID = "MCH Maintenance Asset Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Maint. Asset,History,Work Orders,Cat7,Cat8,Periodic Activities';
    RefreshOnActivate = true;
    SourceTable = "MCH Maintenance Asset";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                IndentationColumn = AssetStructureLevel;
                IndentationControls = Description;
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Make;Make)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Model;Model)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Registration No.";"Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Manufacturer Code";"Manufacturer Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Posting Group that is used on posting of resource/team maintenance timesheets.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group that is used on issue/return posting of maintenance inventory.';
                }
                field("Fixed Asset No.";"Fixed Asset No.")
                {
                    AccessByPermission = TableData "Fixed Asset"=R;
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a (fixed) Responsibility Group that always must be used on work orders. The assigned Responsibility Group is also used to limit viewing/processing by Maint. Users that are setup with Resp. Group view limitations. ';
                }
                field("Fixed Maint. Location Code";"Fixed Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a fixed Maintenance Location that always must be used on work orders.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Parent Asset No.";"Parent Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Manufacturers Part No.";"Manufacturers Part No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Original Part No.";"Original Part No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified By";"Last Modified By")
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
                ToolTip = 'Open the Maintenance Asset List page showing all possible columns.';

                trigger OnAction()
                var
                    MaintAssetList: Page "MCH Maintenance Asset List";
                begin
                    MaintAssetList.SetRecord(Rec);
                    MaintAssetList.LookupMode := true;
                    if MaintAssetList.RunModal = ACTION::LookupOK then begin
                      MaintAssetList.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if ShowAsStructure then
          AssetStructureLevel := "Structure Level";

        StyleTxt := GetStyleTxt;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(2);
        if ShowAsStructure then
          SetCurrentKey("Structure Position ID");
    end;

    var
        [InDataSet]
        StyleTxt: Text;
        ShowAsStructure: Boolean;
        [InDataSet]
        AssetStructureLevel: Integer;


    procedure GetSelectionFilter(): Text
    var
        MaintAsset: Record "MCH Maintenance Asset";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MaintAsset);
        exit(PageFilterHelper.GetSelectionFilterForMaintAsset(MaintAsset));
    end;


    procedure SetShowAsStructure(Set: Boolean)
    begin
        ShowAsStructure := Set;
    end;
}

