page 74058 "MCH Work Order Comment List"
{
    Caption = 'Work Order Comment List';
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "MCH Work Order Comment Line";

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
                field("Last Modified By";"Last Modified By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
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

