codeunit 74059 "MCH Asset Maint. Upgrade Mgt."
{
    Subtype = Upgrade;

    trigger OnCheckPreconditionsPerDatabase();
    begin
        // Database requirement checks before upgrade is run (no company open).
    end;

    trigger OnCheckPreconditionsPerCompany();
    begin
        // Per Company requirement checks before upgrade is run.
    end;

    trigger OnUpgradePerDatabase();
    begin
        // Upgrade Database (no company open).
    end;

    trigger OnUpgradePerCompany();
    begin
        // Per Cpmpany upgrade.
    end;

    trigger OnValidateUpgradePerDatabase();
    begin
        // Verify Database if upgrade was successful (no company open).
    end;

    trigger OnValidateUpgradePerCompany();
    begin
        // Per Company verify if upgrade was successful.
    end;
}

