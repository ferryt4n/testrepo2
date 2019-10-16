codeunit 74039 "MCH AM Structure Entry-Post"
{
    Permissions = TableData "MCH AM Structure Ledger Entry"=rimd;

    trigger OnRun()
    begin
    end;

    var
        MA: Record "MCH Maintenance Asset";
        AMStructureLedgEntry: Record "MCH AM Structure Ledger Entry";
        AMFunctions: Codeunit "MCH AM Functions";
        Text001: Label 'No. of levels in %1 structure on %2 is too high. Check structure for circular referencing. Current %1 %3.';
        NoOfMALevels: Integer;
        Text002: Label 'The %1 %2 of %3 %4 does not exists.';


    procedure FromAMLedgEntry(AMLedgEntry: Record "MCH Asset Maint. Ledger Entry")
    begin
        if (AMLedgEntry."Cost Amount" = 0) and (AMLedgEntry.Hours = 0) then
          exit;
        AMStructureLedgEntry.Reset;
        AMStructureLedgEntry.SetCurrentKey("AM Ledger Entry No.");
        AMStructureLedgEntry.SetRange("AM Ledger Entry No.",AMLedgEntry."Entry No.");
        if not AMStructureLedgEntry.IsEmpty then
          exit;
        AMStructureLedgEntry.Reset;

        NoOfMALevels := 0;
        MA.Get(AMLedgEntry."Asset No.");
        MA."Parent Asset No." := MA."No.";
        repeat
          NoOfMALevels := NoOfMALevels + 1;
          if NoOfMALevels > AMFunctions.MaxAssetStructureLevels then
            Error(Text001,
              MA.TableCaption,AMFunctions.MaxAssetStructureLevels,MA."No.");

          if not MA.Get(MA."Parent Asset No.") then
            Error(Text002,
              MA.FieldCaption(MA."Parent Asset No."),MA."Parent Asset No.",MA.TableCaption,MA."No.");

          AMStructureLedgEntry.Init;
          AMStructureLedgEntry."Entry No." := 0;
          AMStructureLedgEntry."AM Ledger Entry No." := AMLedgEntry."Entry No.";
          AMStructureLedgEntry."Asset No." := MA."No.";
          AMStructureLedgEntry."Source Asset No." := AMLedgEntry."Asset No.";
          AMStructureLedgEntry."Asset Structure Level" := MA."Structure Level";
          AMStructureLedgEntry."Posting Date" := AMLedgEntry."Posting Date";
          AMStructureLedgEntry."Document No." := AMLedgEntry."Document No.";
          AMStructureLedgEntry."Posting Entry Type" := AMLedgEntry."Posting Entry Type";
          AMStructureLedgEntry."Document Type" := AMLedgEntry."Document Type";
          AMStructureLedgEntry.Type := AMLedgEntry.Type;
          AMStructureLedgEntry."No." := AMLedgEntry."No.";
          AMStructureLedgEntry."Cost Amount" := AMLedgEntry."Cost Amount";
          AMStructureLedgEntry.Hours := AMLedgEntry.Hours;
          AMStructureLedgEntry."Global Dimension 1 Code" := AMLedgEntry."Global Dimension 1 Code";
          AMStructureLedgEntry."Global Dimension 2 Code" := AMLedgEntry."Global Dimension 2 Code";
          AMStructureLedgEntry."Work Order No." := AMLedgEntry."Work Order No.";
          AMStructureLedgEntry."Work Order Type" := AMLedgEntry."Work Order Type";
          AMStructureLedgEntry."Maint. Location Code" := AMLedgEntry."Maint. Location Code";
          AMStructureLedgEntry.Insert(true);
        until MA."Parent Asset No." = '';
    end;


    procedure UpdateStructureEntryCost(AMLedgEntry: Record "MCH Asset Maint. Ledger Entry")
    begin
        AMStructureLedgEntry.Reset;
        AMStructureLedgEntry.SetCurrentKey("AM Ledger Entry No.");
        AMStructureLedgEntry.SetRange("AM Ledger Entry No.",AMLedgEntry."Entry No.");
        if not AMStructureLedgEntry.FindSet then
          exit;
        repeat
          if (AMStructureLedgEntry."Cost Amount" <> AMLedgEntry."Cost Amount") or
             (AMStructureLedgEntry.Hours <> AMLedgEntry.Hours)
          then begin
            AMStructureLedgEntry."Cost Amount" := AMLedgEntry."Cost Amount";
            AMStructureLedgEntry.Hours := AMLedgEntry.Hours;
            AMStructureLedgEntry.Modify;
          end;
        until AMStructureLedgEntry.Next = 0;
    end;
}

