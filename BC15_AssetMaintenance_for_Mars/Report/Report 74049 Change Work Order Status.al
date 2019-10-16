report 74049 "MCH Change Work Order Status"
{
    Caption = 'Change Work Order Status';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Status Change Options")
                {
                    Caption = 'Status Change Options';
                    group(Control1101214002)
                    {
                        ShowCaption = false;
                        Visible = SingleWO;
                        field("Work Order No.";WorkOrder."No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Work Order No.';
                            Editable = false;
                            Enabled = false;
                            QuickEntry = false;
                        }
                    }
                    field("Current Status";CurrentStatus)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Current Status';
                        Editable = false;
                        Enabled = false;
                        QuickEntry = false;
                    }
                    group(Control1101214005)
                    {
                        ShowCaption = false;
                        Visible = MultipleWO;
                        field(NoOfWO;NoOfWO)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Selected Work Orders';
                            Editable = false;
                            Enabled = false;
                            QuickEntry = false;
                        }
                    }
                    group(Control1101214020)
                    {
                        ShowCaption = false;
                        Visible = SingleWO AND IsUsingProgressStatus;
                        field(CurrentProgressStatusCode;CurrentProgressStatusCode)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Progress Status Code';
                            Editable = false;
                            Enabled = false;
                        }
                    }
                    field(Placeholder;Placeholder)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowCaption = false;
                    }
                    group(Control1101214006)
                    {
                        ShowCaption = false;
                        Visible = FromRequest;
                        field(RequestNewStatus;RequestNewStatus)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'New Status';

                            trigger OnValidate()
                            begin
                                UpdateNewStatus;
                                if not ValidateNewProgressStatusCode then
                                  NewProgressStatusCode := '';
                            end;
                        }
                    }
                    group(Control1101214013)
                    {
                        ShowCaption = false;
                        Visible = FromPlanned;
                        field(PlannedNewStatus;PlannedNewStatus)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'New Status';
                            Editable = false;
                            QuickEntry = false;

                            trigger OnValidate()
                            begin
                                UpdateNewStatus;
                                if not ValidateNewProgressStatusCode then
                                  NewProgressStatusCode := '';
                            end;
                        }
                    }
                    group(Control1101214011)
                    {
                        ShowCaption = false;
                        Visible = FromReleased;
                        field(ReleasedNewStatus;ReleasedNewStatus)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'New Status';
                            Editable = false;
                            Enabled = false;
                            QuickEntry = false;

                            trigger OnValidate()
                            begin
                                UpdateNewStatus;
                                if not ValidateNewProgressStatusCode then
                                  NewProgressStatusCode := '';
                            end;
                        }
                    }
                    group(Control1101214009)
                    {
                        ShowCaption = false;
                        Visible = FromFinished;
                        field(FinishedNewStatus;FinishedNewStatus)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'New Status';

                            trigger OnValidate()
                            begin
                                UpdateNewStatus;
                                if not ValidateNewProgressStatusCode then
                                  NewProgressStatusCode := '';
                            end;
                        }
                    }
                    group(Control1101214018)
                    {
                        ShowCaption = false;
                        Visible = IsUsingProgressStatus;
                        field(NewProgressStatusCode;NewProgressStatusCode)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'New Progress Status Code';
                            ShowMandatory = ProgressStatusMandatory;
                            TableRelation = "MCH Work Order Progress Status";

                            trigger OnLookup(var Text: Text): Boolean
                            var
                                WOProgressStatus: Record "MCH Work Order Progress Status";
                            begin
                                if NewProgressStatusCode <> '' then
                                  if WOProgressStatus.Get(NewProgressStatusCode) then ;

                                case NewStatus of
                                  NewStatus::Planned:
                                    WOProgressStatus.SetRange("Allow on Planned WO",true);
                                  NewStatus::Released:
                                    WOProgressStatus.SetRange("Allow on Released WO",true);
                                  NewStatus::Finished:
                                    WOProgressStatus.SetRange("Allow on Finished WO",true);
                                  else begin
                                    NewProgressStatusCode := '';
                                    exit;
                                  end;
                                end;
                                WOProgressStatus.SetRange(Blocked,false);
                                if PAGE.RunModal(0,WOProgressStatus,WOProgressStatus.Code) = ACTION::LookupOK then begin
                                  Text := WOProgressStatus.Code;
                                  exit(true);
                                end;
                            end;

                            trigger OnValidate()
                            begin
                                ValidateNewProgressStatusCode;
                            end;
                        }
                    }
                    group(Control1101214014)
                    {
                        ShowCaption = false;
                        Visible = MultipleWO;
                        field(StopOnFirstError;StopOnFirstError)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Stop and Show First Error';
                            ToolTip = 'Specifies whether to stop as soon as the batch job encounters an error.';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            WOProgressStatus: Record "MCH Work Order Progress Status";
        begin
            InitRequestPage;
            if not ValidateNewProgressStatusCode then
              NewProgressStatusCode := '';
            IsUsingProgressStatus := AMSetup."WO Progress Status Mandatory" or (not WOProgressStatus.IsEmpty);
            ProgressStatusMandatory := AMSetup."WO Progress Status Mandatory";
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CurrentStatus := 99;
        NewStatus := 99;
        AMSetup.Get;
    end;

    trigger OnPreReport()
    var
        LastWorkOrder: Record "MCH Work Order Header";
        WOStatusChangeMgt: Codeunit "MCH WO Status Change Mgt.";
        OpenWOpage: Boolean;
    begin
        if not (SingleWO or MultipleWO) then
          Error('');
        WorkOrder.LockTable;
        WorkOrder.SetCurrentKey(Status,"No.");
        if not WorkOrder.Find('-') then
          Error(Text001);
        CounterTotal := WorkOrder.Count;

        WOStatusChangeMgt.SetParameters(CurrentStatus,NewStatus,NewProgressStatusCode);
        if MultipleWO and (not StopOnFirstError) then
          WOStatusChangeMgt.SetStatusChangeResiliency;
        WOStatusChangeMgt.CarryOutBatchStatusChange(WorkOrder);
        Commit;

        if GuiAllowed then begin
          WOStatusChangeMgt.GetResult(CounterSuccess,CounterFailed,LastSuccessWorkOrderNo);
          if CounterFailed > 0 then begin
              Message(Text002,NewStatus,CounterFailed);
          end else begin
            if (CounterSuccess = 1) and LastWorkOrder.Get(NewStatus,LastSuccessWorkOrderNo) then
              OpenWOpage := Confirm(StrSubstNo(Text003,LastWorkOrder."No.",LastWorkOrder.Status),true)
            else
              Message(Text004,NewStatus,CounterSuccess);
          end;
          if OpenWOpage then
            LastWorkOrder.ShowCard;
        end;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        WorkOrder: Record "MCH Work Order Header";
        NewProgressStatusCode: Code[20];
        [InDataSet]
        IsUsingProgressStatus: Boolean;
        [InDataSet]
        SingleWO: Boolean;
        [InDataSet]
        MultipleWO: Boolean;
        NoOfWO: Integer;
        CurrentStatus: Option Request,Planned,Released,Finished;
        CurrentProgressStatusCode: Code[20];
        NewStatus: Option Request,Planned,Released,Finished;
        RequestNewStatus: Option ,Planned,Released;
        PlannedNewStatus: Option ,,Released;
        ReleasedNewStatus: Option ,,,Finished;
        FinishedNewStatus: Option ,,Released;
        [InDataSet]
        FromRequest: Boolean;
        [InDataSet]
        FromPlanned: Boolean;
        [InDataSet]
        FromReleased: Boolean;
        [InDataSet]
        FromFinished: Boolean;
        StopOnFirstError: Boolean;
        Text000: Label '%1 %2 is not allowed for %3 = %4.';
        Text001: Label 'There are no work orders to change status for.';
        CounterTotal: Integer;
        CounterFailed: Integer;
        CounterSuccess: Integer;
        LastSuccessWorkOrderNo: Code[20];
        Text002: Label 'The Status was not changed to %1 for %2 work order(s) because of errors encountered.';
        Text003: Label 'The Status of work order %1 has been changed to %2.\Do you want to open the work order?';
        Text004: Label 'The Status has been changed to %1 for %2 work order(s).';
        [InDataSet]
        ProgressStatusMandatory: Boolean;
        Placeholder: Label 'Placeholder';


    procedure SetWorkOrder(var WorkOrder2: Record "MCH Work Order Header")
    begin
        WorkOrder.Copy(WorkOrder2);

        WorkOrder.FindFirst;
        WorkOrder.SetRange(Status,WorkOrder.Status);
        MultipleWO := WorkOrder.Next <> 0;
        SingleWO := not MultipleWO;
        if SingleWO then
          WorkOrder.SetRecFilter;
        NoOfWO := WorkOrder.Count;

        CurrentStatus := WorkOrder.Status;
        if SingleWO then begin
          CurrentProgressStatusCode := WorkOrder."Progress Status Code";
          NewProgressStatusCode := WorkOrder."Progress Status Code";
        end else begin
          WorkOrder.FindSet;
          NewProgressStatusCode := WorkOrder."Progress Status Code";
          repeat
            if (WorkOrder."Progress Status Code" <> NewProgressStatusCode) then begin
              NewProgressStatusCode := '';
              WorkOrder.FindLast;
            end;
          until (WorkOrder.Next = 0);
        end;

        InitRequestPage;
    end;

    local procedure InitRequestPage()
    begin
        FromRequest := false;
        FromPlanned := false;
        FromReleased := false;
        FromFinished := false;
        if (CurrentStatus in [CurrentStatus::Request..CurrentStatus::Finished]) then begin
          case CurrentStatus of
            WorkOrder.Status::Request:
              begin
                FromRequest := true;
                if not (RequestNewStatus in [RequestNewStatus::Planned,RequestNewStatus::Released]) then
                  RequestNewStatus := RequestNewStatus::Planned;
              end;
            WorkOrder.Status::Planned:
              begin
                FromPlanned := true;
                PlannedNewStatus := PlannedNewStatus::Released;
              end;
            WorkOrder.Status::Released:
              begin
                FromReleased := true;
                ReleasedNewStatus := ReleasedNewStatus::Finished;
              end;
            WorkOrder.Status::Finished:
              begin
                FromFinished := true;
                FinishedNewStatus := FinishedNewStatus::Released;
              end;
          end;
        end;
        UpdateNewStatus;
    end;

    local procedure UpdateNewStatus()
    begin
        case CurrentStatus of
          WorkOrder.Status::Request:
            NewStatus := RequestNewStatus;
          WorkOrder.Status::Planned:
            NewStatus := PlannedNewStatus;
          WorkOrder.Status::Released:
            NewStatus := ReleasedNewStatus;
          WorkOrder.Status::Finished:
            NewStatus := FinishedNewStatus;
          else
            NewStatus := 99;
        end;
    end;

    [TryFunction]
    local procedure ValidateNewProgressStatusCode()
    var
        WOProgressStatus: Record "MCH Work Order Progress Status";
        IsOK: Boolean;
    begin
        if NewProgressStatusCode = '' then
          exit;
        WOProgressStatus.Get(NewProgressStatusCode);
        case NewStatus of
          NewStatus::Planned:
            IsOK := WOProgressStatus."Allow on Planned WO";
          NewStatus::Released:
            IsOK := WOProgressStatus."Allow on Released WO";
          NewStatus::Finished:
            IsOK := WOProgressStatus."Allow on Finished WO";
          else begin
            NewProgressStatusCode := '';
            exit;
          end;
        end;
        if not IsOK then
          Error(Text000,
            WorkOrder.FieldCaption("Progress Status Code"),WOProgressStatus.Code,
            WorkOrder.FieldCaption(Status),NewStatus);
        WOProgressStatus.TestField(Blocked,false);
    end;
}

