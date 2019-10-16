page 74149 "MCH Master Maint.Task Dtl Fact"
{
    Caption = 'Master Maint. Task - Details';
    Editable = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "MCH Master Maintenance Task";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = false;
                group(Control1101214043)
                {
                    ShowCaption = false;
                    field("Code";Code)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                        StyleExpr = StyleTxt;
                    }
                    field(Status;Status)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        Importance = Promoted;
                        StyleExpr = StyleTxt;
                    }
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    group(ShowDescription2Grp)
                    {
                        ShowCaption = false;
                        Visible = ShowDescription2;
                        field("Description 2";"Description 2")
                        {
                            ApplicationArea = Basic,Suite;
                            Visible = ShowDescription2;
                        }
                    }
                    field("Category Code";"Category Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Trigger Method";"Trigger Method")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    group(Control1101214044)
                    {
                        ShowCaption = false;
                        Visible = NOT IsManualTrigger;
                        field("Trigger Description";"Trigger Description")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            Importance = Promoted;
                            QuickEntry = false;
                        }
                    }
                    field("Expected Duration (Hours)";"Expected Duration (Hours)")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("No. of Asset Maint. Tasks";"No. of Asset Maint. Tasks")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("No. of Attachments";"No. of Attachments")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowDocumentAttachments;
                        end;
                    }
                    field("No. of Work Instructions";"No. of Work Instructions")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnDrillDown()
                        begin
                            Rec.ShowAssignedWorkInstructions;
                        end;
                    }
                }
            }
            group(Recurrence)
            {
                Caption = 'Recurrence';
                Enabled = IsRecurringTrigger;
                Visible = IsRecurringTrigger;
                group(Control1101214040)
                {
                    ShowCaption = false;
                    Visible = IsRecurringUsageTrigger;
                    field("Usage - Recur Every";"Usage - Recur Every")
                    {
                        ApplicationArea = Basic,Suite;
                        Enabled = IsRecurringUsageTrigger;
                        ShowMandatory = IsUsageTrigger;
                        Visible = IsRecurringUsageTrigger;
                    }
                }
                group(Control1101214038)
                {
                    ShowCaption = false;
                    Visible = IsCalendarTrigger;
                    field("Calendar Recurrence Type";"Calendar Recurrence Type")
                    {
                        ApplicationArea = Basic,Suite;
                        Enabled = IsCalendarTrigger;
                        Visible = IsCalendarTrigger;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    group(Control1101214036)
                    {
                        ShowCaption = false;
                        Visible = IsCalendarDaily;
                        field("Cal. Daily Type of Day";"Cal. Daily Type of Day")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarDaily;
                            Visible = false;

                            trigger OnValidate()
                            begin
                                CurrPage.Update;
                            end;
                        }
                        field("Cal. Daily Recur Every";"Cal. Daily Recur Every")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarDaily;
                            Visible = IsCalendarDaily;

                            trigger OnValidate()
                            begin
                                CurrPage.Update;
                            end;
                        }
                    }
                    group(Control1101214033)
                    {
                        ShowCaption = false;
                        Visible = IsCalendarWeekly;
                        field("Cal. Weekly Recur Every";"Cal. Weekly Recur Every")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;

                            trigger OnValidate()
                            begin
                                CurrPage.Update;
                            end;
                        }
                        field("Cal. Weekly on Monday";"Cal. Weekly on Monday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field("Cal. Weekly on Tuesday";"Cal. Weekly on Tuesday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field("Cal. Weekly on Wednesday";"Cal. Weekly on Wednesday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field("Cal. Weekly on Thursday";"Cal. Weekly on Thursday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field("Cal. Weekly on Friday";"Cal. Weekly on Friday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field("Cal. Weekly on Saturday";"Cal. Weekly on Saturday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field("Cal. Weekly on Sunday";"Cal. Weekly on Sunday")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarWeekly;
                            Visible = IsCalendarWeekly;
                        }
                        field(Placeholder;Placeholder)
                        {
                            ApplicationArea = Basic,Suite;
                            ShowCaption = false;
                            Visible = IsCalendarWeekly;
                        }
                    }
                    group(Control1101214023)
                    {
                        ShowCaption = false;
                        Visible = IsCalendarMonthly;
                        field("Cal. Monthly Pattern";"Cal. Monthly Pattern")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarMonthly;
                            Visible = IsCalendarMonthly;

                            trigger OnValidate()
                            begin
                                CurrPage.Update;
                            end;
                        }
                        group(Control1101214020)
                        {
                            ShowCaption = false;
                            Visible = IsCalendarMonthly AND IsCalendarFixedDayNo;
                            field("Cal. Monthly Fixed Day No.";"Cal. Monthly Fixed Day No.")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarMonthly AND IsCalendarFixedDayNo;
                                Visible = IsCalendarMonthly AND IsCalendarFixedDayNo;
                            }
                        }
                        group(Control1101214018)
                        {
                            ShowCaption = false;
                            Visible = IsCalendarMonthly AND IsCalendarRelativeDay;
                            field("Cal. Which Day in Month";"Cal. Which Day in Month")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarMonthly AND IsCalendarRelativeDay;
                                Visible = IsCalendarMonthly AND IsCalendarRelativeDay;
                            }
                            field("Cal. Type of Day";"Cal. Type of Day")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarMonthly AND IsCalendarRelativeDay;
                                Visible = IsCalendarMonthly AND IsCalendarRelativeDay;
                            }
                        }
                        field("Cal. Monthly Recur Every";"Cal. Monthly Recur Every")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarMonthly;
                            Visible = IsCalendarMonthly;
                        }
                    }
                    group(Control1101214015)
                    {
                        ShowCaption = false;
                        Visible = IsCalendarYearly;
                        field("Cal. Yearly Pattern";"Cal. Yearly Pattern")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarYearly;
                            Visible = IsCalendarYearly;

                            trigger OnValidate()
                            begin
                                CurrPage.Update;
                            end;
                        }
                        group(Control1101214012)
                        {
                            ShowCaption = false;
                            Visible = IsCalendarYearly AND IsCalendarFixedDayNo;
                            field("Cal. Yearly Month Name";"Cal. Yearly Month Name")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarYearly AND IsCalendarFixedDayNo;
                                Visible = IsCalendarYearly AND IsCalendarFixedDayNo;
                            }
                            field("Cal. Yearly Mth. Fixed Day No.";"Cal. Yearly Mth. Fixed Day No.")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarYearly AND IsCalendarFixedDayNo;
                                Visible = IsCalendarYearly AND IsCalendarFixedDayNo;
                            }
                        }
                        group(Control1101214009)
                        {
                            ShowCaption = false;
                            Visible = IsCalendarYearly AND IsCalendarRelativeDay;
                            field("Cal. Yearly in Month2";"Cal. Yearly Month Name")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarYearly AND IsCalendarRelativeDay;
                                Visible = IsCalendarYearly AND IsCalendarRelativeDay;
                            }
                            field("Cal. Day Type Index2";"Cal. Which Day in Month")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarYearly AND IsCalendarRelativeDay;
                                Visible = IsCalendarYearly AND IsCalendarRelativeDay;
                            }
                            field("Cal. Day Type2";"Cal. Type of Day")
                            {
                                ApplicationArea = Basic,Suite;
                                Enabled = IsCalendarYearly AND IsCalendarRelativeDay;
                                Visible = IsCalendarYearly AND IsCalendarRelativeDay;
                            }
                        }
                        field("Cal. Yearly Recur Every";"Cal. Yearly Recur Every")
                        {
                            ApplicationArea = Basic,Suite;
                            Enabled = IsCalendarYearly;
                            Visible = IsCalendarYearly;
                        }
                    }
                }
                field("Recurring Trigger Calc. Method";"Recurring Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsRecurringTrigger;
                    Importance = Promoted;
                    Visible = IsRecurringTrigger;
                }
            }
            group(Scheduling)
            {
                Caption = 'Scheduling';
                Enabled = IsScheduleTrigger;
                Visible = IsScheduleTrigger;
                field("Schedule Lead Time (Days)";"Schedule Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsScheduleTrigger;
                    Visible = IsScheduleTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                group(Control1101214048)
                {
                    ShowCaption = false;
                    Visible = IsUsageTrigger;
                    field("Usage Schedule-Ahead Tolerance";"Usage Schedule-Ahead Tolerance")
                    {
                        ApplicationArea = Basic,Suite;
                        Enabled = IsUsageTrigger;
                        Visible = IsUsageTrigger;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                }
                field("Scheduling Work Order Type";"Scheduling Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = IsScheduleTrigger;
                    Importance = Promoted;
                    Visible = IsScheduleTrigger;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableControls;
    end;

    trigger OnOpenPage()
    begin
        EnableControls;
    end;

    var
        [InDataSet]
        IsManualTrigger: Boolean;
        [InDataSet]
        IsRecurringTrigger: Boolean;
        [InDataSet]
        IsCalendarTrigger: Boolean;
        [InDataSet]
        IsCalendarDaily: Boolean;
        [InDataSet]
        IsCalendarWeekly: Boolean;
        [InDataSet]
        IsCalendarMonthly: Boolean;
        [InDataSet]
        IsCalendarYearly: Boolean;
        [InDataSet]
        IsCalendarFixedDayNo: Boolean;
        [InDataSet]
        IsCalendarRelativeDay: Boolean;
        [InDataSet]
        IsUsageTrigger: Boolean;
        [InDataSet]
        IsRecurringUsageTrigger: Boolean;
        [InDataSet]
        IsScheduleTrigger: Boolean;
        [InDataSet]
        ShowDescription2: Boolean;
        [InDataSet]
        StyleTxt: Text;
        Placeholder: Label 'Placeholder';

    local procedure EnableControls()
    begin
        StyleTxt := GetStatusStyleTxt;
        ShowDescription2 := ("Description 2" <> '');
        IsManualTrigger := false;
        IsRecurringTrigger := false;
        IsCalendarTrigger := false;
        IsCalendarDaily := false;
        IsCalendarWeekly := false;
        IsCalendarMonthly := false;
        IsCalendarYearly := false;
        IsCalendarFixedDayNo := false;
        IsCalendarRelativeDay := false;
        IsUsageTrigger := false;
        IsRecurringUsageTrigger := false;
        IsScheduleTrigger := true;

        case "Trigger Method" of
          "Trigger Method"::Manual:
            begin
              IsManualTrigger := true;
              IsScheduleTrigger := false;
            end;
          "Trigger Method"::"Calendar (Recurring)":
            begin
              IsRecurringTrigger := true;
              IsCalendarTrigger := true;
              case "Calendar Recurrence Type" of
                "Calendar Recurrence Type"::Daily :
                  IsCalendarDaily := true;
                "Calendar Recurrence Type"::Weekly :
                  IsCalendarWeekly := true;
                "Calendar Recurrence Type"::Monthly :
                  begin
                    IsCalendarMonthly := true;
                    case "Cal. Monthly Pattern" of
                      "Cal. Monthly Pattern"::"Recurring Day of Month" : ;
                      "Cal. Monthly Pattern"::"Fixed Day of Month" :
                        IsCalendarFixedDayNo := true;
                      "Cal. Monthly Pattern"::"Relative Day of Month" :
                        IsCalendarRelativeDay := true;
                    end
                  end;
                "Calendar Recurrence Type"::Yearly :
                  begin
                    IsCalendarYearly := true;
                    case "Cal. Yearly Pattern" of
                      "Cal. Yearly Pattern"::"Recurring Day of Month" : ;
                      "Cal. Yearly Pattern"::"Fixed Day of Month" :
                        IsCalendarFixedDayNo := true;
                      "Cal. Yearly Pattern"::"Relative Day of Month" :
                        IsCalendarRelativeDay := true;
                    end;
                  end;
                else ;
              end;
            end;
          "Trigger Method"::"Usage (Recurring)":
            begin
              IsRecurringTrigger := true;
              IsRecurringUsageTrigger := true;
              IsUsageTrigger := true;
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

