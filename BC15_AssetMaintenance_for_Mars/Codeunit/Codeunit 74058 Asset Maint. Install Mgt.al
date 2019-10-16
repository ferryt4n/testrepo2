codeunit 74058 "MCH Asset Maint. Install Mgt."
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase();
    begin
        // Code for database related operations
        if IsNewInstall then
            HandlePerDatabaseNewInstall
        else
            HandlePerDatabaseReInstall;
    end;

    trigger OnInstallAppPerCompany();
    begin
        // Code for company related operations
        if IsNewInstall then
            HandlePerCompanyNewInstall
        else
            HandlePerCompanyReInstall;
    end;

    local procedure HandlePerDatabaseNewInstall();
    begin
    end;

    local procedure HandlePerCompanyNewInstall();
    begin
    end;

    local procedure HandlePerDatabaseReInstall();
    begin
        // Re-installing the same Version
    end;

    local procedure HandlePerCompanyReInstall();
    begin
        // Re-installing the same Version
    end;

    local procedure IsNewInstall() OK: Boolean;
    var
        AppModuleInfo: ModuleInfo;
    begin
        // Get info about the currently executing module
        NavApp.GetCurrentModuleInfo(AppModuleInfo);
        // DataVersion of 0.0.0.0 indicates a fresh/new install
        exit(AppModuleInfo.DataVersion = Version.Create(0, 0, 0, 0));
    end;
}

