page 74095 "MCH Maint. Task Budget"
{
    AutoSplitKey = true;
    Caption = 'Maintenance Task Budget';
    DataCaptionFields = "Task Code";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    PopulateAllFields = true;
    PromotedActionCategories = 'New,Process,Report,Line,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Maint. Task Budget Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "No.";
                ShowCaption = false;
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Hours;Hours)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Vendor Name";"Vendor Name")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    QuickEntry = false;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Resource Work Type Code";"Resource Work Type Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
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
            group(Control1101214008)
            {
                ShowCaption = false;
                fixed(Control1101214009)
                {
                    ShowCaption = false;
                    group(TaskCode2)
                    {
                        Caption = 'Task Code';
                        field("MasterMaintTask.Code";MasterMaintTask.Code)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            QuickEntry = false;
                            ShowCaption = false;
                        }
                    }
                    group(TaskDescription2)
                    {
                        Caption = 'Task Description';
                        field("MasterMaintTask.Description";MasterMaintTask.Description)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            QuickEntry = false;
                            ShowCaption = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                action(ShowCard)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View detailed information about the type of record on the line.';

                    trigger OnAction()
                    var
                        AMFunction: Codeunit "MCH AM Functions";
                    begin
                        AMFunction.GeneralShowTypeAccCard(Type,"No.");
                    end;
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(ShowAvailByLocation)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ShowItemAvailability(2);
                        end;
                    }
                    action(ShowAvailByPeriod)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ShowItemAvailability(0);
                        end;
                    }
                    action(ShowAvailByEvent)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ShowItemAvailability(4);
                        end;
                    }
                    action(ShowAvailByVariant)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ShowItemAvailability(1);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetDescriptions;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if ("Task Code" <> '') then begin
          if (xRec.Type > Type::" ") then
            Type := xRec.Type
          else
            Type := Type::Item;
        end;
        GetDescriptions;
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        if (GetFilter("Task Code") = '') then begin
          CurrPage.Editable(false);
        end;
        FilterGroup(0);
    end;

    var
        MasterMaintTask: Record "MCH Master Maintenance Task";

    local procedure GetDescriptions()
    begin
        if (MasterMaintTask.Code <> "Task Code") then begin
          if not MasterMaintTask.Get("Task Code") then
            Clear(MasterMaintTask);
        end;
    end;
}

