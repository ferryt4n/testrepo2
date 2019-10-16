page 74031 "MCH AM Report Selection"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Report Selection - Asset Maintenance';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "MCH AM Report Selections";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field(ReportUsage2;ReportUsage2)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage';
                OptionCaption = 'Work Order Request,Planned Work Order,Released Work Order,Finished Work Order';

                trigger OnValidate()
                begin
                    SetUsageFilter;
                    CurrPage.Update;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    LookupPageID = Objects;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;

    trigger OnOpenPage()
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        AMFunctions.InitializeAMReportSelection;
        SetUsageFilter;
    end;

    var
        ReportUsage2: Option "Work Order Request","Planned Work Order","Released Work Order","Finished Work Order";

    local procedure SetUsageFilter()
    begin
        FilterGroup(2);
        case ReportUsage2 of
          ReportUsage2::"Work Order Request":
            SetRange(Usage,Usage::"Work Order Request");
          ReportUsage2::"Planned Work Order":
            SetRange(Usage,Usage::"Planned Work Order");
          ReportUsage2::"Released Work Order":
            SetRange(Usage,Usage::"Released Work Order");
          ReportUsage2::"Finished Work Order":
            SetRange(Usage,Usage::"Finished Work Order");
        end;
        FilterGroup(0);
    end;
}

