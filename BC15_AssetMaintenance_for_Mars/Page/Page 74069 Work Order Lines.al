page 74069 "MCH Work Order Lines"
{
    Caption = 'Work Order Lines';
    DataCaptionFields = Status,"Work Order No.","Asset No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "MCH Work Order Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Asset No.";
                ShowCaption = false;
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Ending Date";"Ending Date")
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
                field("Work Order Description";"Work Order Description")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Description";"Task Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Duration (Hours)";"Expected Duration (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Task Trigger Method";"Task Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = "Task Code"='';
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
                field("Progress Status Code";"Progress Status Code")
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
                }
                field("Completion Date";"Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage on Completion";"Usage on Completion")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Def. Invt. Location Code";"Def. Invt. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Line No.";"Line No.")
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
            action("Show Work Order")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Work Order';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                var
                    WorkOrder: Record "MCH Work Order Header";
                begin
                    WorkOrder.Get(Status,"Work Order No.");
                    WorkOrder.ShowCard;
                end;
            }
            action(Dimensions)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    ShowDims;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnResponsibilityGroup(2);
    end;
}

