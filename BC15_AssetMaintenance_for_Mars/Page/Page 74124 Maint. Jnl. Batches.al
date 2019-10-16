page 74124 "MCH Maint. Jnl. Batches"
{
    Caption = 'Maintenance Journal Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "MCH Maint. Journal Batch";

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
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting No. Series";"Posting No. Series")
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
                    AMJournalMgt.MaintTemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        AMPrintReport.PrintMaintJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "MCH Maint. Jnl.-B.Post";
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "MCH Maint. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewBatch;
    end;

    var
        AMPrintReport: Codeunit "MCH AM Report Mgt.";

    local procedure DataCaption(): Text[250]
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Journal Template Name") <> '' then
            if GetRangeMin("Journal Template Name") = GetRangeMax("Journal Template Name") then
              if MaintJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(MaintJnlTemplate.Name + ' ' + MaintJnlTemplate.Description);
    end;
}

