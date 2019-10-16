report 74046 "MCH Update MA Struc.Disp.Order"
{
    Caption = 'Update Asset Structure Display Order';
    ProcessingOnly = true;

    dataset
    {
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
                    field(Sorting;Sorting)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sort Assets by';
                        OptionCaption = 'Asset No.,Asset Maint. Location,Asset Responsibility Group,Asset Category,Asset Description';
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

    trigger OnInitReport()
    begin
        SortingCompleted := false;
    end;

    trigger OnPreReport()
    var
        MaintAsset: Record "MCH Maintenance Asset";
        xMaintAsset: Record "MCH Maintenance Asset";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        AMStructureLedgEntry: Record "MCH AM Structure Ledger Entry";
    begin
        MaintAsset.LockTable;
        MaintAsset.FindFirst;
        AMLedgEntry.LockTable;
        if AMLedgEntry.FindLast then;
        AMStructureLedgEntry.LockTable;
        if AMStructureLedgEntry.FindLast then;

        Window.Open(
          Text002+
          Text003+
          Text004);
        WindowUpdateDateTime := CurrentDateTime;

        MATotal := MaintAsset.Count;
        case Sorting of
          Sorting::"Asset No." :
            MaintAsset.SetCurrentKey("No.");
          Sorting::"Asset Maint. Location" :
            MaintAsset.SetCurrentKey("Fixed Maint. Location Code");
          Sorting::"Asset Responsibility Group":
            MaintAsset.SetCurrentKey("Responsibility Group Code");
          Sorting::"Asset Category" :
            MaintAsset.SetCurrentKey("Category Code");
          Sorting::"Asset Description" :
            MaintAsset.SetCurrentKey(Description);
        end;

        NextStructureID := AMFunctions.GetAssetStartingStructureID;
        // Reset structure values
        MaintAsset.FindSet(true,false);
        repeat
          MACounter := MACounter + 1;
          if CurrentDateTime - WindowUpdateDateTime >= 500 then begin
            WindowUpdateDateTime := CurrentDateTime;
            Window.Update(1,Round(MACounter/MATotal*10000,1));
          end;

          xMaintAsset := MaintAsset;
          MaintAsset."Structure ID" := NextStructureID;
          MaintAsset."Structure Level" := 0;
          if MaintAsset."Parent Asset No." = '' then
            MaintAsset."Structure Position ID" := MaintAsset."Structure ID"
          else
            MaintAsset."Structure Position ID" := '';

          if (Format(xMaintAsset) <> Format(MaintAsset)) then
            MaintAsset.Modify;

          NextStructureID := IncStr(NextStructureID);
        until MaintAsset.Next = 0;
        Window.Update(1,Round(MACounter/MATotal*10000,1));

        // Root - Update structure
        MACounter := 0;
        MaintAsset.SetCurrentKey("Parent Asset No.");
        MaintAsset.SetRange("Parent Asset No.",'');
        MaintAsset.FindSet(true,false);
        repeat
          MACounter := MACounter + 1;
          if CurrentDateTime - WindowUpdateDateTime >= 500 then begin
            WindowUpdateDateTime := CurrentDateTime;
            Window.Update(2,Round(MACounter/MATotal*10000,1));
          end;
          UpdateHierarchyChildren(MaintAsset);
        until MaintAsset.Next = 0;

        Commit;
        SortingCompleted := true;
    end;

    var
        AMFunctions: Codeunit "MCH AM Functions";
        Window: Dialog;
        Sorting: Option "Asset No.","Asset Maint. Location","Asset Responsibility Group","Asset Category","Asset Description";
        NextStructureID: Code[20];
        MATotal: Integer;
        MACounter: Integer;
        Text002: Label 'Sorting Maintenance Asset Structure...\\';
        Text003: Label 'Initialising @1@@@@@@@@@@@@@@@@@@\';
        Text004: Label 'Updating @2@@@@@@@@@@@@@@@@@@';
        SortingCompleted: Boolean;
        WindowUpdateDateTime: DateTime;

    local procedure UpdateHierarchyChildren(ParentMaintAsset: Record "MCH Maintenance Asset")
    var
        ChildMaintAsset: Record "MCH Maintenance Asset";
        xMaintAsset: Record "MCH Maintenance Asset";
        NewHierarchySortingOrder: Text[1024];
        Text001: Label 'The no. of parent-child levels in the %1 structure must not exceed %2.';
    begin
        ParentMaintAsset.TestField("Structure ID");
        ChildMaintAsset.SetCurrentKey("Parent Asset No.");
        ChildMaintAsset.SetRange("Parent Asset No.",ParentMaintAsset."No.");
        if ChildMaintAsset.FindSet(true,false) then begin
          repeat
            MACounter := MACounter + 1;
            if CurrentDateTime - WindowUpdateDateTime >= 500 then begin
              WindowUpdateDateTime := CurrentDateTime;
              Window.Update(2,Round(MACounter/MATotal*10000,1));
            end;
            xMaintAsset := ChildMaintAsset;
            ChildMaintAsset."Structure Level" := ParentMaintAsset."Structure Level" + 1;
            if ChildMaintAsset."Structure Level" > AMFunctions.MaxAssetStructureLevels then
              Error(
                Text001,ChildMaintAsset.TableCaption,AMFunctions.MaxAssetStructureLevels);

            ChildMaintAsset.TestField("Structure ID");
            ChildMaintAsset."Structure Position ID" := ParentMaintAsset."Structure Position ID" + '-' + ChildMaintAsset."Structure ID";

            if (Format(xMaintAsset) <> Format(ChildMaintAsset)) then
              ChildMaintAsset.Modify;

            UpdateHierarchyChildren(ChildMaintAsset);
          until ChildMaintAsset.Next = 0;
        end;
    end;


    procedure StructureSortingWasRun() OK: Boolean
    begin
        exit(SortingCompleted);
    end;
}

