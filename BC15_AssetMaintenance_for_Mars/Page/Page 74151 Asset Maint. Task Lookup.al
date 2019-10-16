page 74151 "MCH Asset Maint. Task Lookup"
{
    Caption = 'Asset Maintenance Tasks';
    DataCaptionFields = "Asset No.","Task Code";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance Task";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Task Code";
                ShowCaption = false;
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Trigger Method";"Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = MasterStyleTxt;
                }
                field("Trigger Description";"Trigger Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    QuickEntry = false;
                    StyleExpr = MasterStyleTxt;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Effective Date";"Effective Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Scheduled Date";"Last Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Completion Date";"Last Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage Monitor Code";"Usage Monitor Code")
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
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Task Status";"Master Task Status")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Importance = Promoted;
                    StyleExpr = MasterStyleTxt;
                }
                field("Starting Value (Recurr. Usage)";"Starting Value (Recurr. Usage)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expiry Value (Recurr. Usage)";"Expiry Value (Recurr. Usage)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Task Description";"Master Task Description")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Asset Resp. Group Code";"Asset Resp. Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
                ToolTip = 'Open the Asset Maint. Task List page showing all possible columns.';

                trigger OnAction()
                var
                    ListPage: Page "MCH Asset Maint. Task List";
                begin
                    ListPage.SetTableView(Rec);
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

    trigger OnAfterGetRecord()
    begin
        EnableControls;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnAssetResponsibilityGroup(2);
    end;

    var
        [InDataSet]
        StyleTxt: Text;
        [InDataSet]
        MasterStyleTxt: Text;
        [InDataSet]
        IsCalendarTrigger: Boolean;
        [InDataSet]
        IsFixedDateTrigger: Boolean;
        [InDataSet]
        IsRecurringUsageTrigger: Boolean;
        [InDataSet]
        IsFixedUsageTrigger: Boolean;
        [InDataSet]
        EnableUsageMonitor: Boolean;
        [InDataSet]
        HasUsageMonitor: Boolean;


    procedure GetSelectionFilter(): Text
    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(AssetMaintTask);
        exit(PageFilterHelper.GetSelectionFilterForAssetMaintTask(AssetMaintTask));
    end;

    local procedure EnableControls()
    begin
        StyleTxt := GetStyleTxt;
        MasterStyleTxt := GetMasterStyleTxt;

        IsCalendarTrigger := false;
        IsRecurringUsageTrigger := false;
        IsFixedDateTrigger := false;
        IsFixedUsageTrigger := false;
        EnableUsageMonitor := false;
        HasUsageMonitor := ("Usage Monitor Code" <> '');

        case "Trigger Method" of
          "Trigger Method"::Manual:
            begin
              EnableUsageMonitor := true;
            end;
          "Trigger Method"::"Calendar (Recurring)":
            begin
              IsCalendarTrigger := true;
            end;
          "Trigger Method"::"Usage (Recurring)":
            begin
              IsRecurringUsageTrigger := true;
              EnableUsageMonitor := true;
            end;
          "Trigger Method"::"Fixed Date":
            begin
              IsFixedDateTrigger := true;
            end;
          "Trigger Method"::"Fixed Usage":
            begin
              IsFixedUsageTrigger :=true;
              EnableUsageMonitor := true;
            end;
        end;
    end;
}

