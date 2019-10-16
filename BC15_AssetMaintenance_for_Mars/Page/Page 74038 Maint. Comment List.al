page 74038 "MCH Maint. Comment List"
{
    Caption = 'Maint. Comment List';
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "MCH AM Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Modified By";"Modified By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Modified Date-Time";"Modified Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
    }
}

