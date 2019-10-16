codeunit 74035 "MCH AM Report Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        CompanyInfo: Record "Company Information";
        GlobalMaintLocation: Record "MCH Maintenance Location";
        HasCompanyInfo: Boolean;


    procedure PrintWorkOrder(WorkOrder: Record "MCH Work Order Header";ShowRequestPage: Boolean)
    var
        WorkOrder2: Record "MCH Work Order Header";
        AMReportSelection: Record "MCH AM Report Selections";
    begin
        if (WorkOrder."No." = '') then
          exit;
        WorkOrder2 := WorkOrder;
        WorkOrder2.SetRange("No.",WorkOrder2."No.");

        AMReportSelection.Reset;

        case WorkOrder.Status of
          WorkOrder.Status::Request:
            AMReportSelection.SetRange(Usage,AMReportSelection.Usage::"Work Order Request");
          WorkOrder.Status::Planned:
            AMReportSelection.SetRange(Usage,AMReportSelection.Usage::"Planned Work Order");
          WorkOrder.Status::Released:
            AMReportSelection.SetRange(Usage,AMReportSelection.Usage::"Released Work Order");
          WorkOrder.Status::Finished:
            AMReportSelection.SetRange(Usage,AMReportSelection.Usage::"Finished Work Order");
        end;

        AMReportSelection.SetFilter("Report ID",'<>0');
        AMReportSelection.FindSet;
        repeat
          REPORT.Run(AMReportSelection."Report ID",ShowRequestPage,false,WorkOrder2);
        until AMReportSelection.Next = 0;
    end;


    procedure PrintMaintJnlBatch(MaintJnlBatch: Record "MCH Maint. Journal Batch")
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
    begin
        MaintJnlBatch.SetRecFilter;
        MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");
        MaintJnlTemplate.TestField("Test Report ID");
        REPORT.Run(MaintJnlTemplate."Test Report ID",true,false,MaintJnlBatch);
    end;


    procedure PrintMaintJnlLine(NewMaintJnlLine: Record "MCH Maint. Journal Line")
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlLine: Record "MCH Maint. Journal Line";
    begin
        MaintJnlLine.Copy(NewMaintJnlLine);
        MaintJnlLine.SetRange("Journal Template Name",MaintJnlLine."Journal Template Name");
        MaintJnlLine.SetRange("Journal Batch Name",MaintJnlLine."Journal Batch Name");
        MaintJnlTemplate.Get(MaintJnlLine."Journal Template Name");
        MaintJnlTemplate.TestField("Test Report ID");
        REPORT.Run(MaintJnlTemplate."Test Report ID",true,false,MaintJnlLine);
    end;


    procedure GetMaintLocationAddress(MaintLocationCode: Code[20];var MaintLocation: Record "MCH Maintenance Location";var MaintAddr: array [8] of Text[100])
    var
        FormatAddress: Codeunit "Format Address";
    begin
        if GetMaintLocation(MaintLocationCode) then begin
          MaintLocation.Copy(GlobalMaintLocation);
          if (not MaintLocation.Picture.HasValue) then
            CopyCompanyInfoToMaintLocation(MaintLocation,false,true);
        end else begin
          CopyCompanyInfoToMaintLocation(MaintLocation,true,true);
        end;
        with MaintLocation do begin
          FormatAddress.FormatAddr(
            MaintAddr,Name,"Name 2",'',Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
        end;
    end;

    local procedure GetCompanyInfo()
    begin
        if HasCompanyInfo then
          exit;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure GetMaintLocation(MaintLocationCode: Code[20]) OK: Boolean
    begin
        if (MaintLocationCode = '') then begin
          Clear(GlobalMaintLocation);
          exit(false);
        end else begin
          if (MaintLocationCode <> GlobalMaintLocation.Code) then
            GlobalMaintLocation.Get(MaintLocationCode);
        end;
        exit(true);
    end;

    local procedure CopyCompanyInfoToMaintLocation(var MaintLocation: Record "MCH Maintenance Location";CopyAddressDetails: Boolean;CopyPicture: Boolean)
    var
        InStr: InStream;
    begin
        GetCompanyInfo;
        if CopyAddressDetails then begin
          with MaintLocation do begin
            Name := CompanyInfo.Name;
            "Name 2" := CompanyInfo."Name 2";
            Address := CompanyInfo.Address;
            "Address 2" := CompanyInfo."Address 2";
            "Post Code" := CompanyInfo."Post Code";
            City := CompanyInfo.City;
            County := CompanyInfo.County;
            "Country/Region Code" := CompanyInfo."Country/Region Code";
            Contact := CompanyInfo."Contact Person";
            "Phone No." := CompanyInfo."Phone No.";
            "Fax No." := CompanyInfo."Fax No.";
            Email := CompanyInfo."E-Mail";
            "Home Page" := CompanyInfo."Home Page";
          end;
        end;

        if CopyPicture then begin
          if (CompanyInfo.Picture.HasValue) then begin
            CompanyInfo.Picture.CreateInStream(InStr);
            MaintLocation.Picture.ImportStream(InStr,'');
          end;
        end;
    end;


    procedure IsUsingAssetResponsibilityGroups() IsUsing: Boolean
    var
        AssetRespGroup: Record "MCH Asset Responsibility Group";
    begin
        exit(not AssetRespGroup.IsEmpty);
    end;


    procedure IsUsingWOProgressStatus() IsUsing: Boolean
    var
        WorkOrderProgressStatus: Record "MCH Work Order Progress Status";
    begin
        exit(not WorkOrderProgressStatus.IsEmpty);
    end;


    procedure IsUsingWOType() IsUsing: Boolean
    var
        WorkOrderType: Record "MCH Work Order Type";
    begin
        exit(not WorkOrderType.IsEmpty);
    end;
}

