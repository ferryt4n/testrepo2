codeunit 74037 "MCH Usage Jnl.-Reg. Batch"
{
    Permissions = TableData "MCH Usage Monitor Entry"=rim,
                  TableData "MCH Usage Journal Batch"=imd;
    TableNo = "MCH Usage Journal Line";

    trigger OnRun()
    var
        UsageJnlLine: Record "MCH Usage Journal Line";
    begin
        UsageJnlLine.Copy(Rec);
        Code(UsageJnlLine);
        Rec := UsageJnlLine;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintAsset: Record "MCH Maintenance Asset";
        MAUsageMonitor: Record "MCH Asset Usage Monitor";
        TempUsageMonitor: Record "MCH Master Usage Monitor" temporary;
        UsageMonitor: Record "MCH Master Usage Monitor";
        UsageEntry: Record "MCH Usage Monitor Entry";
        PriorUsageEntry: Record "MCH Usage Monitor Entry";
        MaintUser: Record "MCH Asset Maintenance User";
        BalUsageAdjPoint: Record "MCH Asset Usage Monitor" temporary;
        AMUserMgt: Codeunit "MCH AM User Mgt.";
        Window: Dialog;
        IsBatchPosting: Boolean;
        IsCancellationUpdate: Boolean;
        LastReadingDateTime: DateTime;
        NewReadingDateTime: DateTime;
        NextEntryNo: Integer;
        FirstRegisteredEntryNo: Integer;
        HideDialog: Boolean;
        Text009: Label 'The adjusted %5 (%6 -> %7) is less than min. %4 allowed for %1 %2';
        Text010: Label 'The adjusted %5 (%6 -> %7) is greater than max. %4 allowed for %1 %2';
        Text011: Label '%5 (%6) is less than min. %4 allowed for %1 %2';
        Text012: Label '%5 (%6) is greater than max. %4 allowed for %1 %2';
        UserHasAssetRespGroupFilter: Boolean;
        HasSetup: Boolean;
        Text013: Label 'You cannot register with %1 = %2 for %3 %4. The date is outside the allowed date range (%5 to %6).';
        Text014: Label 'The Meter value reading for %1 %2 %3 must not be lower than the previous reading.\\Previous reading: %4 on %5\This reading: %6 on %7';
        DuplicateReadingErrMsg: Label 'Duplicate %1 usage reading cannot be registered for\%2: %3\%4: %5\%6: %7\%8: %9';
        UserRespGrpAccesErrMsg: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
        RegisterWindowMsg: Label 'Journal Batch Name #1##########\#2#############';
        CheckingLinesMsg: Label 'Checking lines %1';
        RegisterLinesMsg: Label 'Registering line %1 of %2';
        BalanceUsageUpdateMsg: Label 'Calc. monitor usage %1 of %2';
        CancellationWindowMsg: Label '#2#############';
        CancelEntryMsg: Label 'Cancelling entry %1 of %2';

    local procedure "Code"(var UsageJnlLine: Record "MCH Usage Journal Line")
    var
        UsageJnlTemplate: Record "MCH Usage Journal Template";
        UsageJnlBatch: Record "MCH Usage Journal Batch";
        UsageJnlLine2: Record "MCH Usage Journal Line";
        UsageJnlLine3: Record "MCH Usage Journal Line";
        StartLineNo: Integer;
        LineCount: Integer;
        NoOfRecords: Integer;
    begin
        with UsageJnlLine do begin
          LockTable;
          SetRange("Journal Template Name","Journal Template Name");
          SetRange("Journal Batch Name","Journal Batch Name");
          UsageJnlTemplate.Get("Journal Template Name");
          UsageJnlBatch.Get("Journal Template Name","Journal Batch Name");
          SetCurrentKey("Asset No.","Monitor Code","Reading Date","Reading Time");
          if not Find('=><') then begin
            "Line No." := 0;
            Commit;
            exit;
          end;
          GetSetup;

          HideDialog := HideDialog or (not GuiAllowed);
          if (not HideDialog) then begin
            Window.Open(RegisterWindowMsg);
            Window.Update(1,"Journal Batch Name");
          end;

          // Check lines
          LineCount := 0;
          StartLineNo := "Line No.";
          repeat
            LineCount := LineCount + 1;
            if (not HideDialog) then
              Window.Update(2,StrSubstNo(CheckingLinesMsg,LineCount));
            CheckLine(UsageJnlLine);
            if Next = 0 then
              Find('-');
          until "Line No." = StartLineNo;
          NoOfRecords := LineCount;

          // Register lines
          IsBatchPosting := true;
          LineCount := 0;
          Find('-');
          repeat
            LineCount := LineCount + 1;
            if (not HideDialog) then begin
              Window.Update(2,StrSubstNo(RegisterLinesMsg,LineCount,NoOfRecords));
            end;
            RegisterLineWithCheck(UsageJnlLine);
          until Next = 0;

          // Update Usage on affected Balance entries
          AdjustBalanceUsage;

          // Delete lines
          UsageJnlLine2.CopyFilters(UsageJnlLine);
          UsageJnlLine2.SetFilter("Asset No.",'<>%1','');
          if UsageJnlLine2.Find('+') then; // Remember the last line
          UsageJnlLine3.Copy(UsageJnlLine);
          if UsageJnlLine3.Find('-') then
            repeat
              UsageJnlLine3.Delete;
            until UsageJnlLine3.Next = 0;
          UsageJnlLine3.Reset;
          UsageJnlLine3.SetRange("Journal Template Name","Journal Template Name");
          UsageJnlLine3.SetRange("Journal Batch Name","Journal Batch Name");
          if not UsageJnlLine3.Find('+') then begin
            UsageJnlLine3.Init;
            UsageJnlLine3."Journal Template Name" := "Journal Template Name";
            UsageJnlLine3."Journal Batch Name" := "Journal Batch Name";
            UsageJnlLine3."Line No." := 10000;
            UsageJnlLine3.Insert;
            UsageJnlLine3.SetUpNewLine(UsageJnlLine2);
            UsageJnlLine3.Modify;
          end;
        end;
        if (not HideDialog) then
          Window.Close;
        Commit;
    end;

    local procedure CheckLine(var UsageJnlLine: Record "MCH Usage Journal Line")
    var
        ReadingIsRoundAdjusted: Boolean;
    begin
        with UsageJnlLine do begin
          if EmptyLine then
            exit;
          TestField("Asset No.");
          TestField("Monitor Code");
          if UserHasAssetRespGroupFilter then begin
            if (MaintAsset."No." <> "Asset No.") then begin
              GetMaintAsset("Asset No.");
              if not AMUserMgt.UserHasAccessToRespGroup(UserId,MaintAsset."Responsibility Group Code") then begin
                Error(UserRespGrpAccesErrMsg,
                  MaintAsset.TableCaption,MaintAsset."No.",
                  MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
              end;
            end;
          end else
            GetMaintAsset("Asset No.");

          GetMAUsageMonitor("Asset No.","Monitor Code",true);
          CheckDate(UsageJnlLine,UsageMonitor);

          "Reading Date-Time" := CreateDateTime("Reading Date","Reading Time");
          // Value Check and Adj/Rounding
          "Original Reading Value" := "Reading Value";
          "Reading Value" := UsageMonitor.CalcRoundAdjustedReadingValue("Reading Value");
          ReadingIsRoundAdjusted := ("Original Reading Value" <> "Reading Value");

          // Allowed Value range
          if (UsageMonitor."Min. Allowed Reading Value" > "Reading Value") then begin
            if ReadingIsRoundAdjusted then
              Error(Text009,
                UsageMonitor.TableCaption,UsageMonitor.Code,
                UsageMonitor."Min. Allowed Reading Value",FieldCaption("Reading Value"),"Original Reading Value","Reading Value")
            else
              Error(Text011,
                UsageMonitor.TableCaption,UsageMonitor.Code,
                UsageMonitor."Min. Allowed Reading Value",FieldCaption("Reading Value"),"Reading Value");
          end;
          if (UsageMonitor."Max. Allowed Reading Value" <> 0) and (UsageMonitor."Max. Allowed Reading Value" < "Reading Value") then begin
            if ReadingIsRoundAdjusted then
              Error(Text010,
                UsageMonitor.TableCaption,UsageMonitor.Code,
                UsageMonitor."Max. Allowed Reading Value",FieldCaption("Reading Value"),"Original Reading Value","Reading Value")
            else
              Error(Text012,
                UsageMonitor.TableCaption,UsageMonitor.Code,
                UsageMonitor."Max. Allowed Reading Value",FieldCaption("Reading Value"),"Reading Value");
          end;

          if (UsageMonitor."Reading Type" = UsageMonitor."Reading Type"::Meter) then begin
            PriorUsageEntry.Reset;
            PriorUsageEntry.SetCurrentKey("Asset No.","Monitor Code","Reading Date-Time","Reading Value");
            PriorUsageEntry.SetRange("Asset No.","Asset No.");
            PriorUsageEntry.SetRange("Monitor Code","Monitor Code");
            PriorUsageEntry.SetFilter("Reading Date-Time",'<%1',"Reading Date-Time");
            PriorUsageEntry.SetRange(Cancelled,false);
            if PriorUsageEntry.FindLast and (not PriorUsageEntry."Closing Meter Reading") then begin
              if ("Reading Value" < PriorUsageEntry."Reading Value") then
                Error(Text014,
                  MAUsageMonitor.TableCaption,MAUsageMonitor."Asset No.",MAUsageMonitor."Monitor Code",
                  PriorUsageEntry."Reading Value",PriorUsageEntry."Reading Date-Time",
                  "Reading Value","Reading Date-Time");
            end;
          end;

          if ((UsageMonitor."Reading Type" = UsageMonitor."Reading Type"::Meter) and
              (AMSetup."Usage Meter Duplicate Reading" = AMSetup."Usage Meter Duplicate Reading"::"Not Allowed")) or
             ((UsageMonitor."Reading Type" = UsageMonitor."Reading Type"::Transactional) and
              (AMSetup."Usage Meter Duplicate Reading" = AMSetup."Usage Trans. Duplicate Reading"::"Not Allowed"))
          then begin
            PriorUsageEntry.Reset;
            PriorUsageEntry.SetCurrentKey("Asset No.","Monitor Code","Reading Date-Time","Reading Value");
            PriorUsageEntry.SetRange("Asset No.","Asset No.");
            PriorUsageEntry.SetRange("Monitor Code","Monitor Code");
            PriorUsageEntry.SetRange("Reading Date-Time","Reading Date-Time");
            PriorUsageEntry.SetRange("Reading Value","Reading Value");
            PriorUsageEntry.SetRange(Cancelled,false);
            if not PriorUsageEntry.IsEmpty then
              Error(DuplicateReadingErrMsg,
                UsageMonitor."Reading Type",MAUsageMonitor.FieldCaption("Asset No."),MAUsageMonitor."Asset No.",
                MAUsageMonitor.FieldCaption("Monitor Code"),MAUsageMonitor."Monitor Code",
                FieldCaption("Reading Date-Time"),"Reading Date-Time",FieldCaption("Reading Value"),"Reading Value");
          end;
        end;
    end;

    local procedure RegisterLineWithCheck(UsageJnlRegLine: Record "MCH Usage Journal Line")
    begin
        with UsageJnlRegLine do begin
          if NextEntryNo = 0 then begin
            BalUsageAdjPoint.Reset;
            BalUsageAdjPoint.DeleteAll;
            UsageEntry.LockTable;
            UsageEntry.Reset;

            if UsageEntry.FindLast then
              NextEntryNo := UsageEntry."Entry No." + 1
            else
              NextEntryNo := 1;
            FirstRegisteredEntryNo := NextEntryNo;
          end else
            NextEntryNo := NextEntryNo + 1;

          CheckLine(UsageJnlRegLine);
          GetMAUsageMonitor("Asset No.","Monitor Code",true);

          UsageEntry.Reset;
          UsageEntry.Init;
          UsageEntry."Entry No." := NextEntryNo;
          UsageEntry."Asset No." := "Asset No.";
          UsageEntry."Monitor Code" := "Monitor Code";
          UsageEntry."Reading Date" := "Reading Date";
          UsageEntry."Reading Time" := "Reading Time";
          if ("Reading Date-Time" <> 0DT) then
            UsageEntry."Reading Date-Time" := "Reading Date-Time"
          else
            UsageEntry."Reading Date-Time" := CreateDateTime("Reading Date","Reading Time");
          UsageEntry.Description := Description;
          UsageEntry."Unit of Measure Code" := UsageMonitor."Unit of Measure Code";
          UsageEntry."Reading Type" := UsageMonitor."Reading Type";

          UsageEntry."Original Reading Value" := "Original Reading Value";
          UsageEntry."Reading Value" := "Reading Value";

          case UsageEntry."Reading Type" of
            UsageEntry."Reading Type"::Transactional :
              begin
                UsageEntry."Usage Value" := "Reading Value";
              end;
            UsageEntry."Reading Type"::Meter :
              begin
                UsageEntry."Usage Value" := 0; // Is updated on balance adjustment
                UsageEntry."Closing Meter Reading" := "Closing Meter Reading";
              end;
          end;
          UsageEntry."Registered By" := UserId;
          UsageEntry."Registered Date-Time" := CurrentDateTime;
          UsageEntry.Insert;

          if (UsageMonitor."Reading Type" = UsageMonitor."Reading Type"::Meter) then begin
            SetBalanceUsageAdjPoint(MAUsageMonitor,UsageEntry."Reading Date");
            if not IsBatchPosting then
              AdjustBalanceUsage;
          end;
        end;
    end;

    local procedure CheckDate(var UsageJnlLine: Record "MCH Usage Journal Line";var TheUsageMonitor: Record "MCH Master Usage Monitor")
    var
        AllowRegFromDate: Date;
        AllowRegToDate: Date;
        BaseDate: Date;
    begin
        if (AMSetup."Usage Allowed ReadingDate Base" = AMSetup."Usage Allowed ReadingDate Base"::"System Date") then
          BaseDate := Today
        else
          BaseDate := WorkDate;
        with UsageJnlLine do begin
          TestField("Reading Date");
          if "Reading Date" <> NormalDate("Reading Date") then
            FieldError("Reading Date");

          // Allowed reading date window
          AllowRegFromDate := BaseDate - TheUsageMonitor."Max. Allowed Aged Read. Days";
          AllowRegToDate := BaseDate + TheUsageMonitor."Max. Allowed Read-Ahead Days";
          if (("Reading Date" < AllowRegFromDate) or ("Reading Date" > AllowRegToDate)) then
            Error(Text013,
              FieldCaption("Reading Date"),"Reading Date",TheUsageMonitor.TableCaption,TheUsageMonitor.Code,AllowRegFromDate,AllowRegToDate);
        end;
    end;


    procedure SetHideDialog(Set: Boolean)
    begin
        HideDialog := Set;
    end;

    local procedure GetMaintAsset(AssetNo: Code[20])
    begin
        if (AssetNo <> MaintAsset."No.") then
          MaintAsset.Get(AssetNo);
    end;

    local procedure GetMAUsageMonitor(MANo: Code[20];MonitorCode: Code[20];CheckMonitorIsActive: Boolean)
    begin
        if (MANo <> MAUsageMonitor."Asset No.") or (MonitorCode <> MAUsageMonitor."Monitor Code") then begin
          MAUsageMonitor.Get(MANo,MonitorCode);
          if CheckMonitorIsActive then
            MAUsageMonitor.TestField(Blocked,false);
          GetUsageMonitor(MonitorCode,CheckMonitorIsActive);
        end;
    end;

    local procedure GetUsageMonitor(MonitorCode: Code[20];CheckMonitorIsActive: Boolean)
    begin
        if (MonitorCode <> UsageMonitor.Code) then begin
          if not TempUsageMonitor.Get(MonitorCode) then begin
            UsageMonitor.Get(MonitorCode);
            if CheckMonitorIsActive then begin
              if not (UsageMonitor.Status = UsageMonitor.Status::Active) then
                UsageMonitor.FieldError(Status);
              UsageMonitor.TestField("Unit of Measure Code");
            end;
            TempUsageMonitor := UsageMonitor;
            TempUsageMonitor.Insert;
          end else
            UsageMonitor := TempUsageMonitor;
        end;
    end;

    local procedure GetSetup()
    begin
        if HasSetup then
          exit;
        AMSetup.Get;
        AMUserMgt.GetMaintenanceUser(UserId,MaintUser);
        UserHasAssetRespGroupFilter := AMUserMgt.UserHasAssetRespGroupFilter;
        HasSetup := true;
    end;

    local procedure SetBalanceUsageAdjPoint(var TheUsageMonitor: Record "MCH Asset Usage Monitor";FromReadingDate: Date)
    begin
        if not BalUsageAdjPoint.Get(TheUsageMonitor."Asset No.",TheUsageMonitor."Monitor Code") then begin
          BalUsageAdjPoint := TheUsageMonitor;
          BalUsageAdjPoint."Meter/Usage Adj. from Date" := FromReadingDate;
          BalUsageAdjPoint.Insert;
        end else begin
          if (BalUsageAdjPoint."Meter/Usage Adj. from Date" > FromReadingDate) then begin
            BalUsageAdjPoint."Meter/Usage Adj. from Date" := FromReadingDate;
            BalUsageAdjPoint.Modify;
          end;
        end;
    end;

    local procedure AdjustBalanceUsage()
    var
        RecCount: Integer;
        NoOfRecords: Integer;
        StartingDateTime: DateTime;
        NewUsageValue: Decimal;
    begin
        BalUsageAdjPoint.Reset;
        if not BalUsageAdjPoint.FindSet then
          exit;
        if not (IsBatchPosting or IsCancellationUpdate) then
          HideDialog := true
        else
          if (not HideDialog) then
            NoOfRecords := BalUsageAdjPoint.Count;

        PriorUsageEntry.Reset;
        repeat
          if (not HideDialog) then begin
            RecCount := RecCount + 1;
            Window.Update(2,StrSubstNo(BalanceUsageUpdateMsg,RecCount,NoOfRecords));
          end;
          with UsageEntry do begin
            StartingDateTime := CreateDateTime(BalUsageAdjPoint."Meter/Usage Adj. from Date",0T);
            Reset;
            SetCurrentKey("Asset No.","Monitor Code","Reading Date-Time","Reading Value");
            SetRange("Asset No.",BalUsageAdjPoint."Asset No.");
            SetRange("Monitor Code",BalUsageAdjPoint."Monitor Code");
            SetFilter("Reading Date-Time",'%1..',StartingDateTime);
            if FindSet then begin
              PriorUsageEntry.Copy(UsageEntry);
              PriorUsageEntry.SetFilter("Reading Date-Time",'<%1',StartingDateTime);
              PriorUsageEntry.SetRange(Cancelled,false);
              if not PriorUsageEntry.FindLast then begin
                Clear(PriorUsageEntry);
                PriorUsageEntry."Closing Meter Reading" := true;
              end;

              repeat
                NewUsageValue := 0;
                if (not Cancelled) then begin
                  if (not PriorUsageEntry."Closing Meter Reading") then begin
                    if ("Reading Value" < PriorUsageEntry."Reading Value") then begin
                      GetMAUsageMonitor("Asset No.","Monitor Code",not IsCancellationUpdate);
                      Error(Text014,
                        MAUsageMonitor.TableCaption,MAUsageMonitor."Asset No.",MAUsageMonitor."Monitor Code",
                        PriorUsageEntry."Reading Value",PriorUsageEntry."Reading Date-Time",
                        "Reading Value","Reading Date-Time");
                    end;
                    NewUsageValue := Round("Reading Value" - PriorUsageEntry."Reading Value",0.00001);
                  end;
                  PriorUsageEntry := UsageEntry;
                end;
                if ("Usage Value" <> NewUsageValue) then begin
                  "Usage Value" := NewUsageValue;
                  Modify;
                end;
              until Next = 0;
            end;
          end;
        until BalUsageAdjPoint.Next = 0;
        BalUsageAdjPoint.DeleteAll;
    end;


    procedure UsageEntryCancellation(var FilteredUsageEntry: Record "MCH Usage Monitor Entry";ReasonCode: Code[10];ShowProgressDialog: Boolean)
    var
        RecCount: Integer;
        NoOfRecords: Integer;
    begin
        GetSetup;
        UsageEntry.LockTable;
        UsageEntry.Reset;
        if UsageEntry.FindLast then ;
        FilteredUsageEntry.SetCurrentKey("Asset No.","Monitor Code",Cancelled,"Reading Date","Reading Time");
        FilteredUsageEntry.SetRange(Cancelled,false);
        if FilteredUsageEntry.IsEmpty then
          exit;
        NoOfRecords := FilteredUsageEntry.Count;
        MaintUser.TestField("Allow Cancel Usage Mon. Entry",true);

        IsCancellationUpdate := true;
        HideDialog := not ShowProgressDialog;
        if ShowProgressDialog then
          Window.Open(CancellationWindowMsg);

        if UserHasAssetRespGroupFilter then begin
          Clear(MaintAsset);
          FilteredUsageEntry.FindSet;
          repeat
            if (MaintAsset."No." <> FilteredUsageEntry."Asset No.") then begin
              GetMaintAsset(FilteredUsageEntry."Asset No.");
              if not AMUserMgt.UserHasAccessToRespGroup(UserId,MaintAsset."Responsibility Group Code") then begin
                Error(UserRespGrpAccesErrMsg,
                  MaintAsset.TableCaption,MaintAsset."No.",
                  MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
              end;
            end;
          until FilteredUsageEntry.Next = 0;
        end;

        FilteredUsageEntry.FindSet;
        repeat
          if ShowProgressDialog then begin
            RecCount := RecCount + 1;
            Window.Update(2,StrSubstNo(CancelEntryMsg,RecCount,NoOfRecords));
          end;

          UsageEntry.Get(FilteredUsageEntry."Entry No.");
          GetMAUsageMonitor(UsageEntry."Asset No.",UsageEntry."Monitor Code",false);
          UsageEntry.Cancelled := true;
          UsageEntry."Cancellation Reason Code" := ReasonCode;
          UsageEntry."Cancellation Date-Time" := CurrentDateTime;
          UsageEntry."Cancelled By" := UserId;
          UsageEntry.Modify;

          if (UsageMonitor."Reading Type" = UsageMonitor."Reading Type"::Meter) then
            SetBalanceUsageAdjPoint(MAUsageMonitor,UsageEntry."Reading Date");
        until FilteredUsageEntry.Next = 0;

        AdjustBalanceUsage;

        if ShowProgressDialog then
          Window.Close;
        Commit;
    end;
}

