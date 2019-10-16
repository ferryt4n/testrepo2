page 74150 "MCH Master Maint. Task Lookup"
{
    Caption = 'Master Maintenance Tasks';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Master Maintenance Task";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StatusStyleTxt;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Trigger Method";"Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Trigger Description";"Trigger Description")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StatusStyleTxt;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Schedule Lead Time (Days)";"Schedule Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsScheduleTrigger;
                }
                field("Calendar Recurrence Type";"Calendar Recurrence Type")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsCalendarTrigger;
                }
                field("Usage - Recur Every";"Usage - Recur Every")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsRecurrUsageTrigger;
                }
                field("Usage Schedule-Ahead Tolerance";"Usage Schedule-Ahead Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsUsageTrigger;
                }
                field("Recurring Trigger Calc. Method";"Recurring Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Duration (Hours)";"Expected Duration (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Scheduling Work Order Type";"Scheduling Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsScheduleTrigger;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(AdvancedView)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the Master Maint. Task List page showing all possible columns.';

                trigger OnAction()
                var
                    ListPage: Page "MCH Master Maint. Task List";
                begin
                    ListPage.SetRecord(Rec);
                    ListPage.LookupMode := true;
                    if ListPage.RunModal = ACTION::LookupOK then begin
                      ListPage.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StatusStyleTxt := GetStatusStyleTxt;
    end;

    trigger OnAfterGetRecord()
    begin
        StatusStyleTxt := GetStatusStyleTxt;
        EnableControls;
    end;

    var
        [InDataSet]
        StatusStyleTxt: Text;
        [InDataSet]
        IsUsageTrigger: Boolean;
        [InDataSet]
        IsScheduleTrigger: Boolean;
        [InDataSet]
        IsCalendarTrigger: Boolean;
        [InDataSet]
        IsRecurrUsageTrigger: Boolean;


    procedure GetSelectionFilter(): Text
    var
        MasterMaintTask: Record "MCH Master Maintenance Task";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MasterMaintTask);
        exit(PageFilterHelper.GetSelectionFilterForMasterMaintTask(MasterMaintTask));
    end;

    local procedure EnableControls()
    begin
        IsUsageTrigger := false;
        IsRecurrUsageTrigger := false;
        IsScheduleTrigger := true;
        IsCalendarTrigger := false;

        case "Trigger Method" of
          "Trigger Method"::Manual:
            begin
              IsScheduleTrigger := false;
            end;
          "Trigger Method"::"Calendar (Recurring)":
            begin
              IsCalendarTrigger := true;
            end;
          "Trigger Method"::"Usage (Recurring)":
            begin
              IsUsageTrigger := true;
              IsRecurrUsageTrigger := true;
            end;
          "Trigger Method"::"Fixed Date by Asset":
            begin
            end;
          "Trigger Method"::"Fixed Usage by Asset":
            begin
              IsUsageTrigger := true;
            end;
        end;
    end;
}

