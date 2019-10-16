report 74044 "MCH Create Work Order"
{
    Caption = 'Create Work Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number=CONST(1));

            trigger OnPreDataItem()
            begin
                MA.Get(MANo);
                WorkOrder.Init;
                case WorkOrderStatus of
                  WorkOrderStatus::Request:
                    WorkOrder.Status := WorkOrder.Status::Request;
                  WorkOrderStatus::Planned:
                    WorkOrder.Status := WorkOrder.Status::Planned;
                  WorkOrderStatus::Released:
                    WorkOrder.Status := WorkOrder.Status::Released;
                end;


                WorkOrder.Insert(true);
                if NewStartingDate <> 0D then
                  WorkOrder.Validate("Starting Date",NewStartingDate);
                if WorkOrderType.Code <> '' then
                  WorkOrder.Validate("Work Order Type",WorkOrderType.Code);
                WorkOrder.Modify(true);

                WorkOrderLine.Status := WorkOrder.Status;
                WorkOrderLine."Work Order No." := WorkOrder."No.";
                WorkOrderLine."Line No." := 10000;
                WorkOrderLine.Insert(true);
                WorkOrderLine.Validate("Asset No.",MANo);
                WorkOrderLine.Modify;

                Commit;
                WorkOrder.ShowCard();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Options - New Work Order")
                {
                    Caption = 'Options - New Work Order';
                    field(MANo;MANo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Asset No.';
                        Editable = false;
                    }
                    field(WorkOrderStatus;WorkOrderStatus)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Status';
                    }
                    field(NewStartingDate;NewStartingDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Starting Date';
                    }
                    field("Work Order Type";WorkOrderType.Code)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Work Order Type';
                        DrillDown = false;
                        Lookup = true;
                        LookupPageID = "MCH Work Order Type Lookup";
                        TableRelation = "MCH Work Order Type".Code WHERE (Blocked=CONST(false));
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            NewStartingDate := WorkDate;
        end;
    }

    labels
    {
    }

    var
        WorkOrder: Record "MCH Work Order Header";
        WorkOrderLine: Record "MCH Work Order Line";
        MA: Record "MCH Maintenance Asset";
        WorkOrderType: Record "MCH Work Order Type";
        NewStartingDate: Date;
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        WorkOrderStatus: Option Request,Planned,Released;
        WorkOrderNo: Code[20];
        MANo: Code[20];


    procedure SetMANo(NewMANo: Code[20])
    begin
        MANo := NewMANo;
    end;
}

