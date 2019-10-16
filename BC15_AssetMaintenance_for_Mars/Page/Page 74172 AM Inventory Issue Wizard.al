page 74172 "MCH AM Inventory Issue Wizard"
{
    Caption = 'Suggest Inventory Issue - Wizard';
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
                    InstructionalText = 'The work order for which you want to issue inventory items.';
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
                    InstructionalText = 'Multiple work orders selected for which you want to issue inventory items.';
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
                    InstructionalText = 'Set filters on the work orders for which you want to issue inventory items.';
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
            group(StepWhatWhen)
            {
                ShowCaption = false;
                Visible = WhatWhenVisible;
                group(StepTopSpaceGroup2)
                {
                    Visible = NOT WhatWhenVisible;
                    field(StepTopSpace2; '')
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Work Order Budget")
                {
                    Caption = 'Work Order Budget - Filters';
                    InstructionalText = 'Set filters on the work order budget lines.';
                    field(ItemNoFilter; ItemNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item No.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Item: Record Item;
                            ItemList: Page "Item List";
                        begin
                            Item.SetRange(Type, Item.Type::Inventory);
                            ItemList.SetTableView(Item);
                            ItemList.LookupMode := true;
                            if ItemList.RunModal = ACTION::LookupOK then
                                Text := ItemList.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
                        end;
                    }
                    field(LocationCodeFilter; LocationCodeFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Location Filter';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            LocationList: Page "Location List";
                        begin
                            LocationList.LookupMode := true;
                            if LocationList.RunModal = ACTION::LookupOK then
                                Text := LocationList.GetSelectionFilter
                            else
                                exit(false);
                            exit(true);
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
                }
            }
            group(StepSuggestions)
            {
                Caption = '';
                Visible = SuggestionsVisible;
                group("Inventory Issue Suggestion")
                {
                    Caption = 'Inventory Issue Suggestion';
                    part(SuggestionLinePage; "MCH AM Invt. Issue Wiz. Sub")
                    {
                        ApplicationArea = Basic, Suite;
                        UpdatePropagation = Both;
                    }
                }
            }
            group(StepReadyToIssue)
            {
                ShowCaption = false;
                Visible = ReadyToIssueVisible;
                group(StepTopSpaceGroup4)
                {
                    Visible = NOT ReadyToIssueVisible;
                    field(StepTopSpace4; '')
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Ready)
                {
                    Caption = 'Selection Complete';
                    InstructionalText = 'Ready to create the inventory issue line(s).';
                    field(NoOfBudgetLinesSelectedInfo; StrSubstNo(NoOfBudgetLinesSelectedTxt, NoOfLinesSelected, NoOfSuggestionLines))
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                    }
                }
                group("Maint. Inventory Journal")
                {
                    Caption = 'Maint. Inventory Journal';
                    InstructionalText = 'The journal batch where inventory issue lines will be inserted.';
                    group(Control1101214032)
                    {
                        ShowCaption = false;
                        Visible = ShowJnlTemplate;
                        field("Template Name"; MaintJnlBatch."Journal Template Name")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Template Name';
                            Editable = NOT IsCalledFromJournal;
                            ShowMandatory = true;
                            TableRelation = "MCH Maint. Journal Template".Name WHERE(Type = CONST(Inventory));

                            trigger OnValidate()
                            begin
                                if not MaintJnlBatch.Get(MaintJnlBatch."Journal Template Name", MaintJnlBatch.Name) then
                                    MaintJnlBatch.Name := '';
                            end;
                        }
                    }
                    field("Batch Name"; MaintJnlBatch.Name)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Batch Name';
                        Editable = NOT IsCalledFromJournal;
                        ShowMandatory = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MaintJnlBatch2: Record "MCH Maint. Journal Batch";
                        begin
                            if not MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name") then
                                exit;
                            MaintJnlTemplate.TestField(Type, MaintJnlTemplate.Type::Inventory);
                            MaintJnlBatch2.FilterGroup(2);
                            MaintJnlBatch2.SetRange("Journal Template Name", MaintJnlBatch."Journal Template Name");
                            MaintJnlBatch2.FilterGroup(0);
                            MaintJnlBatch2."Journal Template Name" := MaintJnlBatch."Journal Template Name";
                            MaintJnlBatch2.Name := MaintJnlBatch.Name;
                            if PAGE.RunModal(0, MaintJnlBatch2) = ACTION::LookupOK then
                                MaintJnlBatch.Name := MaintJnlBatch2.Name;
                        end;

                        trigger OnValidate()
                        begin
                            if not MaintJnlBatch.Get(MaintJnlBatch."Journal Template Name", MaintJnlBatch.Name) then
                                MaintJnlBatch.Name := '';
                        end;
                    }
                    field("Location Code"; Location.Code)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Location Code';
                        TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
                        ToolTip = 'Specifies a Location Code that you want to used for All journal line Items.';
                    }
                    field("Issue to Resource No."; IssueToResource."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Issue to Resource No.';
                        TableRelation = Resource;
                        ToolTip = 'Specifies the resource/person to receive the journal items.';
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
    begin
        if CloseAction = ACTION::OK then begin
            if (Step <> Step::Finished) then begin
                if not Confirm(NotFinishedCloseQst, false) then
                    Error('');
            end;
        end;
    end;

    var
        MaintUser: Record "MCH Asset Maintenance User";
        SuggestionBuffer: Record "MCH AM Invt. Issue Suggest Buf" temporary;
        CallingWorkOrder: Record "MCH Work Order Header";
        CallingMaintJnlLine: Record "MCH Maint. Journal Line";
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
        IssueToResource: Record Resource;
        Location: Record Location;
        SuggestWizardHelper: Codeunit "MCH AM Suggest Wizard Helper";
        IsCalledFromWorkOrder: Boolean;
        IsCalledFromJournal: Boolean;
        Step: Option WorkOrder,WhatWhen,Suggestions,ReadyToIssue,Finished;
        [InDataSet]
        BackEnabled: Boolean;
        [InDataSet]
        NextEnabled: Boolean;
        [InDataSet]
        FinishEnabled: Boolean;
        [InDataSet]
        WorkOrderVisible: Boolean;
        [InDataSet]
        WhatWhenVisible: Boolean;
        [InDataSet]
        SuggestionsVisible: Boolean;
        [InDataSet]
        ReadyToIssueVisible: Boolean;
        [InDataSet]
        AnyWO: Boolean;
        [InDataSet]
        MultipleWO: Boolean;
        [InDataSet]
        SingleWO: Boolean;
        [InDataSet]
        NoOfWO: Integer;
        [InDataSet]
        ShowJnlTemplate: Boolean;
        [InDataSet]
        ItemNoFilter: Text;
        [InDataSet]
        LocationCodeFilter: Text;
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
        NoOfLinesSelected: Integer;
        NoLinesSelectedErrMsg: Label 'No lines selected for inventory issue.';
        NotFinishedCloseQst: Label 'No issue journal lines created.\\Are you sure that you want to exit?';
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
                Step::ReadyToIssue:
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
                Step::WhatWhen:
                    begin
                        if DoCalculate() then begin
                            Step := Step::Suggestions;
                        end else begin
                            Message(NoSuggestionsMsg);
                        end;
                    end;
                Step::Suggestions:
                    begin
                        ValidateSelections();
                        Step := Step::ReadyToIssue;
                    end;
                Step::ReadyToIssue:
                    begin
                        CompleteInventoryIssue();
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
        WhatWhenVisible := false;
        SuggestionsVisible := false;
        ReadyToIssueVisible := false;

        case Step of
            Step::WorkOrder:
                begin
                    WorkOrderVisible := true;
                    BackEnabled := false;
                end;
            Step::WhatWhen:
                begin
                    WhatWhenVisible := true;
                end;
            Step::Suggestions:
                begin
                    SuggestionsVisible := true;
                end;
            Step::ReadyToIssue:
                begin
                    SetDefaultJournalBatch();
                    ReadyToIssueVisible := true;
                    NextEnabled := false;
                    FinishEnabled := true;
                end;
        end;
    end;

    local procedure InitWizardControls()
    begin
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
                SuggestWizardHelper.PreCheckWorkOrderForInvtIssue(CallingWorkOrder);
                SetRecFilter;
                WorkOrderNoFilter := "No.";
            end else
                WorkOrderNoFilter := '';
            NoOfWO := Count;
        end;
    end;


    procedure SetCalledFromIssueJournal(var NewCallingMaintJnlLine: Record "MCH Maint. Journal Line")
    begin
        IsCalledFromJournal := true;
        CallingMaintJnlLine := NewCallingMaintJnlLine;
        IssueToResource."No." := NewCallingMaintJnlLine."Resource No. (Issue/Return)";
        MaintJnlBatch.Get(CallingMaintJnlLine."Journal Template Name", CallingMaintJnlLine."Journal Batch Name");
        MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");
        MaintJnlTemplate.TestField(Type, MaintJnlTemplate.Type::Inventory);
    end;

    local procedure DoCalculate() OK: Boolean
    begin
        SuggestionBuffer.Reset;
        SuggestionBuffer.DeleteAll;
        CurrPage.SuggestionLinePage.PAGE.SetPageSourceTempRecords(SuggestionBuffer);
        Clear(SuggestWizardHelper);
        SuggestWizardHelper.InvtIssueSetWorkOrderParameters(
          CallingWorkOrder,
          MultipleWO,
          WorkOrderNoFilter,
          WOTypeFilter,
          ProgressStatusFilter,
          MaintLocationFilter,
          AssetRespGroupFilter,
          PersonReponsibleFilter,
          AssignedToUserIDFilter);
        SuggestWizardHelper.InvtIssueSetBudgetParameters(
          ItemNoFilter,
          LocationCodeFilter,
          StartingDateFilter,
          MaintAssetFilter);
        SuggestWizardHelper.InvtIssueCalculateSuggestion(
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

    local procedure SetDefaultJournalBatch()
    begin
        MaintJnlTemplate.SetRange(Type, MaintJnlTemplate.Type::Inventory);
        if (not IsCalledFromJournal) then begin
            if (MaintJnlBatch."Journal Template Name" = '') then begin
                if MaintJnlTemplate.FindFirst then
                    MaintJnlBatch."Journal Template Name" := MaintJnlTemplate.Name;
            end;
            if (MaintJnlBatch."Journal Template Name" = '') then
                MaintJnlBatch.Name := ''
            else begin
                MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");
                if not MaintJnlBatch.Get(MaintJnlTemplate.Name, MaintJnlBatch.Name) then begin
                    MaintJnlBatch.SetRange("Journal Template Name", MaintJnlTemplate.Name);
                    if MaintJnlBatch.FindFirst then;
                end;
            end;
        end;

        ShowJnlTemplate := (MaintJnlTemplate.Count <> 1);
    end;

    local procedure CompleteInventoryIssue()
    var
        MaintJnlLine: Record "MCH Maint. Journal Line";
    begin
        MaintJnlBatch.Get(MaintJnlBatch."Journal Template Name", MaintJnlBatch.Name);
        MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");

        CurrPage.SuggestionLinePage.PAGE.GetSelectedLines(SuggestionBuffer);
        SuggestionBuffer.SetRange(Selected, true);
        if SuggestionBuffer.IsEmpty then
            Error(NoLinesSelectedErrMsg);
        Clear(SuggestWizardHelper);

        SuggestWizardHelper.CreateInvtIssueJnlLines(SuggestionBuffer, MaintJnlBatch, IssueToResource."No.", Location.Code);
        Commit;

        if not IsCalledFromJournal then begin
            MaintJnlLine.FilterGroup(2);
            MaintJnlLine.SetRange("Journal Template Name", MaintJnlTemplate.Name);
            MaintJnlLine.SetRange("Journal Batch Name", MaintJnlBatch.Name);
            MaintJnlLine.FilterGroup(0);
            if MaintJnlLine.FindLast then;
            PAGE.Run(MaintJnlTemplate."Page ID", MaintJnlLine);
        end;
    end;
}

