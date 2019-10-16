report 74037 "MCH Asset Maintenance Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/MCHAssetMaintenanceRegister.rdlc';
    Caption = 'Asset Maintenance Register';

    dataset
    {
        dataitem(AMPostingRegister;"MCH AM Posting Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportCaption;ReportCaption)
            {
            }
            column(COMPANYNAME;COMPANYPROPERTY.DisplayName)
            {
            }
            column(PageNoCaptionLbl;CurrReportPageNoCaptionLbl)
            {
            }
            column(AMRegFilter;TableCaption + ': ' + AMRegFilter)
            {
            }
            column(AMRegister_No;"No.")
            {
            }
            column(AMRegister_NoLbl;No_AMRegisterCaptionLbl)
            {
            }
            column(AMRegister_UserID;"User ID")
            {
            }
            column(AMRegister_CreationDateTime;Format("Creation Date-Time"))
            {
            }
            dataitem(AMLedgerEntry;"MCH Asset Maint. Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                column(AMLedg_PostingDate;Format("Posting Date"))
                {
                }
                column(AMLedg_PostingDateLbl;FieldCaption("Posting Date"))
                {
                }
                column(AMLedg_EntryType;EntryTypeText)
                {
                }
                column(AMLedg_EntryTypeLbl;EntryTypeLbl)
                {
                }
                column(AMLedg_DocumentNo;"Document No.")
                {
                }
                column(AMLedg_DocumentNoLbl;FieldCaption("Document No."))
                {
                }
                column(AMLedg_WorkOrderNo;"Work Order No.")
                {
                }
                column(AMLedg_WorkOrderNoLbl;FieldCaption("Work Order No."))
                {
                }
                column(AMLedg_AssetNo;"Asset No.")
                {
                }
                column(AMLedg_AssetNoLbl;FieldCaption("Asset No."))
                {
                }
                column(AMLedg_Type;Format(Type))
                {
                }
                column(AMLedg_TypeLbl;FieldCaption(Type))
                {
                }
                column(AMLedg_Description;Description)
                {
                }
                column(AMLedg_DescriptionLbl;FieldCaption(Description))
                {
                }
                column(AMLedg_No;"No.")
                {
                }
                column(AMLedg_NoLbl;FieldCaption("No."))
                {
                }
                column(AMLedg_UoMCode;"Unit of Measure Code")
                {
                }
                column(AMLedg_UoMCodeLbl;UnitOfMeasureCodeLbl)
                {
                }
                column(AMLedg_Quantity;Quantity)
                {
                }
                column(AMLedg_QuantityLbl;FieldCaption(Quantity))
                {
                }
                column(AMLedg_MaintTaskCode;"Maint. Task Code")
                {
                }
                column(AMLedg_MaintTaskCodeLbl;FieldCaption("Maint. Task Code"))
                {
                }
                column(AMLedg_EntryNo;"Entry No.")
                {
                }
                column(AMLedg_EntryNoLbl;FieldCaption("Entry No."))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    case "Posting Entry Type" of
                      "Posting Entry Type"::Inventory:
                        EntryTypeText := Format("Inventory Entry Type");
                      else
                        EntryTypeText := Format("Posting Entry Type");
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.",AMPostingRegister."From Entry No.",AMPostingRegister."To Entry No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
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
        AMRegFilter := AMPostingRegister.GetFilters;
        if AMRegFilter = '' then
          Error(NoFilterSetErr);
    end;

    var
        AMRegFilter: Text;
        ReportCaption: Label 'Asset Maintenance Posting Register';
        CurrReportPageNoCaptionLbl: Label 'Page';
        No_AMRegisterCaptionLbl: Label 'Register No.';
        EntryTypeText: Text;
        EntryTypeLbl: Label 'Entry Type';
        UnitOfMeasureCodeLbl: Label 'UoM Code';
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all AM entries.';
}

