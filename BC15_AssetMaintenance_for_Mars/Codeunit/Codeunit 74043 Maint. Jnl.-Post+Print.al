codeunit 74043 "MCH Maint. Jnl.-Post+Print"
{
    TableNo = "MCH Maint. Journal Line";

    trigger OnRun()
    begin
        MaintJnlLine.Copy(Rec);
        Code;
        Rec.Copy(MaintJnlLine);
    end;

    var
        Text001: Label 'Do you want to post the journal lines and print the posting report?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted.';
        Text005: Label 'You are now in the %1 journal.';
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        AMReg: Record "MCH AM Posting Register";
        MaintJnlPostBatch: Codeunit "MCH Maint. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        with MaintJnlLine do begin
          MaintJnlTemplate.Get("Journal Template Name");
          MaintJnlTemplate.TestField("Posting Report ID");

          if not Confirm(Text001,false) then
            exit;

          TempJnlBatchName := "Journal Batch Name";

          MaintJnlPostBatch.Run(MaintJnlLine);

          if AMReg.Get(MaintJnlPostBatch.GetMaintRegNo) then begin
            AMReg.SetRecFilter;
            REPORT.Run(MaintJnlTemplate."Posting Report ID",false,false,AMReg);
          end;

          if (MaintJnlPostBatch.GetMaintRegNo = 0) then
            Message(Text002)
          else
            if TempJnlBatchName = "Journal Batch Name" then
              Message(Text003)
            else
              Message(
                Text004 +
                Text005,
                "Journal Batch Name");

          if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") then begin
            Reset;
            FilterGroup(2);
            SetRange("Journal Template Name","Journal Template Name");
            SetRange("Journal Batch Name","Journal Batch Name");
            FilterGroup(0);
            "Line No." := 1;
          end;
        end;
    end;
}

