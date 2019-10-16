codeunit 74045 "MCH Maint. Jnl.-B.Post+Print"
{
    TableNo = "MCH Maint. Journal Batch";

    trigger OnRun()
    begin
        MaintJnlBatch.Copy(Rec);
        Code;
        Rec := MaintJnlBatch;
    end;

    var
        Text000: Label 'Do you want to post the journals and print the report(s)?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals.';
        Text003: Label 'The journals that were not successfully posted are now marked.';
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        AMReg: Record "MCH AM Posting Register";
        MaintJnlPostBatch: Codeunit "MCH Maint. Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with MaintJnlBatch do begin
          MaintJnlTemplate.Get("Journal Template Name");
          if MaintJnlTemplate."Force Posting Report" then
            MaintJnlTemplate.TestField("Posting Report ID");

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            MaintJnlLine."Journal Template Name" := "Journal Template Name";
            MaintJnlLine."Journal Batch Name" := Name;
            MaintJnlLine."Line No." := 1;
            Clear(MaintJnlPostBatch);
            if MaintJnlPostBatch.Run(MaintJnlLine) then begin
              Mark(false);
              if AMReg.Get(MaintJnlPostBatch.GetMaintRegNo) then begin
                if MaintJnlTemplate."Posting Report ID" <> 0 then begin
                  AMReg.SetRecFilter;
                  REPORT.Run(MaintJnlTemplate."Posting Report ID",false,false,AMReg);
                end;
              end;
            end else begin
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
            Name := '';
          end;
        end;
    end;
}

