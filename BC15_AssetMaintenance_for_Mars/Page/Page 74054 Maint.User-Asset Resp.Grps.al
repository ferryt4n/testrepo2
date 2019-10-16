page 74054 "MCH Maint.User-Asset Resp.Grps"
{
    Caption = 'Maint. User-Asset Responsibility Groups';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Maint. User-Asset Resp.Grp";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Maint. User ID";"Maint. User ID")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resp. Group Code";"Resp. Group Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("User Default";"User Default")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Resp. Group Description";"Resp. Group Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
    }
}

