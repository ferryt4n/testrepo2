page 74030 "MCH Asset Maintenance Setup"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Maintenance Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Maintenance Asset")
            {
                Caption = 'Maintenance Asset';
                field("Asset Category Mandatory";"Asset Category Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Fixed Maint. Loc. Mand.";"Asset Fixed Maint. Loc. Mand.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Resp. Group Mandatory";"Asset Resp. Group Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group("Work Order")
            {
                Caption = 'Work Order';
                field("Work Order Line Restriction";"Work Order Line Restriction")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you only will allow one line per work order.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Work Order Type Mandatory";"Work Order Type Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("WO Progress Status Mandatory";"WO Progress Status Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("WO Person Respons. Mandatory";"WO Person Respons. Mandatory")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field("Use WO No. as Posting Doc. No.";"Use WO No. as Posting Doc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you only allow one line per work order.';
                }
                field("Post Team Timesheet Res. Ledg.";"Post Team Timesheet Res. Ledg.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Res. No. Mandatory - Invt.Iss";"Res. No. Mandatory - Invt.Iss")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Res. No. Mandatory - Invt.Rtrn";"Res. No. Mandatory - Invt.Rtrn")
                {
                    ApplicationArea = Basic,Suite;
                }
                group("Work Order Budget")
                {
                    Caption = 'Work Order Budget';
                    field("WO Invt. Usage to Budget Link";"WO Invt. Usage to Budget Link")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("WO Purchase to Budget Link";"WO Purchase to Budget Link")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("WO Timesheet to Budget Link";"WO Timesheet to Budget Link")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
                group("Usage Monitor")
                {
                    Caption = 'Usage Monitor';
                    field("Usage Allowed ReadingDate Base";"Usage Allowed ReadingDate Base")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the Base Date that is used when calculating the date range (window) within which usage monitor readings are allowed. The from/to dates in the range are determined by settings per Master Usage Monitor.';
                    }
                    field("Usage Meter Duplicate Reading";"Usage Meter Duplicate Reading")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if registering of Meter duplicate usage readings are allowed. A new usage monitor reading is a duplicate when an entry already exists with the same date, time and reading value.';
                    }
                    field("Usage Trans. Duplicate Reading";"Usage Trans. Duplicate Reading")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if registering of Transactional duplicate usage readings are allowed. A new usage monitor reading is a duplicate when an entry already exists with the same date, time and reading value.';
                    }
                }
            }
            group("Maint. Schedule and Forecast")
            {
                Caption = 'Maintenance Schedule and Forecast';
                group(Scheduling)
                {
                    Caption = 'Scheduling';
                    field("Def. Sched. Look Ahead (Days)";"Def. Sched. Look Ahead (Days)")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the Default number of days within a Scheduling period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Def. Sched. Task Recurr. Limit";"Def. Sched. Task Recurr. Limit")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the Default max. number of times (days) that a Recurring task will occur within a Scheduling period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Max. Sched. Look Ahead (Days)";"Max. Sched. Look Ahead (Days)")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the System Maximum number of days allowed within a Scheduling period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Schedule Task Recurr. Limit";"Schedule Task Recurr. Limit")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the maximum allowed number of times (days) that a Recurring task can occur within a Scheduling period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                }
                group(Forecasting)
                {
                    Caption = 'Forecasting';
                    field("Def. FCast Look Ahead (Days)";"Def. FCast Look Ahead (Days)")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the Default number of days within a maintenance Forecast period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Def. FCast Task Recurr. Limit";"Def. FCast Task Recurr. Limit")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the Default max. number of times (days) that a Recurring task will occur within a maintenance Forecast period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Forecast Look Ahead (Days)";"Forecast Look Ahead (Days)")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the System Maximum number of days allowed within a maintenance Forecast period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Forecast Task Recurr. Limit";"Forecast Task Recurr. Limit")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the maximum allowed number of times (days) that a Recurring task can occur within a maintenance Forecast period.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                }
            }
            group(Defaults)
            {
                Caption = 'Defaults';
                field("Def. Inventory Location Code";"Def. Inventory Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Def. Work Order Priority";"Def. Work Order Priority")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Def. WO Type on Request";"Def. WO Type on Request")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Asset Nos.";"Asset Nos.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Nos.";"Work Order Nos.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maintenance Task Nos.";"Maintenance Task Nos.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Instructions Nos.";"Work Instructions Nos.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Spare Part Nos.";"Spare Part Nos.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214009;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214008;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
          AMFunctions.InitializeAMReportSelection;
        end;
    end;
}

