page 74034 "MCH Asset - Maint. Task FactBL"
{
    Caption = 'Maintenance Tasks';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Asset Maintenance Task";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Task Code";
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Trigger Method";"Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
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
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Task Status";"Master Task Status")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Card)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Card';
                Enabled = EnableControls;
                Image = ServiceTasks;
                RunObject = Page "MCH Asset Maint. Task Card";
                RunPageMode = View;
                RunPageOnRec = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        EnableControls := false;
    end;

    var
        [InDataSet]
        EnableControls: Boolean;
}

