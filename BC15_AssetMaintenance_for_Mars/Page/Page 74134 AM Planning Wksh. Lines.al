page 74134 "MCH AM Planning Wksh. Lines"
{
    Caption = 'Maint. Planning Worksheet Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "MCH AM Planning Wksh. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Asset No.";
                ShowCaption = false;
                field("Worksheet Template Name";"Worksheet Template Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Description";"Task Description")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Task Scheduled Date";"Task Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Scheduled Usage Value";"Task Scheduled Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Location Code";"Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Category Code";"Asset Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Budgeted Cost Amount";"Budgeted Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
                field("Budgeted Hours";"Budgeted Hours")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
                field("Last Modified By";"Last Modified By")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Batch")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Batch';
                Image = ViewDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Show the worksheet batch that the line is based on.';

                trigger OnAction()
                var
                    PlanningWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
                    PlanningWkshLine: Record "MCH AM Planning Wksh. Line";
                begin
                    if "Line No." = 0 then
                      exit;
                    PlanningWkshTemplate.Get("Worksheet Template Name");
                    PlanningWkshLine := Rec;
                    PlanningWkshLine.FilterGroup(2);
                    PlanningWkshLine.SetRange("Worksheet Template Name","Worksheet Template Name");
                    PlanningWkshLine.SetRange("Journal Batch Name","Journal Batch Name");
                    PlanningWkshLine.FilterGroup(0);
                    PAGE.Run(PlanningWkshTemplate."Page ID",PlanningWkshLine);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
    end;
}

