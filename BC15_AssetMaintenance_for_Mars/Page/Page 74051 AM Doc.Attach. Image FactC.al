page 74051 "MCH AM Doc.Attach. Image FactC"
{
    Caption = 'Image Preview';
    Editable = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "MCH AM Document Attachment";

    layout
    {
        area(content)
        {
            group(Control1101214002)
            {
                ShowCaption = false;
                Visible = EnableImagePreview;
                field("Attachment Content";"Attachment Content")
                {
                    ApplicationArea = Basic,Suite;
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableImagePreview := ("File Type" = "File Type"::Image);
    end;

    var
        [InDataSet]
        EnableImagePreview: Boolean;
}

