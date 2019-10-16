page 74165 "MCH Asset MaintTask FCast Fact"
{
    Caption = 'Maintenance Forecast';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance Task";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = false;
                field("Trigger Description";"Trigger Description")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(IsScheduleTrigger)
            {
                Enabled = IsScheduleTrigger;
                ShowCaption = false;
                Visible = IsScheduleTrigger;
                field("Forecast Starting Date";ScheduleBuffer."Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Forecast Starting Date';
                    Visible = IsScheduleTrigger;
                }
                field("Lead Time (Days)";ScheduleBuffer."Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Lead Time (Days)';
                    Visible = IsScheduleTrigger;
                }
                field("Last Completion Date";ScheduleBuffer."Last Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Completion Date';
                    Visible = IsScheduleTrigger;
                }
                field("Last Scheduled Date";ScheduleBuffer."Last Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Scheduled Date';
                    Visible = IsScheduleTrigger;
                }
                group(IsUsageTrigger)
                {
                    ShowCaption = false;
                    Visible = IsUsageTrigger;
                    field("Scheduled Usage";ScheduleBuffer."Scheduled Usage")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Scheduled Usage';
                        DecimalPlaces = 0:5;
                        Visible = IsUsageTrigger;
                    }
                    field("Last Scheduled Usage";ScheduleBuffer."Last Scheduled Usage")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Last Scheduled Usage';
                        DecimalPlaces = 0:5;
                        Visible = IsUsageTrigger;
                    }
                    field("Last Actual Usage";ScheduleBuffer."Last Actual Usage")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Last Actual Usage';
                        DecimalPlaces = 0:5;
                        Visible = IsUsageTrigger;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
        if IsScheduleTrigger then
          CalcMaintForcastNext();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IsManualTrigger := true;
    end;

    trigger OnOpenPage()
    begin
        EnableControls;
    end;

    var
        ScheduleBuffer: Record "MCH Maint. Schedule Buffer" temporary;
        [InDataSet]
        IsManualTrigger: Boolean;
        [InDataSet]
        IsScheduleTrigger: Boolean;
        [InDataSet]
        IsDateTrigger: Boolean;
        [InDataSet]
        IsUsageTrigger: Boolean;

    local procedure EnableControls()
    begin
        IsScheduleTrigger := true;
        IsManualTrigger := false;
        IsDateTrigger := false;
        IsUsageTrigger := false;
        case "Trigger Method" of
          "Trigger Method"::Manual:
            begin
              IsManualTrigger := true;
              IsScheduleTrigger := false;
            end;
          "Trigger Method"::"Calendar (Recurring)":
            begin
              IsDateTrigger := true;
            end;
          "Trigger Method"::"Usage (Recurring)":
            begin
              IsUsageTrigger := true;
            end;
          "Trigger Method"::"Fixed Date":
            begin
              IsDateTrigger := true;
            end;
          "Trigger Method"::"Fixed Usage":
            begin
              IsUsageTrigger := true;
            end;
        end;
    end;

    local procedure CalcMaintForcastNext()
    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        AMScheduleMgt: Codeunit "MCH AM Schedule Mgt.";
    begin
        AssetMaintTask := Rec;
        Clear(ScheduleBuffer);
        if AMScheduleMgt.CalcMaintTaskForNextForecastOnly(AssetMaintTask) then
          AMScheduleMgt.ShareResultScheduleBuffer(ScheduleBuffer);
    end;
}

