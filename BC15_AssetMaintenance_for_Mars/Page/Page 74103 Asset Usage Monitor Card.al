page 74103 "MCH Asset Usage Monitor Card"
{
    Caption = 'Asset Usage Monitor Card';
    DataCaptionExpression = Caption;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Usage Monitor";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control1101214010)
                {
                    ShowCaption = false;
                    field("Asset No.";"Asset No.")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    field("Monitor Code";"Monitor Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                        StyleExpr = StyleTxt;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AssetUsageMonitor: Record "MCH Asset Usage Monitor";
                            MasterUsageMonitor: Record "MCH Master Usage Monitor";
                            MasterUsageMonitorList: Page "MCH Master Usage Monitors";
                            [InDataSet]
                            InsertMode: Boolean;
                        begin
                            InsertMode := not AssetUsageMonitor.Get("Asset No.","Monitor Code");
                            MasterUsageMonitor.Code := "Monitor Code";
                            if (MasterUsageMonitor.Code <> '') then
                              MasterUsageMonitorList.SetRecord(MasterUsageMonitor);
                            if InsertMode then begin
                              MasterUsageMonitor.SetCurrentKey(Status);
                              MasterUsageMonitor.SetFilter(Status,'%1|%2',MasterUsageMonitor.Status::"On Hold",MasterUsageMonitor.Status::Active);
                              MasterUsageMonitorList.SetTableView(MasterUsageMonitor);
                              MasterUsageMonitorList.LookupMode := true;
                              if MasterUsageMonitorList.RunModal = ACTION::LookupOK then begin
                                if CurrPage.Editable then begin
                                  MasterUsageMonitorList.GetRecord(MasterUsageMonitor);
                                  Text := MasterUsageMonitor.Code;
                                  exit(true);
                                end;
                              end;
                            end else begin
                              MasterUsageMonitorList.Run;
                            end;
                            exit(false);
                        end;
                    }
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        StyleExpr = StyleTxt;
                    }
                    field("Description 2";"Description 2")
                    {
                        ApplicationArea = Basic,Suite;
                        StyleExpr = StyleTxt;
                        Visible = false;
                    }
                    field(Position;Position)
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Unit of Measure Code";"Unit of Measure Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    field("Serial No.";"Serial No.")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Identifier Code";"Identifier Code")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Next Calibration Date";"Next Calibration Date")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Last Calibration Date";"Last Calibration Date")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
                group(Control1101214011)
                {
                    ShowCaption = false;
                    field("Total Usage";"Total Usage")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Last Reading Date";"Last Reading Date")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowLastUsageEntry;
                        end;
                    }
                    field(FindLastReadingValue;FindLastReadingValue)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Last Reading Value';
                        DecimalPlaces = 0:5;
                        Visible = false;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowLastUsageEntry;
                        end;
                    }
                    field(FindLastUsageValue;FindLastUsageValue)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Last Usage Value';
                        DecimalPlaces = 0:5;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowLastUsageEntry;
                        end;
                    }
                    field("First Reading Date";"First Reading Date")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowFirstUsageEntry;
                        end;
                    }
                    field("Category Code";"Category Code")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Reading Type";"Reading Type")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        ToolTip = 'Specifies the type of reading values to record: Meter: E.g. odometer balance-forward readings where usage is calculated based on the previous (date/time) registered reading. Transactional: E.g. fuel consumption.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Master Monitor Status";"Master Monitor Status")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                    }
                    field(Blocked;Blocked)
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Asset Description";"Asset Description")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Visible = false;
                    }
                    field("Master Monitor Description";"Master Monitor Description")
                    {
                        ApplicationArea = Basic,Suite;
                        Lookup = false;
                        Visible = false;
                    }
                    field("Created By";"Created By")
                    {
                        ApplicationArea = Basic,Suite;
                        Visible = false;
                    }
                    field("Created Date-Time";"Created Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Visible = false;
                    }
                    field("Last Modified By";"Last Modified By")
                    {
                        ApplicationArea = Basic,Suite;
                        Visible = false;
                    }
                    field("Last Modified Date-Time";"Last Modified Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Visible = false;
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214021;"MCH Asset Usage Monitor Pict.")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Monitor Code"=FIELD("Monitor Code");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ShowMACard)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Asset';
                Image = ServiceItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "MCH Maintenance Asset Card";
                RunPageLink = "No."=FIELD("Asset No.");
                ShortCutKey = 'Shift+F7';
            }
            action(ShowUsageTrendscape)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage &Trendscape';
                Image = EntryStatistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.ShowTrendscape;
                end;
            }
            action(ShowUsageEntries)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage E&ntries';
                Image = CapacityLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+F7';

                trigger OnAction()
                begin
                    Rec.ShowUsageEntries;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxt;
    end;

    var
        [InDataSet]
        StyleTxt: Text;
}

