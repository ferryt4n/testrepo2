page 74093 "MCH Master Maint. Task List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Master Maintenance Task List';
    CardPageID = "MCH Master Maint. Task Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Task,History,Work Order,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Master Maintenance Task";
    UsageCategory = Lists;

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
                field("Budgeted Cost Amount";"Budgeted Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Budgeted Hours";"Budgeted Hours")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Scheduling Work Order Type";"Scheduling Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsScheduleTrigger;
                }
                field("No. of Asset Maint. Tasks";"No. of Asset Maint. Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Ongoing Work Orders";"Ongoing Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Ongoing Planning Worksheet";"Ongoing Planning Worksheet")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("No. of Work Instructions";"No. of Work Instructions")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowAssignedWorkInstructions;
                    end;
                }
                field("No. of Attachments";"No. of Attachments")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowDocumentAttachments;
                    end;
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214028;"MCH Master Maint. Task FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Code=FIELD(Code);
            }
            part(Control1101214044;"MCH Master Maint.Task Dtl Fact")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Code=FIELD(Code);
            }
            systempart(Control1101214024;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214023;Links)
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

