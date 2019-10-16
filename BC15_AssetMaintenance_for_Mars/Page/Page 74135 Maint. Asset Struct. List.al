page 74135 "MCH Maint. Asset Struct. List"
{
    Caption = 'Asset Structure List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions,History';
    SourceTable = "MCH Maintenance Asset";
    SourceTableView = SORTING("Structure Position ID");

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                IndentationColumn = AssetStructureLevel;
                IndentationControls = Description;
                ShowAsTree = true;
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        ShowCard;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = DescriptionStyleTxt;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Fixed Maint. Location Code";"Fixed Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
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
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Fixed Asset No.";"Fixed Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Is Parent";"Is Parent")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("Parent Asset No.";"Parent Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Description 2";"Description 2")
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
                field("Def. Invt. Location Code";"Def. Invt. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Fixed Asset Description";"Fixed Asset Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
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
                field("Structure ID";"Structure ID")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Structure Level";"Structure Level")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Structure Position ID";"Structure Position ID")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214038;"Dimensions FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Table ID"=CONST(74032),
                              "No."=FIELD("No.");
                Visible = false;
            }
            systempart(Control1101214037;Links)
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
            }
            systempart(Control1101214036;Notes)
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
            group(Functions)
            {
                Caption = 'Functions';
                action(UpdateMAStructureDisplayOrder)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Update Display Order';
                    Ellipsis = true;
                    Image = CalculateHierarchy;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        UpdateMAStructureDisplayOrder: Report "MCH Update MA Struc.Disp.Order";
                    begin
                        UpdateMAStructureDisplayOrder.RunModal;
                        if UpdateMAStructureDisplayOrder.StructureSortingWasRun then
                          CurrPage.Update(false);
                    end;
                }
            }
        }
        area(navigation)
        {
            group(History)
            {
                Caption = 'History';
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("AM Structure Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Structure Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH AM Structure Ledg. Entries";
                    RunPageLink = "Asset No."=FIELD("No.");
                    RunPageView = SORTING("Asset No.","Posting Date");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AssetStructureLevel := "Structure Level";
        Emphasize := "Is Parent";
        DescriptionStyleTxt := '';
        case true of
          "Is Parent":
            DescriptionStyleTxt := 'Strong';
          Blocked:
            DescriptionStyleTxt := 'Unfavorable';
        end;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(99);
        SetAutoCalcFields("Is Parent");
    end;

    var
        Emphasize: Boolean;
        AssetStructureLevel: Integer;
        [InDataSet]
        DescriptionStyleTxt: Text;
}

