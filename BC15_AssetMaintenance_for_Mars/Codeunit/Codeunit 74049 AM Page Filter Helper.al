codeunit 74049 "MCH AM Page Filter Helper"
{

    trigger OnRun()
    begin
    end;


    procedure RunFilterPage(var RecRef: RecordRef;var DefaultFilterField: Record "Field" temporary;TableFilterCaption: Text) OK: Boolean
    var
        FilterPageBuilder: FilterPageBuilder;
    begin
        FilterPageBuilder.AddRecordRef(TableFilterCaption,RecRef);
        FilterPageBuilder.SetView(TableFilterCaption,RecRef.GetView);
        if DefaultFilterField.FindSet then
          repeat
            if FilterPageBuilder.AddFieldNo(TableFilterCaption,DefaultFilterField."No.") then ;
          until DefaultFilterField.Next = 0;

        if FilterPageBuilder.RunModal then begin
          RecRef.SetView(FilterPageBuilder.GetView(TableFilterCaption));
          exit(true);
        end else
          exit(false);
    end;


    procedure BufferDefaultFilterPageField(var DefaultFilterField: Record "Field" temporary;FilterTableNo: Integer;FilterFieldNo: Integer)
    var
        "Field": Record "Field";
    begin
        with DefaultFilterField do begin
          if Field.Get(FilterTableNo,FilterFieldNo) and
             (Field.Class <> Field.Class::FlowFilter) and
             (Field.ObsoleteState = Field.ObsoleteState::No)
          then begin
            TableNo := FilterTableNo;
            "No." := FilterFieldNo;
            if Insert then ;
          end;
        end;
    end;


    procedure GetSelectionFilterForMaintAsset(var MaintenanceAsset: Record "MCH Maintenance Asset"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MaintenanceAsset);
        exit(GetSelectionFilter(RecRef,MaintenanceAsset.FieldNo("No.")));
    end;


    procedure GetSelectionFilterForWorkOrder(var WorkOrderHeader: Record "MCH Work Order Header"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(WorkOrderHeader);
        exit(GetSelectionFilter(RecRef,WorkOrderHeader.FieldNo("No.")));
    end;


    procedure GetSelectionFilterForMACategory(var MACategory: Record "MCH Maint. Asset Category"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MACategory);
        exit(GetSelectionFilter(RecRef,MACategory.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForWOType(var WorkOrderType: Record "MCH Work Order Type"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(WorkOrderType);
        exit(GetSelectionFilter(RecRef,WorkOrderType.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForWOProgressStatus(var WOProgressStatus: Record "MCH Work Order Progress Status"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(WOProgressStatus);
        exit(GetSelectionFilter(RecRef,WOProgressStatus.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForMaintLocation(var MaintenanceLocation: Record "MCH Maintenance Location"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MaintenanceLocation);
        exit(GetSelectionFilter(RecRef,MaintenanceLocation.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForAssetResponsibilityGroup(var AssetResponsibilityGroup: Record "MCH Asset Responsibility Group"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(AssetResponsibilityGroup);
        exit(GetSelectionFilter(RecRef,AssetResponsibilityGroup.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForMaintUser(var MaintUser: Record "MCH Asset Maintenance User"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MaintUser);
        exit(GetSelectionFilter(RecRef,MaintUser.FieldNo("User ID")));
    end;


    procedure GetSelectionFilterForMasterMaintTask(var MasterMaintTask: Record "MCH Master Maintenance Task"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MasterMaintTask);
        exit(GetSelectionFilter(RecRef,MasterMaintTask.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForAssetMaintTask(var AssetMaintTask: Record "MCH Asset Maintenance Task"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(AssetMaintTask);
        exit(GetSelectionFilter(RecRef,AssetMaintTask.FieldNo("Task Code")));
    end;


    procedure GetSelectionFilterForSparePart(var SparePart: Record "MCH Maintenance Spare Part"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(SparePart);
        exit(GetSelectionFilter(RecRef,SparePart.FieldNo("No.")));
    end;


    procedure GetSelectionFilterForMaintCost(var MaintCost: Record "MCH Maintenance Cost"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MaintCost);
        exit(GetSelectionFilter(RecRef,MaintCost.FieldNo(Code)));
    end;


    procedure GetSelectionFilterForTrade(var MaintTrade: Record "MCH Maintenance Trade"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MaintTrade);
        exit(GetSelectionFilter(RecRef,MaintTrade.FieldNo(Code)));
    end;

    local procedure GetSelectionFilter(var TempRecRef: RecordRef;SelectionFieldID: Integer): Text
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
    begin
        if TempRecRef.IsTemporary then begin
          RecRef := TempRecRef.Duplicate;
          RecRef.Reset;
        end else
          RecRef.Open(TempRecRef.Number);

        TempRecRefCount := TempRecRef.Count;
        if TempRecRefCount > 0 then begin
          TempRecRef.Ascending(true);
          TempRecRef.Find('-');
          while TempRecRefCount > 0 do begin
            TempRecRefCount := TempRecRefCount - 1;
            RecRef.SetPosition(TempRecRef.GetPosition);
            RecRef.Find;
            FieldRef := RecRef.Field(SelectionFieldID);
            FirstRecRef := Format(FieldRef.Value);
            LastRecRef := FirstRecRef;
            More := TempRecRefCount > 0;
            while More do
              if RecRef.Next = 0 then
                More := false
              else begin
                SavePos := TempRecRef.GetPosition;
                TempRecRef.SetPosition(RecRef.GetPosition);
                if not TempRecRef.Find then begin
                  More := false;
                  TempRecRef.SetPosition(SavePos);
                end else begin
                  FieldRef := RecRef.Field(SelectionFieldID);
                  LastRecRef := Format(FieldRef.Value);
                  TempRecRefCount := TempRecRefCount - 1;
                  if TempRecRefCount = 0 then
                    More := false;
                end;
              end;
            if SelectionFilter <> '' then
              SelectionFilter := SelectionFilter + '|';
            if FirstRecRef = LastRecRef then
              SelectionFilter := SelectionFilter + AddSelectionQuotes(FirstRecRef)
            else
              SelectionFilter := SelectionFilter + AddSelectionQuotes(FirstRecRef) + '..' + AddSelectionQuotes(LastRecRef);
            if TempRecRefCount > 0 then
              TempRecRef.Next;
          end;
          exit(SelectionFilter);
        end;
    end;

    local procedure AddSelectionQuotes(inString: Text[1024]): Text
    begin
        if DelChr(inString,'=',' &|()*') = inString then
          exit(inString);
        exit('''' + inString + '''');
    end;
}

