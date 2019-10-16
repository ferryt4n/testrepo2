page 74108 "MCH Usage Jnl. Batches"
{
    Caption = 'Usage Journal Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "MCH Usage Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Journal Template Name";"Journal Template Name")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Template Type";"Template Type")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Journal Lines";"No. of Journal Lines")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
            }
            systempart(Control1101214000;Notes)
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
            action("Edit Journal")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open a journal based on the journal batch.';

                trigger OnAction()
                var
                    AMJournalMgt: Codeunit "MCH AM Journal Mgt.";
                begin
                    AMJournalMgt.UsageTemplateSelectionFromBatch(Rec);
                end;
            }
        }
    }

    local procedure DataCaption(): Text[250]
    var
        MAUsageJnlTemplate: Record "MCH Usage Journal Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Journal Template Name") <> '' then
            if GetRangeMin("Journal Template Name") = GetRangeMax("Journal Template Name") then
              if MAUsageJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(MAUsageJnlTemplate.Name + ' ' + MAUsageJnlTemplate.Description);
    end;
}

