page 74170 "MCH AM Purchase Wizard"
{
    Caption = 'Suggest Maintenance Purchase - Wizard';
    LinksAllowed = false;
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(StepWorkOrder)
            {
                Caption = 'StepWorkOrder';
                ShowCaption = false;
                Visible = WorkOrderVisible;
                group(StepTopSpaceGroup1)
                {
                    Visible = NOT WorkOrderVisible;
                    field(StepTopSpace1; '')
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(WorkOrderSinglePara)
                {
                    Caption = 'Work Order - Selected';
                    InstructionalText = 'The work order for which you want to purchase.';
                    Visible = SingleWO;
                    field(CallingWorkOrderNo; WorkOrderNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No.';
                        Editable = false;
                    }
                }
                group(WorkOrderMultiple)
                {
                    Caption = 'Work Orders';
                    InstructionalText = 'Multiple work orders selected for which you want to purchase.';
                    Visible = MultipleWO;
                    field(NoOfWOMultiple; NoOfWO)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Work Orders';
                        Editable = false;
                        QuickEntry = false;
                    }
                }
                group(WorkOrderAnyPara)
                {
                    Caption = 'Work Order - Filters';
                    InstructionalText = 'Set filters on the work orders for which you want to purchase.';
                    Visible = AnyWO;
                    field(WorkOrderNoFilter; WorkOrderNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            WorkOrder2: Record "MCH Work Order Header";
                            WorkOrderList: Page "MCH Work Order List";
                        begin
                            WorkOrder2.SetCurrentKey("No.");
                            WorkOrder2.FilterGroup(2);
                            WorkOrder2.SetRange(Status, WorkOrder2.Status::Released);
                            WorkOrder2.FilterGroup(0);
                            WorkOrder2.SetFilter("Work Order Type", WOTypeFilter);
                            WorkOrder2.SetFilter("Progress Status Code", ProgressStatusFilter);
                            WorkOrder2.SetFilter("Maint. Location Code", MaintLocationFilter);
                            WorkOrder2.SetFilter("Responsibility Group Code", AssetRespGroupFilter);
                            WorkOrder2.SetFilter("Person Responsible", PersonReponsibleFilter);
                            WorkOrder2.SetFilter("Assigned User ID", AssignedToUserIDFilter);
                            WorkOrderList.SetTableView(WorkOrder2);
                            WorkOrderList.LookupMode := true;
                            if WorkOrderList.RunModal = ACTION::LookupOK then
                                Text := WorkOrderList.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(WOTypeFilter; WOTypeFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Work Order Type';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            WorkOrderTypeLookup: Page "MCH Work Order Type Lookup";
                        begin
                            WorkOrderTypeLookup.LookupMode := true;
                            if WorkOrderTypeLookup.RunModal = ACTION::LookupOK then
                                Text := WorkOrderTypeLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(ProgressStatusFilter; ProgressStatusFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Progress Status Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            WOrderProgressStatus: Record "MCH Work Order Progress Status";
                            WOProgressStatusLookup: Page "MCH WO Progress Status Lookup";
                        begin
                            WOrderProgressStatus.SetRange("Allow on Released WO", true);
                            WOProgressStatusLookup.SetTableView(WOrderProgressStatus);
                            WOProgressStatusLookup.LookupMode := true;
                            if WOProgressStatusLookup.RunModal = ACTION::LookupOK then
                                Text := WOProgressStatusLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(MaintLocationFilter; MaintLocationFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Maint. Location Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintLocationList: Page "MCH Maintenance Location List";
                        begin
                            MaintLocationList.LookupMode := true;
                            if MaintLocationList.RunModal = ACTION::LookupOK then
                                Text := MaintLocationList.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(AssetRespGroupFilter; AssetRespGroupFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Asset Responsibility Group Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AssetRespGroupLookup: Page "MCH Asset Resp. Group Lookup";
                        begin
                            AssetRespGroupLookup.LookupMode := true;
                            if AssetRespGroupLookup.RunModal = ACTION::LookupOK then
                                Text := AssetRespGroupLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(PersonReponsibleFilter; PersonReponsibleFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Person Reponsible';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AssetMaintUserLookup: Page "MCH Asset Maint. User Lookup";
                        begin
                            AssetMaintUserLookup.LookupMode := true;
                            if AssetMaintUserLookup.RunModal = ACTION::LookupOK then
                                Text := AssetMaintUserLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(AssignedToUserIDFilter; AssignedToUserIDFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Assigned to User ID';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AssetMaintUserLookup: Page "MCH Asset Maint. User Lookup";
                        begin
                            AssetMaintUserLookup.LookupMode := true;
                            if AssetMaintUserLookup.RunModal = ACTION::LookupOK then
                                Text := AssetMaintUserLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(MaintAssetFilter; MaintAssetFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Asset No.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintAssetLookup: Page "MCH Maintenance Asset Lookup";
                        begin
                            MaintAssetLookup.LookupMode := true;
                            if MaintAssetLookup.RunModal = ACTION::LookupOK then
                                Text := MaintAssetLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                }
            }
            group(StepPurchaseOrder)
            {
                Caption = '';
                Visible = PurchaseOrderVisible;
                group(StepTopSpaceGroup2)
                {
                    Visible = NOT PurchaseOrderVisible;
                    field(StepTopSpace2; '')
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(StepPurchaseOrderPara)
                {
                    Caption = 'Purchase Order';
                    InstructionalText = 'The purchase order to which you want add maintenance purchase lines.';
                    field(PONo; CallingPurchHeader."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No.';
                        Editable = false;
                    }
                    field(POBoyFromVendorNo; CallingPurchHeader."Buy-from Vendor No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Buy-from Vendor No.';
                        Editable = false;
                    }
                    field(POBoyFromVendorName; CallingPurchHeader."Buy-from Vendor Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Buy-from Vendor Name';
                        Editable = false;
                    }
                }
            }
            group(StepWhatWhen)
            {
                ShowCaption = false;
                Visible = WhatWhenVisible;
                group(StepTopSpaceGroup3)
                {
                    Visible = NOT WhatWhenVisible;
                    field(StepTopSpace3; '')
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Work Order Budget")
                {
                    Caption = 'Work Order Budget - Filters';
                    InstructionalText = 'Set filters on the work order budget lines.';
                    group(BudgetFilterGroup1)
                    {
                        Caption = 'BudgetFilterGroup1';
                        Enabled = IsCalledFromPurchaseDoc;
                        ShowCaption = false;
                        Visible = IsCalledFromPurchaseDoc;
                        field(IncludeBudgetLinesWithoutVendor; IncludeBudgetLinesWithoutVendor)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Budget Lines without a Vendor No.';
                            Editable = IsCalledFromPurchaseDoc;
                            Enabled = IsCalledFromPurchaseDoc;
                        }
                    }
                    field(VendorNoFilter; VendorNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Buy-from Vendor No.';
                        Editable = NOT IsCalledFromPurchaseDoc;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            VendList: Page "Vendor List";
                        begin
                            if (not IsCalledFromPurchaseDoc) then begin
                                VendList.LookupMode := true;
                                if VendList.RunModal = ACTION::LookupOK then
                                    Text := VendList.GetSelectionFilter
                                else
                                    exit(false);
                                exit(true);
                            end;
                        end;
                    }
                    field(StartingDateFilter; StartingDateFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Budget Starting Date Filter';

                        trigger OnValidate()
                        var
                            FilterTokens: Codeunit "Filter Tokens";
                        begin
                            FilterTokens.MakeDateFilter(StartingDateFilter);
                        end;
                    }
                    field(IncludeSparePart; IncludeSparePart)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Maint. Spare Parts';
                    }
                    field(SparePartFilter; SparePartFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Maint. Spare Part No.';
                        Enabled = IncludeSparePart;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintSparePartLookup: Page "MCH Maint. Spare Part Lookup";
                        begin
                            MaintSparePartLookup.LookupMode := true;
                            if MaintSparePartLookup.RunModal = ACTION::LookupOK then
                                Text := MaintSparePartLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(IncludeMaintCost; IncludeMaintCost)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Maint. Costs';
                    }
                    field(MaintCostFilter; MaintCostFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Maint. Cost Code';
                        Enabled = IncludeMaintCost;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintCostLookup: Page "MCH Maint. Cost Lookup";
                        begin
                            MaintCostLookup.LookupMode := true;
                            if MaintCostLookup.RunModal = ACTION::LookupOK then
                                Text := MaintCostLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(IncludeTrade; IncludeTrade)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Maint. Trades';
                    }
                    field(TradeFilter; TradeFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Maint. Trade Code';
                        Enabled = IncludeTrade;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintTradeLookup: Page "MCH Maintenance Trade Lookup";
                        begin
                            MaintTradeLookup.LookupMode := true;
                            if MaintTradeLookup.RunModal = ACTION::LookupOK then
                                Text := MaintTradeLookup.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                }
            }
            group(StepSuggestions)
            {
                Caption = '';
                Visible = SuggestionsVisible;
                group("Purchase Suggestion")
                {
                    Caption = 'Purchase Suggestion';
                    part(SuggestionLinePage; "MCH AM Purchase Wizard Sub")
                    {
                        ApplicationArea = Basic, Suite;
                        UpdatePropagation = Both;
                    }
                }
            }
            group(StepReadyToOrder)
            {
                ShowCaption = false;
                Visible = ReadyToOrderVisible;
                group(StepTopSpaceGroup4)
                {
                    Visible = NOT ReadyToOrderVisible;
                    field(StepTopSpace4; '')
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Ready)
                {
                    Caption = 'Selection Complete';
                    InstructionalText = 'Ready to create the maintenance purchase order line(s).';
                    field(NoOfBudgetLinesSelectedInfo; StrSubstNo(NoOfBudgetLinesSelectedTxt, NoOfLinesSelected, NoOfSuggestionLines))
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviousPage)
            {
                ApplicationArea = Suite;
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(NextPage)
            {
                ApplicationArea = Suite;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(Finish)
            {
                ApplicationArea = Suite;
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserNotMaintUserErrMsg: Label 'Your must be setup as a Maintenance User to perform the selected action.';
    begin
        if not MaintUser.Get(UserId) then
            Error(UserNotMaintUserErrMsg);
        InitWizardControls;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        QstText: Text;
    begin
        if CloseAction = ACTION::OK then begin
            if (Step <> Step::Finished) then begin
                if IsCalledFromPurchaseDoc then
                    QstText := NotFinishedCloseQst
                else
                    QstText := NotFinishedCloseQst;
                if not Confirm(QstText, false) then
                    Error('');
            end;
        end;
    end;

    var
        MaintUser: Record "MCH Asset Maintenance User";
        SuggestionBuffer: Record "MCH AM Purch. Suggest Buffer" temporary;
        CallingWorkOrder: Record "MCH Work Order Header";
        CallingPurchHeader: Record "Purchase Header";
        SuggestWizardHelper: Codeunit "MCH AM Suggest Wizard Helper";
        IsCalledFromWorkOrder: Boolean;
        IsCalledFromPurchaseDoc: Boolean;
        Step: Option WorkOrder,PurchaseOrder,WhatWhen,Suggestions,ReadyToOrder,Finished;
        [InDataSet]
        BackEnabled: Boolean;
        [InDataSet]
        NextEnabled: Boolean;
        [InDataSet]
        FinishEnabled: Boolean;
        [InDataSet]
        WorkOrderVisible: Boolean;
        [InDataSet]
        PurchaseOrderVisible: Boolean;
        [InDataSet]
        WhatWhenVisible: Boolean;
        [InDataSet]
        SuggestionsVisible: Boolean;
        [InDataSet]
        ReadyToOrderVisible: Boolean;
        [InDataSet]
        AnyWO: Boolean;
        [InDataSet]
        MultipleWO: Boolean;
        [InDataSet]
        SingleWO: Boolean;
        [InDataSet]
        NoOfWO: Integer;
        [InDataSet]
        IncludeBudgetLinesWithoutVendor: Boolean;
        PurchOrderVendorNo: Code[20];
        [InDataSet]
        VendorNoFilter: Text;
        [InDataSet]
        StartingDateFilter: Text;
        [InDataSet]
        WorkOrderNoFilter: Text;
        [InDataSet]
        WOTypeFilter: Text;
        [InDataSet]
        ProgressStatusFilter: Text;
        [InDataSet]
        MaintLocationFilter: Text;
        [InDataSet]
        AssetRespGroupFilter: Text;
        [InDataSet]
        PersonReponsibleFilter: Text;
        [InDataSet]
        AssignedToUserIDFilter: Text;
        [InDataSet]
        MaintAssetFilter: Text;
        [InDataSet]
        SparePartFilter: Text;
        [InDataSet]
        MaintCostFilter: Text;
        [InDataSet]
        TradeFilter: Text;
        [InDataSet]
        IncludeSparePart: Boolean;
        [InDataSet]
        IncludeMaintCost: Boolean;
        [InDataSet]
        IncludeTrade: Boolean;
        NoOfLinesSelected: Integer;
        NoLinesSelectedErrMsg: Label 'No lines selected for purchase.';
        NoPurchaseOrdersCreatedErr: Label 'No purchase orders created.';
        NotFinishedCloseQst: Label 'No maintenance purchase order was created.\\Are you sure that you want to exit?';
        NotFinishedFromOrderCloseQst: Label 'No maintenance purchase lines were added.\\Are you sure that you want to exit?';
        NoOfBudgetLinesSelectedTxt: Label '%1 of %2 suggested work order budget line(s) selected';
        NoOfSuggestionLines: Integer;

    local procedure NextStep(Backwards: Boolean)
    var
        NoSuggestionsMsg: Label 'No work order budget lines found.';
    begin
        if Backwards then begin
            case Step of
                Step::WorkOrder:
                    begin
                        if IsCalledFromPurchaseDoc then
                            Step := Step::PurchaseOrder;
                    end;
                Step::PurchaseOrder:
                    begin
                        // No backwards
                    end;
                Step::WhatWhen:
                    begin
                        Step := Step::WorkOrder
                    end;
                Step::Suggestions:
                    begin
                        Step := Step::WhatWhen;
                    end;
                Step::ReadyToOrder:
                    begin
                        Step := Step::Suggestions;
                    end;
            end;
        end else begin
            case Step of
                Step::WorkOrder:
                    begin
                        Step := Step::WhatWhen
                    end;
                Step::PurchaseOrder:
                    begin
                        Step := Step::WorkOrder;
                    end;
                Step::WhatWhen:
                    begin
                        ValidateWhatWhenSettings();
                        if DoCalculate() then begin
                            Step := Step::Suggestions;
                        end else begin
                            Message(NoSuggestionsMsg);
                        end;
                    end;
                Step::Suggestions:
                    begin
                        ValidateSelections();
                        Step := Step::ReadyToOrder;
                    end;
                Step::ReadyToOrder:
                    begin
                        CompletePurchase();
                        Step := Step::Finished;
                        CurrPage.Close;
                    end;
            end;
        end;
        SetControlVisibility();
        CurrPage.Update(false);
    end;

    local procedure SetControlVisibility()
    begin
        BackEnabled := true;
        NextEnabled := true;
        FinishEnabled := false;
        WorkOrderVisible := false;
        PurchaseOrderVisible := false;
        WhatWhenVisible := false;
        SuggestionsVisible := false;
        ReadyToOrderVisible := false;

        case Step of
            Step::WorkOrder:
                begin
                    WorkOrderVisible := true;
                    if not IsCalledFromPurchaseDoc then
                        BackEnabled := false;
                end;
            Step::PurchaseOrder:
                begin
                    PurchaseOrderVisible := true;
                end;
            Step::WhatWhen:
                begin
                    WhatWhenVisible := true;
                end;
            Step::Suggestions:
                begin
                    SuggestionsVisible := true;
                end;
            Step::ReadyToOrder:
                begin
                    ReadyToOrderVisible := true;
                    NextEnabled := false;
                    FinishEnabled := true;
                end;
        end;
    end;

    local procedure InitWizardControls()
    begin
        IncludeSparePart := true;
        IncludeMaintCost := true;
        IncludeTrade := true;
        CurrPage.SuggestionLinePage.PAGE.SetVendorNoEditable(not IsCalledFromPurchaseDoc);

        case true of
            IsCalledFromWorkOrder:
                begin
                    Step := Step::WhatWhen;
                    if SingleWO then begin
                        NextStep(false);
                    end;
                end;
            else begin
                    Step := Step::WorkOrder;
                    MaintLocationFilter := MaintUser."Default Maint. Location Code";
                end;
        end;
        AnyWO := not IsCalledFromWorkOrder;
        SetControlVisibility();
    end;


    procedure SetCalledFromWorkOrder(var NewCallingWorkOrder: Record "MCH Work Order Header")
    begin
        IsCalledFromWorkOrder := true;
        CallingWorkOrder.Copy(NewCallingWorkOrder);
        with CallingWorkOrder do begin
            SetRange(Status, Status::Released);
            FindFirst;
            MultipleWO := Next <> 0;
            SingleWO := not MultipleWO;
            if SingleWO then begin
                SuggestWizardHelper.PreCheckWorkOrderForPurchasing(CallingWorkOrder);
                SetRecFilter;
                WorkOrderNoFilter := "No.";
            end else
                WorkOrderNoFilter := '';
            NoOfWO := Count;
        end;
    end;


    procedure SetCalledFromPurchDocument(var NewCallingPurchHeader: Record "Purchase Header")
    begin
        IsCalledFromPurchaseDoc := true;
        CallingPurchHeader := NewCallingPurchHeader;
        with CallingPurchHeader do begin
            Find;
            TestStatusOpen;
            TestField("Buy-from Vendor No.");
            VendorNoFilter := "Buy-from Vendor No.";
            PurchOrderVendorNo := "Buy-from Vendor No.";
        end;
    end;

    local procedure ValidateWhatWhenSettings()
    var
        MissingPurchaseTypeErrMsg: Label 'You must select either spare part, cost or/and trade.';
    begin
        if not (IncludeSparePart or IncludeMaintCost or IncludeTrade) then
            Error(MissingPurchaseTypeErrMsg);
    end;

    local procedure DoCalculate() OK: Boolean
    var
        VendorNoFilter2: Text;
    begin
        SuggestionBuffer.Reset;
        SuggestionBuffer.DeleteAll;
        CurrPage.SuggestionLinePage.PAGE.SetPageSourceTempRecords(SuggestionBuffer);
        Clear(SuggestWizardHelper);
        SuggestWizardHelper.PurchaseSetWorkOrderParameters(
          CallingWorkOrder,
          MultipleWO,
          WorkOrderNoFilter,
          WOTypeFilter,
          ProgressStatusFilter,
          MaintLocationFilter,
          AssetRespGroupFilter,
          PersonReponsibleFilter,
          AssignedToUserIDFilter);

        if IsCalledFromPurchaseDoc and IncludeBudgetLinesWithoutVendor then
            VendorNoFilter2 := StrSubstNo('%1|%2', ''' ''', VendorNoFilter)
        else
            VendorNoFilter2 := VendorNoFilter;

        SuggestWizardHelper.PurchaseSetBudgetParameters(
          PurchOrderVendorNo,
          VendorNoFilter2,
          StartingDateFilter,
          MaintAssetFilter,
          IncludeSparePart,
          SparePartFilter,
          IncludeMaintCost,
          MaintCostFilter,
          IncludeTrade,
          TradeFilter);
        SuggestWizardHelper.PurchaseCalculateSuggestion(
          SuggestionBuffer);

        exit(not SuggestionBuffer.IsEmpty);
    end;

    local procedure ValidateSelections()
    begin
        CurrPage.SuggestionLinePage.PAGE.GetSelectedLines(SuggestionBuffer);
        SuggestionBuffer.SetRange(Selected);
        NoOfSuggestionLines := SuggestionBuffer.Count;
        SuggestionBuffer.SetRange(Selected, true);
        if SuggestionBuffer.IsEmpty then
            Error(NoLinesSelectedErrMsg);
        NoOfLinesSelected := SuggestionBuffer.Count;
    end;

    local procedure CompletePurchase()
    var
        PurchHeader: Record "Purchase Header";
        CreatedPurchOrderNoFilter: Text;
    begin
        CurrPage.SuggestionLinePage.PAGE.GetSelectedLines(SuggestionBuffer);
        SuggestionBuffer.SetRange(Selected, true);
        if SuggestionBuffer.IsEmpty then
            Error(NoLinesSelectedErrMsg);
        Clear(SuggestWizardHelper);
        SuggestWizardHelper.CreatePurchase(SuggestionBuffer, IsCalledFromPurchaseDoc, CallingPurchHeader."No.");
        Commit;

        if not IsCalledFromPurchaseDoc then begin
            CreatedPurchOrderNoFilter := SuggestWizardHelper.GetCreatedPurchOrderNoFilter;
            if (CreatedPurchOrderNoFilter = '') then
                Error(NoPurchaseOrdersCreatedErr);

            PurchHeader.SetFilter("No.", CreatedPurchOrderNoFilter);
            PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
            case PurchHeader.Count of
                0:
                    Error(NoPurchaseOrdersCreatedErr);
                1:
                    PAGE.Run(PAGE::"Purchase Order", PurchHeader);
                else
                    PAGE.Run(PAGE::"Purchase Order List", PurchHeader);
            end;
        end;
    end;
}

