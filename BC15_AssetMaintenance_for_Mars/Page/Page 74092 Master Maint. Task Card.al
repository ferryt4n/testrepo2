page 74092 "MCH Master Maint. Task Card"
{
    Caption = 'Master Maintenance Task Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Task,History,Work Order,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Master Maintenance Task";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = EnableSetup;
                group(Control1101214043)
                {
                    ShowCaption = false;
                    field("Code";Code)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                        StyleExpr = StyleTxt;

                        trigger OnAssistEdit()
                        begin
                            if AssistEdit(xRec) then
                              CurrPage.Update;
                        end;
                    }
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    field("Description 2";"Description 2")
                    {
                        ApplicationArea = Basic,Suite;
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
                    field(DynamicTriggerDescription;FindTriggerMethodDescription)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Trigger Description';
                        Editable = false;
                        Importance = Promoted;
                        QuickEntry = false;
                    }
                }
                group(Control1101214044)
                {
                    ShowCaption = false;
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
                    }
                    field("Budgeted Cost Amount";"Budgeted Cost Amount")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Budgeted Hours";"Budgeted Hours")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field(Status;Status)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        Importance = Promoted;
                        StyleExpr = StyleTxt;
                    }
                }
            }
            group(Recurrence)
            {
                Caption = 'Recurrence';
                Editable = EnableSetup;
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
                Editable = EnableSetup;
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
            part(Control1101214061;"MCH Work Instr. Setup Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Table Name"=CONST("Maint. Task"),
                              Code=FIELD(Code);
            }
        }
        area(factboxes)
        {
            part(Control1101214060;"MCH Master Maint. Task FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Code=FIELD(Code);
            }
            systempart(Control1101214053;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214052;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Status to Active")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Active';
                Enabled = Status <> Status::Active;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to Active. The task can be selected on work orders with this status.';

                trigger OnAction()
                begin
                    SetStatus(Status::Active,true);
                end;
            }
            action("Set Status to Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Setup';
                Enabled = Status <> Status::Setup;
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to Setup to edit task settings. The task cannot be selected on work orders with this status and is also excluded on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::Setup,false);
                end;
            }
            action("Set Status to On Hold")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to On Hold';
                Enabled = Status <> Status::"On Hold";
                Image = Pause;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to On Hold. The task cannot be selected on work orders with this status and is also excluded on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::"On Hold",true);
                end;
            }
            action("Set Status to Blocked")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Blocked';
                Enabled = Status <> Status::Blocked;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to Blocked. The task cannot be selected on work orders with this status and is also excluded on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::Blocked,true);
                end;
            }
            group(Task)
            {
                Caption = 'Task';
                action(Budget)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Budget';
                    Image = CostAccountingSetup;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowBudget;
                    end;
                }
                action("Asset Maint. Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Maint. Tasks';
                    Image = ServiceTasks;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "MCH Asset Maint. Task List";
                    RunPageLink = "Task Code"=FIELD(Code);
                }
                action(WorkInstructions)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Instructions';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "MCH Work Instrution Setup";
                    RunPageLink = Code=FIELD(Code);
                    RunPageView = SORTING("Table Name",Code,"Work Instruction No.")
                                  WHERE("Table Name"=CONST("Maint. Task"));
                }
                action(Attachments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocumentAttachments;
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Maint. Task Code"=FIELD(Code);
                    RunPageView = SORTING("Asset No.","Maint. Task Code",Type,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Finished Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Finished Work Orders';
                    Image = PostedServiceOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Task Code"=FIELD(Code);
                    RunPageView = SORTING("Task Code")
                                  WHERE(Status=CONST(Finished));
                }
            }
            group("Work Order")
            {
                Caption = 'Work Order';
                action("Work Order Requests")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Order Requests';
                    Image = ServiceLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Task Code"=FIELD(Code);
                    RunPageView = SORTING("Task Code")
                                  WHERE(Status=CONST(Request));
                }
                action("Planned Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Planned Work Orders';
                    Image = ServiceLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Task Code"=FIELD(Code);
                    RunPageView = SORTING("Task Code")
                                  WHERE(Status=CONST(Planned));
                }
                action("Released Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Released Work Orders';
                    Image = ServiceLines;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunObject = Page "MCH Work Order Lines";
                    RunPageLink = "Task Code"=FIELD(Code);
                    RunPageView = SORTING("Task Code")
                                  WHERE(Status=CONST(Released));
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableControls;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetRange("Trigger Method");
        "Trigger Method" := "Trigger Method"::Manual;
        SetRange(Status);
        Status := Status::Setup;
        EnableSetup := true;

        EnableControls;
    end;

    trigger OnOpenPage()
    begin
        EnableControls;
    end;

    var
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
        StyleTxt: Text;
        [InDataSet]
        EnableSetup: Boolean;
        Placeholder: Label 'Placeholder';

    local procedure EnableControls()
    begin
        StyleTxt := GetStatusStyleTxt;
        EnableSetup := (Status = Status::Setup);

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

