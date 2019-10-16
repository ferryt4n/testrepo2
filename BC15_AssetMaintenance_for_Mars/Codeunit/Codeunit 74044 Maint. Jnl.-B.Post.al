codeunit 74044 "MCH Maint. Jnl.-B.Post"
{
    TableNo = "MCH Maint. Journal Batch";

    trigger OnRun()
    begin
        MaintJnlBatch.Copy(Rec);
        Code;
        Rec.Copy(MaintJnlBatch);
    end;

    var
        Text000: Label 'Do you want to post the journals?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals.';
        Text003: Label 'The journals that were not successfully posted are now marked.';
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        MaintJnlPostBatch: Codeunit "MCH Maint. Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with MaintJnlBatch do begin
          MaintJnlTemplate.Get("Journal Template Name");
          MaintJnlTemplate.TestField("Force Posting Report",false);

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            MaintJnlLine."Journal Template Name" := "Journal Template Name";
            MaintJnlLine."Journal Batch Name" := Name;
            MaintJnlLine."Line No." := 1;
            Clear(MaintJnlPostBatch);
            if MaintJnlPostBatch.Run(MaintJnlLine) then
              Mark(false)
            else begin
              Mark(true);
              JnlWithErrors := true;
            end;
          until Next = 0;

          if not JnlWithErrors then
            Message(Text001)
          else
            Message(
              Text002 +
              Text003);

          if not Find('=><') then begin
            Reset;
            FilterGroup(2);
            SetRange("Journal Template Name","Journal Template Name");
            FilterGroup(0);
            Name := '';
          end;
        end;
    end;
}

