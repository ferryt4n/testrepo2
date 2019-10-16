codeunit 74036 "MCH Usage Jnl.-Register"
{
    TableNo = "MCH Usage Journal Line";

    trigger OnRun()
    begin
        UsageJnlLine.Copy(Rec);
        Code;
        Rec.Copy(UsageJnlLine);
    end;

    var
        Text001: Label 'Do you want to register the journal lines?';
        Text002: Label 'There is nothing to register.';
        Text003: Label 'The journal lines were successfully registered.';
        UsageJnlTemplate: Record "MCH Usage Journal Template";
        UsageJnlLine: Record "MCH Usage Journal Line";

    local procedure "Code"()
    begin
        with UsageJnlLine do begin
          UsageJnlTemplate.Get("Journal Template Name");
          if GuiAllowed then
            if not Confirm(Text001) then
              exit;

          CODEUNIT.Run(CODEUNIT::"MCH Usage Jnl.-Reg. Batch",UsageJnlLine);
          if GuiAllowed then begin
            if "Line No." = 0 then
              Message(Text002)
            else
              Message(Text003);
          end;

          if not Find('=><') then begin
            Reset;
            FilterGroup(2);
            SetRange("Journal Template Name","Journal Template Name");
            SetRange("Journal Batch Name","Journal Batch Name");
            FilterGroup(0);
            "Line No." := 10000;
          end;
        end;
    end;
}

