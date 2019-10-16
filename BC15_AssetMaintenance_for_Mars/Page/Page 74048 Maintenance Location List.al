page 74048 "MCH Maintenance Location List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Maintenance Location List';
    CardPageID = "MCH Maintenance Location Card";
    Editable = false;
    PageType = List;
    SourceTable = "MCH Maintenance Location";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Name;
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Name 2";"Name 2")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post Code/City';
                    Visible = false;
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(County;County)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Def. Invt. Location Code";"Def. Invt. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Assets";"No. of Assets")
                {
                    ApplicationArea = Basic,Suite;
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
            }
        }
        area(factboxes)
        {
            part(Control1101214014;"Dimensions FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Table ID"=CONST(74035),
                              "No."=FIELD(Code);
            }
            systempart(Control1101214002;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214001;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Location)
            {
                Caption = 'Location';
            }
        }
        area(navigation)
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                action(DimensionsSingle)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions-Single';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=CONST(74035),
                                  "No."=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                }
                action(DimensionsMultiple)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions-&Multiple';
                    Image = DimensionSets;
                    ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                    trigger OnAction()
                    var
                        MaintLocation: Record "MCH Maintenance Location";
                        DefaultDimMultiple: Page "Default Dimensions-Multiple";
                    begin
                        CurrPage.SetSelectionFilter(MaintLocation);
                        DefaultDimMultiple.SetMultiRecord(MaintLocation,FieldNo(Code));
                        DefaultDimMultiple.RunModal;
                    end;
                }
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        MaintenanceLocation: Record "MCH Maintenance Location";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MaintenanceLocation);
        exit(PageFilterHelper.GetSelectionFilterForMaintLocation(MaintenanceLocation));
    end;
}

