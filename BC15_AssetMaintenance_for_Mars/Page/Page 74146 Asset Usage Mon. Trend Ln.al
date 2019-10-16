page 74146 "MCH Asset Usage Mon. Trend Ln"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Period Start';
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Period Name';
                }
                field("Period End";"Period End")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(NoOfPeriodReadings;NoOfPeriodReadings)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'No. of Readings';
                }
                field(PeriodUsage;PeriodUsage)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Period Usage';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        DrillDownEntries(false);
                    end;
                }
                field("Balance at Date";BalanceAtDate)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Balance at Date';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        DrillDownEntries(true);
                    end;
                }
                field(AvgUsagePerDay;AvgUsagePerDay)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Avg. Usage per Day';
                    DecimalPlaces = 0:5;
                }
                field(AvgUsagePerReading;AvgUsagePerReading)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Avg. Usage per Reading';
                    DecimalPlaces = 0:5;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        AvgUsagePerDay := 0;
        AvgUsagePerReading := 0;
        PeriodUsage := 0;
        BalanceAtDate := 0;

        MAUsageEntry.Reset;
        MAUsageEntry.SetCurrentKey("Asset No.","Monitor Code",Cancelled,"Reading Date","Reading Time");
        MAUsageEntry.SetRange("Asset No.",MAUsageMonitor."Asset No.");
        MAUsageEntry.SetRange("Monitor Code",MAUsageMonitor."Monitor Code");
        MAUsageEntry.SetRange("Reading Date","Period Start","Period End");
        MAUsageEntry.SetRange(Cancelled,false);
        NoOfPeriodReadings := MAUsageEntry.Count;
        if (NoOfPeriodReadings > 0) then begin

          MAUsageEntry.CalcSums("Usage Value");
          PeriodUsage := MAUsageEntry."Usage Value";
          AvgUsagePerReading := UsageMonitor.CalcRoundAdjustedReadingValue(PeriodUsage/NoOfPeriodReadings);

          if PeriodUsage <> 0 then begin
            if "Period Start" < FirstReadingDate then
              AvgFirstDate := FirstReadingDate
            else
              AvgFirstDate := "Period Start";
            if "Period End" > LastReadingDate then
              AvgLastDate := LastReadingDate
            else
              AvgLastDate := "Period End";

            AvgUsagePerDay := UsageMonitor.CalcRoundAdjustedReadingValue(PeriodUsage/(AvgLastDate-AvgFirstDate+1));
          end;
        end;

        if (LastReadingDate >= "Period Start") then begin
          // Sum to Period End
          MAUsageEntry.SetRange("Reading Date",0D,"Period End");
          MAUsageEntry.CalcSums("Usage Value");
          BalanceAtDate := MAUsageEntry."Usage Value";
        end;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,PeriodType));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,PeriodType));
    end;

    trigger OnOpenPage()
    begin
        Reset;
    end;

    var
        MAUsageMonitor: Record "MCH Asset Usage Monitor";
        UsageMonitor: Record "MCH Master Usage Monitor";
        MAUsageEntry: Record "MCH Usage Monitor Entry";
        DateRec: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;
        NoOfPeriodReadings: Integer;
        PeriodUsage: Decimal;
        BalanceAtDate: Decimal;
        AvgUsagePerDay: Decimal;
        AvgUsagePerReading: Decimal;
        FirstReadingDate: Date;
        LastReadingDate: Date;
        AvgFirstDate: Date;
        AvgLastDate: Date;


    procedure Set(var NewMAUsageMonitor: Record "MCH Asset Usage Monitor";NewPeriodType: Integer;NewFirstReadingDate: Date;NewLastReadingDate: Date)
    begin
        MAUsageMonitor.Copy(NewMAUsageMonitor);
        UsageMonitor.Get(MAUsageMonitor."Monitor Code");
        PeriodType := NewPeriodType;
        FirstReadingDate := NewFirstReadingDate;
        LastReadingDate := NewLastReadingDate;
        CurrPage.Update(false);
    end;

    local procedure DrillDownEntries(ShowAtDate: Boolean)
    begin
        if MAUsageMonitor.Find then begin
          if ShowAtDate then
            MAUsageMonitor.SetRange("Date Filter",0D,"Period End")
          else
            MAUsageMonitor.SetRange("Date Filter","Period Start","Period End");
          MAUsageMonitor.ShowUsageEntries;
        end;
    end;
}

