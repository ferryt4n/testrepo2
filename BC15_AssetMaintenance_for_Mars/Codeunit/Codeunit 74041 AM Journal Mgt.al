codeunit 74041 "MCH AM Journal Mgt."
{
    Permissions = TableData "MCH AM Planning Wksh. Templ." = imd,
                  TableData "MCH AM Planning Wksh. Name" = imd,
                  TableData "MCH Usage Journal Template" = imd,
                  TableData "MCH Usage Journal Batch" = imd,
                  TableData "MCH Maint. Journal Template" = imd,
                  TableData "MCH Maint. Journal Batch" = imd;

    trigger OnRun()
    begin
    end;

    var
        Text002: Label '%1 Journal';
        Text003: Label 'DEFAULT';
        Text004: Label 'Default %1 Journal';
        LastPlanWkshLine: Record "MCH AM Planning Wksh. Line";
        LastMaintJnlLine: Record "MCH Maint. Journal Line";
        LastUsageJnlLine: Record "MCH Usage Journal Line";
        OpenPlanningWkshFromBatch: Boolean;
        OpenMaintJnlFromBatch: Boolean;
        OpenUsageJnlFromBatch: Boolean;
        OpenCondJnlFromBatch: Boolean;
        Text005: Label 'Default Planning Worksheet';
        Text006: Label 'Default Usage Journal';


    procedure PlanningWkshTemplateSelection(PageID: Integer; PageTemplate: Option Planning; var PlanWkshLine: Record "MCH AM Planning Wksh. Line"; var JnlSelected: Boolean)
    var
        PlanWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
    begin
        JnlSelected := true;

        PlanWkshTemplate.Reset;
        PlanWkshTemplate.SetRange("Page ID", PageID);
        PlanWkshTemplate.SetRange(Type, PageTemplate);

        case PlanWkshTemplate.Count of
            0:
                begin
                    PlanWkshTemplate.Init;
                    PlanWkshTemplate.Validate(Type, PageTemplate);
                    PlanWkshTemplate.Validate("Page ID", PageID);
                    PlanWkshTemplate.Name := Format(PlanWkshTemplate.Type, MaxStrLen(PlanWkshTemplate.Name));
                    PlanWkshTemplate.Description := StrSubstNo(Text002, PlanWkshTemplate.Type);
                    PlanWkshTemplate.Insert;
                    Commit;
                end;
            1:
                PlanWkshTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, PlanWkshTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            PlanWkshLine.FilterGroup := 2;
            PlanWkshLine.SetRange("Worksheet Template Name", PlanWkshTemplate.Name);
            PlanWkshLine.FilterGroup := 0;
            if OpenPlanningWkshFromBatch then begin
                PlanWkshLine."Worksheet Template Name" := '';
                PAGE.Run(PlanWkshTemplate."Page ID", PlanWkshLine);
            end;
        end;
    end;


    procedure PlanningWkshTemplateSelectionFromBatch(var PlanWkshName: Record "MCH AM Planning Wksh. Name")
    var
        PlanWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        PlanWkshLine: Record "MCH AM Planning Wksh. Line";
    begin
        OpenPlanningWkshFromBatch := true;
        PlanWkshTemplate.Get(PlanWkshName."Worksheet Template Name");
        PlanWkshTemplate.TestField("Page ID");
        PlanWkshName.TestField(Name);

        PlanWkshLine.FilterGroup := 2;
        PlanWkshLine.SetRange("Worksheet Template Name", PlanWkshTemplate.Name);
        PlanWkshLine.FilterGroup := 0;

        PlanWkshLine."Worksheet Template Name" := '';
        PlanWkshLine."Journal Batch Name" := PlanWkshName.Name;
        PAGE.Run(PlanWkshTemplate."Page ID", PlanWkshLine);
    end;


    procedure PlanningWkshOpenJnl(var CurrentWkshName: Code[10]; var PlanWkshLine: Record "MCH AM Planning Wksh. Line")
    begin
        PlanningWkshCheckTemplateName(PlanWkshLine.GetRangeMax("Worksheet Template Name"), CurrentWkshName);
        PlanWkshLine.FilterGroup := 2;
        PlanWkshLine.SetRange("Journal Batch Name", CurrentWkshName);
        PlanWkshLine.FilterGroup := 0;
    end;

    procedure PlanningWkshOpenJnlBatch(var PlanWkshName: Record "MCH AM Planning Wksh. Name")
    var
        PlanWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        PlanWkshLine: Record "MCH AM Planning Wksh. Line";
        JnlSelected: Boolean;
    begin
        if PlanWkshName.GetFilter("Worksheet Template Name") <> '' then
            exit;
        PlanWkshName.FilterGroup(2);
        if PlanWkshName.GetFilter("Worksheet Template Name") <> '' then begin
            PlanWkshName.FilterGroup(0);
            exit;
        end;
        PlanWkshName.FilterGroup(0);

        if not PlanWkshName.FindFirst then
            for PlanWkshTemplate.Type := PlanWkshTemplate.Type::Planning to PlanWkshTemplate.Type::Planning do begin
                PlanWkshTemplate.SetRange(Type, PlanWkshTemplate.Type);
                if not PlanWkshTemplate.FindFirst then
                    PlanningWkshTemplateSelection(0, PlanWkshTemplate.Type, PlanWkshLine, JnlSelected);
                if PlanWkshTemplate.FindFirst then
                    PlanningWkshCheckTemplateName(PlanWkshTemplate.Name, PlanWkshName.Name);
            end;

        PlanWkshName.FindFirst;
        JnlSelected := true;
        PlanWkshName.CalcFields("Template Type");
        PlanWkshTemplate.SetRange(Type, PlanWkshName."Template Type");
        if PlanWkshName.GetFilter("Worksheet Template Name") <> '' then
            PlanWkshTemplate.SetRange(Name, PlanWkshName.GetFilter("Worksheet Template Name"));
        case PlanWkshTemplate.Count of
            1:
                PlanWkshTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, PlanWkshTemplate) = ACTION::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        PlanWkshName.FilterGroup(2);
        PlanWkshName.SetRange("Worksheet Template Name", PlanWkshTemplate.Name);
        PlanWkshName.FilterGroup(0);
    end;

    local procedure PlanningWkshCheckTemplateName(CurrentWkshTemplateName: Code[10]; var CurrentWkshName: Code[10])
    var
        PlanWkshName: Record "MCH AM Planning Wksh. Name";
    begin
        PlanWkshName.SetRange("Worksheet Template Name", CurrentWkshTemplateName);
        if not PlanWkshName.Get(CurrentWkshTemplateName, CurrentWkshName) then begin
            if not PlanWkshName.FindFirst then begin
                PlanWkshName.Init;
                PlanWkshName."Worksheet Template Name" := CurrentWkshTemplateName;
                PlanWkshName.Name := Text003;
                PlanWkshName.Description := Text005;
                PlanWkshName.Insert(true);
                Commit;
            end;
            CurrentWkshName := PlanWkshName.Name
        end;
    end;


    procedure PlanningWkshCheckName(CurrentWkshName: Code[10]; var PlanWkshLine: Record "MCH AM Planning Wksh. Line")
    var
        PlanWkshName: Record "MCH AM Planning Wksh. Name";
    begin
        PlanWkshName.Get(PlanWkshLine.GetRangeMax("Worksheet Template Name"), CurrentWkshName);
    end;


    procedure PlanningWkshSetName(CurrentWkshName: Code[10]; var PlanWkshLine: Record "MCH AM Planning Wksh. Line")
    begin
        PlanWkshLine.FilterGroup := 2;
        PlanWkshLine.SetRange("Journal Batch Name", CurrentWkshName);
        PlanWkshLine.FilterGroup := 0;
        if PlanWkshLine.FindFirst then;
    end;


    procedure PlanningWkshLookupName(var CurrentWkshName: Code[10]; var PlanWkshLine: Record "MCH AM Planning Wksh. Line"): Boolean
    var
        PlanWkshName: Record "MCH AM Planning Wksh. Name";
    begin
        Commit;
        PlanWkshName."Worksheet Template Name" := PlanWkshLine.GetRangeMax("Worksheet Template Name");
        PlanWkshName.Name := PlanWkshLine.GetRangeMax("Journal Batch Name");
        PlanWkshName.FilterGroup := 2;
        PlanWkshName.SetRange("Worksheet Template Name", PlanWkshName."Worksheet Template Name");
        PlanWkshName.FilterGroup := 0;
        if PAGE.RunModal(0, PlanWkshName) = ACTION::LookupOK then begin
            CurrentWkshName := PlanWkshName.Name;
            PlanningWkshSetName(CurrentWkshName, PlanWkshLine);
        end;
    end;


    procedure PlanningWkshGetNames(var PlanWkshLine: Record "MCH AM Planning Wksh. Line"; var MADescription: Text; var MaintProcDescription: Text)
    var
        MA: Record "MCH Maintenance Asset";
        MaintProcedure: Record "MCH Master Maintenance Task";
    begin
        if (PlanWkshLine."Asset No." = '') or
           (PlanWkshLine."Asset No." <> LastPlanWkshLine."Asset No.")
        then begin
            MADescription := '';
            if (PlanWkshLine."Asset No." <> '') then
                if MA.Get(PlanWkshLine."Asset No.") then
                    MADescription := MA.Description;
        end;

        if (PlanWkshLine."Task Code" = '') or
           (PlanWkshLine."Task Code" <> LastPlanWkshLine."Task Code")
        then begin
            MaintProcDescription := '';
            if (PlanWkshLine."Task Code" <> '') then
                if MaintProcedure.Get(PlanWkshLine."Task Code") then
                    MaintProcDescription := MaintProcedure.Description;
        end;
        LastPlanWkshLine := PlanWkshLine;
    end;


    procedure MaintTemplateSelection(PageID: Integer; PageTemplate: Option Inventory,Timesheet; var MaintJnlLine: Record "MCH Maint. Journal Line"; var JnlSelected: Boolean)
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
    begin
        JnlSelected := true;
        MaintJnlTemplate.Reset;
        MaintJnlTemplate.SetRange("Page ID", PageID);
        MaintJnlTemplate.SetRange(Type, PageTemplate);

        case MaintJnlTemplate.Count of
            0:
                begin
                    MaintJnlTemplate.Init;
                    MaintJnlTemplate.Validate(Type, PageTemplate);
                    MaintJnlTemplate.Validate("Page ID", PageID);
                    MaintJnlTemplate.Name := CopyStr(Format(MaintJnlTemplate.Type), 1, MaxStrLen(MaintJnlTemplate.Name));
                    MaintJnlTemplate.Description := StrSubstNo(Text002, MaintJnlTemplate.Type);
                    MaintJnlTemplate.Insert;
                    Commit;
                end;
            1:
                MaintJnlTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, MaintJnlTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            MaintJnlLine.FilterGroup := 2;
            MaintJnlLine.SetRange("Journal Template Name", MaintJnlTemplate.Name);
            MaintJnlLine.FilterGroup := 0;
            if OpenMaintJnlFromBatch then begin
                MaintJnlLine."Journal Template Name" := '';
                PAGE.Run(MaintJnlTemplate."Page ID", MaintJnlLine);
            end;
        end;
    end;


    procedure MaintTemplateSelectionFromBatch(var MaintJnlBatch: Record "MCH Maint. Journal Batch")
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlLine: Record "MCH Maint. Journal Line";
    begin
        OpenMaintJnlFromBatch := true;
        MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");
        MaintJnlTemplate.TestField("Page ID");
        MaintJnlBatch.TestField(Name);

        MaintJnlLine.FilterGroup := 2;
        MaintJnlLine.SetRange("Journal Template Name", MaintJnlTemplate.Name);
        MaintJnlLine.FilterGroup := 0;

        MaintJnlLine."Journal Template Name" := '';
        MaintJnlLine."Journal Batch Name" := MaintJnlBatch.Name;
        PAGE.Run(MaintJnlTemplate."Page ID", MaintJnlLine);
    end;


    procedure MaintOpenJnl(var CurrentJnlBatchName: Code[10]; var MaintJnlLine: Record "MCH Maint. Journal Line")
    begin
        MaintCheckTemplateName(MaintJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
        MaintJnlLine.FilterGroup := 2;
        MaintJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        MaintJnlLine.FilterGroup := 0;
    end;


    procedure MaintOpenJnlBatch(var MaintJnlBatch: Record "MCH Maint. Journal Batch")
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        JnlSelected: Boolean;
    begin
        if MaintJnlBatch.GetFilter("Journal Template Name") <> '' then
            exit;
        MaintJnlBatch.FilterGroup(2);
        if MaintJnlBatch.GetFilter("Journal Template Name") <> '' then begin
            MaintJnlBatch.FilterGroup(0);
            exit;
        end;
        MaintJnlBatch.FilterGroup(0);

        if not MaintJnlBatch.FindFirst then
            for MaintJnlTemplate.Type := MaintJnlTemplate.Type::Inventory to MaintJnlTemplate.Type::Timesheet do begin
                MaintJnlTemplate.SetRange(Type, MaintJnlTemplate.Type);
                if not MaintJnlTemplate.FindFirst then
                    MaintTemplateSelection(0, MaintJnlTemplate.Type, MaintJnlLine, JnlSelected);
                if MaintJnlTemplate.FindFirst then
                    MaintCheckTemplateName(MaintJnlTemplate.Name, MaintJnlBatch.Name);
            end;

        MaintJnlBatch.FindFirst;
        JnlSelected := true;
        MaintJnlBatch.CalcFields("Template Type");
        MaintJnlTemplate.SetRange(Type, MaintJnlBatch."Template Type");
        if MaintJnlBatch.GetFilter("Journal Template Name") <> '' then
            MaintJnlTemplate.SetRange(Name, MaintJnlBatch.GetFilter("Journal Template Name"));
        case MaintJnlTemplate.Count of
            1:
                MaintJnlTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, MaintJnlTemplate) = ACTION::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        MaintJnlBatch.FilterGroup(2);
        MaintJnlBatch.SetRange("Journal Template Name", MaintJnlTemplate.Name);
        MaintJnlBatch.FilterGroup(0);
    end;

    local procedure MaintCheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
    begin
        MaintJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not MaintJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not MaintJnlBatch.FindFirst then begin
                MaintJnlBatch.Init;
                MaintJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                MaintJnlBatch.SetupNewBatch;
                MaintJnlBatch.Name := Text003;
                MaintJnlTemplate.Get(MaintJnlBatch."Journal Template Name");
                MaintJnlBatch.Description := StrSubstNo(Text004, MaintJnlTemplate.Type);
                MaintJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := MaintJnlBatch.Name
        end;
    end;


    procedure MaintCheckName(CurrentJnlBatchName: Code[10]; var MaintJnlLine: Record "MCH Maint. Journal Line")
    var
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
    begin
        MaintJnlBatch.Get(MaintJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure MaintSetName(CurrentJnlBatchName: Code[10]; var MaintJnlLine: Record "MCH Maint. Journal Line")
    begin
        MaintJnlLine.FilterGroup := 2;
        MaintJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        MaintJnlLine.FilterGroup := 0;
        if MaintJnlLine.FindFirst then;
    end;


    procedure MaintLookupName(var CurrentJnlBatchName: Code[10]; var MaintJnlLine: Record "MCH Maint. Journal Line"): Boolean
    var
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
    begin
        Commit;
        MaintJnlBatch."Journal Template Name" := MaintJnlLine.GetRangeMax("Journal Template Name");
        MaintJnlBatch.Name := MaintJnlLine.GetRangeMax("Journal Batch Name");
        MaintJnlBatch.FilterGroup := 2;
        MaintJnlBatch.SetRange("Journal Template Name", MaintJnlBatch."Journal Template Name");
        MaintJnlBatch.FilterGroup := 0;
        if PAGE.RunModal(0, MaintJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := MaintJnlBatch.Name;
            MaintSetName(CurrentJnlBatchName, MaintJnlLine);
        end;
    end;


    procedure MaintJnlGetNames(var MaintJnlLine: Record "MCH Maint. Journal Line"; var WorkOrderDescription: Text; var MADescription: Text; var AccName: Text)
    var
        WorkOrder: Record "MCH Work Order Header";
        MA: Record "MCH Maintenance Asset";
        Item: Record Item;
        SparePart: Record "MCH Maintenance Spare Part";
        MaintCost: Record "MCH Maintenance Cost";
        Resource: Record Resource;
        MaintTeam: Record "MCH Maintenance Team";
        MaintTrade: Record "MCH Maintenance Trade";
    begin
        if (MaintJnlLine."Work Order No." = '') or
           (MaintJnlLine."Work Order No." <> LastMaintJnlLine."Work Order No.")
        then begin
            WorkOrderDescription := '';
            if (MaintJnlLine."Work Order No." <> '') then
                if WorkOrder.Get(WorkOrder.Status::Released, MaintJnlLine."Work Order No.") then
                    WorkOrderDescription := WorkOrder.Description;
        end;

        if (MaintJnlLine."Asset No." = '') or
           (MaintJnlLine."Asset No." <> LastMaintJnlLine."Asset No.")
        then begin
            MADescription := '';
            if (MaintJnlLine."Asset No." <> '') then
                if MA.Get(MaintJnlLine."Asset No.") then
                    MADescription := MA.Description;
        end;

        if (MaintJnlLine.Type <> LastMaintJnlLine.Type) or
           (MaintJnlLine."No." <> LastMaintJnlLine."No.")
        then begin
            AccName := '';
            if (MaintJnlLine.Type > LastMaintJnlLine.Type::" ") and
               (MaintJnlLine."No." <> '')
            then
                case MaintJnlLine.Type of
                    MaintJnlLine.Type::Item:
                        if Item.Get(MaintJnlLine."No.") then
                            AccName := Item.Description;
                    MaintJnlLine.Type::"Spare Part":
                        if SparePart.Get(MaintJnlLine."No.") then
                            AccName := SparePart.Description;
                    MaintJnlLine.Type::Cost:
                        if MaintCost.Get(MaintJnlLine."No.") then
                            AccName := MaintCost.Description;
                    MaintJnlLine.Type::Resource:
                        if Resource.Get(MaintJnlLine."No.") then
                            AccName := Resource.Name;
                    MaintJnlLine.Type::Team:
                        if MaintTeam.Get(MaintJnlLine."No.") then
                            AccName := MaintTeam.Description;
                    MaintJnlLine.Type::Trade:
                        if MaintTrade.Get(MaintJnlLine."No.") then
                            AccName := MaintTrade.Description;
                end;
        end;

        LastMaintJnlLine := MaintJnlLine;
    end;


    procedure MaintJnlShowAccCard(var MaintJnlLine: Record "MCH Maint. Journal Line")
    var
        AMFunction: Codeunit "MCH AM Functions";
    begin
        AMFunction.GeneralShowTypeAccCard(MaintJnlLine.Type, MaintJnlLine."No.");
    end;


    procedure UsageTemplateSelection(FormID: Integer; PageTemplate: Option Usage; var UsageJnlLine: Record "MCH Usage Journal Line"; var JnlSelected: Boolean)
    var
        UsageJnlTemplate: Record "MCH Usage Journal Template";
    begin
        JnlSelected := true;

        UsageJnlTemplate.Reset;
        UsageJnlTemplate.SetRange("Page ID", FormID);
        UsageJnlTemplate.SetRange(Type, PageTemplate);

        case UsageJnlTemplate.Count of
            0:
                begin
                    UsageJnlTemplate.Init;
                    UsageJnlTemplate.Validate(Type, PageTemplate);
                    UsageJnlTemplate.Validate("Page ID", FormID);
                    UsageJnlTemplate.Name := Format(UsageJnlTemplate.Type, MaxStrLen(UsageJnlTemplate.Name));
                    UsageJnlTemplate.Description := StrSubstNo(Text002, UsageJnlTemplate.Type);
                    UsageJnlTemplate.Insert;
                    Commit;
                end;
            1:
                UsageJnlTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, UsageJnlTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            UsageJnlLine.FilterGroup := 2;
            UsageJnlLine.SetRange("Journal Template Name", UsageJnlTemplate.Name);
            UsageJnlLine.FilterGroup := 0;
            if OpenUsageJnlFromBatch then begin
                UsageJnlLine."Journal Template Name" := '';
                PAGE.Run(UsageJnlTemplate."Page ID", UsageJnlLine);
            end;
        end;
    end;


    procedure UsageTemplateSelectionFromBatch(var UsageJnlBatch: Record "MCH Usage Journal Batch")
    var
        UsageJnlTemplate: Record "MCH Usage Journal Template";
        UsageJnlLine: Record "MCH Usage Journal Line";
    begin
        OpenUsageJnlFromBatch := true;
        UsageJnlTemplate.Get(UsageJnlBatch."Journal Template Name");
        UsageJnlTemplate.TestField("Page ID");
        UsageJnlBatch.TestField(Name);

        UsageJnlLine.FilterGroup := 2;
        UsageJnlLine.SetRange("Journal Template Name", UsageJnlTemplate.Name);
        UsageJnlLine.FilterGroup := 0;

        UsageJnlLine."Journal Template Name" := '';
        UsageJnlLine."Journal Batch Name" := UsageJnlBatch.Name;
        PAGE.Run(UsageJnlTemplate."Page ID", UsageJnlLine);
    end;


    procedure UsageOpenJnl(var CurrentJnlBatchName: Code[10]; var UsageJnlLine: Record "MCH Usage Journal Line")
    begin
        UsageCheckTemplateName(UsageJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
        UsageJnlLine.FilterGroup := 2;
        UsageJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        UsageJnlLine.FilterGroup := 0;
    end;

    procedure UsageOpenJnlBatch(var UsageJnlBatch: Record "MCH Usage Journal Batch")
    var
        UsageJnlTemplate: Record "MCH Usage Journal Template";
        UsageJnlLine: Record "MCH Usage Journal Line";
        JnlSelected: Boolean;
    begin
        if UsageJnlBatch.GetFilter("Journal Template Name") <> '' then
            exit;
        UsageJnlBatch.FilterGroup(2);
        if UsageJnlBatch.GetFilter("Journal Template Name") <> '' then begin
            UsageJnlBatch.FilterGroup(0);
            exit;
        end;
        UsageJnlBatch.FilterGroup(0);

        if not UsageJnlBatch.FindFirst then
            for UsageJnlTemplate.Type := UsageJnlTemplate.Type::Usage to UsageJnlTemplate.Type::Usage do begin
                UsageJnlTemplate.SetRange(Type, UsageJnlTemplate.Type);
                if not UsageJnlTemplate.FindFirst then
                    UsageTemplateSelection(0, UsageJnlTemplate.Type, UsageJnlLine, JnlSelected);
                if UsageJnlTemplate.FindFirst then
                    UsageCheckTemplateName(UsageJnlTemplate.Name, UsageJnlBatch.Name);
            end;

        UsageJnlBatch.FindFirst;
        JnlSelected := true;
        UsageJnlBatch.CalcFields("Template Type");
        UsageJnlTemplate.SetRange(Type, UsageJnlBatch."Template Type");
        if UsageJnlBatch.GetFilter("Journal Template Name") <> '' then
            UsageJnlTemplate.SetRange(Name, UsageJnlBatch.GetFilter("Journal Template Name"));
        case UsageJnlTemplate.Count of
            1:
                UsageJnlTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, UsageJnlTemplate) = ACTION::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        UsageJnlBatch.FilterGroup(2);
        UsageJnlBatch.SetRange("Journal Template Name", UsageJnlTemplate.Name);
        UsageJnlBatch.FilterGroup(0);
    end;

    local procedure UsageCheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        UsageJnlBatch: Record "MCH Usage Journal Batch";
    begin
        UsageJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not UsageJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not UsageJnlBatch.FindFirst then begin
                UsageJnlBatch.Init;
                UsageJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                UsageJnlBatch.Name := Text003;
                UsageJnlBatch.Description := Text006;
                UsageJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := UsageJnlBatch.Name
        end;
    end;


    procedure UsageCheckName(CurrentJnlBatchName: Code[10]; var UsageJnlLine: Record "MCH Usage Journal Line")
    var
        UsageJnlBatch: Record "MCH Usage Journal Batch";
    begin
        UsageJnlBatch.Get(UsageJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure UsageSetName(CurrentJnlBatchName: Code[10]; var UsageJnlLine: Record "MCH Usage Journal Line")
    begin
        UsageJnlLine.FilterGroup := 2;
        UsageJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        UsageJnlLine.FilterGroup := 0;
        if UsageJnlLine.FindFirst then;
    end;


    procedure UsageLookupName(var CurrentJnlBatchName: Code[10]; var UsageJnlLine: Record "MCH Usage Journal Line"): Boolean
    var
        UsageJnlBatch: Record "MCH Usage Journal Batch";
    begin
        Commit;
        UsageJnlBatch."Journal Template Name" := UsageJnlLine.GetRangeMax("Journal Template Name");
        UsageJnlBatch.Name := UsageJnlLine.GetRangeMax("Journal Batch Name");
        UsageJnlBatch.FilterGroup := 2;
        UsageJnlBatch.SetRange("Journal Template Name", UsageJnlBatch."Journal Template Name");
        UsageJnlBatch.FilterGroup := 0;
        if PAGE.RunModal(0, UsageJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := UsageJnlBatch.Name;
            UsageSetName(CurrentJnlBatchName, UsageJnlLine);
        end;
    end;


    procedure UsageGetNames(var UsageJnlLine: Record "MCH Usage Journal Line"; var MADescription: Text; var UsageMonitorDescription: Text)
    var
        MA: Record "MCH Maintenance Asset";
        MAUsageMonitor: Record "MCH Asset Usage Monitor";
    begin
        if (UsageJnlLine."Asset No." = '') or
           (UsageJnlLine."Asset No." <> LastUsageJnlLine."Asset No.")
        then begin
            MADescription := '';
            if (UsageJnlLine."Asset No." <> '') then
                if MA.Get(UsageJnlLine."Asset No.") then
                    MADescription := MA.Description;
        end;

        if (UsageJnlLine."Monitor Code" = '') or
           (UsageJnlLine."Monitor Code" <> LastUsageJnlLine."Monitor Code")
        then begin
            UsageMonitorDescription := '';
            if (UsageJnlLine."Monitor Code" <> '') then
                if MAUsageMonitor.Get(UsageJnlLine."Asset No.", UsageJnlLine."Monitor Code") then
                    UsageMonitorDescription := MAUsageMonitor.Description;
        end;

        LastUsageJnlLine := UsageJnlLine;
    end;


    procedure DimMaintTypeToTableID(Type: Option " ",Item,"Spare Part",Cost,Resource,Team,Trade): Integer
    begin
        case Type of
            Type::" ":
                exit(0);
            Type::Item:
                exit(DATABASE::Item);
            Type::"Spare Part":
                exit(DATABASE::"MCH Maintenance Spare Part");
            Type::Cost:
                exit(DATABASE::"MCH Maintenance Cost");
            Type::Resource:
                exit(DATABASE::Resource);
            Type::Team:
                exit(DATABASE::"MCH Maintenance Team");
            Type::Trade:
                exit(DATABASE::"MCH Maintenance Trade");
            else
                exit(0);
        end;
    end;


    procedure IsSaasExcelAddinEnabled() OK: Boolean
    var
        ServerSetting: Codeunit "Server Setting";
    begin
        // BC15.0 bug. Will be fixed in v15.1.... 
        // Currently not allowed for Cloud development
        // exit(ServerSetting.GetIsSaasExcelAddinEnabled);        
    end;
}

