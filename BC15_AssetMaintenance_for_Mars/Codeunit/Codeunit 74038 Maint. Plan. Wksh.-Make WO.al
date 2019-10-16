codeunit 74038 "MCH Maint. Plan. Wksh.-Make WO"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Worksheet Name #1##########\\';
        Text001: Label 'Checking worksheet lines #2######\';
        Text002: Label 'Creating work orders #3######\';
        Text003: Label 'Creating work order lines #4######\';
        Text005: Label 'Deleting worksheet lines #5######';
        Text008: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text009: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        AMSetup: Record "MCH Asset Maintenance Setup";
        MPWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        MPWkshName: Record "MCH AM Planning Wksh. Name";
        MPWkshLine: Record "MCH AM Planning Wksh. Line";
        MPWkshLine2: Record "MCH AM Planning Wksh. Line";
        MPWkshLine3: Record "MCH AM Planning Wksh. Line";
        PrevMPWkshLine: Record "MCH AM Planning Wksh. Line" temporary;
        WorkOrder: Record "MCH Work Order Header";
        WorkOrderLine: Record "MCH Work Order Line";
        TempFailedMPWkshLine: Record "MCH AM Planning Wksh. Line" temporary;
        MPWkshMakeOrders: Codeunit "MCH Maint. Plan. Wksh.-Make WO";
        AMFunctions: Codeunit "MCH AM Functions";
        Window: Dialog;
        EndOrderDate: Date;
        PrintWorkOrders: Boolean;
        OrderCounter: Integer;
        LineCount: Integer;
        OrderLineCounter: Integer;
        StartLineNo: Integer;
        NextLineNo: Integer;
        CounterFailed: Integer;
        GroupBy: Option "Wksh. Line","Maint. Asset","Maint. Procedure";
        DefOrderStatus: Option Planned,Released;
        FixedProgStatus: Code[20];


    procedure CarryOutBatchAction(var MPWkshLine2: Record "MCH AM Planning Wksh. Line")
    begin
        MPWkshLine.Copy(MPWkshLine2);
        Code;
        MPWkshLine2 := MPWkshLine;
    end;


    procedure Set(NewWorkOrder: Record "MCH Work Order Header";NewGroupBy: Option;NewOrderStatus: Option;NewPrintWorkOrder: Boolean;NewProgStatus: Code[20])
    begin
        WorkOrder := NewWorkOrder;
        GroupBy := NewGroupBy;
        DefOrderStatus := NewOrderStatus;
        PrintWorkOrders := NewPrintWorkOrder;
        FixedProgStatus := NewProgStatus;
    end;

    local procedure "Code"()
    begin
        with MPWkshLine do begin
          Clear(WorkOrder);
          Clear(WorkOrderLine);

          SetRange("Worksheet Template Name","Worksheet Template Name");
          SetRange("Journal Batch Name","Journal Batch Name");
          if RecordLevelLocking then
            LockTable;

          MPWkshTemplate.Get("Worksheet Template Name");

          if not Find('=><') then begin
            "Line No." := 0;
            Commit;
            exit;
          end;

          Window.Open(
            Text000 +
            Text001 +
            Text002 +
            Text003 +
            Text005);
          Window.Update(1,"Journal Batch Name");

          // Check lines
          LineCount := 0;
          StartLineNo := "Line No.";
          repeat
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);
            CheckMPWkshLine(MPWkshLine);
            if Next = 0 then
              FindFirst;
          until "Line No." = StartLineNo;

          // Create lines
          LineCount := 0;
          OrderCounter := 0;
          OrderLineCounter := 0;
          Clear(WorkOrder);
          case GroupBy of
            GroupBy::"Wksh. Line":
              SetCurrentKey("Worksheet Template Name","Journal Batch Name","Line No.");
            GroupBy::"Maint. Asset":
              SetCurrentKey(
                "Worksheet Template Name","Journal Batch Name",
                "Work Order Type",Priority,"Asset No.","Starting Date");
            GroupBy::"Maint. Procedure":
              SetCurrentKey(
                "Worksheet Template Name","Journal Batch Name",
                "Work Order Type",Priority,"Task Code","Starting Date");
          end;

          if FindSet then
            repeat
              CarryOutWkshLineAction(MPWkshLine);
            until Next = 0;

          if PrintWorkOrders then
            PrintWorkOrder;

          if WorkOrderLine."Asset No." <> '' then
            FinalizeOrderHeader(WorkOrder);

          // Copy number of created orders and current journal batch name to planning worksheet
          Init;
          "Line No." := OrderCounter;

          if OrderCounter <> 0 then begin
            MPWkshLine2.Copy(MPWkshLine);
            if MPWkshLine2.FindFirst then; // Remember the last line
            if FindFirst then
              repeat
                TempFailedMPWkshLine := MPWkshLine;
                if not TempFailedMPWkshLine.Find then
                  Delete(true);
              until Next = 0;

            MPWkshLine3.SetRange("Worksheet Template Name","Worksheet Template Name");
            MPWkshLine3.SetRange("Journal Batch Name","Journal Batch Name");
            if not MPWkshLine3.Find('+') then
              if IncStr("Journal Batch Name") <> '' then begin
                MPWkshName.Get("Worksheet Template Name","Journal Batch Name");
                MPWkshName.Delete;
                MPWkshName.Name := IncStr("Journal Batch Name");
                if MPWkshName.Insert then;
                "Journal Batch Name" := MPWkshName.Name;
              end;

            MPWkshLine3.SetRange("Journal Batch Name","Journal Batch Name");
            if not MPWkshLine3.Find('+') then begin
              MPWkshLine3.Init;
              MPWkshLine3."Worksheet Template Name" := "Worksheet Template Name";
              MPWkshLine3."Journal Batch Name" := "Journal Batch Name";
              MPWkshLine3."Line No." := 10000;
              MPWkshLine3.Insert;
            end;
          end;
        end;
    end;

    local procedure CheckMPWkshLine(var MPWkshLine2: Record "MCH AM Planning Wksh. Line")
    var
        MA: Record "MCH Maintenance Asset";
        MaintProcedure: Record "MCH Master Maintenance Task";
        MAProcedure: Record "MCH Asset Maintenance Task";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        with MPWkshLine2 do begin
          if ("Asset No." <> '') or ("Asset Category Code" <> '') or ("Task Code" <> '') then begin
            TestField("Asset No.");
            TestField("Task Code");
          end;
          MA.Get("Asset No.");
          MA.TestField(Blocked,false);
          MA.TestField("Posting Group");
          MaintProcedure.Get("Task Code");
          MaintProcedure.TestField(Status,MaintProcedure.Status::Active);
          MAProcedure.Get("Asset No.","Task Code");
        end;
    end;

    local procedure CarryOutWkshLineAction(var MPWkshLine: Record "MCH AM Planning Wksh. Line")
    var
        CarryOutAction: Codeunit "Carry Out Action";
    begin
        with MPWkshLine do begin
          case GroupBy of
            GroupBy::"Wksh. Line":
              FinalizeOrderHeader(WorkOrder);
            GroupBy::"Maint. Asset":
              begin
                if PrevMPWkshLine.FindFirst then
                  if (PrevMPWkshLine."Work Order Type" <> "Work Order Type") or
                     (PrevMPWkshLine.Priority <> Priority) or
                     (WorkOrderLine."Asset No." <> "Asset No.")
                  then
                    FinalizeOrderHeader(WorkOrder);
              end;
            GroupBy::"Maint. Procedure":
              begin
                if PrevMPWkshLine.FindFirst then
                  if (PrevMPWkshLine."Work Order Type" <> "Work Order Type") or
                     (PrevMPWkshLine.Priority <> Priority) or
                     (WorkOrderLine."Task Code" <> "Task Code")
                  then
                    FinalizeOrderHeader(WorkOrder);
              end;
          end;
          PrevMPWkshLine.DeleteAll;
          PrevMPWkshLine := MPWkshLine;
          PrevMPWkshLine.Insert;

          InsertWorkOrderLine(MPWkshLine,WorkOrder);
        end;
    end;

    local procedure InsertWorkOrderLine(var MPWkshLine2: Record "MCH AM Planning Wksh. Line";var WorkOrder: Record "MCH Work Order Header")
    var
        xWorkOrderLine: Record "MCH Work Order Line";
    begin
        with MPWkshLine2 do begin
          if ("Asset No." = '') or ("Task Code" = '') then
            exit;

          case GroupBy of
            GroupBy::"Wksh. Line":
              begin
                InsertHeader(MPWkshLine2);
                LineCount := 0;
                NextLineNo := 0;
              end;
            GroupBy::"Maint. Asset":
              if (PrevMPWkshLine."Work Order Type" <> "Work Order Type") or
                 (PrevMPWkshLine.Priority <> Priority) or
                 (WorkOrderLine."Asset No." <> "Asset No.")
              then begin
                InsertHeader(MPWkshLine2);
                LineCount := 0;
                NextLineNo := 0;
              end;
            GroupBy::"Maint. Procedure":
              if (PrevMPWkshLine."Work Order Type" <> "Work Order Type") or
                 (PrevMPWkshLine.Priority <> Priority) or
                 (WorkOrderLine."Task Code" <> "Task Code")
              then begin
                InsertHeader(MPWkshLine2);
                LineCount := 0;
                NextLineNo := 0;
              end;
          end;

          LineCount := LineCount + 1;
          Window.Update(4,LineCount);

          NextLineNo := NextLineNo + 10000;
          WorkOrderLine.Init;
          WorkOrderLine.Status := WorkOrder.Status;
          WorkOrderLine."Work Order No." := WorkOrder."No.";
          WorkOrderLine."Line No." := NextLineNo;
          WorkOrderLine.Validate("Asset No.","Asset No.");
          WorkOrderLine.Validate("Task Code","Task Code");
          WorkOrderLine.Validate("Starting Date","Starting Date");
          WorkOrderLine."Task Scheduled Date" := "Starting Date";
          WorkOrderLine."Task Scheduled Usage Value" := "Task Scheduled Usage Value";
          WorkOrderLine.Description := Description;
          WorkOrderLine."Description 2" := "Description 2";
          WorkOrderLine.Insert;

        end;
    end;

    local procedure InsertHeader(var MPWkshLine2: Record "MCH AM Planning Wksh. Line")
    var
        MA: Record "MCH Maintenance Asset";
        MaintProcedure: Record "MCH Master Maintenance Task";
    begin
        with MPWkshLine2 do begin
          OrderCounter := OrderCounter + 1;
          Window.Update(3,OrderCounter);

          WorkOrder.Init;
          WorkOrder.Status := DefOrderStatus + 1;
          WorkOrder."No." := '';
          WorkOrder.Insert(true);
          case GroupBy of
            GroupBy::"Wksh. Line":
              begin
                WorkOrder.Description := Description;
                WorkOrder."Description 2" := "Description 2";
              end;
            GroupBy::"Maint. Asset":
              begin
                MA.Get("Asset No.");
                WorkOrder.Description := MA.Description;
                WorkOrder."Description 2" := MA."Description 2";
              end;
            GroupBy::"Maint. Procedure":
              begin
                MaintProcedure.Get("Task Code");
                WorkOrder.Description := MaintProcedure.Description;
                WorkOrder."Description 2" := MaintProcedure."Description 2";
              end;
          end;
          WorkOrder.Validate("Starting Date","Starting Date");
          WorkOrder.Validate("Work Order Type","Work Order Type");
          WorkOrder.Validate(Priority,Priority);
          WorkOrder.Modify;
          Commit;
          if RecordLevelLocking then
            LockTable;
          WorkOrder.Mark(true);
        end;
    end;

    local procedure FinalizeOrderHeader(WorkOrder: Record "MCH Work Order Header")
    begin
        // Update/delete lines
        if not MPWkshLine.RecordLevelLocking then
          MPWkshLine.LockTable(true,true);

        OrderLineCounter := OrderLineCounter + LineCount;
        Window.Update(5,OrderLineCounter);

        MPWkshLine2.Copy(MPWkshLine);
        MPWkshLine2.SetRange("Work Order Type",WorkOrder."Work Order Type");
        MPWkshLine2.SetRange(Priority,WorkOrder.Priority);
        case GroupBy of
          GroupBy::"Wksh. Line":
            MPWkshLine2.SetRange("Line No.",MPWkshLine."Line No.");
          GroupBy::"Maint. Asset":
            MPWkshLine2.SetRange("Asset No.",WorkOrderLine."Asset No.");
          GroupBy::"Maint. Procedure":
            MPWkshLine2.SetRange("Task Code",WorkOrderLine."Task Code");
        end;
        if MPWkshLine2.FindFirst then begin
          repeat
            TempFailedMPWkshLine := MPWkshLine2;
            if not TempFailedMPWkshLine.Find then begin
              MPWkshLine2.Delete(true);
            end;
          until MPWkshLine2.Next = 0;
        end;

        Commit;
    end;


    procedure GetFailedCounter(): Integer
    begin
        exit(CounterFailed);
    end;

    local procedure PrintWorkOrder()
    begin
    end;
}

