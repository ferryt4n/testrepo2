table 74103 "MCH Asset Maintenance Cue"
{
    Caption = 'Asset Maintenance Cue';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2;"Work Order Requests";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Request)));
            Caption = 'Work Order Requests';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Planned Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Planned)));
            Caption = 'Planned Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Released Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Released)));
            Caption = 'Released Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Finished Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Finished)));
            Caption = 'Finished Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Overdue Released Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Released),
                                                               "Expected Ending Date"=FIELD("Overdue Date Filter")));
            Caption = 'Overdue Released Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Requests to Approve";Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE ("Approver ID"=FIELD("User ID Filter"),
                                                        Status=FILTER(Open)));
            Caption = 'Requests to Approve';
            FieldClass = FlowField;
        }
        field(51;"Requests Sent for Approval";Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE ("Sender ID"=FIELD("User ID Filter"),
                                                        Status=FILTER(Open)));
            Caption = 'Requests Sent for Approval';
            FieldClass = FlowField;
        }
        field(100;"User ID Filter";Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(101;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(102;"Overdue Date Filter";Date)
        {
            Caption = 'Overdue Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        WorkOrderHeader: Record "MCH Work Order Header";
        AMUserMgt: Codeunit "MCH AM User Mgt.";


    procedure GetUserAssetRespGroupFilter() UserAssetRespGroupFilter: Text
    begin
        exit(AMUserMgt.GetAssetRespGroupFilter);
    end;


    procedure CountWorkOrders(FieldNumber: Integer;UserAssetRespGroupFilter: Text) Result: Integer
    var
        CountWorkOrdersQry: Query "MCH AM Count Work Orders";
    begin
        case FieldNumber of
          FieldNo("Work Order Requests"):
            begin
              CountWorkOrdersQry.SetRange(Status,WorkOrderHeader.Status::Request);
            end;
          FieldNo("Planned Work Orders"):
            begin
              CountWorkOrdersQry.SetRange(Status,WorkOrderHeader.Status::Planned);
            end;
          FieldNo("Released Work Orders"):
            begin
              CountWorkOrdersQry.SetRange(Status,WorkOrderHeader.Status::Released);
            end;
          FieldNo("Finished Work Orders"):
            begin
              CountWorkOrdersQry.SetRange(Status,WorkOrderHeader.Status::Finished);
            end;
          FieldNo("Overdue Released Work Orders"):
            begin
              CountWorkOrdersQry.SetRange(Status,WorkOrderHeader.Status::Released);
              CountWorkOrdersQry.SetFilter(Expected_Ending_Date,GetFilter("Overdue Date Filter"));
            end;
          else
            exit(0);
        end;

        if (UserAssetRespGroupFilter <> '') then
          CountWorkOrdersQry.SetFilter(Responsibility_Group_Code,UserAssetRespGroupFilter);

        CountWorkOrdersQry.Open;
        CountWorkOrdersQry.Read;
        Result := CountWorkOrdersQry.Count_Orders;
        exit(Result);
    end;


    procedure ShowWorkOrders(FieldNumber: Integer)
    var
        WorkOrder: Record "MCH Work Order Header";
        PageID: Integer;
    begin
        case FieldNumber of
          FieldNo("Work Order Requests"):
            PageID := PAGE::"MCH Work Order Requests";
          FieldNo("Planned Work Orders"):
            PageID := PAGE::"MCH Planned Work Orders";
          FieldNo("Released Work Orders"),
          FieldNo("Overdue Released Work Orders"):
            PageID := PAGE::"MCH Released Work Orders";
          FieldNo("Finished Work Orders"):
            PageID := PAGE::"MCH Finished Work Orders";
        end;
        if (PageID = 0) then
          exit;

        case FieldNumber of
          FieldNo("Overdue Released Work Orders"):
            begin
              WorkOrder.SetFilter("Expected Ending Date",GetFilter("Overdue Date Filter"));
            end;
        end;

        PAGE.Run(PageID,WorkOrder);
    end;
}

