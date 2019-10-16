page 74145 "MCH Asset Usage Monitor Trend"
{
    Caption = 'Usage Reading Trendscape';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "MCH Asset Usage Monitor";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View by';
                    Importance = Promoted;
                    OptionCaption = 'Day,Week,Month,Quarter,Year';

                    trigger OnValidate()
                    begin
                        UpdateSubPage;
                    end;
                }
            }
            part(Subform;"MCH Asset Usage Mon. Trend Ln")
            {
                ApplicationArea = Basic,Suite;
            }
        }
        area(factboxes)
        {
            part(Control1101214001;"MCH Asset Usage Monitor FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Monitor Code"=FIELD("Monitor Code");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        MAUsageEntry.SetRange("Asset No.","Asset No.");
        MAUsageEntry.SetRange("Monitor Code","Monitor Code");
        MAUsageEntry.SetRange(Cancelled,false);
        if MAUsageEntry.FindFirst then begin
          FirstReadingDate := MAUsageEntry."Reading Date";
          MAUsageEntry.FindLast;
          LastReadingDate := MAUsageEntry."Reading Date";
        end else begin
          FirstReadingDate := 0D;
          LastReadingDate := 0D;
        end;
        UpdateSubPage;
    end;

    trigger OnOpenPage()
    begin
        MAUsageEntry.SetCurrentKey("Asset No.","Monitor Code",Cancelled,"Reading Date","Reading Time");
    end;

    var
        MAUsageEntry: Record "MCH Usage Monitor Entry";
        FirstReadingDate: Date;
        LastReadingDate: Date;
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;

    local procedure UpdateSubPage()
    begin
        CurrPage.Subform.PAGE.Set(Rec,PeriodType,FirstReadingDate,LastReadingDate);
    end;
}

