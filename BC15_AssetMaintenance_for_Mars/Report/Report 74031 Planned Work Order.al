report 74031 "MCH Planned Work Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/MCHPlannedWorkOrder.rdlc';
    Caption = 'Planned Work Order';
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Header;"MCH Work Order Header")
        {
            DataItemTableView = SORTING(Status,"No.") WHERE(Status=CONST(Planned));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Progress Status Code","Work Order Type",Priority,"Starting Date","Person Responsible";
            RequestFilterHeading = 'Planned Work Order';
            column(CompanyName;COMPANYPROPERTY.DisplayName)
            {
            }
            column(ReportCaptionLbl;ReportCaptionLbl)
            {
            }
            column(ReportPageNoCaption;ReportPageNoCaption)
            {
            }
            column(ReportLogo;MaintLocation.Picture)
            {
            }
            column(ReportPrintInfoText;PrintInfoText)
            {
            }
            column(WO_No;"No.")
            {
            }
            column(WO_NoLbl;FieldCaption("No."))
            {
            }
            column(WO_Status;Format(Status))
            {
            }
            column(WO_StatusLbl;FieldCaption(Status))
            {
            }
            column(WO_OrderDate;Format("Order Date"))
            {
            }
            column(WO_OrderDateLbl;FieldCaption("Order Date"))
            {
            }
            column(WO_RequestedStartingDate;Format("Requested Starting Date"))
            {
            }
            column(WO_RequestedStartingDateLbl;FieldCaption("Requested Starting Date"))
            {
            }
            column(WO_StartingDate;Format("Starting Date"))
            {
            }
            column(WO_StartingDateLbl;FieldCaption("Starting Date"))
            {
            }
            column(WO_ExpectedEndingDate;Format("Expected Ending Date"))
            {
            }
            column(WO_ExpectedEndingDateLbl;FieldCaption("Expected Ending Date"))
            {
            }
            column(WO_EndingDate;Format("Ending Date"))
            {
            }
            column(WO_EndingDateLbl;FieldCaption("Ending Date"))
            {
            }
            column(WO_CompletionDate;Txt2Txt(Format("Completion Date"),false))
            {
            }
            column(WO_CompletionDateLbl;Txt2Txt(FieldCaption("Completion Date"),true))
            {
            }
            column(WO_WorkOrderType;"Work Order Type")
            {
            }
            column(WO_WorkOrderTypeLbl;Txt2Txt(FieldCaption("Work Order Type"),HideWorkOrderType))
            {
            }
            column(WO_MaintLocationCode;"Maint. Location Code")
            {
            }
            column(WO_MaintLocationCodeLbl;Txt2Txt(FieldCaption("Maint. Location Code"),"Maint. Location Code"=''))
            {
            }
            column(WO_ResponsibilityGroupCode;"Responsibility Group Code")
            {
            }
            column(WO_ResponsibilityGroupCodeLbl;Txt2Txt(FieldCaption("Responsibility Group Code"),HideAssetRespGroupCode))
            {
            }
            column(WO_Priority;Format(Priority))
            {
            }
            column(WO_PriorityLbl;FieldCaption(Priority))
            {
            }
            column(WO_ProgressStatusCode;"Progress Status Code")
            {
            }
            column(WO_ProgressStatusCodeLbl;Txt2Txt(FieldCaption("Progress Status Code"),HideProgressStatusCode))
            {
            }
            column(WO_Description;Description)
            {
            }
            column(WO_DescriptionLbl;FieldCaption(Description))
            {
            }
            column(WO_Description2;"Description 2")
            {
            }
            column(WO_Description2Lbl;FieldCaption("Description 2"))
            {
            }
            column(WO_LongDescription;MakeLongTxt(Description,"Description 2"))
            {
            }
            column(WO_CreatedBy;"Created By")
            {
            }
            column(WO_CreatedByLbl;FieldCaption("Created By"))
            {
            }
            column(WO_PersonResponsible;"Person Responsible")
            {
            }
            column(WO_PersonResponsibleLbl;FieldCaption("Person Responsible"))
            {
            }
            column(WO_AssignedUserID;"Assigned User ID")
            {
            }
            column(WO_AssignedUserIDLbl;FieldCaption("Assigned User ID"))
            {
            }
            column(MaintAddr1;MaintAddr[1])
            {
            }
            column(MaintAddr2;MaintAddr[2])
            {
            }
            column(MaintAddr3;MaintAddr[3])
            {
            }
            column(MaintAddr4;MaintAddr[4])
            {
            }
            column(MaintAddr5;MaintAddr[5])
            {
            }
            column(MaintAddr6;MaintAddr[6])
            {
            }
            column(MaintAddr7;MaintAddr[7])
            {
            }
            column(MaintAddr8;MaintAddr[8])
            {
            }
            column(ShowWorkDescription;ShowWorkDescription)
            {
            }
            column(ShowBudgetSummary;ShowBudgetSummary)
            {
            }
            column(ShowBudgetLines;ShowBudgetLines)
            {
            }
            column(ShowWorkInstructions;ShowWorkInstructions)
            {
            }
            dataitem(WorkDescriptionLines;"Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number=FILTER(1..99999));
                column(WorkDescription_LineNo;Number)
                {
                }
                column(WorkDescription_LineTxt;WorkDescriptionLineTxt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if WorkDescriptionInStream.EOS then
                      CurrReport.Break;
                    WorkDescriptionInStream.ReadText(WorkDescriptionLineTxt);

                    ClearObsoluteHeaderData;
                    FirstRowOutput := true;
                end;

                trigger OnPostDataItem()
                begin
                    Clear(WorkDescriptionInStream);
                end;

                trigger OnPreDataItem()
                begin
                    if not ShowWorkDescription then
                      CurrReport.Break;
                    Clear(WorkDescriptionInStream);
                    Header."Work Description".CreateInStream(WorkDescriptionInStream,TEXTENCODING::UTF8);
                end;
            }
            dataitem(Line;"MCH Work Order Line")
            {
                DataItemLink = Status=FIELD(Status),"Work Order No."=FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING(Status,"Work Order No.","Line No.");
                column(Line_LineNo;"Line No.")
                {
                }
                column(Line_AssetNo;"Asset No.")
                {
                }
                column(Line_AssetNoLbl;FieldCaption("Asset No."))
                {
                }
                column(Line_AssetLbl;AssetLbl)
                {
                }
                column(Line_Description;Description)
                {
                }
                column(Line_DescriptionLbl;FieldCaption(Description))
                {
                }
                column(Line_Description2;"Description 2")
                {
                }
                column(Line_Description2Lbl;FieldCaption("Description 2"))
                {
                }
                column(Line_LongDescription;MakeLongTxt(Description,"Description 2"))
                {
                }
                column(Line_StartingDate;Format("Starting Date"))
                {
                }
                column(Line_StartingDateLbl;FieldCaption("Starting Date"))
                {
                }
                column(Line_EndingDate;Format("Ending Date"))
                {
                }
                column(Line_EndingDateLbl;FieldCaption("Ending Date"))
                {
                }
                column(Line_CompletionDate;Txt2Txt(Format("Completion Date"),false))
                {
                }
                column(Line_CompletionDateLbl;Txt2Txt(FieldCaption("Completion Date"),false))
                {
                }
                column(Line_ExpectedDurationHours;"Expected Duration (Hours)")
                {
                }
                column(Line_ExpectedDurationHoursAsTxt;Qty2Txt("Expected Duration (Hours)","Expected Duration (Hours)"=0))
                {
                }
                column(Line_ExpectedDurationHoursLbl;FieldCaption("Expected Duration (Hours)"))
                {
                }
                column(Line_ExpectedDowntimeHours;"Expected Downtime (Hours)")
                {
                }
                column(Line_ExpectedDowntimeHoursAsTxt;Qty2Txt("Expected Downtime (Hours)","Expected Downtime (Hours)"=0))
                {
                }
                column(Line_ExpectedDowntimeHoursLbl;FieldCaption("Expected Downtime (Hours)"))
                {
                }
                column(Line_TaskCode;"Task Code")
                {
                }
                column(Line_TaskCodeLbl;FieldCaption("Task Code"))
                {
                }
                column(Line_TaskLbl;TaskLbl)
                {
                }
                column(Line_TaskDescription;"Task Description")
                {
                }
                column(Line_TaskDescriptionLbl;FieldCaption("Task Description"))
                {
                }
                column(Line_TaskScheduledDate;Format("Task Scheduled Date"))
                {
                }
                column(Line_TaskScheduledDateLbl;FieldCaption("Task Scheduled Date"))
                {
                }
                column(Line_TaskUsageMonitorCode;AssetUsageMonitor."Monitor Code")
                {
                }
                column(Line_TaskUsageMonitorCodeLbl;TaskUsageMonitorCodeLbl)
                {
                }
                column(Line_TaskUsageUoMCode;AssetUsageMonitor."Unit of Measure Code")
                {
                }
                column(Line_TaskUsageUoMCodeLbl;UsageUnitOfMeasureLbl)
                {
                }
                column(Line_TaskScheduledUsage;"Task Scheduled Usage Value")
                {
                }
                column(Line_TaskScheduledUsageAsTxt;Qty2Txt("Task Scheduled Usage Value","Task Scheduled Usage Value"=0))
                {
                }
                column(Line_TaskScheduledUsageLbl;FieldCaption("Task Scheduled Usage Value"))
                {
                }
                column(Line_UsageOnCompletion;"Usage on Completion")
                {
                }
                column(Line_UsageOnCompletionAsTxt;Qty2Txt("Usage on Completion","Usage on Completion"=0))
                {
                }
                column(Line_UsageOnCompletionLbl;Txt2Txt(FieldCaption("Usage on Completion"),true))
                {
                }
                column(Line_DimCaptionLbl;Txt2Txt(LineDimCaptionLbl,not RequestShowLineDimensions))
                {
                }
                column(Line_Dimensions;GetDimensionList("Dimension Set ID",not RequestShowLineDimensions))
                {
                }
                column(Line_ShowLineTaskDetails;ShowLineTaskDetails)
                {
                }
                column(Line_ShowLineTaskUsageDetails;ShowLineTaskUsageDetails)
                {
                }
                column(Line_ShowLineStartEndDates;ShowLineStartEndDates)
                {
                }
                column(LineShowLineCompletionDate;ShowLineCompletionDate)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(AssetMaintTask);
                    Clear(AssetUsageMonitor);
                    ShowLineTaskDetails := false;
                    ShowLineTaskUsageDetails := false;

                    ShowLineStartEndDates := (Header."Starting Date" <> "Starting Date") or (Header."Ending Date" <> "Ending Date");
                    ShowLineCompletionDate := (Header."Completion Date" <> "Completion Date");

                    if (Line."Task Code" <> '') then begin
                      ShowLineTaskDetails := true;
                      AssetMaintTask.Get("Asset No.","Task Code");
                      if (AssetMaintTask."Usage Monitor Code" <> '') then begin
                        ShowLineTaskUsageDetails := true;
                        AssetUsageMonitor.Get(AssetMaintTask."Asset No.",AssetMaintTask."Usage Monitor Code");
                      end;
                    end;

                    ClearObsoluteHeaderData;
                    FirstRowOutput := true;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Asset No.",'<>%1','');
                end;
            }
            dataitem(BudgetSummaryLine;"MCH Work Order Budget Line")
            {
                DataItemTableView = SORTING(Status,"Work Order No.","Line No.");
                UseTemporary = true;
                column(BudgetSummaryLbl;BudgetSummaryLbl)
                {
                }
                column(BudgetSum_LineNo;"Line No.")
                {
                }
                column(BudgetSum_Type;Format(Type))
                {
                }
                column(BudgetSum_TypeLbl;FieldCaption(Type))
                {
                }
                column(BudgetSum_ColCaption1;BudgetSumColCaption[1])
                {
                }
                column(BudgetSum_ColCaption2;BudgetSumColCaption[2])
                {
                }
                column(BudgetSum_ColCaption3;BudgetSumColCaption[3])
                {
                }
                column(BudgetSum_ColCaption4;BudgetSumColCaption[4])
                {
                }
                column(BudgetSum_ColCaption5;BudgetSumColCaption[5])
                {
                }
                column(BudgetSum_ColCaption6;BudgetSumColCaption[6])
                {
                }
                column(BudgetSum_Col1;BudgetSumColAsTxt[Type,1])
                {
                }
                column(BudgetSum_Col2;BudgetSumColAsTxt[Type,2])
                {
                }
                column(BudgetSum_Col3;BudgetSumColAsTxt[Type,3])
                {
                }
                column(BudgetSum_Col4;BudgetSumColAsTxt[Type,4])
                {
                }
                column(BudgetSum_Col5;BudgetSumColAsTxt[Type,5])
                {
                }
                column(BudgetSum_Col6;BudgetSumColAsTxt[Type,6])
                {
                }
                column(BudgetSum_TotalCol1;BudgetSumColAsTxt[8,1])
                {
                }
                column(BudgetSum_TotalCol2;BudgetSumColAsTxt[8,2])
                {
                }
                column(BudgetSum_TotalCol3;BudgetSumColAsTxt[8,3])
                {
                }
                column(BudgetSum_TotalCol4;BudgetSumColAsTxt[8,4])
                {
                }
                column(BudgetSum_TotalCol5;BudgetSumColAsTxt[8,5])
                {
                }
                column(BudgetSum_TotalCol6;BudgetSumColAsTxt[8,6])
                {
                }
                column(BudgetSum_IsLineWithTotals;BudgetSumLineNoWithTotals="Line No.")
                {
                }

                trigger OnPreDataItem()
                begin
                    if not ShowBudgetSummary then
                      CurrReport.Break;
                end;
            }
            dataitem(BudgetLine;"MCH Work Order Budget Line")
            {
                DataItemLink = Status=FIELD(Status),"Work Order No."=FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING(Status,"Work Order No.","Work Order Line No.");
                column(BudgetLineLbl;BudgetLineLbl)
                {
                }
                column(Budget_AssetTaskCaption;BudgetLineAssetTaskCaption)
                {
                }
                column(Budget_LineNo;"Line No.")
                {
                }
                column(Budget_WOLineNo;"Work Order Line No.")
                {
                }
                column(Budget_Type;Format(Type))
                {
                }
                column(Budget_TypeLbl;FieldCaption(Type))
                {
                }
                column(Budget_No;"No.")
                {
                }
                column(Budget_NoLbl;FieldCaption("No."))
                {
                }
                column(Budget_Description;Description)
                {
                }
                column(Budget_DescriptionLbl;FieldCaption(Description))
                {
                }
                column(Budget_Description2;"Description 2")
                {
                }
                column(Budget_Description2Lbl;FieldCaption("Description 2"))
                {
                }
                column(Budget_LongDescription;MakeLongTxt(Description,"Description 2"))
                {
                }
                column(Budget_LocationCode;"Location Code")
                {
                }
                column(Budget_LocationCodeLbl;FieldCaption("Location Code"))
                {
                }
                column(Budget_UoMCode;"Unit of Measure Code")
                {
                }
                column(Budget_UoMCodeLbl;BudgetUnitOfMeasureLbl)
                {
                }
                column(Budget_Quantity;Quantity)
                {
                }
                column(Budget_QuantityAsTxt;Qty2Txt(Quantity,false))
                {
                }
                column(Budget_QuantityLbl;FieldCaption(Quantity))
                {
                }
                column(Budget_PostedQuantity;BudgetPostedQuantity)
                {
                    DecimalPlaces = 0:5;
                }
                column(Budget_PostedQuantityAsTxt;Qty2Txt(BudgetPostedQuantity,BudgetPostedQuantity=0))
                {
                }
                column(Budget_PostedQuantityLbl;Txt2Txt(BudgetPostedQuantityLbl,true))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if (WorkOrderLine."Work Order No." <> "Work Order No.") or
                       (WorkOrderLine."Line No." <> "Work Order Line No.")
                    then
                      WorkOrderLine.Get(Status,"Work Order No.","Work Order Line No.");

                    BudgetLineAssetTaskCaption := '';
                    if (WorkOrderLine."Task Code" <> '') then
                      BudgetLineAssetTaskCaption := StrSubstNo('%1: %2 - %3: %4',AssetLbl,WorkOrderLine."Asset No.",TaskLbl,WorkOrderLine."Task Code")
                    else
                      if ("Asset No." <> '') then
                        BudgetLineAssetTaskCaption := StrSubstNo('%1: %2',AssetLbl,WorkOrderLine."Asset No.");

                    BudgetPostedQuantity := 0;
                    if ("Posted Qty. (Base)" <> 0) then begin
                      if ("Qty. per Unit of Measure" <> 0) then
                        BudgetPostedQuantity := Round("Posted Qty. (Base)" / "Qty. per Unit of Measure",0.00001);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if not ShowBudgetLines then
                      CurrReport.Break;
                    SetAutoCalcFields("Posted Qty. (Base)");
                end;
            }
            dataitem(WorkInstructionSetup;"MCH Work Instruction Setup")
            {
                DataItemTableView = SORTING("Table Name",Code,"Work Instruction No.");
                UseTemporary = true;
                column(WorkInstructionsLbl;WorkInstructionsLbl)
                {
                }
                column(WorkInstrSetup_TableCodeCaption;StrSubstNo('%1: %2',"Table Name",Code))
                {
                }
                dataitem(WorkInstructionHeader;"MCH Work Instruction Header")
                {
                    DataItemLink = "No."=FIELD("Work Instruction No.");
                    DataItemTableView = SORTING("No.");
                    column(WorkInstr_No;"No.")
                    {
                    }
                    column(WorkInstr_Description;Description)
                    {
                    }
                    dataitem(WorkInstructionLine;"MCH Work Instruction Line")
                    {
                        DataItemLink = "Work Instruction No."=FIELD("No.");
                        DataItemTableView = SORTING("Work Instruction No.","Line No.");
                        column(WorkInstr_LineText;Text)
                        {
                        }
                        column(WorkInstr_LineTextLbl;FieldCaption(Text))
                        {
                        }
                    }
                }

                trigger OnPreDataItem()
                begin
                    if not ShowWorkInstructions then
                      CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            var
                WorkOrderLine: Record "MCH Work Order Line";
                WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
            begin
                WorkOrderLine.SetRange(Status,Status);
                WorkOrderLine.SetRange("Work Order No.","No.");
                WorkOrderLine.SetFilter("Asset No.",'<>%1','');
                if WorkOrderLine.IsEmpty then
                  CurrReport.Skip;

                ReportMgt.GetMaintLocationAddress("Maint. Location Code",MaintLocation,MaintAddr);
                if RequestShowWorkDescription then
                  ShowWorkDescription := "Work Description".HasValue;

                if (RequestShowBudgetSumHours <> RequestShowBudgetSumHours::No) or
                   (RequestShowBudgetSumCost <> RequestShowBudgetSumCost::No)
                then
                  ShowBudgetSummary := PrepareBudgetSummary(Header);

                if RequestShowBudgetLines then begin
                  WorkOrderBudgetLine.SetRange(Status,Status);
                  WorkOrderBudgetLine.SetRange("Work Order No.","No.");
                  WorkOrderBudgetLine.SetFilter("No.",'<>%1','');
                  ShowBudgetLines := not WorkOrderBudgetLine.IsEmpty;
                end;
                if RequestShowWorkInstructions then
                  ShowWorkInstructions := PrepareWorkInstructions(Header);

                FirstRowOutput := false;
                ObsoluteHeaderDataCleared := false;
            end;

            trigger OnPreDataItem()
            begin
                SetSecurityFilterOnResponsibilityGroup(99);
                if RequestShowWorkDescription then
                  SetAutoCalcFields("Work Description");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Show Additional Details")
                {
                    Caption = 'Show Additional Details';
                    field(RequestShowWorkDescription;RequestShowWorkDescription)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Work Description';
                    }
                    field(RequestShowLineDimensions;RequestShowLineDimensions)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Line Dimensions';
                    }
                    field(RequestShowBudgetSumHours;RequestShowBudgetSumHours)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Budget Summary Hours';
                    }
                    field(RequestShowBudgetSumCost;RequestShowBudgetSumCost)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Budget Summary Amounts';
                    }
                    field(ShowBudgetLines;RequestShowBudgetLines)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Budget Lines';
                    }
                    field(ShowWorkInstructions;RequestShowWorkInstructions)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Work Instructions';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if Header.GetFilters = '' then
          Error(NoFilterSetErr);
        GLSetup.Get;
        HideAssetRespGroupCode := not ReportMgt.IsUsingAssetResponsibilityGroups;
        HideProgressStatusCode := not ReportMgt.IsUsingWOProgressStatus;
        HideWorkOrderType := not ReportMgt.IsUsingWOType;
        PrintInfoText := StrSubstNo('%1  |  %2  |  %3 %4',COMPANYPROPERTY.DisplayName,UserId,Format(Today,0,'<Weekday Text>'),CurrentDateTime);
    end;

    var
        ReportPageNoCaption: Label 'Page %1 of %2';
        ReportCaptionLbl: Label 'Work Order';
        GLSetup: Record "General Ledger Setup";
        MaintLocation: Record "MCH Maintenance Location";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
        WorkOrderLine: Record "MCH Work Order Line";
        WorkDescriptionInStream: InStream;
        ReportMgt: Codeunit "MCH AM Report Mgt.";
        MaintAddr: array [8] of Text[100];
        RequestShowWorkDescription: Boolean;
        RequestShowLineDimensions: Boolean;
        RequestShowBudgetSumHours: Option No,Yes;
        RequestShowBudgetSumCost: Option No,Yes;
        RequestShowBudgetLines: Boolean;
        RequestShowWorkInstructions: Boolean;
        HideAssetRespGroupCode: Boolean;
        HideProgressStatusCode: Boolean;
        HideWorkOrderType: Boolean;
        FirstRowOutput: Boolean;
        ObsoluteHeaderDataCleared: Boolean;
        PrintInfoText: Text;
        ShowWorkDescription: Boolean;
        ShowBudgetSummary: Boolean;
        ShowBudgetLines: Boolean;
        BudgetLineAssetTaskCaption: Text;
        BudgetPostedQuantity: Decimal;
        ShowWorkInstructions: Boolean;
        WorkDescriptionLineTxt: Text;
        AssetLbl: Label 'Asset';
        TaskLbl: Label 'Task';
        TaskUsageMonitorCodeLbl: Label 'Usage Monitor Code';
        UsageUnitOfMeasureLbl: Label 'Usage Unit of Measure';
        LineDimCaptionLbl: Label 'Dimensions';
        BudgetSummaryLbl: Label 'Budget - Summary';
        BudgetLineLbl: Label 'Line Budget';
        WorkInstructionsLbl: Label 'Work Instructions';
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all documents.';
        ShowLineTaskDetails: Boolean;
        ShowLineTaskUsageDetails: Boolean;
        ShowLineStartEndDates: Boolean;
        ShowLineCompletionDate: Boolean;
        BudgetSumColAsTxt: array [8,6] of Text;
        BudgetSumColCaption: array [6] of Text;
        BudgetSumLineNoWithTotals: Integer;
        BudgetPostedQuantityLbl: Label 'Quantity Posted';
        BudgetUnitOfMeasureLbl: Label 'Unit of Measure';

    local procedure ClearObsoluteHeaderData()
    begin
        // Performance - Only want header logo on first row output.
        if (not FirstRowOutput) or ObsoluteHeaderDataCleared then
          exit;
        Clear(MaintLocation.Picture);
        ObsoluteHeaderDataCleared := true;
    end;

    local procedure MakeLongTxt(Text1: Text;Text2: Text) LongText: Text
    var
        CR: Text[1];
    begin
        if (Text1 = '') or (Text2 = '') then
          exit(Text1+Text2)
        else begin
          CR[1] := 10;
          exit(StrSubstNo('%1%2%3',Text1,CR,Text2));
        end;
    end;

    local procedure Qty2Txt(DecValue: Decimal;DoBlank: Boolean) DecAsText: Text
    begin
        if DoBlank then
          exit('')
        else
          exit(Format(DecValue));
    end;

    local procedure Amt2Txt(DecValue: Decimal;DoBlank: Boolean) AmtAsText: Text
    begin
        if DoBlank then
          exit('')
        else
          exit(Format(DecValue,0,StrSubstNo('<Precision,%1><Standard Format,0>',GLSetup."Amount Decimal Places")));
    end;

    local procedure Txt2Txt(InputTxt: Text;DoBlank: Boolean) OutputTxt: Text
    begin
        if DoBlank then
          exit('')
        else
          exit(InputTxt);
    end;

    local procedure PrepareBudgetSummary(WorkOrder: Record "MCH Work Order Header") OK: Boolean
    var
        "Sum": array [8,6] of Decimal;
        ColIndex: Integer;
        TypeIndex: Integer;
        CalcBudgetHour: Boolean;
        CalcActualHour: Boolean;
        CalcBudgetCost: Boolean;
        CalcActualCost: Boolean;
        SummaryLineNo: Integer;
        BudgetHoursLbl: Label 'Budget Hours';
        ActualHoursLbl: Label 'Actual Hours';
        VarianceHoursLbl: Label 'Variance Hours';
        BudgetCostLbl: Label 'Budget Amount';
        ActualCostLbl: Label 'Actual Amount';
        VarianceCostLbl: Label 'Variance Amount';
        TypeWithHours: Boolean;
        DoBlankIfTypeCostZeroHours: Boolean;
    begin
        BudgetSummaryLine.Reset;
        BudgetSummaryLine.DeleteAll;
        Clear(BudgetSumColAsTxt);
        Clear(BudgetSumColCaption);
        Clear(Sum);
        
        /* Released/Finished options
        CalcBudgetHour := (RequestShowBudgetSumHours <> RequestShowBudgetSumHours::No);
        CalcActualHour := (RequestShowBudgetSumHours = RequestShowBudgetSumHours::"Budget and Actual");
        CalcBudgetCost := (RequestShowBudgetSumCost <> RequestShowBudgetSumCost::No);
        CalcActualCost := (RequestShowBudgetSumCost = RequestShowBudgetSumCost::"Budget and Actual");
        */
        CalcBudgetHour := (RequestShowBudgetSumHours <> RequestShowBudgetSumHours::No);
        CalcBudgetCost := (RequestShowBudgetSumCost <> RequestShowBudgetSumCost::No);
        
        
        // Condensed summary Column order - max. 6 (ColIndex) :
        // Budget Hours -> Actual Hours -> Variance Hours -> Budget Cost -> Actual Cost -> Variance Cost
        // "Type Filter": ' ,Item,Spare Part,Cost,Resource,Team,Trade'
        // Using Type/index '8' for column totals
        for TypeIndex := 1 to 6 do begin
          ColIndex := 0;
          TypeWithHours := (TypeIndex in [WorkOrder."Type Filter"::Cost,WorkOrder."Type Filter"::Resource,WorkOrder."Type Filter"::Team,WorkOrder."Type Filter"::Trade]);
          WorkOrder.SetRange("Type Filter",TypeIndex);
          if TypeWithHours then
            WorkOrder.CalcFields("Budgeted Cost Amount","Actual Cost Amount","Budgeted Hours","Actual Hours")
          else
            WorkOrder.CalcFields("Budgeted Cost Amount","Actual Cost Amount");
          DoBlankIfTypeCostZeroHours := (TypeIndex = WorkOrder."Type Filter"::Cost) and (WorkOrder."Budgeted Hours" = 0) and (WorkOrder."Actual Hours" = 0);
          if CalcBudgetHour then begin
            ColIndex := ColIndex + 1;
            if TypeWithHours then begin
              Sum[TypeIndex,ColIndex] := WorkOrder."Budgeted Hours";
              Sum[8,ColIndex] := Sum[8,ColIndex] + Sum[TypeIndex,ColIndex];
              BudgetSumColAsTxt[TypeIndex,ColIndex] := Qty2Txt(Sum[TypeIndex,ColIndex],DoBlankIfTypeCostZeroHours);
              BudgetSumColAsTxt[8,ColIndex] := Qty2Txt(Sum[8,ColIndex],false);
            end;
          end;
          if CalcActualHour then begin
            ColIndex := ColIndex + 1;
            if TypeWithHours then begin
              Sum[TypeIndex,ColIndex] := WorkOrder."Actual Hours";
              Sum[8,ColIndex] := Sum[8,ColIndex] + Sum[TypeIndex,ColIndex];
              BudgetSumColAsTxt[TypeIndex,ColIndex] := Qty2Txt(Sum[TypeIndex,ColIndex],DoBlankIfTypeCostZeroHours);
              BudgetSumColAsTxt[8,ColIndex] := Qty2Txt(Sum[8,ColIndex],false);
            end;
            // Variance: budget - actual
              ColIndex := ColIndex + 1;
            if TypeWithHours then begin
              Sum[TypeIndex,ColIndex] := Sum[TypeIndex,ColIndex-2] - Sum[TypeIndex,ColIndex-1];
              Sum[8,ColIndex] := Sum[8,ColIndex] + Sum[TypeIndex,ColIndex];
              BudgetSumColAsTxt[TypeIndex,ColIndex] := Qty2Txt(Sum[TypeIndex,ColIndex],DoBlankIfTypeCostZeroHours);
              BudgetSumColAsTxt[8,ColIndex] := Qty2Txt(Sum[8,ColIndex],false);
            end;
          end;
        
          if CalcBudgetCost then begin
            ColIndex := ColIndex + 1;
            Sum[TypeIndex,ColIndex] := WorkOrder."Budgeted Cost Amount";
            Sum[8,ColIndex] := Sum[8,ColIndex] + Sum[TypeIndex,ColIndex];
            BudgetSumColAsTxt[TypeIndex,ColIndex] := Amt2Txt(Sum[TypeIndex,ColIndex],false);
            BudgetSumColAsTxt[8,ColIndex] := Amt2Txt(Sum[8,ColIndex],false);
          end;
          if CalcActualCost then begin
            ColIndex := ColIndex + 1;
            Sum[TypeIndex,ColIndex] := WorkOrder."Actual Cost Amount";
            Sum[8,ColIndex] := Sum[8,ColIndex] + Sum[TypeIndex,ColIndex];
            BudgetSumColAsTxt[TypeIndex,ColIndex] := Amt2Txt(Sum[TypeIndex,ColIndex],false);
            BudgetSumColAsTxt[8,ColIndex] := Amt2Txt(Sum[8,ColIndex],false);
            // Variance: budget - actual
            ColIndex := ColIndex + 1;
            Sum[TypeIndex,ColIndex] := Sum[TypeIndex,ColIndex-2] - Sum[TypeIndex,ColIndex-1];
            Sum[8,ColIndex] := Sum[8,ColIndex] + Sum[TypeIndex,ColIndex];
            BudgetSumColAsTxt[TypeIndex,ColIndex] := Amt2Txt(Sum[TypeIndex,ColIndex],false);
            BudgetSumColAsTxt[8,ColIndex] := Amt2Txt(Sum[8,ColIndex],false);
          end;
        
          if (Sum[TypeIndex,1] <> 0) or (Sum[TypeIndex,2] <> 0) or (Sum[TypeIndex,3] <> 0) or
             (Sum[TypeIndex,4] <> 0) or (Sum[TypeIndex,5] <> 0) or (Sum[TypeIndex,6] <> 0)
          then begin
            SummaryLineNo := SummaryLineNo + 1;
            BudgetSummaryLine.Init;
            BudgetSummaryLine."Line No." := SummaryLineNo;
            BudgetSummaryLine.Type := TypeIndex;
            BudgetSummaryLine.Insert;
          end;
        end;
        if (SummaryLineNo = 0) then
          exit(false);
        BudgetSumLineNoWithTotals := SummaryLineNo;
        // Assign column captions
        ColIndex := 0;
        if CalcBudgetHour then begin
          ColIndex := ColIndex + 1;
          BudgetSumColCaption[ColIndex] := BudgetHoursLbl;
        end;
        if CalcActualHour then begin
          ColIndex := ColIndex + 1;
          BudgetSumColCaption[ColIndex] := ActualHoursLbl;
          // Variance: budget - actual
          ColIndex := ColIndex + 1;
          BudgetSumColCaption[ColIndex] := VarianceHoursLbl;
        end;
        if CalcBudgetCost then begin
          ColIndex := ColIndex + 1;
          BudgetSumColCaption[ColIndex] := BudgetCostLbl;
        end;
        if CalcActualCost then begin
          ColIndex := ColIndex + 1;
          BudgetSumColCaption[ColIndex] := ActualCostLbl;
          // Variance: budget - actual
          ColIndex := ColIndex + 1;
          BudgetSumColCaption[ColIndex] := VarianceCostLbl;
        end;
        exit(true);

    end;

    local procedure PrepareWorkInstructions(WorkOrder: Record "MCH Work Order Header") OK: Boolean
    var
        WorkOrderLine: Record "MCH Work Order Line";
        WorkInstrSetup2: Record "MCH Work Instruction Setup";
    begin
        WorkInstructionSetup.Reset;
        WorkInstructionSetup.DeleteAll;
        WorkOrderLine.SetRange(Status,WorkOrder.Status);
        WorkOrderLine.SetRange("Work Order No.",WorkOrder."No.");
        WorkInstrSetup2.SetAutoCalcFields("Has Instruction Text Lines");
        if WorkOrderLine.FindSet then begin
          repeat
            if (WorkOrderLine."Asset No." <> '') then begin
              WorkInstrSetup2.SetRange("Table Name",WorkInstrSetup2."Table Name"::Asset);
              WorkInstrSetup2.SetRange(Code,WorkOrderLine."Asset No.");
              if WorkInstrSetup2.FindSet then begin
                repeat
                  if WorkInstrSetup2."Has Instruction Text Lines" then begin
                    WorkInstructionSetup := WorkInstrSetup2;
                    if WorkInstructionSetup.Insert then ;
                  end;
                until WorkInstrSetup2.Next = 0;
              end;

              if (WorkOrderLine."Task Code" <> '') then begin
                WorkInstrSetup2.SetRange("Table Name",WorkInstrSetup2."Table Name"::"Maint. Task");
                WorkInstrSetup2.SetRange(Code,WorkOrderLine."Task Code");
                if WorkInstrSetup2.FindSet then begin
                  repeat
                    if WorkInstrSetup2."Has Instruction Text Lines" then begin
                      WorkInstructionSetup := WorkInstrSetup2;
                      if WorkInstructionSetup.Insert then ;
                    end;
                  until WorkInstrSetup2.Next = 0;
                end;
              end;
            end;
          until WorkOrderLine.Next = 0;
        end;
        exit(not WorkInstructionSetup.IsEmpty);
    end;

    local procedure GetDimensionList(DimSetID: Integer;DoBlankList: Boolean) DimensionList: Text
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        if DoBlankList then
          exit('');
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        if DimSetEntry.FindSet then
          repeat
            if DimensionList = '' then
              DimensionList := StrSubstNo('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
            else
              DimensionList := StrSubstNo('%1; %2 - %3',DimensionList,DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
          until DimSetEntry.Next = 0;
    end;
}

