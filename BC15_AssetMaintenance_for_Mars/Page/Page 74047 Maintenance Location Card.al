page 74047 "MCH Maintenance Location Card"
{
    Caption = 'Maintenance Location Card';
    PageType = Card;
    SourceTable = "MCH Maintenance Location";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control1101214006)
                {
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
                    }
                    field("Address 2";"Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Post Code";"Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Post Code/City';
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field(County;County)
                    {
                        ApplicationArea = Basic,Suite;
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
                }
                group(Control1101214005)
                {
                    ShowCaption = false;
                    field("No. of Assets";"No. of Assets")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("No. of Work Orders";"No. of Work Orders")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Def. Invt. Location Code";"Def. Invt. Location Code")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214008;"Dimensions FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Table ID"=CONST(74035),
                              "No."=FIELD(Code);
            }
            part(Control1101214007;"MCH Maint. Location Logo FactB")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Code=FIELD(Code);
            }
            systempart(Control1101214003;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214002;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Location)
            {
                Caption = 'Location';
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=CONST(74035),
                                  "No."=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }

    var
        Mail: Codeunit Mail;
}

