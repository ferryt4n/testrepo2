codeunit 74034 "MCH WO Status Change Mgt."
{
    Permissions = TableData "MCH Work Order Header"=rimd;
    TableNo = "MCH Work Order Header";

    trigger OnRun()
    var
        WorkOrderLine: Record "MCH Work Order Line";
    begin
        if not ParametersAreSet then
          Error(Text020);
        if StatusChangeResiliency then begin
          WorkOrderLine.LockTable;
          if WorkOrderLine.FindFirst then ;
          LockTable;
        end;
        CheckFromToStatusChangePermission(FromStatus,NewStatus);
        CarryOutChangeStatus(Rec);
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintUserSetup: Record "MCH Asset Maintenance User";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        Text001: Label '%1 %2 cannot be finished because it is related to %3 in worksheet %4 %5.';
        Text002: Label '%1 %2 cannot be finished because the associated Purchase %3 %4 has not been fully posted.';
        Text003: Label 'The work order has no lines.';
        Text005: Label '%1 %2 is not allowed for %3 = %4.';
        Text012: Label '%1 in %2 %3 must not be earlier than %4 in %5.';
        Text013: Label '%1 for %2 %3 in %4 %5 must be specified.';
        StatusChangeResiliency: Boolean;
        SuppressCommit: Boolean;
        HideDialog: Boolean;
        CounterTotal: Integer;
        CounterProgress: Integer;
        CounterSuccess: Integer;
        CounterFailed: Integer;
        LastSuccessWorkOrderNo: Code[20];
        ParametersAreSet: Boolean;
        FromStatus: Option Requested,Planned,Released,Finished;
        NewStatus: Option Request,Planned,Released,Finished;
        NewProgressStatusCode: Code[20];
        HasSetup: Boolean;
        Text016: Label 'You do not have permission to change %1 %2 to %3.';
        Text017: Label '"%1" is not a valid %2 %3 value.';
        Text018: Label 'The %1 %2 cannot be changed from %3 to %4.';
        Text019: Label 'You do not have permission to reopen a %1 %2 to %3 = %4.';
        Text020: Label 'Status Change parameters are incomplete.';
        Text021: Label '%1 of %2';
        WindowMsg: Label 'Changing Status #1####################\\Processing #2####################\Work Order No. #3####################';


    procedure CarryOutBatchStatusChange(var WorkOrder2: Record "MCH Work Order Header")
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if not ParametersAreSet then
          Error(Text020);
        CheckFromToStatusChangePermission(FromStatus,NewStatus);

        WorkOrder.Copy(WorkOrder2);
        Code(WorkOrder);
        WorkOrder2 := WorkOrder;
    end;

    local procedure "Code"(var WorkOrder: Record "MCH Work Order Header")
    var
        WorkOrderLine: Record "MCH Work Order Line";
    begin
        with WorkOrder do begin
          if not StatusChangeResiliency then begin
            WorkOrderLine.LockTable;
            if WorkOrderLine.FindFirst then ;
            LockTable;
          end;

          SetRange(Status,FromStatus);
          if not Find('-') then
            exit;
          HideDialog := HideDialog or (not GuiAllowed);
          if not HideDialog then begin
            CounterTotal := Count;
            Window.Open(WindowMsg);
            Window.Update(1,StrSubstNo('%1 -> %2',GetStatusAsText(FromStatus),GetStatusAsText(NewStatus)));
          end;

          repeat
            if not HideDialog then begin
              CounterProgress := CounterProgress + 1;
              Window.Update(2,StrSubstNo(Text021,CounterProgress,CounterTotal));
              Window.Update(3,"No.");
            end;
            if StatusChangeResiliency then begin
              if not TryCarryOutChangeStatus(WorkOrder) then begin
                CounterFailed := CounterFailed + 1;
              end else begin
                CounterSuccess := CounterSuccess + 1;
                LastSuccessWorkOrderNo := WorkOrder."No.";
              end;
            end else begin
              CarryOutChangeStatus(WorkOrder);
              CounterSuccess := CounterSuccess + 1;
              LastSuccessWorkOrderNo := WorkOrder."No.";
            end;
          until Next = 0;

          if not HideDialog then
            Window.Close;
        end;
    end;

    local procedure CarryOutChangeStatus(var WorkOrder: Record "MCH Work Order Header")
    begin
        GetSetup;
        CheckWorkOrder(WorkOrder);
        TransWorkOrder(WorkOrder);

        if not SuppressCommit then
          Commit;
    end;

    local procedure TransWorkOrder(var FromWorkOrder: Record "MCH Work Order Header")
    var
        ToWorkOrder: Record "MCH Work Order Header";
    begin
        with FromWorkOrder do begin
          CalcFields("Work Description");
          ToWorkOrder := FromWorkOrder;
          ToWorkOrder.Status := NewStatus;
          if (NewProgressStatusCode <> '') then
            ToWorkOrder."Progress Status Code" := NewProgressStatusCode;
          ToWorkOrder."Previous Status" := FromWorkOrder.Status;
          ToWorkOrder."Status Changed By" := UserId;
          ToWorkOrder."Status Changed Date-Time" := CurrentDateTime;
          ToWorkOrder.SetLastModifiedDateTimeUser;

          TransferReferences(FromWorkOrder,ToWorkOrder);
          FromWorkOrder.Delete;
          ToWorkOrder.Insert;

          TransWorkOrderCommentLine(FromWorkOrder,ToWorkOrder,0);
          TransWorkOrderLine(FromWorkOrder,ToWorkOrder);
          TransWorkOrderBudgetLine(FromWorkOrder,ToWorkOrder);
        end;
    end;

    local procedure TransWorkOrderLine(FromWorkOrder: Record "MCH Work Order Header";var ToWorkOrder: Record "MCH Work Order Header")
    var
        FromWorkOrderLine: Record "MCH Work Order Line";
        ToWorkOrderLine: Record "MCH Work Order Line";
    begin
        with FromWorkOrderLine do begin
          SetRange(Status,FromWorkOrder.Status);
          SetRange("Work Order No.",FromWorkOrder."No.");
          if FindSet(true) then begin
            repeat
              ToWorkOrderLine := FromWorkOrderLine;
              ToWorkOrderLine.Status := ToWorkOrder.Status;
              ToWorkOrderLine."Work Order No." := ToWorkOrder."No.";

              if (ToWorkOrderLine."Asset No." <> '') then begin
                if ToWorkOrder.Status <> ToWorkOrder.Status::Finished then begin
                  ToWorkOrderLine."Completion Date" := 0D;
                  ToWorkOrderLine."Usage on Completion" := 0;
                end;
              end else begin
                ToWorkOrderLine.Init;
              end;
              ToWorkOrderLine.Insert;
              TransferReferences(FromWorkOrderLine,ToWorkOrderLine);
              TransWorkOrderCommentLine(FromWorkOrder,ToWorkOrder,"Line No.");

              Delete;
            until Next = 0;
          end;
        end;
    end;

    local procedure TransWorkOrderBudgetLine(FromWorkOrder: Record "MCH Work Order Header";var ToWorkOrder: Record "MCH Work Order Header")
    var
        FromWorkOrderBudgetLine: Record "MCH Work Order Budget Line";
        ToWorkOrderBudgetLine: Record "MCH Work Order Budget Line";
    begin
        with FromWorkOrderBudgetLine do begin
          SetRange(Status,FromWorkOrder.Status);
          SetRange("Work Order No.",FromWorkOrder."No.");
          LockTable;
          if Find('-') then begin
            repeat
              ToWorkOrderBudgetLine := FromWorkOrderBudgetLine;
              ToWorkOrderBudgetLine.Status := ToWorkOrder.Status;
              ToWorkOrderBudgetLine."Work Order No." := ToWorkOrder."No.";
              ToWorkOrderBudgetLine.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure TransWorkOrderCommentLine(FromWorkOrder: Record "MCH Work Order Header";ToWorkOrder: Record "MCH Work Order Header";TableLineNo: Integer)
    var
        FromWorkOrderCommentLine: Record "MCH Work Order Comment Line";
        ToWorkOrderCommentLine: Record "MCH Work Order Comment Line";
    begin
        with FromWorkOrderCommentLine do begin
          if (TableLineNo = 0) then begin
            SetRange("Table Name","Table Name"::"Work Order","Table Name"::"Work Order")
          end else begin
            SetRange("Table Name","Table Name"::"Work Order","Table Name"::"Work Order Line");
            SetRange("Table Line No.",TableLineNo);
          end;
          SetRange("Table Subtype",FromWorkOrder.Status);
          SetRange("No.",FromWorkOrder."No.");
          LockTable;
          if Find('-') then begin
            repeat
              ToWorkOrderCommentLine := FromWorkOrderCommentLine;
              ToWorkOrderCommentLine."Table Subtype" := ToWorkOrder.Status;
              ToWorkOrderCommentLine."No." := ToWorkOrder."No.";
              ToWorkOrderCommentLine.Insert;
            until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    local procedure CheckWorkOrder(var WorkOrder: Record "MCH Work Order Header")
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        GetSetup;
        if (FromStatus <> FromStatus::Finished) then begin
          if not WorkOrder.AssetWorkOrderLinesExist then
            Error(Text003);
          if AMSetup."Work Order Type Mandatory" then
            WorkOrder.TestField("Work Order Type");
          if AMSetup."WO Person Respons. Mandatory" then
            WorkOrder.TestField("Person Responsible");
          CheckProgressStatus(WorkOrder);
          AMFunctions.CheckWorkOrderDimensions(WorkOrder);
        end;
        if (NewStatus = NewStatus::Finished) then begin
          CheckOnFinishStatus(WorkOrder);
        end;
    end;

    local procedure CheckOnFinishStatus(WorkOrder: Record "MCH Work Order Header")
    var
        PurchLine: Record "Purchase Line";
        WorkOrderLine: Record "MCH Work Order Line";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        WOBudgetLine: Record "MCH Work Order Budget Line";
    begin
        WorkOrder.TestField("Completion Date");

        with PurchLine do begin
          SetCurrentKey("Document Type","MCH Work Order No.");
          SetRange("MCH Work Order No.",WorkOrder."No.");
          SetFilter(Quantity,'<>%1',0);
          if FindSet then
            repeat
              if ("Outstanding Quantity" <> 0) or
                 ("Qty. Rcd. Not Invoiced" <> 0) or
                 ("Return Qty. Shipped Not Invd." <> 0)
              then
                Error(Text002,
                  WorkOrder.TableCaption,WorkOrder."No.","Document Type","Document No.");
            until Next = 0;
        end;

        MaintJnlLine.SetCurrentKey("Work Order No.");
        MaintJnlLine.SetRange("Work Order No.",WorkOrder."No.");
        if MaintJnlLine.FindFirst then
          Error(Text001,
            WorkOrder.TableCaption,WorkOrder."No.",
            MaintJnlLine.TableCaption,MaintJnlLine."Journal Template Name",MaintJnlLine."Journal Batch Name");

        WorkOrderLine.SetRange(Status,WorkOrder.Status);
        WorkOrderLine.SetRange("Work Order No.",WorkOrder."No.");
        WorkOrderLine.SetFilter("Asset No.",'<>%1','');
        WorkOrderLine.FindSet;
        repeat
          WorkOrderLine.TestField("Completion Date");
          if (WorkOrderLine."Completion Date" > WorkOrder."Completion Date") then
            Error(Text012,
              WorkOrder.FieldCaption("Completion Date"),WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrderLine.TableCaption,WorkOrderLine."Completion Date");

          if WorkOrderLine."Task Code" <> '' then begin
            AssetMaintTask.Get(WorkOrderLine."Asset No.",WorkOrderLine."Task Code");
            if (AssetMaintTask."Trigger Method" in [AssetMaintTask."Trigger Method"::"Usage (Recurring)",AssetMaintTask."Trigger Method"::"Fixed Usage"]) and
               (WorkOrderLine."Task Scheduled Usage Value" <> 0)
            then begin
              if WorkOrderLine."Usage on Completion" = 0 then
                Error(Text013,
                  WorkOrderLine.FieldCaption("Usage on Completion"),
                  AssetMaintTask.TableCaption,WorkOrderLine."Task Code",
                  WorkOrder.TableCaption,WorkOrder."No.");
            end;
          end;
        until WorkOrderLine.Next = 0;
    end;

    local procedure CheckProgressStatus(var WorkOrder: Record "MCH Work Order Header")
    var
        WOProgressStatus: Record "MCH Work Order Progress Status";
        ChangeOk: Boolean;
    begin
        GetSetup;
        if AMSetup."WO Progress Status Mandatory" then begin
          if (NewProgressStatusCode = '') then
            WorkOrder.TestField("Progress Status Code");
        end else begin
          if (WorkOrder."Progress Status Code" = '') and (NewProgressStatusCode = '') then
            exit;
        end;
        if (NewProgressStatusCode = '') then
          WOProgressStatus.Get(WorkOrder."Progress Status Code")
        else
          WOProgressStatus.Get(NewProgressStatusCode);

        case NewStatus of
          NewStatus::Planned:
            ChangeOk := WOProgressStatus."Allow on Planned WO";
          NewStatus::Released:
            ChangeOk := WOProgressStatus."Allow on Released WO";
          NewStatus::Finished:
            ChangeOk := WOProgressStatus."Allow on Finished WO";
        end;
        if not ChangeOk then
          Error(Text005,
            WorkOrder.FieldCaption("Progress Status Code"),WOProgressStatus.Code,
            WorkOrder.FieldCaption(Status),GetStatusAsText(NewStatus));

        if WOProgressStatus."Maint. Location Mandatory" then
          WorkOrder.TestField("Maint. Location Code");
        if WOProgressStatus."Person Responsible Mandatory" then
          WorkOrder.TestField("Person Responsible");
    end;

    [TryFunction]

    procedure CheckFromToStatusChangePermission(FromStatus: Option Request,Planned,Released,Finished;ToStatus: Option Request,Planned,Released,Finished)
    var
        TempWorkOrder: Record "MCH Work Order Header";
        HasPermission: Boolean;
    begin
        // Check the allowed From-To Status combinations
        GetSetup;
        if not (FromStatus in [FromStatus::Request..FromStatus::Finished]) then
          Error(Text017,GetStatusAsText(FromStatus),TempWorkOrder.TableCaption,TempWorkOrder.FieldCaption(Status));
        if not (NewStatus in [NewStatus::Request..NewStatus::Finished]) then
          Error(Text017,GetStatusAsText(NewStatus),TempWorkOrder.TableCaption,TempWorkOrder.FieldCaption(Status));

        if (FromStatus = NewStatus) or
           ((FromStatus in [FromStatus::Request,FromStatus::Planned,FromStatus::Released]) and
            ((NewStatus < FromStatus)) or
           ((FromStatus = FromStatus::Finished) and (NewStatus <> NewStatus::Released)))
        then
          Error(Text018,TempWorkOrder.TableCaption,TempWorkOrder.FieldCaption(Status),GetStatusAsText(FromStatus),GetStatusAsText(NewStatus));

        // New Status check
        HasPermission := false;
        case NewStatus of
          NewStatus::Planned:
            HasPermission := MaintUserSetup."Change WO Status to Planned";
          NewStatus::Released:
            HasPermission := MaintUserSetup."Change WO Status to Released";
          NewStatus::Finished:
            HasPermission := MaintUserSetup."Change WO Status to Finished";
        end;
        if not HasPermission then
          Error(Text016,TempWorkOrder.TableCaption,TempWorkOrder.FieldCaption(Status),GetStatusAsText(NewStatus));

        // Special: Finished -> Released
        if ((FromStatus = FromStatus::Finished) and (NewStatus = NewStatus::Released)) and
           (not MaintUserSetup."Reopen Finished WO to Released")
        then
          Error(Text019,GetStatusAsText(FromStatus),TempWorkOrder.TableCaption,TempWorkOrder.FieldCaption(Status),GetStatusAsText(NewStatus));
    end;

    local procedure TryCarryOutChangeStatus(var WorkOrder: Record "MCH Work Order Header") OK: Boolean
    var
        WOStatusChangeMgt: Codeunit "MCH WO Status Change Mgt.";
    begin
        with WorkOrder do begin
          Commit;
          WOStatusChangeMgt.SetParameters(FromStatus,NewStatus,NewProgressStatusCode);
          WOStatusChangeMgt.SetStatusChangeResiliency;
          WOStatusChangeMgt.SetSuppressCommit(SuppressCommit);
          OK := WOStatusChangeMgt.Run(WorkOrder);
        end;
    end;

    local procedure TransferReferences(FromRecord: Variant;ToRecord: Variant)
    var
        RecordLinkManagement: Codeunit "Record Link Management";
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.GetTable(FromRecord);
        if FromRecRef.HasLinks then begin
          RecordLinkManagement.CopyLinks(FromRecord,ToRecord);
          FromRecRef.DeleteLinks;
        end;
        ToRecRef.GetTable(ToRecord);
        AMDocAttachmentMgt.CopyAttachmentsByVariantRef(FromRecord,ToRecord);
    end;

    local procedure GetSetup()
    begin
        if HasSetup then
          exit;
        HasSetup := true;
        AMSetup.Get;
        AMSetup.TestField("Source Code");
        MaintUserMgt.GetMaintenanceUser(UserId,MaintUserSetup);
    end;

    local procedure GetStatusAsText(StatusInteger: Integer) StatusTxt: Text
    var
        TempWorkOrder: Record "MCH Work Order Header";
    begin
        TempWorkOrder.Status := StatusInteger;
        exit(Format(TempWorkOrder.Status));
    end;


    procedure SetStatusChangeResiliency()
    begin
        StatusChangeResiliency := true;
    end;


    procedure SetSuppressCommit(Set: Boolean)
    begin
        SuppressCommit := Set;
    end;


    procedure SetHideDialog(Set: Boolean)
    begin
        HideDialog := Set;
    end;


    procedure SetParameters(FromStatus2: Option;NewStatus2: Option;NewProgressStatusCode2: Code[20])
    begin
        FromStatus := FromStatus2;
        NewStatus := NewStatus2;
        NewProgressStatusCode := NewProgressStatusCode2;
        ParametersAreSet := true;
    end;


    procedure GetResult(var NoOfSuccess: Integer;var NoOfFailed: Integer;var LastSuccessWorkOrderNo2: Code[20])
    begin
        NoOfSuccess := CounterSuccess;
        NoOfFailed := CounterFailed;
        LastSuccessWorkOrderNo2 := LastSuccessWorkOrderNo;
    end;
}

