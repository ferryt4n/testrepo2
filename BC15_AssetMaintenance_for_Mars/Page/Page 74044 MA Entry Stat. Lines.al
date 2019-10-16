page 74044 "MCH MA Entry Stat. Lines"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
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
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Value[10]";Value[10])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(10);
                    end;
                }
                field("Value[1]";Value[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    BlankZero = true;
                    Caption = 'Inventory';
                    Visible = NOT IsHourUsage;

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(1);
                    end;
                }
                field("Value[2]";Value[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    BlankZero = true;
                    Caption = 'Spare Parts';
                    DrillDown = true;
                    Visible = NOT IsHourUsage;

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(2);
                    end;
                }
                field("Value[3]";Value[3])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    BlankZero = true;
                    Caption = 'Cost Type';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(3);
                    end;
                }
                field("Value[4]";Value[4])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    BlankZero = true;
                    Caption = 'Resources';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(4);
                    end;
                }
                field("Value[5]";Value[5])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    BlankZero = true;
                    Caption = 'Teams';

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(5);
                    end;
                }
                field("Value[6]";Value[6])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = FormatStr;
                    AutoFormatType = 10;
                    BlankZero = true;
                    Caption = 'Trades';

                    trigger OnDrillDown()
                    begin
                        DrillDowmAMLedger(6);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetDateFilter;
        Clear(Value);
        for i := 1 to 6 do begin
          MaintAsset.SetRange("Type Filter",i);
          case UsageType of
            UsageType::"Cost Amount" :
              begin
                MaintAsset.CalcFields("Cost Amount");
                Value[i] := MaintAsset."Cost Amount";
              end;
            UsageType::Hour :
              begin
                MaintAsset.CalcFields(Hours);
                Value[i] := MaintAsset.Hours;
              end;
          end;
          Value[10] := Value[10] + Value[i];
        end;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,PeriodLength));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,PeriodLength));
    end;

    trigger OnOpenPage()
    begin
        Reset;
        GLSetup.Get;
        AmountFormatString := '<Precision,' + GLSetup."Amount Decimal Places" + '><Standard Format,0>';
        HourFormatString := '<Precision,2:5><Standard Format,0>';
    end;

    var
        MaintAsset: Record "MCH Maintenance Asset";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodLength: Option Day,Week,Month,Quarter,Year,Period;
        ValueType: Option "Net Change","Balance at Date";
        UsageType: Option "Cost Amount",Hour;
        Value: array [10] of Decimal;
        AmountFormatString: Text;
        HourFormatString: Text;
        FormatStr: Text;
        i: Integer;
        [InDataSet]
        IsHourUsage: Boolean;


    procedure Set(var NewMaintAsset: Record "MCH Maintenance Asset";NewPeriodLength: Integer;NewValueType: Option "Net Change","Balance at Date";NewUsageType: Option "Cost Amount",Hour)
    begin
        MaintAsset.Copy(NewMaintAsset);
        PeriodLength := NewPeriodLength;
        ValueType := NewValueType;
        UsageType := NewUsageType;
        IsHourUsage := false;
        case UsageType of
          UsageType::"Cost Amount" :
            FormatStr := AmountFormatString;
          UsageType::Hour :
            begin
              FormatStr := HourFormatString;
              IsHourUsage := true;
            end;
        end;
        CurrPage.Update(false);
    end;

    local procedure SetDateFilter()
    begin
        if ValueType = ValueType::"Net Change" then
          MaintAsset.SetRange("Date Filter","Period Start","Period End")
        else
          MaintAsset.SetRange("Date Filter",0D,"Period End");
    end;


    procedure DrillDowmAMLedger(Type: Option)
    begin
        SetDateFilter;
        AMLedgEntry.Reset;
        AMLedgEntry.SetCurrentKey("Asset No.","Maint. Task Code",Type,"Posting Date");
        AMLedgEntry.SetRange("Asset No.",MaintAsset."No.");
        MaintAsset.CopyFilter(MaintAsset."Maint. Task Filter",AMLedgEntry."Maint. Task Code");
        if Type < 10 then
          AMLedgEntry.SetRange(Type,Type);
        AMLedgEntry.SetFilter("Posting Date",MaintAsset.GetFilter("Date Filter"));
        PAGE.Run(0,AMLedgEntry);
    end;
}

