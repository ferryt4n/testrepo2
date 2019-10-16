table 74032 "MCH Maintenance Asset"
{
    Caption = 'Maintenance Asset';
    DataCaptionFields = "No.",Description;
    DrillDownPageID = "MCH Maintenance Asset List";
    LookupPageID = "MCH Maintenance Asset Lookup";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  AMSetup.Get;
                  NoSeriesMgt.TestManual(AMSetup."Asset Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(3;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(5;Position;Text[50])
        {
            Caption = 'Position';
            DataClassification = CustomerContent;
        }
        field(7;Picture;Media)
        {
            Caption = 'Picture';
        }
        field(8;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(9;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10;"Category Code";Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "MCH Maint. Asset Category";
        }
        field(11;"Fixed Maint. Location Code";Code[20])
        {
            Caption = 'Fixed Maint. Location Code';
            TableRelation = "MCH Maintenance Location";

            trigger OnValidate()
            begin
                if ("Fixed Maint. Location Code" <> xRec."Fixed Maint. Location Code") then begin
                  if (CurrFieldNo = FieldNo("Fixed Maint. Location Code")) then begin
                    ConfirmChangeText := StrSubstNo(ConfirmChangeQst,FieldCaption("Fixed Maint. Location Code"));
                    CalcFields("Ongoing Work Orders","Ongoing Planning Worksheet");
                    if ("Ongoing Work Orders" or "Ongoing Planning Worksheet") then begin
                      if "Ongoing Work Orders" then
                        ConfirmChangeText := ConfirmChangeText + ManualChangeWorkOrderMsg;
                      if "Ongoing Planning Worksheet" then
                        ConfirmChangeText := ConfirmChangeText + ManualChangePlanningWkshMsg;
                      if not Confirm(ConfirmChangeText,false) then
                        "Fixed Maint. Location Code" := xRec."Fixed Maint. Location Code";
                    end;
                  end;
                end;
            end;
        }
        field(12;"Responsibility Group Code";Code[20])
        {
            Caption = 'Responsibility Group Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Asset Responsibility Group";

            trigger OnValidate()
            begin
                if ("Responsibility Group Code" <> xRec."Responsibility Group Code") then begin
                  if MaintUserMgt.UserHasAssetRespGroupFilter then begin
                    if ("Responsibility Group Code" = '') then
                      Error(Text005,FieldCaption("Responsibility Group Code"),TableCaption,"No.")
                    else begin
                      if (xRec."Responsibility Group Code" <> '') then begin
                        if not MaintUserMgt.UserHasAccessToRespGroup(UserId,xRec."Responsibility Group Code") then
                          Error(Text006,FieldCaption("Responsibility Group Code"),xRec."Responsibility Group Code");
                      end;
                      if not MaintUserMgt.UserHasAccessToRespGroup(UserId,"Responsibility Group Code") then
                        Error(Text006,FieldCaption("Responsibility Group Code"),"Responsibility Group Code");
                    end;
                  end;
                  if (CurrFieldNo = FieldNo("Responsibility Group Code")) then begin
                    ConfirmChangeText := StrSubstNo(ConfirmChangeQst,FieldCaption("Responsibility Group Code"));
                    CalcFields("Ongoing Work Orders","Ongoing Planning Worksheet");
                    if ("Ongoing Work Orders" or "Ongoing Planning Worksheet") then begin
                      if "Ongoing Work Orders" then
                        ConfirmChangeText := ConfirmChangeText + ManualChangeWorkOrderMsg;
                      if "Ongoing Planning Worksheet" then
                        ConfirmChangeText := ConfirmChangeText + ManualChangePlanningWkshMsg;
                      if not Confirm(ConfirmChangeText,false) then
                        "Responsibility Group Code" := xRec."Responsibility Group Code";
                    end;
                  end;
                  if ("Responsibility Group Code" <> xRec."Responsibility Group Code") then begin
                    if SyncAssetResponsibilityGroupCode then
                      Modify(true);
                  end;
                end;
            end;
        }
        field(13;"Def. Invt. Location Code";Code[10])
        {
            Caption = 'Def. Invt. Location Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));
        }
        field(15;"Posting Group";Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "MCH Maint. Asset Posting Group";
        }
        field(18;"Gen. Bus. Posting Group";Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(20;"Fixed Asset No.";Code[20])
        {
            Caption = 'Fixed Asset No.';
            TableRelation = "Fixed Asset";
        }
        field(21;"Fixed Asset Description";Text[100])
        {
            CalcFormula = Lookup("Fixed Asset".Description WHERE ("No."=FIELD("Fixed Asset No.")));
            Caption = 'Fixed Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;"Manufacturer Code";Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(31;"Date of Manufacture";Date)
        {
            Caption = 'Date of Manufacture';
        }
        field(32;Make;Text[50])
        {
            Caption = 'Make';
        }
        field(33;Model;Text[50])
        {
            Caption = 'Model';
        }
        field(34;"Serial No.";Code[50])
        {
            Caption = 'Serial No.';
        }
        field(35;"Manufacturers Part No.";Code[50])
        {
            Caption = 'Manufacturers Part No.';
        }
        field(36;"Original Part No.";Code[50])
        {
            Caption = 'Original Part No.';
        }
        field(37;"Registration No.";Code[50])
        {
            Caption = 'Registration No.';
            DataClassification = CustomerContent;
        }
        field(38;"Warranty Date";Date)
        {
            Caption = 'Warranty Date';
            DataClassification = CustomerContent;
        }
        field(40;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(41;"Vendor Name";Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42;"Vendor Item No.";Text[50])
        {
            Caption = 'Vendor Item No.';
        }
        field(50;"Parent Asset No.";Code[20])
        {
            Caption = 'Parent Asset No.';
            TableRelation = "MCH Maintenance Asset";

            trigger OnValidate()
            var
                MaintAsset: Record "MCH Maintenance Asset";
                ParentChangeQstText: Text;
                ParentChangeQst: Label 'Do you want to change %1 from %2 to %3 ?';
                ParentAssignQst: Label 'Do you want to change %1 to %2 ?';
                ParentBlankQst: Label 'Do you really want to Clear the %1 ?';
            begin
                if ("No." = '') then begin
                  "Parent Asset No." := '';
                  exit;
                end;
                if ("Parent Asset No." = "No.") then
                  FieldError("Parent Asset No.");

                if (CurrFieldNo = FieldNo("Parent Asset No.")) and ("Parent Asset No." <> xRec."Parent Asset No.") then begin
                  if (xRec."Parent Asset No." = '') then
                    ParentChangeQstText := StrSubstNo(ParentAssignQst,FieldCaption("Parent Asset No."),"Parent Asset No.")
                  else
                    if ("Parent Asset No." = '') then
                      ParentChangeQstText := StrSubstNo(ParentBlankQst,FieldCaption("Parent Asset No."))
                    else
                      ParentChangeQstText := StrSubstNo(ParentChangeQst,FieldCaption("Parent Asset No."),xRec."Parent Asset No.","Parent Asset No.");
                  if not Confirm(ParentChangeQstText,false) then begin
                    "Parent Asset No." := xRec."Parent Asset No.";
                    exit;
                  end;
                end;

                AMFunctions.VerifyAssetParentChildRelationship(Rec);
                AMFunctions.AssignAssetStructureID(Rec,MaintAsset.Get("No."));
                if "Parent Asset No." <> xRec."Parent Asset No." then begin
                  if "Parent Asset No." = '' then begin
                    "Structure Position ID" := "Structure ID";
                    "Structure Level" := 0;
                    MaintAsset := Rec;
                  end else
                    MaintAsset.Get("Parent Asset No.");

                  MaintAsset.LockTable;
                  Modify;
                  AMFunctions.UpdateAssetStructureChildren(MaintAsset);
                  Get("No.");
                end;
            end;
        }
        field(51;"Structure Position ID";Text[180])
        {
            Caption = 'Structure Position ID';
            Editable = false;
        }
        field(52;"Structure Level";Integer)
        {
            Caption = 'Structure Level';
            Editable = false;
        }
        field(53;"Structure ID";Code[20])
        {
            Caption = 'Structure ID';
            Editable = false;
        }
        field(60;Comment;Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH AM Comment Line" WHERE ("Table Name"=CONST("Maint. Asset"),
                                                             "No."=FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Is Parent";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH Maintenance Asset" WHERE ("Parent Asset No."=FIELD("No.")));
            Caption = 'Is Parent';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("MCH Asset Maint. Ledger Entry"."Cost Amount" WHERE ("Asset No."=FIELD("No."),
                                                                                   "Maint. Task Code"=FIELD("Maint. Task Filter"),
                                                                                   "Work Order No."=FIELD("Work Order Filter"),
                                                                                   Type=FIELD("Type Filter"),
                                                                                   "Work Order Type"=FIELD("Work Order Type Filter"),
                                                                                   "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                                   "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date"=FIELD("Date Filter")));
            Caption = 'Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63;Quantity;Decimal)
        {
            CalcFormula = Sum("MCH Asset Maint. Ledger Entry"."Quantity (Base)" WHERE ("Asset No."=FIELD("No."),
                                                                                       "Maint. Task Code"=FIELD("Maint. Task Filter"),
                                                                                       "Work Order No."=FIELD("Work Order Filter"),
                                                                                       Type=FIELD("Type Filter"),
                                                                                       "Posting Date"=FIELD("Date Filter")));
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Usage Monitor Value";Decimal)
        {
            CalcFormula = Sum("MCH Usage Monitor Entry"."Usage Value" WHERE ("Asset No."=FIELD("No."),
                                                                             "Monitor Code"=FIELD("Usage Monitor Code Filter"),
                                                                             "Reading Date"=FIELD("Date Filter")));
            Caption = 'Usage Monitor Value';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(71;"Usage Monitor Code Filter";Code[20])
        {
            Caption = 'Usage Monitor Code Filter';
            FieldClass = FlowFilter;
            TableRelation = "MCH Master Usage Monitor";
        }
        field(73;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(75;"Work Order Filter";Code[20])
        {
            Caption = 'Work Order Filter';
            FieldClass = FlowFilter;
            TableRelation = "MCH Work Order Header"."No." WHERE (Status=FILTER(Released|Finished));
        }
        field(76;"Maint. Task Filter";Code[20])
        {
            Caption = 'Maint. Task Filter';
            FieldClass = FlowFilter;
            TableRelation = "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("No."));
        }
        field(77;"Type Filter";Option)
        {
            Caption = 'Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(82;Hours;Decimal)
        {
            CalcFormula = Sum("MCH Asset Maint. Ledger Entry".Hours WHERE ("Asset No."=FIELD("No."),
                                                                           Type=FIELD("Type Filter"),
                                                                           "Work Order Type"=FIELD("Work Order Type Filter"),
                                                                           "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date"=FIELD("Date Filter")));
            Caption = 'Hours';
            DecimalPlaces = 2:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85;"Rolled-up Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("MCH AM Structure Ledger Entry"."Cost Amount" WHERE ("Asset No."=FIELD("No."),
                                                                                   Type=FIELD("Type Filter"),
                                                                                   "Work Order Type"=FIELD("Work Order Type Filter"),
                                                                                   "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                                   "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date"=FIELD("Date Filter")));
            Caption = 'Rolled-up Cost Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(86;"Rolled-up Hours";Decimal)
        {
            CalcFormula = Sum("MCH AM Structure Ledger Entry".Hours WHERE ("Asset No."=FIELD("No."),
                                                                           Type=FIELD("Type Filter"),
                                                                           "Work Order Type"=FIELD("Work Order Type Filter"),
                                                                           "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date"=FIELD("Date Filter")));
            Caption = 'Rolled-up Hours';
            DecimalPlaces = 2:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(101;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(110;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(111;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(115;"Work Order Type Filter";Code[20])
        {
            Caption = 'Work Order Type Filter';
            FieldClass = FlowFilter;
            TableRelation = "MCH Work Order Type";
        }
        field(200;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(201;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(202;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(203;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(250;"Ongoing Work Orders";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH Work Order Line" WHERE (Status=FILTER(Request|Planned|Released),
                                                             "Asset No."=FIELD("No.")));
            Caption = 'Ongoing Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(251;"Ongoing Planning Worksheet";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH AM Planning Wksh. Line" WHERE ("Asset No."=FIELD("No.")));
            Caption = 'Ongoing Planning Worksheet';
            Editable = false;
            FieldClass = FlowField;
        }
        field(260;"No. of Request WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Request),
                                                             "Asset No."=FIELD("No.")));
            Caption = 'No. of Request WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(261;"No. of Planned WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Planned),
                                                             "Asset No."=FIELD("No.")));
            Caption = 'No. of Planned WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(262;"No. of Released WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Released),
                                                             "Asset No."=FIELD("No.")));
            Caption = 'No. of Released WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(263;"No. of Finished WO Lines";Integer)
        {
            CalcFormula = Count("MCH Work Order Line" WHERE (Status=CONST(Finished),
                                                             "Asset No."=FIELD("No.")));
            Caption = 'No. of Finished WO Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(264;"No. of Planning Wksh. Lines";Integer)
        {
            CalcFormula = Count("MCH AM Planning Wksh. Line" WHERE ("Asset No."=FIELD("No.")));
            Caption = 'No. of Planning Wksh. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(270;"No. of Maintenance Tasks";Integer)
        {
            CalcFormula = Count("MCH Asset Maintenance Task" WHERE ("Asset No."=FIELD("No.")));
            Caption = 'No. of Maintenance Tasks';
            Editable = false;
            FieldClass = FlowField;
        }
        field(271;"No. of Usage Monitors";Integer)
        {
            CalcFormula = Count("MCH Asset Usage Monitor" WHERE ("Asset No."=FIELD("No.")));
            Caption = 'No. of Usage Monitors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(272;"No. of Work Instructions";Integer)
        {
            CalcFormula = Count("MCH Work Instruction Setup" WHERE ("Table Name"=CONST(Asset),
                                                                    Code=FIELD("No.")));
            Caption = 'No. of Work Instructions';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                ShowAssignedWorkInstructions;
            end;
        }
        field(300;"No. of Attachments";Integer)
        {
            CalcFormula = Count("MCH AM Document Attachment" WHERE ("Table ID"=CONST(74032),
                                                                    "No."=FIELD("No.")));
            Caption = 'No. of Attachments';
            Editable = false;
            FieldClass = FlowField;
            InitValue = 0;

            trigger OnLookup()
            begin
                Rec.ShowDocumentAttachments;
            end;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;Description)
        {
        }
        key(Key3;"Category Code")
        {
        }
        key(Key4;"Responsibility Group Code")
        {
        }
        key(Key5;"Posting Group")
        {
        }
        key(Key6;"Fixed Maint. Location Code")
        {
        }
        key(Key7;"Parent Asset No.")
        {
        }
        key(Key8;"Fixed Asset No.")
        {
        }
        key(Key9;"Structure Level")
        {
        }
        key(Key10;"Structure Position ID")
        {
        }
        key(Key11;"Structure ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Description,"Category Code","Responsibility Group Code","Fixed Maint. Location Code","Registration No.")
        {
        }
        fieldgroup(Brick;"No.","Category Code","Responsibility Group Code","Fixed Maint. Location Code","Registration No.",Description,Picture)
        {
        }
    }

    trigger OnDelete()
    var
        MaintAsset: Record "MCH Maintenance Asset";
        AMLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        WorkOrderLine: Record "MCH Work Order Line";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
        UsageMonitorEntry: Record "MCH Usage Monitor Entry";
        MaintCommentLine: Record "MCH AM Comment Line";
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
    begin
        AMLedgEntry.Reset;
        AMLedgEntry.SetCurrentKey("Asset No.");
        AMLedgEntry.SetRange("Asset No.","No.");
        if AMLedgEntry.FindFirst then
          Error(
            Text000,
            TableCaption,"No.",AMLedgEntry.TableCaption);

        UsageMonitorEntry.Reset;
        UsageMonitorEntry.SetCurrentKey("Asset No.");
        UsageMonitorEntry.SetRange("Asset No.","No.");
        if UsageMonitorEntry.FindFirst then
          Error(
            Text000,
            TableCaption,"No.",UsageMonitorEntry.TableCaption);

        WorkOrderLine.Reset;
        WorkOrderLine.SetCurrentKey("Asset No.");
        WorkOrderLine.SetRange("Asset No.","No.");
        if WorkOrderLine.FindFirst then
          Error(
            Text000,
            TableCaption,"No.",WorkOrderLine.TableCaption);

        MaintAsset.Reset;
        MaintAsset.SetCurrentKey("Parent Asset No.");
        MaintAsset.SetRange("Parent Asset No.","No.");
        if MaintAsset.FindFirst then
          Error(
            Text000,
            TableCaption,"No.",TableCaption);

        AssetUsageMonitor.SetRange("Asset No.","No.");
        AssetUsageMonitor.DeleteAll(true);

        AssetMaintTask.SetRange("Asset No.","No.");
        AssetMaintTask.DeleteAll(true);

        MaintCommentLine.Reset;
        MaintCommentLine.SetRange("Table Name",MaintCommentLine."Table Name"::"Maint. Asset");
        MaintCommentLine.SetRange("No.","No.");
        MaintCommentLine.DeleteAll;

        WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::Asset);
        WorkInstructionSetup.SetRange(Code,"No.");
        WorkInstructionSetup.DeleteAll(true);

        if ("No." <> '') then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);

        DimMgt.DeleteDefaultDim(DATABASE::"MCH Maintenance Asset","No.");
    end;

    trigger OnInsert()
    var
        DefaultResponsibilityGroupCode: Code[20];
    begin
        AMSetup.Get ;
        if "No." = '' then begin
          AMSetup.TestField("Asset Nos.");
          NoSeriesMgt.InitSeries(AMSetup."Asset Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;

        DimMgt.UpdateDefaultDim(DATABASE::"MCH Maintenance Asset","No.","Global Dimension 1 Code","Global Dimension 2 Code");
        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;

        if ("Responsibility Group Code" = '') then begin
          DefaultResponsibilityGroupCode := MaintUserMgt.GetDefaultAssetRespGroupCode;
          if (DefaultResponsibilityGroupCode <> '') then
            Validate("Responsibility Group Code",DefaultResponsibilityGroupCode);
        end;

        "Parent Asset No." := '';
        "Structure Level" := 0;
        "Structure ID" := '';
        AMFunctions.AssignAssetStructureID(Rec,false);
    end;

    trigger OnModify()
    begin
        SetLastModified;
        AMFunctions.AssignAssetStructureID(Rec,false);
    end;

    trigger OnRename()
    begin
        DimMgt.RenameDefaultDim(DATABASE::"MCH Maintenance Asset",xRec."No.","No.");
        SetLastModified;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AMFunctions: Codeunit "MCH AM Functions";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'You cannot delete %1 %2 because there exists at least one %3 associated with it.';
        Text001: Label 'You cannot change %1 because one or more entries are associated with this %2.';
        Text005: Label 'You must specify a %1 for %2 %3. The field cannot be blank.';
        Text006: Label 'Your identification is not setup for %1 %2.';
        ConfirmChangeQst: Label 'Do you want to change the %1 ?\';
        ManualChangeWorkOrderMsg: Label '\You must update existing ongoing work orders manually.';
        ManualChangePlanningWkshMsg: Label '\You must update existing planning worksheet lines manually.';
        ConfirmChangeText: Text;


    procedure AssistEdit(OldMaintAsset: Record "MCH Maintenance Asset"): Boolean
    var
        MaintAsset: Record "MCH Maintenance Asset";
    begin
        with MaintAsset do begin
          MaintAsset := Rec;
          AMSetup.Get;
          AMSetup.TestField("Asset Nos.");
          if NoSeriesMgt.SelectSeries(AMSetup."Asset Nos.",OldMaintAsset."No. Series","No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := MaintAsset;
            exit(true);
          end;
        end;
    end;


    procedure ShowCard()
    begin
        if "No." = '' then
          exit;
        PAGE.Run(PAGE::"MCH Maintenance Asset Card",Rec);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"MCH Maintenance Asset","No.",FieldNumber,ShortcutDimCode);
        Modify;
    end;


    procedure ShowDocumentAttachments()
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
        AMDocAttachDetails: Page "MCH AM Doc.Attach. Details";
    begin
        if ("No." = '') then
          exit;
        AMDocumentAttachment.FilterGroup(4);
        AMDocumentAttachment.SetRange("Table ID",DATABASE::"MCH Maintenance Asset");
        AMDocumentAttachment.SetRange("No.","No.");
        AMDocumentAttachment.FilterGroup(0);
        AMDocAttachDetails.SetTableView(AMDocumentAttachment);
        AMDocAttachDetails.SetCaption(StrSubstNo('%1 - %2',TableCaption,"No."));
        AMDocAttachDetails.RunModal;
    end;


    procedure ShowAssignedWorkInstructions()
    var
        WorkInstructionSetup: Record "MCH Work Instruction Setup";
        AssignedWorkInstrList: Page "MCH Assigned Work Instr. List";
    begin
        if "No." = '' then
          exit;
        WorkInstructionSetup.FilterGroup(2);
        WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::Asset);
        WorkInstructionSetup.SetRange(Code,"No.");
        WorkInstructionSetup.FilterGroup(0);
        WorkInstructionSetup.SetRange("Table Name",WorkInstructionSetup."Table Name"::Asset);
        WorkInstructionSetup.SetRange(Code,"No.");
        AssignedWorkInstrList.SetTableView(WorkInstructionSetup);
        AssignedWorkInstrList.Run;
    end;


    procedure ShowMaintForecastOverview()
    var
        MaintFCastOverview: Page "MCH Maint. FCast Overview";
    begin
        if "No." = '' then
          exit;
        MaintFCastOverview.InitPageFromMaintAsset(Rec);
        MaintFCastOverview.Run;
    end;

    [TryFunction]

    procedure CheckMandatoryFields()
    begin
        AMFunctions.CheckAssetMandatoryFields(Rec);
    end;


    procedure OnParentShowChildren()
    var
        ChildMA: Record "MCH Maintenance Asset";
        StructurePositionFilter: Text;
    begin
        if "No." = '' then
          exit;
        CalcFields("Is Parent");
        if not "Is Parent" then
          exit;
        ChildMA.SetCurrentKey("Structure Position ID");
        StructurePositionFilter := '*' + "Structure ID" + '*';
        ChildMA.FilterGroup(2);
        ChildMA.SetFilter("Structure Position ID",StructurePositionFilter);
        ChildMA.SetFilter("Structure Level",'>=%1',"Structure Level");
        ChildMA.FilterGroup(0);
        if ChildMA.FindFirst then ;
        PAGE.RunModal(0,ChildMA);
    end;

    local procedure SetLastModified()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;


    procedure SetSecurityFilterOnResponsibilityGroup(FilterGrpNo: Integer)
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
          FilterGroup(FilterGrpNo);
          SetFilter("Responsibility Group Code",MaintUserMgt.GetAssetRespGroupFilter);
          FilterGroup(0);
        end;
    end;

    local procedure SyncAssetResponsibilityGroupCode() DoModify: Boolean
    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
    begin
        AssetMaintTask.SetRange("Asset No.","No.");
        if not AssetMaintTask.IsEmpty then begin
          DoModify := true;
          AssetMaintTask.LockTable;
          AssetMaintTask.FindFirst;
          AssetMaintTask.ModifyAll("Asset Resp. Group Code","Responsibility Group Code",true);
        end;
        AssetUsageMonitor.SetRange("Asset No.","No.");
        if not AssetUsageMonitor.IsEmpty then begin
          DoModify := true;
          AssetUsageMonitor.LockTable;
          AssetUsageMonitor.FindFirst;
          AssetUsageMonitor.ModifyAll("Asset Resp. Group Code","Responsibility Group Code",true);
        end;
    end;


    procedure GetIsParentStyleTxt() StyleTxt: Text
    begin
        CalcFields("Is Parent");
        if "Is Parent" then
          exit('Strong');
    end;


    procedure GetBlockedStyleTxt() StyleTxt: Text
    begin
        if Blocked then
          exit('Unfavorable');
    end;


    procedure GetStyleTxt() StyleTxt: Text
    begin
        CalcFields("Is Parent");
        if "Is Parent" then
          exit('Strong')
        else
          if Blocked then
            exit('Unfavorable');
    end;
}

