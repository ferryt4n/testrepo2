report 74036 "MCH Maint. Journal - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/MCHMaintJournalTest.rdlc';
    Caption = 'Maint. Journal - Test';

    dataset
    {
        dataitem(MaintJnlBatch;"MCH Maint. Journal Batch")
        {
            DataItemTableView = SORTING("Journal Template Name",Name);
            PrintOnlyIfDetail = true;
            column(ReportCaption;ReportCaptionLbl)
            {
            }
            column(COMPANYNAME;COMPANYPROPERTY.DisplayName)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(MaintJnlLineFilter;MaintJnlLineFilter)
            {
            }
            column(MaintJnlLineFilterTableCaption;MaintJnlLine.TableCaption + ': ' + MaintJnlLineFilter)
            {
            }
            column(JournalTemplateName;"Journal Template Name")
            {
            }
            column(JournalTemplateNameLbl;MaintJnlLine.FieldCaption("Journal Template Name"))
            {
            }
            column(JournalBatchName;Name)
            {
            }
            column(JournalBatchNameLbl;MaintJnlLine.FieldCaption("Journal Batch Name"))
            {
            }
            column(Line_PostingDateLbl;MaintJnlLine.FieldCaption("Posting Date"))
            {
            }
            column(Line_DocumentNoLbl;MaintJnlLine.FieldCaption("Document No."))
            {
            }
            column(Line_WorkOrderNoLbl;MaintJnlLine.FieldCaption("Work Order No."))
            {
            }
            column(Line_AssetNoLbl;MaintJnlLine.FieldCaption("Asset No."))
            {
            }
            column(Line_EntryTypeLbl;MaintJnlLine.FieldCaption("Entry Type"))
            {
            }
            column(Line_TypeLbl;MaintJnlLine.FieldCaption(Type))
            {
            }
            column(Line_NoLbl;MaintJnlLine.FieldCaption("No."))
            {
            }
            column(Line_DescriptionLbl;MaintJnlLine.FieldCaption(Description))
            {
            }
            column(Line_QuantityLbl;MaintJnlLine.FieldCaption(Quantity))
            {
            }
            column(Line_UnitOfMeasureCodeLbl;UnitOfMeasureCodeLbl)
            {
            }
            column(Line_LocationCodeLbl;Txt2Txt(MaintJnlLine.FieldCaption("Location Code"),not IsInventoryJnl))
            {
            }
            column(Line_DimensionsLbl;DimensionsLbl)
            {
            }
            dataitem(MaintJnlLine;"MCH Maint. Journal Line")
            {
                DataItemLink = "Journal Template Name"=FIELD("Journal Template Name"),"Journal Batch Name"=FIELD(Name);
                DataItemLinkReference = MaintJnlBatch;
                DataItemTableView = SORTING("Journal Template Name","Journal Batch Name","Line No.");
                RequestFilterFields = "Posting Date";
                column(Line_RowNo;RowNo)
                {
                }
                column(Line_LineNo;"Line No.")
                {
                }
                column(Linel_PostingDate;Format("Posting Date"))
                {
                }
                column(Line_DocumentNo;"Document No.")
                {
                }
                column(Line_WorkOrderNo;"Work Order No.")
                {
                }
                column(Line_AssetNo;"Asset No.")
                {
                }
                column(Line_EntryType;Format("Entry Type"))
                {
                }
                column(Line_Type;Format(Type))
                {
                }
                column(Line_No;"No.")
                {
                }
                column(Line_Description;Description)
                {
                }
                column(Line_Quantity;Quantity)
                {
                }
                column(Line_UnitOfMeasureCode;"Unit of Measure Code")
                {
                }
                column(Line_LocationCode;Txt2Txt("Location Code",not IsInventoryJnl))
                {
                }
                column(Line_Dimensions;GetDimensionList("Dimension Set ID",not ShowDim))
                {
                }
                dataitem(ErrorLoop;"Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(ErrorTextNumber;ErrorText[Number])
                    {
                    }
                    column(WarningCaption;WarningCap)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        ErrorCounter := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number,1,ErrorCounter);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    TableID: array [10] of Integer;
                    No: array [10] of Code[20];
                begin
                    if EmptyLine then
                      CurrReport.Skip;
                    RowNo := RowNo + 1;

                    case true of
                      ("Work Order No." = ''):
                        AddError(StrSubstNo(Text001,FieldCaption("Work Order No.")));
                      ("Work Order Line No." = 0):
                        AddError(StrSubstNo(Text001,FieldCaption("Work Order Line No.")));
                      ("Asset No." = ''):
                        AddError(StrSubstNo(Text001,FieldCaption("Asset No.")));
                      else begin
                        if not WorkOrder.Get(WorkOrder.Status::Released,"Work Order No.") then
                          AddError(StrSubstNo(Text019,WorkOrder.TableCaption,"Work Order No."))
                        else begin
                          if WorkOrder."Work Order Type" = '' then begin
                            if AMSetup."Work Order Type Mandatory" then
                              AddError(StrSubstNo(Text006,
                                                WorkOrder.FieldCaption("Work Order Type"),
                                                WorkOrder.TableCaption,"Work Order No."));
                          end else begin
                            if not WorkOrderType.Get(WorkOrder."Work Order Type") then
                              AddError(StrSubstNo(Text002,WorkOrderType.TableCaption,WorkOrder."Work Order Type"));
                          end;
                        end;
                        if not WorkOrderLine.Get(WorkOrder.Status::Released,"Work Order No.","Work Order Line No.") then
                          AddError(StrSubstNo(Text005,"Work Order No.","Work Order Line No."))
                        else begin
                          if WorkOrderLine."Asset No." <> "Asset No." then
                            AddError(StrSubstNo(Text007,FieldCaption("Asset No."),WorkOrderLine."Asset No."));
                          if WorkOrderLine."Task Code" <> '' then begin
                            MasterMaintTask.Get(WorkOrderLine."Task Code");
                            if (MasterMaintTask.Status <> MasterMaintTask.Status::Active) then
                              AddError(StrSubstNo(Text018,MasterMaintTask.FieldCaption(Status),MasterMaintTask.Status,
                                                  MasterMaintTask.TableCaption,WorkOrderLine."Task Code"));
                          end;
                        end;
                        if not MaintAsset.Get("Asset No.") then
                          AddError(StrSubstNo(Text002,MaintAsset.TableCaption,"Asset No."))
                        else begin
                          if MaintAsset.Blocked then
                            AddError(StrSubstNo(Text003,MaintAsset.FieldCaption(Blocked),false,
                                                MaintAsset.TableCaption,"Asset No."));
                        end;
                      end;
                    end;

                    if "No." = '' then
                      AddError(StrSubstNo(Text001,FieldCaption("No.")))
                    else begin
                      case Type of
                        Type::Item :
                          if not Item.Get("No.") then
                            AddError(StrSubstNo(Text002,Item.TableCaption,"No."))
                          else
                            if Item.Blocked then
                              AddError(StrSubstNo(Text003,Item.FieldCaption(Blocked),false,Item.TableCaption,"No."));
                        Type::"Spare Part" :
                          if not SparePart.Get("No.") then
                            AddError(StrSubstNo(Text002,SparePart.TableCaption,"No."))
                          else
                            if SparePart.Blocked then
                              AddError(StrSubstNo(Text003,SparePart.FieldCaption(Blocked),false,SparePart.TableCaption,"No."));
                        Type::Cost :
                          if not MaintCost.Get("No.") then
                            AddError(StrSubstNo(Text002,MaintCost.TableCaption,"No."))
                          else
                            if MaintCost.Blocked then
                              AddError(StrSubstNo(Text003,MaintCost.FieldCaption(Blocked),false,MaintCost.TableCaption,"No."));
                        Type::Resource :
                          if not Resource.Get("No.") then
                            AddError(StrSubstNo(Text002,Resource.TableCaption,"No."))
                          else
                            if Resource.Blocked then
                              AddError(StrSubstNo(Text003,Resource.FieldCaption(Blocked),false,Resource.TableCaption,"No."));
                        Type::Team :
                          if not MaintTeam.Get("No.") then
                            AddError(StrSubstNo(Text002,MaintTeam.TableCaption,"No."))
                          else
                            if MaintTeam.Blocked then
                              AddError(StrSubstNo(Text003,MaintTeam.FieldCaption(Blocked),false,MaintTeam.TableCaption,"No."));
                        Type::Trade :
                          if not MaintTrade.Get("No.") then
                            AddError(StrSubstNo(Text002,MaintTrade.TableCaption,"No."))
                          else
                            if MaintTrade.Blocked then
                              AddError(StrSubstNo(Text003,MaintTrade.FieldCaption(Blocked),false,MaintTrade.TableCaption,"No."));
                      end;

                      if Type in [Type::Item,Type::Resource,Type::Team] then begin
                        if "Gen. Prod. Posting Group" = '' then
                          AddError(StrSubstNo(Text001,FieldCaption("Gen. Prod. Posting Group")))
                        else
                          if not AMCostMgt.FindAMPostingSetup(
                            MAPostingSetup,false,"Asset Posting Group","Gen. Prod. Posting Group",WorkOrder."Work Order Type")
                          then begin
                             AddError(StrSubstNo(Text013,
                               MAPostingSetup.TableCaption));
                             AddError(StrSubstNo(Text014,
                               MAPostingSetup.FieldCaption("Asset Posting Group"),"Asset Posting Group",
                               MAPostingSetup.FieldCaption("Gen. Prod. Posting Group"),"Gen. Prod. Posting Group",
                               MAPostingSetup.FieldCaption("Work Order Type"),WorkOrder."Work Order Type"));
                           end;
                      end;

                      case "Entry Type" of
                        "Entry Type"::Issue:
                          begin
                            if AMSetup."Res. No. Mandatory - Invt.Iss" then
                              if "Resource No. (Issue/Return)" = '' then
                                AddError(StrSubstNo(Text001,FieldCaption("Resource No. (Issue/Return)")));
                            if AMFunctions.CheckIfInvtIssueBlocked("Work Order No.",false) then
                              AddError(StrSubstNo(Text015,
                                WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"));
                          end;
                        "Entry Type"::Return:
                          begin
                            if AMSetup."Res. No. Mandatory - Invt.Rtrn" then
                              if "Resource No. (Issue/Return)" = '' then
                                AddError(StrSubstNo(Text001,FieldCaption("Resource No. (Issue/Return)")));
                            if AMFunctions.CheckIfInvtReturnBlocked("Work Order No.",false) then
                              AddError(StrSubstNo(Text016,
                                WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"));
                          end;
                        "Entry Type"::Timesheet:
                          begin
                            if AMFunctions.CheckIfTimePostBlocked("Work Order No.",false) then
                               AddError(StrSubstNo(Text017,
                                 WorkOrder.FieldCaption("Progress Status Code"),WorkOrder."Progress Status Code"));
                          end;
                        end;
                    end;

                    if "Posting Date" = 0D then
                      AddError(StrSubstNo(Text001,FieldCaption("Posting Date")))
                    else begin
                      if "Posting Date" <> NormalDate("Posting Date") then
                        AddError(StrSubstNo(Text009,FieldCaption("Posting Date")));

                      if MaintJnlBatch."No. Series" <> '' then
                        if NoSeries."Date Order" and ("Posting Date" < LastPostingDate) then
                          AddError(Text010);
                      LastPostingDate := "Posting Date";

                      if not UserSetupManagement.TestAllowedPostingDate("Posting Date",TempErrorText) then
                        AddError(TempErrorText);
                    end;

                    if ("Document Date" <> 0D) then
                      if ("Document Date" <> NormalDate("Document Date")) then
                        AddError(StrSubstNo(Text009,FieldCaption("Document Date")));

                    if MaintJnlBatch."No. Series" <> '' then begin
                      if LastDocNo <> '' then
                        if ("Document No." <> LastDocNo) and ("Document No." <> IncStr(LastDocNo)) then
                          AddError(Text012);
                      LastDocNo := "Document No.";
                    end;

                    TableID[1] := DATABASE::"MCH Maintenance Asset";
                    No[1] := WorkOrderLine."Asset No.";
                    TableID[2] := DATABASE::"MCH Maintenance Location";
                    No[2] := WorkOrderLine."Maint. Location Code";
                    TableID[3] := DATABASE::"MCH Work Order Type";
                    No[3] := WorkOrderLine."Work Order Type";
                    TableID[4] := AMJnlMgt.DimMaintTypeToTableID(MaintJnlLine.Type);
                    No[4] := MaintJnlLine."No.";

                    if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                      AddError(DimMgt.GetDimCombErr);
                    if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
                      AddError(DimMgt.GetDimValuePostingErr);
                end;

                trigger OnPreDataItem()
                begin
                    if MaintJnlBatch."No. Series" <> '' then
                      NoSeries.Get(MaintJnlBatch."No. Series");
                    LastPostingDate := 0D;
                    LastDocNo := '';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");
                IsInventoryJnl := (MaintJnlTemplate.Type = MaintJnlTemplate.Type::Inventory);
                IsTimesheetJnl := (MaintJnlTemplate.Type = MaintJnlTemplate.Type::Timesheet);
                RowNo := 0;
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
                group(Options)
                {
                    Caption = 'Options';
                    field("Show Dimensions";ShowDim)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Dimensions';
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
    var
        MaintJnlLine2: Record "MCH Maint. Journal Line";
    begin
        AMSetup.Get;
        MaintJnlLine2.Copy(MaintJnlLine);
        MaintJnlLine2.SetRange("Journal Template Name");
        MaintJnlLine2.SetRange("Journal Batch Name");
        MaintJnlLineFilter := MaintJnlLine2.GetFilters;
    end;

    var
        Text001: Label '%1 must be specified.';
        Text002: Label '%1 %2 does not exist.';
        Text003: Label '%1 must be %2 for %3 %4.';
        Text004: Label '%1 %2 %3 does not exist.';
        Text005: Label 'Work Order %1 - Line %2 does not exist.';
        Text006: Label '%1 must be specified for %2 %3.';
        Text007: Label '%1 must be %2.';
        Text009: Label '%1 must not be a closing date.';
        Text010: Label 'The lines are not listed according to posting date because they were not entered in that order.';
        Text011: Label '%1 is not within your allowed range of posting dates.';
        Text012: Label 'There is a gap in the number series.';
        AMSetup: Record "MCH Asset Maintenance Setup";
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        AccountingPeriod: Record "Accounting Period";
        WorkOrder: Record "MCH Work Order Header";
        WorkOrderLine: Record "MCH Work Order Line";
        MaintAsset: Record "MCH Maintenance Asset";
        MasterMaintTask: Record "MCH Master Maintenance Task";
        WorkOrderType: Record "MCH Work Order Type";
        Item: Record Item;
        SparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        Resource: Record Resource;
        MaintTeam: Record "MCH Maintenance Team";
        MaintTrade: Record "MCH Maintenance Trade";
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MAPostingSetup: Record "MCH AM Posting Setup";
        NoSeries: Record "No. Series";
        DimSetEntry: Record "Dimension Set Entry";
        DimMgt: Codeunit DimensionManagement;
        UserSetupManagement: Codeunit "User Setup Management";
        AMCostMgt: Codeunit "MCH AM Cost Mgt.";
        AMFunctions: Codeunit "MCH AM Functions";
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        RowNo: Integer;
        IsInventoryJnl: Boolean;
        IsTimesheetJnl: Boolean;
        ErrorCounter: Integer;
        ErrorText: array [50] of Text[250];
        TempErrorText: Text[250];
        MaintJnlLineFilter: Text[250];
        LastPostingDate: Date;
        LastDocNo: Code[20];
        ShowDim: Boolean;
        Continue: Boolean;
        Text013: Label '%1 cannot be found for the combination of';
        Text014: Label '%1 = %2, %3 = %4 and %5 = %6.';
        Text015: Label 'Inventory Issue is blocked for %1 %2.';
        Text016: Label 'Inventory Return is blocked for %1 %2.';
        Text017: Label 'Timesheet Posting is blocked for %1 %2.';
        Text018: Label '%1 must not be %2 for %3 %4.';
        Text019: Label 'Released %1 %2 cannot be found.';
        PageCaptionLbl: Label 'Page %1 of %2';
        ReportCaptionLbl: Label 'Maintenance Journal - Test';
        WarningCap: Label 'Warning!';
        DimensionsLbl: Label 'Dimensions';
        UnitOfMeasureCodeLbl: Label 'UoM Code';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        if ErrorCounter > ArrayLen(ErrorText) then
          exit;
        ErrorText[ErrorCounter] := Text;
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

    local procedure Txt2Txt(InputTxt: Text;DoBlank: Boolean) OutputTxt: Text
    begin
        if DoBlank then
          exit('')
        else
          exit(InputTxt);
    end;
}

