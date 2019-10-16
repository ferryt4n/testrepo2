codeunit 74050 "MCH AM User Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        Text002: Label 'You do not have permission to change the Work Order Status to %1.';
        Text003: Label 'You do not have permission to change the Work Order Priority.';

    [TryFunction]

    procedure CheckWorkOrderChangeStatus(NewWOStatus: Option Requested,Planned,Released,Finished)
    var
        TempWorkOrder: Record "MCH Work Order Header";
        MaintenanceUser: Record "MCH Asset Maintenance User";
    begin
        GetMaintenanceUser(UserId,MaintenanceUser);
        TempWorkOrder.Status := NewWOStatus;

        case NewWOStatus of
          TempWorkOrder.Status::Planned:
            if not MaintenanceUser."Change WO Status to Planned" then
              Error(Text002,TempWorkOrder.Status);
          TempWorkOrder.Status::Released:
            if not MaintenanceUser."Change WO Status to Released" then
              Error(Text002,TempWorkOrder.Status);
          TempWorkOrder.Status::Finished:
            if not MaintenanceUser."Change WO Status to Finished" then
              Error(Text002,TempWorkOrder.Status);
        end;
    end;

    [TryFunction]

    procedure GetMaintenanceUser(ForUserID: Code[50];var MaintenanceUser: Record "MCH Asset Maintenance User")
    begin
        Clear(MaintenanceUser);
        if ForUserID = '' then
          ForUserID := UserId;
        MaintenanceUser.Get(ForUserID);
    end;


    procedure FindMaintUserResourceNo(ForUserID: Code[50]) ResourceNo: Code[20]
    var
        MaintenanceUser: Record "MCH Asset Maintenance User";
    begin
        if GetMaintenanceUser(ForUserID,MaintenanceUser) then
          exit(MaintenanceUser."Resource No.");
    end;


    procedure GetDefaultAssetRespGroupCode() AssetRespGroupCode: Code[20]
    begin
        exit(GetDefaultAssetRespGroupCodeForUser(UserId));
    end;


    procedure GetDefaultAssetRespGroupCodeForUser(ForUserID: Code[50]) AssetRespGroupCode: Code[20]
    var
        MaintenanceUser: Record "MCH Asset Maintenance User";
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
    begin
        if not GetMaintenanceUser(ForUserID,MaintenanceUser) then
          exit('');
        if (MaintenanceUser."Asset Resp. Group View" = MaintenanceUser."Asset Resp. Group View"::Unrestricted) or
           (MaintenanceUser."Default Resp. Group Code" <> '')
        then
          exit(MaintenanceUser."Default Resp. Group Code");

        // Find and use the first filtered Resp. Group as default
        MaintUserAssetRespGrp.SetRange("Maint. User ID",MaintenanceUser."User ID");
        if MaintUserAssetRespGrp.FindFirst then ;
        exit(MaintUserAssetRespGrp."Resp. Group Code");
    end;


    procedure UserHasAssetRespGroupFilter() OK: Boolean
    var
        MaintenanceUser: Record "MCH Asset Maintenance User";
    begin
        if not GetMaintenanceUser(UserId,MaintenanceUser) then
          exit(false);
        exit(MaintenanceUser."Asset Resp. Group View" = MaintenanceUser."Asset Resp. Group View"::Limited);
    end;


    procedure GetAssetRespGroupFilter() AssetRespGroupFilter: Text
    begin
        exit(GetAssetRespGroupFilterForUser(UserId));
    end;


    procedure GetAssetRespGroupFilterForUser(ForUserID: Code[50]) AssetRespGroupFilter: Text
    begin
        exit(BuildAssetRespGroupFilter(ForUserID));
    end;


    procedure UserHasAccessToRespGroup(ForUserID: Code[50];RespGroupCode: Code[20]) OK: Boolean
    var
        MaintenanceUser: Record "MCH Asset Maintenance User";
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
    begin
        if not GetMaintenanceUser(ForUserID,MaintenanceUser) then
          exit(false);
        if (MaintenanceUser."Asset Resp. Group View" = MaintenanceUser."Asset Resp. Group View"::Unrestricted) then
          exit(true);
        exit(MaintUserAssetRespGrp.Get(MaintenanceUser."User ID",RespGroupCode));
    end;

    local procedure BuildAssetRespGroupFilter(ForUserID: Code[50]) AssetRespGroupFilter: Text
    var
        MaintenanceUser: Record "MCH Asset Maintenance User";
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
    begin
        if not GetMaintenanceUser(ForUserID,MaintenanceUser) then
          exit('');
        if (MaintenanceUser."Asset Resp. Group View" = MaintenanceUser."Asset Resp. Group View"::Unrestricted) then
          exit('');

        with MaintUserAssetRespGrp do begin
          SetRange("Maint. User ID",MaintenanceUser."User ID");
          if Find('-') then begin
            repeat
              if AssetRespGroupFilter <> '' then
                AssetRespGroupFilter := AssetRespGroupFilter + '|';
              AssetRespGroupFilter := AssetRespGroupFilter + AddFilterValueQuotes("Resp. Group Code");
            until Next = 0;
          end;
        end;
    end;

    local procedure AddFilterValueQuotes(inString: Text[1024]): Text
    begin
        if DelChr(inString,'=',' &|()*') = inString then
          exit(inString);
        exit('''' + inString + '''');
    end;


    procedure GetDefaultMaintLocationCode() MaintLocationCode: Code[20]
    begin
        exit(GetDefaultMaintLocationCodeForUser(UserId));
    end;


    procedure GetDefaultMaintLocationCodeForUser(ForUserID: Code[50]) MaintLocationCode: Code[20]
    var
        MaintenanceUser: Record "MCH Asset Maintenance User";
    begin
        if not GetMaintenanceUser(ForUserID,MaintenanceUser) then
          exit('');
        exit(MaintenanceUser."Default Maint. Location Code");
    end;

    [EventSubscriber(ObjectType::Table, 74040, 'OnAfterDeleteEvent', '', false, false)]
    local procedure MaintUserOnAfterDelete(var Rec: Record "MCH Asset Maintenance User";RunTrigger: Boolean)
    var
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
    begin
        if Rec.IsTemporary then
          exit;
        MaintUserAssetRespGrp.SetRange("Maint. User ID",Rec."User ID");
        if not MaintUserAssetRespGrp.IsEmpty then
          MaintUserAssetRespGrp.DeleteAll(true);
    end;

    [EventSubscriber(ObjectType::Table, 74037, 'OnAfterInsertEvent', '', false, false)]
    local procedure MaintUserAssetRespGrpOnAfterInsert(var Rec: Record "MCH Maint. User-Asset Resp.Grp";RunTrigger: Boolean)
    var
        MaintUser: Record "MCH Asset Maintenance User";
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
    begin
        if Rec.IsTemporary then
          exit;
        with MaintUser do begin
          Get(Rec."Maint. User ID");
          if ("Asset Resp. Group View" = "Asset Resp. Group View"::Unrestricted) then begin
            "Asset Resp. Group View" := "Asset Resp. Group View"::Limited;
            if ("Default Resp. Group Code" <> '') then begin
              if not MaintUserAssetRespGrp.Get("User ID","Default Resp. Group Code") then
                "Default Resp. Group Code" := '';
            end;
            Modify(true);
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 74037, 'OnAfterDeleteEvent', '', false, false)]
    local procedure MaintUserAssetRespGrpOnAfterDelete(var Rec: Record "MCH Maint. User-Asset Resp.Grp";RunTrigger: Boolean)
    var
        MaintUser: Record "MCH Asset Maintenance User";
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
        DoUpdate: Boolean;
    begin
        if Rec.IsTemporary then
          exit;
        with MaintUser do begin
          if Get(Rec."Maint. User ID") then begin
            if ("Asset Resp. Group View" = "Asset Resp. Group View"::Limited) then begin
              MaintUserAssetRespGrp.SetRange("Maint. User ID","User ID");
              if MaintUserAssetRespGrp.IsEmpty then begin
                "Asset Resp. Group View" := "Asset Resp. Group View"::Unrestricted;
                DoUpdate := true;
              end;
            end;

            if ("Asset Resp. Group View" = "Asset Resp. Group View"::Limited) then begin
              if ("Default Resp. Group Code" = Rec."Resp. Group Code") then begin
                "Default Resp. Group Code" := '';
                DoUpdate := true;
              end;
            end;
            if DoUpdate then
              Modify(true);
          end;
        end;
    end;
}

