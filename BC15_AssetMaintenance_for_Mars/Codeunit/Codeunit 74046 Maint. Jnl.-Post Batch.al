codeunit 74046 "MCH Maint. Jnl.-Post Batch"
{
    Permissions = TableData "MCH Maint. Journal Batch"=imd;
    TableNo = "MCH Maint. Journal Line";

    trigger OnRun()
    begin
        MaintJnlLine.Copy(Rec);
        Code;
        Rec := MaintJnlLine;
    end;

    var
        Text001: Label 'Journal Batch Name #1##########\\';
        Text002: Label 'Checking lines #2######\';
        Text003: Label 'Posting lines #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        MaintJnlLine2: Record "MCH Maint. Journal Line";
        MaintJnlLine3: Record "MCH Maint. Journal Line";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        AMReg: Record "MCH AM Posting Register";
        NoSeries: Record "No. Series" temporary;
        MaintJnlCheckLine: Codeunit "MCH Maint. Jnl.-Check Line";
        MaintJnlPostLine: Codeunit "MCH Maint. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt2: array [10] of Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        MaintRegNo: Integer;
        StartLineNo: Integer;
        NoOfRecords: Integer;
        LineCount: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;
        SuppressCommit: Boolean;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        OldEntryType: Option;
    begin
        with MaintJnlLine do begin
          LockTable;
          SetRange("Journal Template Name","Journal Template Name");
          SetRange("Journal Batch Name","Journal Batch Name");

          MaintJnlTemplate.Get("Journal Template Name");
          MaintJnlBatch.Get("Journal Template Name","Journal Batch Name");
          if not Find('=><') then begin
            "Line No." := 0;
            if not SuppressCommit then
              Commit;
            exit;
          end;

          Window.Open(
            Text001 +
            Text002 +
            Text003);

          Window.Update(1,"Journal Batch Name");

          // Check Lines
          LineCount := 0;
          StartLineNo := "Line No.";
          repeat
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);
            MaintJnlCheckLine.RunCheck(MaintJnlLine);
            if Next = 0 then
              Find('-');
          until "Line No." = StartLineNo;
          NoOfRecords := LineCount;

          // Find next register no.
          AMLedgEntry.LockTable;
          if AMLedgEntry.FindLast then;

          AMReg.LockTable;
          if AMReg.FindLast then
            MaintRegNo := AMReg."No." + 1
          else
            MaintRegNo := 1;

          // Post lines
          LineCount := 0;
          LastDocNo := '';
          LastDocNo2 := '';
          LastPostedDocNo := '';
          OldEntryType := "Entry Type";
          Find('-');
          repeat
            if not EmptyLine and
               (MaintJnlBatch."No. Series" <> '') and
               ("Document No." <> LastDocNo2)
            then
              TestField("Document No.",NoSeriesMgt.GetNextNo(MaintJnlBatch."No. Series","Posting Date",false));
            LastDocNo2 := "Document No.";
            if "Posting No. Series" = '' then
              "Posting No. Series" := MaintJnlBatch."No. Series"
            else
              if not EmptyLine then
                if "Document No." = LastDocNo then
                  "Document No." := LastPostedDocNo
                else begin
                  if not NoSeries.Get("Posting No. Series") then begin
                    NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                    if NoOfPostingNoSeries > ArrayLen(NoSeriesMgt2) then
                      Error(
                        Text006,
                        ArrayLen(NoSeriesMgt2));
                    NoSeries.Code := "Posting No. Series";
                    NoSeries.Description := Format(NoOfPostingNoSeries);
                    NoSeries.Insert;
                  end;
                  LastDocNo := "Document No.";
                  Evaluate(PostingNoSeriesNo,NoSeries.Description);
                  "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series","Posting Date",false);
                  LastPostedDocNo := "Document No.";
                end;

            LineCount := LineCount + 1;
            Window.Update(3,LineCount);
            Window.Update(4,Round(LineCount / NoOfRecords * 10000,1));

            MaintJnlPostLine.RunWithCheck(MaintJnlLine);
          until Next = 0;

          // Copy register no. and current journal batch name to maintenance journal
          if not AMReg.Find('+') or (AMReg."No." <> MaintRegNo) then
            MaintRegNo := 0;

          Init;
          "Line No." := MaintRegNo;

          // Delete lines
          if "Line No." <> 0 then begin
            MaintJnlLine2.CopyFilters(MaintJnlLine);
            MaintJnlLine2.SetFilter("Work Order No.",'<>%1','');
            if MaintJnlLine2.Find('+') then; // Remember the last line
            MaintJnlLine2."Entry Type" := OldEntryType;

            MaintJnlLine3.Copy(MaintJnlLine);
            MaintJnlLine3.DeleteAll;
            MaintJnlLine3.Reset;
            MaintJnlLine3.SetRange("Journal Template Name","Journal Template Name");
            MaintJnlLine3.SetRange("Journal Batch Name","Journal Batch Name");
            if (MaintJnlBatch."No. Series" = '') and not MaintJnlLine3.Find('+') then begin
              MaintJnlLine3.Init;
              MaintJnlLine3."Journal Template Name" := "Journal Template Name";
              MaintJnlLine3."Journal Batch Name" := "Journal Batch Name";
              MaintJnlLine3."Line No." := 10000;
              MaintJnlLine3.Insert;
              MaintJnlLine3.SetUpNewLine(MaintJnlLine2);
              MaintJnlLine3.Modify;
            end;
          end;
          if MaintJnlBatch."No. Series" <> '' then
            NoSeriesMgt.SaveNoSeries;
          if NoSeries.FindSet then
            repeat
              Evaluate(PostingNoSeriesNo,NoSeries.Description);
              NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
            until NoSeries.Next = 0;

          Window.Close;
          if not SuppressCommit then
            Commit;
          Clear(MaintJnlCheckLine);
          Clear(MaintJnlPostLine);
        end;
        UpdateAnalysisView.UpdateAll(0,true);
        UpdateItemAnalysisView.UpdateAll(0,true);
        if not SuppressCommit then
          Commit;
    end;


    procedure GetMaintRegNo(): Integer
    begin
        exit(MaintRegNo);
    end;


    procedure SetSuppressCommit(NewSuppressCommit: Boolean)
    begin
        SuppressCommit := NewSuppressCommit;
    end;
}

