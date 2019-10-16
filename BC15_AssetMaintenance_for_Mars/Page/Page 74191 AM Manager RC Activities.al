page 74191 "MCH AM Manager RC Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    Permissions = TableData "MCH Asset Maintenance Cue" = rimd;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "MCH Asset Maintenance Cue";

    layout
    {
        area(content)
        {
            cuegroup("Ongoing Work Orders")
            {
                Caption = 'Ongoing Work Orders';
                field("Work Order Requests"; "Work Order Requests")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies work order requests that have not yet been converted to planned or released.';

                    trigger OnDrillDown()
                    begin
                        ShowWorkOrders(FieldNo("Work Order Requests"));
                    end;
                }
                field("Planned Work Orders"; "Planned Work Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies planned work orders that have not yet been converted to released.';

                    trigger OnDrillDown()
                    begin
                        ShowWorkOrders(FieldNo("Planned Work Orders"));
                    end;
                }
                field("Released Work Orders"; "Released Work Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies released work orders that have not yet been finished.';

                    trigger OnDrillDown()
                    begin
                        ShowWorkOrders(FieldNo("Released Work Orders"));
                    end;
                }
                field("Overdue Released Work Orders"; "Overdue Released Work Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies released work orders that have an expected ending date equal to or earlier than work date.';

                    trigger OnDrillDown()
                    begin
                        ShowWorkOrders(FieldNo("Overdue Released Work Orders"));
                    end;
                }
            }
            cuegroup("My User Tasks")
            {
                Caption = 'My User Tasks';
                field("Pending User Tasks"; UserTaskManagement.GetMyPendingUserTasksCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending User Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you or to a group that you are a member of.';

                    trigger OnDrillDown()
                    var
                        UserTaskList: Page "User Task List";
                    begin
                        UserTaskList.SetPageToShowMyPendingUserTasks;
                        UserTaskList.Run;
                    end;
                }
            }
            cuegroup("General Approvals")
            {
                Caption = 'General Approvals';
                field("Requests Sent for Approval"; "Requests Sent for Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Approval Entries";
                    ToolTip = 'Specifies requests for certain documents, cards, or journal lines that your approver must approve before you can proceed.';
                }
                field("Requests to Approve"; "Requests to Approve")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Requests to Approve";
                    ToolTip = 'Specifies requests for certain documents, cards, or journal lines that you must approve for other users before they can proceed.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueSetup: Codeunit "Cues And KPIs";
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;
        SetCueFilters;
    end;

    var
        UserTaskManagement: Codeunit "User Task Management";
        UserAssetRespGroupFilter: Text;

    local procedure CalculateCueFieldValues()
    begin
        SetCueFilters;
        "Work Order Requests" := CountWorkOrders(FieldNo("Work Order Requests"), UserAssetRespGroupFilter);
        "Planned Work Orders" := CountWorkOrders(FieldNo("Planned Work Orders"), UserAssetRespGroupFilter);
        "Released Work Orders" := CountWorkOrders(FieldNo("Released Work Orders"), UserAssetRespGroupFilter);
        "Overdue Released Work Orders" := CountWorkOrders(FieldNo("Overdue Released Work Orders"), UserAssetRespGroupFilter);
    end;

    local procedure SetCueFilters()
    begin
        SetFilter("User ID Filter", UserId);
        SetRange("Date Filter", 0D, WorkDate);
        SetFilter("Overdue Date Filter", '>%1&<=%2', 0D, WorkDate);
        UserAssetRespGroupFilter := GetUserAssetRespGroupFilter;
    end;
}

