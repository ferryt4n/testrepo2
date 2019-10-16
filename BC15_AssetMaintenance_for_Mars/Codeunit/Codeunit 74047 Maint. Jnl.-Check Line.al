codeunit 74047 "MCH Maint. Jnl.-Check Line"
{
    TableNo = "MCH Maint. Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        Text000: Label 'cannot be a closing date';
        Text002: Label 'cannot be %1 when %2 is %3';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AMSetup: Record "MCH Asset Maintenance Setup";
        InvtSetup: Record "Inventory Setup";
        WorkOrder: Record "MCH Work Order Header";
        WorkOrder2: Record "MCH Work Order Header";
        WorkOrderLine: Record "MCH Work Order Line";
        WOBudgetLine: Record "MCH Work Order Budget Line";
        MaintAsset: Record "MCH Maintenance Asset";
        MasterMaintTask: Record "MCH Master Maintenance Task";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        Item: Record Item;
        Location: Record Location;
        MaintSparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        Resource: Record Resource;
        MaintTeam: Record "MCH Maintenance Team";
        MaintTeamMember: Record "MCH Maint. Team Member";
        MaintTrade: Record "MCH Maintenance Trade";
        MAPostingSetup: Record "MCH AM Posting Setup";
        DimMgt: Codeunit DimensionManagement;
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        AMFunctions: Codeunit "MCH AM Functions";
        AMCostCalcMgt: Codeunit "MCH AM Cost Mgt.";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        Text006: Label '%1 cannot be found for %2 = %3, %4 = %5 and %6 = %7 (%8 = %9).';
        Text011: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
        DimCombBlockedErr: Label 'The combination of dimensions used in maint. inventory journal line %1, %2, %3 is blocked. %4.';
        DimCausedErr: Label 'A dimension used in maint. inventory journal line %1, %2, %3 has caused an error. %4.';
        SetupRead: Boolean;
        MissingBudgetLinkErrMsg: Label 'A link to a %1 for %2 %3, %4=%5 is required in %6 %7 %8 line %9.';


    procedure RunCheck(var MaintJnlLine: Record "MCH Maint. Journal Line")
    var
        InvtPeriod: Record "Inventory Period";
        UserSetupManagement: Codeunit "User Setup Management";
        BudgetLinkMandatory: Boolean;
    begin
        GetSetup;
        with MaintJnlLine do begin
          if EmptyLine then begin
            exit;
          end;

          TestField("Work Order No.");
          TestField("Asset No.");
          TestField("No.");
          TestField(Type);
          TestField(Quantity);
          TestField("Posting Date");
          TestField("Document No.");
          TestField("Unit of Measure Code");
          TestField("Qty. per Unit of Measure");

          if "Posting Date" <> NormalDate("Posting Date") then
            FieldError("Posting Date",Text000);
          UserSetupManagement.CheckAllowedPostingDate("Posting Date");

          if ("Document Date" <> 0D) then
            if ("Document Date" <> NormalDate("Document Date")) then
              FieldError("Document Date",Text000);

          case Type of
            Type::Item:
              begin
                TestField("Item No.");
                if not ("Entry Type" in ["Entry Type"::Issue,"Entry Type"::Return]) then
                  FieldError(Type,StrSubstNo(Text002,Type,FieldCaption("Entry Type"),"Entry Type"));
              end;
            Type::Resource,
            Type::Team:
              if not ("Entry Type" in ["Entry Type"::Timesheet]) then
                FieldError(Type,StrSubstNo(Text002,Type,FieldCaption("Entry Type"),"Entry Type"));
            Type::"Spare Part",
            Type::Cost,
            Type::Trade:
              begin
                TestField("Entry Type","Entry Type"::Purchase); // Check but should set on purchase posting...
                TestField("Item No.");
              end;
            else
              FieldError(Type);
          end;

          if not WorkOrder.Get(WorkOrder.Status::Released,"Work Order No.") then begin
            WorkOrder2.SetCurrentKey("No.");
            WorkOrder2.SetRange("No.","Work Order No.");
            if not WorkOrder2.FindFirst then
              WorkOrder.Get(WorkOrder.Status::Released,"Work Order No.")
            else
              WorkOrder2.TestField(Status,WorkOrder2.Status::Released);
          end;
          CheckWorkOrder(MaintJnlLine);

          if "Work Order Budget Line No." <> 0 then begin
            WOBudgetLine.Get(WOBudgetLine.Status::Released,"Work Order No.","Work Order Budget Line No.");
            TestField("Work Order Line No.",WOBudgetLine."Work Order Line No.");
          end else begin
            TestField("Work Order Line No.");
          end;

          TestField("Gen. Prod. Posting Group");
          TestField("Gen. Bus. Posting Group");

          if (Type in [Type::Resource,Type::Team]) then begin
            TestField("Asset Posting Group");
            if not AMCostCalcMgt.FindAMPostingSetup(
              MAPostingSetup,false,"Asset Posting Group","Gen. Prod. Posting Group",WorkOrder."Work Order Type")
            then
              Error(
                StrSubstNo(Text006,
                  MAPostingSetup.TableCaption,
                  MAPostingSetup.FieldCaption("Asset Posting Group"),"Asset Posting Group",
                  MAPostingSetup.FieldCaption("Gen. Prod. Posting Group"),"Gen. Prod. Posting Group",
                  MAPostingSetup.FieldCaption("Work Order Type"),WorkOrder."Work Order Type",
                  FieldCaption("Work Order No."),"Work Order No."));
          end;

          case Type of
            Type::Item:
              begin
                Item.Get("No.");
                Item.TestField(Blocked,false);
                Item.TestField("Item Tracking Code",'');
                if (Item.Type = Item.Type::Inventory) then begin
                  if InvtSetup."Location Mandatory" then
                    TestField("Location Code");
                end else begin
                  TestField("Location Code",'');
                end;
                if ("Location Code" <> '') then begin
                  Location.Get("Location Code");
                  Location.TestField("Bin Mandatory",false);
                  Location.TestField("Directed Put-away and Pick",false);
                end;

                if not InvtPeriod.IsValidDate("Posting Date") then
                  InvtPeriod.ShowError("Posting Date");

                case "Entry Type" of
                  "Entry Type"::Issue:
                    if AMSetup."Res. No. Mandatory - Invt.Iss" then
                      TestField("Resource No. (Issue/Return)");
                  "Entry Type"::Return:
                    if AMSetup."Res. No. Mandatory - Invt.Rtrn" then
                      TestField("Resource No. (Issue/Return)");
                end;
              end;
            Type::Resource:
              begin
                Resource.Get("No.");
                Resource.TestField(Blocked,false);
                MAPostingSetup.TestField("Expense Account");
                MAPostingSetup.TestField("Resource Account");
                TestField(Hours);
              end;
            Type::Team:
              begin
                MaintTeam.Get("No.");
                MaintTeam.TestField(Blocked,false);
                MAPostingSetup.TestField("Expense Account");
                MAPostingSetup.TestField("Maint. Team Account");
                TestField(Hours);

                if AMSetup."Post Team Timesheet Res. Ledg." then begin
                  MaintTeamMember.SetRange("Maint. Team Code",MaintTeam.Code);
                  MaintTeamMember.FindSet;
                  repeat
                    MaintTeamMember.TestField("Resource No.");
                    Resource.Get(MaintTeamMember."Resource No.");
                    Resource.TestField(Blocked,false);
                    MaintTeamMember.TestField("Unit of Measure Code");
                    MaintTeamMember.TestField("Quantity per");
                  until MaintTeamMember.Next = 0;
                end;
              end;
            Type::"Spare Part":
              begin
                MaintSparePart.Get("No.");
                MaintSparePart.TestField(Blocked,false);
              end;
            Type::Cost:
              begin
                MaintCost.Get("No.");
                MaintCost.TestField(Blocked,false);
              end;
            Type::Trade:
              begin
                MaintTrade.Get("No.");
                MaintTrade.TestField(Blocked,false);
              end;
          end;

          CheckDimensions(MaintJnlLine);

          if "Work Order Budget Line No." <> 0 then begin
            WOBudgetLine.Get(WOBudgetLine.Status::Released,"Work Order No.","Work Order Budget Line No.");
            TestField("Work Order Line No.",WOBudgetLine."Work Order Line No.");
            WOBudgetLine.TestField(Type,Type);
            WOBudgetLine.TestField("No.");
          end else begin
            case Type of
              Type::Item:
                BudgetLinkMandatory := (AMSetup."WO Invt. Usage to Budget Link" = AMSetup."WO Invt. Usage to Budget Link"::"Mandatory on Entry");
              Type::Resource,
              Type::Team:
                BudgetLinkMandatory := (AMSetup."WO Timesheet to Budget Link" = AMSetup."WO Timesheet to Budget Link"::"Mandatory on Entry");
              Type::"Spare Part",
              Type::Cost,
              Type::Trade:
                BudgetLinkMandatory := false; // Handled on purchase AM posting
            end;
            if BudgetLinkMandatory then
              Error(
                MissingBudgetLinkErrMsg,
                WOBudgetLine.TableCaption,WorkOrder.TableCaption,WorkOrder."No.",Type,"No.",
                TableCaption,"Journal Template Name","Journal Batch Name","Line No.");
          end;
        end;
    end;

    local procedure CheckWorkOrder(var MaintJnlLine: Record "MCH Maint. Journal Line")
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
          if not MaintUserMgt.UserHasAccessToRespGroup(UserId,WorkOrder."Responsibility Group Code") then
            Error(Text011,
              WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Responsibility Group Code"),WorkOrder."Responsibility Group Code");
        end;

        if AMSetup."Work Order Type Mandatory" then
          WorkOrder.TestField("Work Order Type");
        if AMSetup."WO Progress Status Mandatory" then
          WorkOrder.TestField("Progress Status Code");
        if AMSetup."WO Person Respons. Mandatory" then
          WorkOrder.TestField("Person Responsible");

        case MaintJnlLine."Entry Type" of
          MaintJnlLine."Entry Type"::Issue:
            AMFunctions.CheckIfInvtIssueBlocked2(WorkOrder,true);
          MaintJnlLine."Entry Type"::Return:
            AMFunctions.CheckIfInvtReturnBlocked2(WorkOrder,true);
          MaintJnlLine."Entry Type"::Timesheet:
            AMFunctions.CheckIfTimePostBlocked2(WorkOrder,true);
          MaintJnlLine."Entry Type"::Purchase:
            AMFunctions.CheckIfPurchPostBlocked2(WorkOrder,true);
        end;

        WorkOrderLine.Get(WorkOrder.Status,WorkOrder."No.",MaintJnlLine."Work Order Line No.");
        WorkOrderLine.TestField("Asset No.");
        MaintJnlLine.TestField("Asset No.",WorkOrderLine."Asset No.");
        MaintAsset.Get(WorkOrderLine."Asset No.");
        MaintAsset.TestField(Blocked,false);

        if WorkOrderLine."Task Code" <> '' then begin
          AssetMaintTask.Get(MaintAsset."No.",WorkOrderLine."Task Code");
          AssetMaintTask.TestField(Blocked,false);
          MasterMaintTask.Get(WorkOrderLine."Task Code");
          MasterMaintTask.TestField(Status,MasterMaintTask.Status::Active);
        end;
    end;

    local procedure CheckDimensions(var MaintJnlLine: Record "MCH Maint. Journal Line")
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        TableID[1] := DATABASE::"MCH Maintenance Asset";
        No[1] := WorkOrderLine."Asset No.";
        TableID[2] := DATABASE::"MCH Maintenance Location";
        No[2] := WorkOrderLine."Maint. Location Code";
        TableID[3] := DATABASE::"MCH Work Order Type";
        No[3] := WorkOrderLine."Work Order Type";
        TableID[4] := AMJnlMgt.DimMaintTypeToTableID(MaintJnlLine.Type);
        No[4] := MaintJnlLine."No.";

        with MaintJnlLine do begin
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(DimCombBlockedErr,"Journal Template Name","Journal Batch Name","Line No.",DimMgt.GetDimCombErr);

          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then begin
            if "Line No." <> 0 then
              Error(DimCausedErr,"Journal Template Name","Journal Batch Name","Line No.",DimMgt.GetDimValuePostingErr);
            Error(DimMgt.GetDimValuePostingErr);
          end;
        end;
    end;

    local procedure GetSetup()
    begin
        if SetupRead then
          exit;
        SetupRead := true;
        GLSetup.Get;
        InvtSetup.Get;
        AMSetup.Get;
    end;
}

