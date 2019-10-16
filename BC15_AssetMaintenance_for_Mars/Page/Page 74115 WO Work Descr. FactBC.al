page 74115 "MCH WO Work Descr. FactBC"
{
    Caption = 'Work Description';
    Editable = false;
    PageType = CardPart;
    SourceTable = "MCH Work Order Header";

    layout
    {
        area(content)
        {
            group(Control1101214001)
            {
                ShowCaption = false;
                field(WorkDescription;WorkDescription)
                {
                    ApplicationArea = Basic,Suite;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the extended work order description';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        WorkDescription := GetWorkDescription;
    end;

    var
        WorkDescription: Text;
}

