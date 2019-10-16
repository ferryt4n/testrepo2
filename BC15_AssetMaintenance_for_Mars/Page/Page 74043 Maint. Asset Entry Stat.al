page 74043 "MCH Maint. Asset Entry Stat."
{
    Caption = 'Asset Entry Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "MCH Maintenance Asset";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(AssetMaintTaskCodeFilter;AssetMaintTaskCodeFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maint. Task Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AssetMaintTaskList: Page "MCH Asset Maint. Task List";
                        AssetMaintTask: Record "MCH Asset Maintenance Task";
                    begin
                        AssetMaintTask.FilterGroup(2);
                        AssetMaintTask.SetRange("Asset No.","No.");
                        AssetMaintTask.FilterGroup(0);
                        AssetMaintTaskList.LookupMode := true;
                        if AssetMaintTaskList.RunModal = ACTION::LookupOK then
                          Text := AssetMaintTaskList.GetSelectionFilter
                        else
                          exit(false);
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SetFilter("Maint. Task Filter",AssetMaintTaskCodeFilter);
                        UpdateSubpage;
                    end;
                }
                field(UsageType;UsageType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show as Columns';
                    OptionCaption = 'Cost Amount,Hours';

                    trigger OnValidate()
                    begin
                        UpdateSubpage;
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Day';

                    trigger OnValidate()
                    begin
                        UpdateSubpage;
                    end;
                }
                field(ValueType;ValueType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Net Change';

                    trigger OnValidate()
                    begin
                        UpdateSubpage;
                    end;
                }
            }
            part(StatLines;"MCH MA Entry Stat. Lines")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        AssetMaintTaskCodeFilter := GetFilter("Maint. Task Filter");
        UpdateSubpage;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        AssetMaintTaskCodeFilter := GetFilter("Maint. Task Filter");
    end;

    var
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;
        ValueType: Option "Net Change","Balance at Date";
        UsageType: Option "Cost Amount",Hours;
        AssetMaintTaskCodeFilter: Text;

    local procedure UpdateSubpage()
    begin
        CurrPage.StatLines.PAGE.Set(Rec,PeriodType,ValueType,UsageType);
    end;
}

