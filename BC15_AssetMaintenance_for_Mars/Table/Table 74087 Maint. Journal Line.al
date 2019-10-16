table 74087 "MCH Maint. Journal Line"
{
    Caption = 'Maintenance Journal Line';
    DataCaptionFields = "Journal Batch Name","Line No.";
    DrillDownPageID = "MCH Maintenance Journal Lines";
    LookupPageID = "MCH Maintenance Journal Lines";
    PasteIsValid = false;

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "MCH Maint. Journal Template";
        }
        field(2;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "MCH Maint. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Entry Type";Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Issue,Return,Timesheet';
            OptionMembers = Issue,Return,Timesheet,Purchase;

            trigger OnValidate()
            begin
                if "Entry Type" <> xRec."Entry Type" then begin
                  Validate(Type);
                end;
                CheckProgStatusBlocking;
            end;
        }
        field(5;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
                Validate("Document Date","Posting Date");
            end;
        }
        field(6;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(7;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(8;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(15;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
            TableRelation = "MCH Work Order Header"."No." WHERE (Status=CONST(Released));

            trigger OnValidate()
            var
                WorkOrder: Record "MCH Work Order Header";
                WorkOrderLine: Record "MCH Work Order Line";
            begin
                GetSetup;
                if "Work Order No." <> xRec."Work Order No." then begin
                  Validate("Work Order Line No.",0);
                  if AMSetup."Use WO No. as Posting Doc. No." then
                    "Document No." := "Work Order No.";
                end;
                if "Work Order No." = '' then begin
                  Validate("No.",'');
                  exit;
                end;

                GetWorkOrder(WorkOrder);
                CheckProgStatusBlocking;
                CheckUserWorkOrderRespGroupAccess(WorkOrder);
                SetFilterWorkOrderLine(WorkOrderLine);
                WorkOrderLine.FindFirst;
                if WorkOrderLine.Next = 0 then begin
                  if ("Work Order Line No." <> WorkOrderLine."Line No.") then
                    Validate("Work Order Line No.",WorkOrderLine."Line No.");
                end;
            end;
        }
        field(16;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "MCH Maintenance Asset";

            trigger OnValidate()
            var
                WorkOrderLine: Record "MCH Work Order Line";
                MaintAsset: Record "MCH Maintenance Asset";
            begin
                if "Asset No." <> '' then begin
                  TestField("Work Order No.");
                  SetFilterWorkOrderLine(WorkOrderLine);
                  WorkOrderLine.SetRange("Asset No.","Asset No.");
                  WorkOrderLine.FindFirst;
                  if WorkOrderLine.Next = 0 then begin
                    if ("Work Order Line No." <> WorkOrderLine."Line No.") then
                      Validate("Work Order Line No.",WorkOrderLine."Line No.");
                  end else begin
                    GetMaintAsset(MaintAsset);
                    Validate("Work Order Line No.",0);
                    "Asset No." := MaintAsset."No.";
                    CopyFromMaintAsset(MaintAsset);
                  end;
                end else
                  Validate("Work Order Line No.",0);
            end;
        }
        field(17;"Work Order Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Work Order Line No.';
            TableRelation = "MCH Work Order Line"."Line No." WHERE (Status=CONST(Released),
                                                                    "Work Order No."=FIELD("Work Order No."));

            trigger OnValidate()
            var
                WorkOrder: Record "MCH Work Order Header";
                WorkOrderLine: Record "MCH Work Order Line";
                MaintAsset: Record "MCH Maintenance Asset";
            begin
                if ("Work Order Line No." = 0) then begin
                  CopyFromWorkOrderLine(WorkOrderLine);
                  "Work Order Budget Line No." := 0;
                end else begin
                  GetWorkOrder(WorkOrder);
                  WorkOrderLine.Get(WorkOrderLine.Status::Released,"Work Order No.","Work Order Line No.");
                  WorkOrderLine.TestField("Asset No.");
                  CopyFromWorkOrderLine(WorkOrderLine);
                end;

                GetMaintAsset(MaintAsset);
                CopyFromMaintAsset(MaintAsset);
                if ("Work Order Line No." <> 0) then begin
                  if not IsItemNonInventoriable("No.") then begin
                    if WorkOrderLine."Def. Invt. Location Code" <> '' then
                      Validate("Location Code",WorkOrderLine."Def. Invt. Location Code");
                  end;
                end;

                CreateDim(
                  AMJnlMgt.DimMaintTypeToTableID(Type),"No.");
            end;
        }
        field(18;"Asset Description";Text[100])
        {
            CalcFormula = Lookup("MCH Maintenance Asset".Description WHERE ("No."=FIELD("Asset No.")));
            Caption = 'Asset Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;

            trigger OnValidate()
            begin
                case Type of
                  Type::Item:
                    if not ("Entry Type" in ["Entry Type"::Issue,"Entry Type"::Return]) then
                      FieldError(Type,StrSubstNo(Text002,Type,FieldCaption("Entry Type"),"Entry Type"));
                  Type::Resource,Type::Team:
                    if not ("Entry Type" in ["Entry Type"::Timesheet]) then
                      FieldError(Type,StrSubstNo(Text002,Type,FieldCaption("Entry Type"),"Entry Type"));
                  else begin
                    FieldError(Type);
                  end;
                end;
                if Type <> xRec.Type then
                  Validate("No.",'');
            end;
        }
        field(21;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST("Spare Part")) "MCH Maintenance Spare Part"
                            ELSE IF (Type=CONST(Cost)) "MCH Maintenance Cost"
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Team)) "MCH Maintenance Team"
                            ELSE IF (Type=CONST(Trade)) "MCH Maintenance Trade";

            trigger OnValidate()
            var
                WorkOrder: Record "MCH Work Order Header";
                WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
                Item: Record Item;
                Resource: Record Resource;
                MaintTeam: Record "MCH Maintenance Team";
            begin
                if (CurrFieldNo = FieldNo("No.")) and ("Work Order Budget Line No." <> 0) then begin
                  WorkOrderBudgetLine.Get(
                    WorkOrderBudgetLine.Status::Released,"Work Order No.","Work Order Budget Line No.");
                  if ("No." <> WorkOrderBudgetLine."No.") or (Type <> WorkOrderBudgetLine.Type) then
                    Validate("Work Order Budget Line No.",0);
                end;
                if ("No." <> xRec."No.")  then begin
                  "Item No." := '';
                  "Variant Code" := '';
                  "Bin Code" := '';
                  "Overhead Rate" := 0;
                  "Resource Work Type Code" := '';
                end;

                if ("No." = '') then begin
                  CreateDim(
                    AMJnlMgt.DimMaintTypeToTableID(Type),"No.");
                  exit;
                end;

                TestField(Type);
                GetWorkOrder(WorkOrder);

                case Type of
                  Type::Item:
                    begin
                      GetItem(Item);
                      Item.TestField(Blocked,false);
                      Item.TestField("Gen. Prod. Posting Group");
                      Item.TestField("Base Unit of Measure");
                      if Item.IsNonInventoriableType then
                        "Location Code" := '';
                      if ("Location Code" <> '') then begin
                        GetLocation("Location Code");
                      end;
                      "Item No." := Item."No.";
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                      "Unit of Measure Code" := Item."Base Unit of Measure";
                      "Indirect Cost %" := Item."Indirect Cost %";
                      "Overhead Rate" := Item."Overhead Rate";
                    end;
                  Type::Resource:
                    begin
                      Resource.Get("No.");
                      Resource.TestField(Blocked,false);
                      Resource.TestField("Gen. Prod. Posting Group");
                      Resource.TestField("Base Unit of Measure");
                      Description := Resource.Name;
                      "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                      "Unit of Measure Code" := Resource."Base Unit of Measure";
                      "Indirect Cost %" := Resource."Indirect Cost %";
                    end;
                  Type::Team:
                    begin
                      MaintTeam.Get("No.");
                      MaintTeam.TestField(Blocked,false);
                      MaintTeam.TestField("Gen. Prod. Posting Group");
                      MaintTeam.TestField("Base Unit of Measure");
                      Description := MaintTeam.Description;
                      "Description 2" := MaintTeam."Description 2";
                      "Gen. Prod. Posting Group" := MaintTeam."Gen. Prod. Posting Group";
                      "Unit of Measure Code" := MaintTeam."Base Unit of Measure";
                      "Indirect Cost %" := MaintTeam."Indirect Cost %";
                    end;
                  else begin
                    FieldError(Type);
                  end;
                end;

                RetrieveCosts;
                "Unit Cost" := UnitCost;
                "Unit Amount" := UnitCost;
                Validate("Unit of Measure Code");

                if Type = Type::Item then begin
                  if "Variant Code" <> '' then
                    Validate("Variant Code");
                  CheckItemAvailable(FieldNo("No."));
                end;
                CreateDim(
                  AMJnlMgt.DimMaintTypeToTableID(Type),"No.");
            end;
        }
        field(22;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(23;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(24;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if (Quantity <> 0) then begin
                  TestField(Type);
                  TestField("No.");
                end;
                case "Entry Type" of
                  "Entry Type"::Issue,
                  "Entry Type"::Return:
                    if (Quantity < 0) then begin
                      if ("Journal Batch Name" <>'') then
                        FieldError(Quantity,Text005);
                    end;
                end;

                "Quantity (Base)" := CalcBaseQty(Quantity);
                GetUnitAmount(FieldNo(Quantity));
                UpdateAmount;
                if Type = Type::Item then
                  CheckItemAvailable(FieldNo(Quantity));

                UpdateHours;

                if Type = Type::Item then begin
                  GetItem(Item);
                end;
            end;
        }
        field(25;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                TestField("No.");
                RetrieveCosts;
                if ("Entry Type" = "Entry Type"::Return) and (Type = Type::Item) then begin
                  GetItem(Item);
                  if Item."Costing Method" = Item."Costing Method"::Standard then begin
                    if CurrFieldNo = FieldNo("Unit Cost") then
                      Error(
                        Text003,
                        FieldCaption("Unit Cost"),Item.FieldCaption("Costing Method"),Item."Costing Method")
                    else
                      "Unit Cost" := Round(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                  end;
                end;

                if (CurrFieldNo = FieldNo("Unit Cost")) then begin
                  case "Entry Type" of
                    "Entry Type"::Return:
                      begin
                        GetSetup;
                        "Unit Amount" :=
                          Round(
                            ("Unit Cost" - "Overhead Rate" * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
                            GLSetup."Unit-Amount Rounding Precision")
                      end;
                    "Entry Type"::Issue,
                    "Entry Type"::Timesheet:
                      begin
                        if (Type = Type::Item) then begin
                          GetItem(Item);
                          if Item."Costing Method" = Item."Costing Method"::Standard then
                            Error(
                              Text003,
                              FieldCaption("Unit Cost"),Item.FieldCaption("Costing Method"),Item."Costing Method");
                        end;
                        "Unit Amount" := "Unit Cost";
                      end;
                  end;
                  UpdateAmount;
                end;
            end;
        }
        field(26;"Unit Amount";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Amount';

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                UpdateAmount;

                if ("No." <> '') then begin
                    case "Entry Type" of
                      "Entry Type"::Return:
                        begin
                          if Type = Type::Item then begin
                            GetItem(Item);
                            if (CurrFieldNo = FieldNo("Unit Amount")) and
                               (Item."Costing Method" = Item."Costing Method"::Standard)
                            then
                              Error(
                                Text003,
                                FieldCaption("Unit Amount"),Item.FieldCaption("Costing Method"),Item."Costing Method");
                          end;

                          GetSetup;
                          "Unit Cost" :=
                            Round(
                              "Unit Amount" * (1 + "Indirect Cost %" / 100),GLSetup."Unit-Amount Rounding Precision") +
                              "Overhead Rate" * "Qty. per Unit of Measure";
                          Validate("Unit Cost");
                        end;
                      "Entry Type"::Issue,
                      "Entry Type"::Timesheet:
                        begin
                          if Type = Type::Item then begin
                            GetItem(Item);
                            if (CurrFieldNo = FieldNo("Unit Amount")) and
                               (Item."Costing Method" = Item."Costing Method"::Standard)
                            then
                              Error(
                                Text003,
                                FieldCaption("Unit Amount"),Item.FieldCaption("Costing Method"),Item."Costing Method");
                          end;
                          "Unit Cost" := "Unit Amount";
                          Validate("Unit Cost");
                        end;
                    end;
                end;
            end;
        }
        field(27;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestField(Quantity);
                "Unit Amount" := Amount / Quantity;
                Validate("Unit Amount");
                GetSetup;
                "Unit Amount" := Round("Unit Amount",GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(28;Hours;Decimal)
        {
            BlankZero = true;
            Caption = 'Hours';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(29;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                TestField("No.");
                if "Entry Type" = "Entry Type"::Return then
                  Error(
                    Text004,
                    "Entry Type",FieldCaption("Entry Type"),FieldCaption("Indirect Cost %"));

                if Type = Type::Item then begin
                  GetItem(Item);
                  if Item."Costing Method" = Item."Costing Method"::Standard then
                    Error(
                      Text003,
                      FieldCaption("Indirect Cost %"),Item.FieldCaption("Costing Method"),Item."Costing Method");
                end;

                "Unit Cost" :=
                  Round(
                    "Unit Amount" * (1 + "Indirect Cost %" / 100) +
                    "Overhead Rate" * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(30;"Overhead Rate";Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if ("Overhead Rate" <> 0) then
                  TestField(Type,Type::Item);
                if ("Overhead Rate" <> xRec."Overhead Rate") then
                  Validate("Indirect Cost %");
            end;
        }
        field(31;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."))
                            ELSE IF (Type=CONST("Spare Part")) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Cost)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Trade)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("Item No."))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE ("Resource No."=FIELD("No."))
                            ELSE IF (Type=CONST(Team)) "MCH Maint. Unit of Measure"."Unit of Measure Code" WHERE ("Table Name"=CONST(Team),
                                                                                                                  Code=FIELD("No."))
                                                                                                                  ELSE "Unit of Measure";

            trigger OnValidate()
            var
                WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
                Item: Record Item;
                Resource: Record Resource;
                ResUnitofMeasure: Record "Resource Unit of Measure";
                MaintTeam: Record "MCH Maintenance Team";
            begin
                "Qty. per Unit of Measure" := 1;
                GetSetup;
                if "Unit of Measure Code" <> '' then
                  TestField("No.");
                
                if WorkOrderBudgetLine.Get(
                  WorkOrderBudgetLine.Status::Released,"Work Order No.","Work Order Budget Line No.")
                then begin
                  if (CurrFieldNo <> 0) and (CurrFieldNo <> FieldNo("Work Order Budget Line No.")) and
                     (WorkOrderBudgetLine."Unit of Measure Code" <> '')
                  then
                    TestField("Unit of Measure Code",WorkOrderBudgetLine."Unit of Measure Code");
                end;
                
                if ("No." <> '') then begin
                  TestField("Unit of Measure Code");
                  case Type of
                    Type::Item:
                      begin
                        GetItem(Item);
                        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                      end;
                    Type::Resource:
                      begin
                        Resource.Get("No.");
                        if "Resource Work Type Code" <> '' then begin
                          WorkType.Get("Resource Work Type Code");
                          if WorkType."Unit of Measure Code" <> '' then
                            TestField("Unit of Measure Code",WorkType."Unit of Measure Code");
                        end;
                        ResUnitofMeasure.Get("No.","Unit of Measure Code");
                        ResUnitofMeasure.TestField("Related to Base Unit of Meas.",true);
                        "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                        AMFunction.TestIfUOMTimeBased("Unit of Measure Code",true);
                      end;
                    Type::Team:
                      begin
                        MaintTeam.Get("No.");
                        "Qty. per Unit of Measure" := AMFunction.GetTeamQtyPerUOM(MaintTeam,"Unit of Measure Code");
                        AMFunction.TestIfUOMTimeBased("Unit of Measure Code",true);
                      end;
                    else begin
                      FieldError(Type);
                      /*
                      Types not handled in Maint. Journal -
                      Type::"Spare Part":
                      Type::Cost:
                      Type::Trade:
                      */
                      end;
                  end;
                
                  GetUnitAmount(FieldNo("Unit of Measure Code"));
                  "Unit Cost" := Round(UnitCost * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision");
                  Validate("Unit Amount");
                  Validate(Quantity);
                
                  CheckItemAvailable(FieldNo("Unit of Measure Code"));
                end;

            end;
        }
        field(32;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if (Type <> Type::Item) or ("No." = '') then
                  exit;
                GetItem(Item);
                if "Location Code" <> '' then
                  Item.TestField(Type,Item.Type::Inventory);

                GetUnitAmount(FieldNo("Location Code"));
                "Unit Cost" := UnitCost;
                Validate("Unit Amount");
                if Type = Type::Item then
                  CheckItemAvailable(FieldNo("Location Code"));

                if "Location Code" <> xRec."Location Code" then begin
                  "Bin Code" := '';
                  if ("Location Code" <> '') and ("No." <> '') then begin
                    GetLocation("Location Code");
                  end;
                end;
                Validate("Unit of Measure Code");
            end;
        }
        field(33;"Resource Work Type Code";Code[10])
        {
            Caption = 'Resource Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                TestField(Type,Type::Resource);
                TestField("No.");
                if ("Resource Work Type Code" = '') and (xRec."Resource Work Type Code" <>'') then begin
                  Resource.Get("No.");
                  "Unit of Measure Code" := Resource."Base Unit of Measure";
                end;
                if ("Resource Work Type Code" <> '') then begin
                  WorkType.Get("Resource Work Type Code");
                  if WorkType."Unit of Measure Code" <> '' then
                    "Unit of Measure Code" := WorkType."Unit of Measure Code"
                  else begin
                    Resource.Get("No.");
                    "Unit of Measure Code" := Resource."Base Unit of Measure";
                  end;
                end;

                GetUnitAmount(FieldNo("Resource Work Type Code"));
                "Unit Cost" := UnitCost;
                Validate("Unit Amount");
                Validate("Unit of Measure Code");
            end;
        }
        field(34;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE ("Item No."=FIELD("No."));

            trigger OnValidate()
            var
                ItemVariant: Record "Item Variant";
            begin
                if "Variant Code" <> '' then begin
                  TestField(Type,Type::Item);
                  TestField("No.");
                end;

                if Type <> Type::Item then
                  exit;
                if "Variant Code" <> xRec."Variant Code" then begin
                  "Bin Code" := '';
                  if ("Location Code" <> '') and ("No." <> '') then begin
                    GetLocation("Location Code");
                  end;
                end;
                GetUnitAmount(FieldNo("Variant Code"));
                "Unit Cost" := UnitCost;
                Validate("Unit Amount");
                Validate("Unit of Measure Code");

                if "Variant Code" = '' then
                  exit;
                ItemVariant.Get("No.","Variant Code");
                Description := ItemVariant.Description;
            end;
        }
        field(35;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(36;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure",1);
                Validate(Quantity,"Quantity (Base)");
            end;
        }
        field(41;"Maint. Task Code";Code[20])
        {
            Caption = 'Maint. Task Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Master Maintenance Task";
        }
        field(42;"Maint. Location Code";Code[20])
        {
            Caption = 'Maint. Location Code';
            Editable = false;
            TableRelation = "MCH Maintenance Location";
        }
        field(43;"Work Order Type";Code[20])
        {
            Caption = 'Work Order Type';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MCH Work Order Type";
        }
        field(45;"Resource No. (Issue/Return)";Code[20])
        {
            Caption = 'Resource No. (Issue/Return)';
            TableRelation = Resource;
        }
        field(51;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(53;"Posting No. Series";Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(54;"Asset Posting Group";Code[20])
        {
            Caption = 'Asset Posting Group';
            TableRelation = "MCH Maint. Asset Posting Group";
        }
        field(55;"Gen. Prod. Posting Group";Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(57;"Gen. Bus. Posting Group";Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(60;"Applies-to Item Entry";Integer)
        {
            Caption = 'Applies-to Item Entry';

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Applies-to Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Applies-to Item Entry" <> 0 then begin
                  TestField(Type,Type::Item);
                  TestField("No.");
                  TestField(Quantity);
                  if Signed(Quantity) > 0 then begin
                    if Quantity > 0 then
                      FieldError(Quantity,Text006);
                    if Quantity < 0 then
                      FieldError(Quantity,Text005);
                  end;
                  ItemLedgEntry.Get("Applies-to Item Entry");
                  ItemLedgEntry.TestField(Open,true);
                  ItemLedgEntry.TestField(Positive,true);

                  "Location Code" := ItemLedgEntry."Location Code";
                  "Variant Code" := ItemLedgEntry."Variant Code";
                end;
            end;
        }
        field(61;"Applies-from Item Entry";Integer)
        {
            Caption = 'Applies-from Item Entry';
            MinValue = 0;

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Applies-from Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Applies-from Item Entry" <> 0 then begin
                  TestField(Type,Type::Item);
                  TestField("No.");
                  TestField(Quantity);
                  if Signed(Quantity) < 0 then begin
                    if Quantity > 0 then
                      FieldError(Quantity,Text006);
                    if Quantity < 0 then
                      FieldError(Quantity,Text005);
                  end;
                  ItemLedgEntry.Get("Applies-from Item Entry");
                  ItemLedgEntry.TestField(Positive,false);
                  "Unit Cost" := CalcUnitCost(ItemLedgEntry."Entry No.");
                end;
            end;
        }
        field(62;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            Editable = false;
            TableRelation = IF (Type=CONST(Item),
                                "Entry Type"=FILTER(Return),
                                Quantity=FILTER(>=0)) Bin.Code WHERE ("Location Code"=FIELD("Location Code"),
                                                                      "Item Filter"=FIELD("No."),
                                                                      "Variant Filter"=FIELD("Variant Code"))
                                                                      ELSE IF (Type=CONST(Item),
                                                                               "Entry Type"=FILTER(Return),
                                                                               Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE ("Location Code"=FIELD("Location Code"),
                                                                                                                                    "Item No."=FIELD("No."),
                                                                                                                                    "Variant Code"=FIELD("Variant Code"))
                                                                                                                                    ELSE IF (Type=CONST(Item),
                                                                                                                                             "Entry Type"=FILTER(Issue),
                                                                                                                                             Quantity=FILTER(>0)) "Bin Content"."Bin Code" WHERE ("Location Code"=FIELD("Location Code"),
                                                                                                                                                                                                  "Item No."=FIELD("No."),
                                                                                                                                                                                                  "Variant Code"=FIELD("Variant Code"))
                                                                                                                                                                                                  ELSE IF (Type=CONST(Item),
                                                                                                                                                                                                           "Entry Type"=FILTER(Issue),
                                                                                                                                                                                                           Quantity=FILTER(<=0)) Bin.Code WHERE ("Location Code"=FIELD("Location Code"),
                                                                                                                                                                                                                                                 "Item Filter"=FIELD("No."),
                                                                                                                                                                                                                                                 "Variant Filter"=FIELD("Variant Code"));

            trigger OnValidate()
            begin
                if "Bin Code" <> xRec."Bin Code" then begin
                  if "Bin Code" <> '' then begin
                    TestField(Type,Type::Item);
                    TestField("No.");
                    TestField("Location Code");
                    GetBin("Location Code","Bin Code");
                    GetLocation("Location Code");
                    Location.TestField("Bin Mandatory");
                    Location.TestField("Directed Put-away and Pick",false);

                    TestField("Location Code",Bin."Location Code");
                  end;
                end;
            end;
        }
        field(71;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(72;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(73;"Work Order Budget Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Work Order Budget Line No.';
            TableRelation = IF ("Entry Type"=CONST(Issue)) "MCH Work Order Budget Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                          "Work Order No."=FIELD("Work Order No."),
                                                                                                          Type=CONST(Item))
                                                                                                          ELSE IF ("Entry Type"=CONST(Return)) "MCH Work Order Budget Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                                                                                                              "Work Order No."=FIELD("Work Order No."),
                                                                                                                                                                                              Type=CONST(Item))
                                                                                                                                                                                              ELSE IF ("Entry Type"=CONST(Timesheet)) "MCH Work Order Budget Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                                                                                                                                                                                                     "Work Order No."=FIELD("Work Order No."),
                                                                                                                                                                                                                                                                                     Type=FILTER(Resource|Team));

            trigger OnValidate()
            var
                WorkOrder: Record "MCH Work Order Header";
                WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
                RemQtyBase: Decimal;
            begin
                if "Work Order Budget Line No." <> 0 then begin
                  GetWorkOrder(WorkOrder);
                  WorkOrderBudgetLine.Get(WorkOrderBudgetLine.Status::Released,"Work Order No.","Work Order Budget Line No.");
                  Validate("Work Order Line No.",WorkOrderBudgetLine."Work Order Line No.");
                  case "Entry Type" of
                    "Entry Type"::Issue,"Entry Type"::Return:
                      begin
                        WorkOrderBudgetLine.TestField(Type,WorkOrderBudgetLine.Type::Item);
                        WorkOrderBudgetLine.TestField("Unit of Measure Code");

                        Validate(Type,WorkOrderBudgetLine.Type);
                        Validate("No.",WorkOrderBudgetLine."No.");
                        if (WorkOrderBudgetLine."Variant Code" <> '') then
                          Validate("Variant Code",WorkOrderBudgetLine."Variant Code");
                        Validate("Unit of Measure Code",WorkOrderBudgetLine."Unit of Measure Code");
                        if IsItemNonInventoriable("No.") then begin
                          if ("Location Code" <> '') then
                            Validate("Location Code",'');
                        end else begin
                          if (WorkOrderBudgetLine."Location Code" <> '') and ("Location Code" <> WorkOrderBudgetLine."Location Code") then
                            Validate("Location Code",WorkOrderBudgetLine."Location Code");
                        end;

                        if ("Entry Type" = "Entry Type"::Issue) and (WorkOrderBudgetLine.Quantity > 0) then begin
                          WorkOrderBudgetLine.CalcFields("Posted Qty. (Base)");
                          RemQtyBase := WorkOrderBudgetLine."Quantity (Base)" - WorkOrderBudgetLine."Posted Qty. (Base)";
                          if (RemQtyBase > 0) then
                            Validate(Quantity,Round(RemQtyBase/WorkOrderBudgetLine."Qty. per Unit of Measure",0.00001));
                        end;
                      end;
                    "Entry Type"::Timesheet:
                      begin
                        if not (WorkOrderBudgetLine.Type in [WorkOrderBudgetLine.Type::Resource,WorkOrderBudgetLine.Type::Team]) then
                          WorkOrderBudgetLine.FieldError(Type);
                        WorkOrderBudgetLine.TestField("Unit of Measure Code");
                        Validate(Type,WorkOrderBudgetLine.Type);
                        Validate("No.",WorkOrderBudgetLine."No.");
                        Validate("Unit of Measure Code",WorkOrderBudgetLine."Unit of Measure Code");
                      end;
                    else
                      FieldError("Entry Type");
                  end;
                end;
            end;
        }
        field(79;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Item;
        }
        field(80;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(84;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
        field(85;"Document Type";Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,,,,,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase CR/Adj Note';
            OptionMembers = " ",,,,,"Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo";
        }
        field(86;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(87;"Qty. Invoiced";Decimal)
        {
            Caption = 'Qty. Invoiced';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
        }
        field(88;"Qty. Invoiced (Base)";Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
        }
        field(90;"AM Ledger Entry No.";Integer)
        {
            Caption = 'AM Ledger Entry No.';
        }
        field(91;"Item Ledger Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Item Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
        key(Key2;Type,"No.","Variant Code","Location Code","Posting Date")
        {
        }
        key(Key3;"Entry Type",Type,"No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)",Hours;
        }
        key(Key4;"Work Order No.","Work Order Line No.","Work Order Budget Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)",Hours;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
    end;

    trigger OnInsert()
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
    begin
        LockTable;
        MaintJnlTemplate.Get("Journal Template Name");
        MaintJnlBatch.Get("Journal Template Name","Journal Batch Name");

        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
    end;

    var
        GLSetup: Record "General Ledger Setup";
        AMSetup: Record "MCH Asset Maintenance Setup";
        InventorySetup: Record "Inventory Setup";
        GlobalItem: Record Item;
        Location: Record Location;
        Bin: Record Bin;
        WorkType: Record "Work Type";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UOMMgt: Codeunit "Unit of Measure Management";
        AMFunction: Codeunit "MCH AM Functions";
        DimMgt: Codeunit DimensionManagement;
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        SetupRead: Boolean;
        Text001: Label 'You cannot change %1 when %2 is %3.';
        Text002: Label 'cannot be %1 when %2 is %3';
        Text003: Label 'You cannot change %1 when %2 is %3.';
        Text004: Label 'You cannot change %3 when %2 is %1.';
        UnitCost: Decimal;
        Text005: Label 'must be positive';
        Text006: Label 'must be negative';
        Text007: Label '%1 must be reduced.';
        Text010: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';


    procedure SetUpNewLine(LastMaintJnlLine: Record "MCH Maint. Journal Line")
    var
        MaintJnlTemplate: Record "MCH Maint. Journal Template";
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
        MaintJnlLine: Record "MCH Maint. Journal Line";
    begin
        GetSetup;
        MaintJnlTemplate.Get("Journal Template Name");
        MaintJnlBatch.Get("Journal Template Name","Journal Batch Name");
        MaintJnlLine.SetRange("Journal Template Name","Journal Template Name");
        MaintJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
        if MaintJnlLine.Find('-') then begin
          "Posting Date" := LastMaintJnlLine."Posting Date";
          "Document Date" := LastMaintJnlLine."Posting Date";
          if not AMSetup."Use WO No. as Posting Doc. No." then
            "Document No." := LastMaintJnlLine."Document No."
        end else begin
          "Posting Date" := WorkDate;
          "Document Date" := WorkDate;
          if not AMSetup."Use WO No. as Posting Doc. No." then
            if MaintJnlBatch."No. Series" <> '' then begin
              Clear(NoSeriesMgt);
              "Document No." := NoSeriesMgt.GetNextNo(MaintJnlBatch."No. Series","Posting Date",false);
            end;
        end;
        "Reason Code" := MaintJnlBatch."Reason Code";
        "Posting No. Series" := MaintJnlBatch."Posting No. Series";

        case MaintJnlTemplate.Type of
          MaintJnlTemplate.Type::Inventory:
            begin
              if (LastMaintJnlLine."Entry Type" in
                [LastMaintJnlLine."Entry Type"::Issue,LastMaintJnlLine."Entry Type"::Return])
              then
                "Entry Type" := LastMaintJnlLine."Entry Type"
              else
               "Entry Type" := "Entry Type"::Issue;
              Type := Type::Item;
              if (LastMaintJnlLine."Resource No. (Issue/Return)" <> '') then
                "Resource No. (Issue/Return)" := LastMaintJnlLine."Resource No. (Issue/Return)";
            end;
          MaintJnlTemplate.Type::Timesheet:
            begin
              "Entry Type" := "Entry Type"::Timesheet;
              if (LastMaintJnlLine.Type in [LastMaintJnlLine.Type::Resource..LastMaintJnlLine.Type::Team]) then
                Type := LastMaintJnlLine.Type
              else
                Type := Type::Resource;
            end;
        end;
    end;

    local procedure GetWorkOrder(var WorkOrder: Record "MCH Work Order Header")
    begin
        TestField("Work Order No.");
        if WorkOrder."No." <> "Work Order No." then
          WorkOrder.Get(WorkOrder.Status::Released,"Work Order No.");
    end;

    local procedure SetFilterWorkOrderLine(var WorkOrderLine: Record "MCH Work Order Line")
    begin
        WorkOrderLine.Reset;
        WorkOrderLine.SetRange(Status,WorkOrderLine.Status::Released);
        WorkOrderLine.SetRange("Work Order No.","Work Order No.");
        WorkOrderLine.SetFilter("Asset No.",'<>%1','');
    end;

    local procedure CopyFromWorkOrderLine(var WorkOrderLine: Record "MCH Work Order Line")
    begin
        "Asset No." := WorkOrderLine."Asset No.";
        "Maint. Location Code" := WorkOrderLine."Maint. Location Code";
        "Work Order Type" := WorkOrderLine."Work Order Type";
    end;

    local procedure CopyFromMaintAsset(var MaintAsset: Record "MCH Maintenance Asset")
    begin
        "Asset Posting Group" := MaintAsset."Posting Group";
        "Gen. Bus. Posting Group" := MaintAsset."Gen. Bus. Posting Group";
    end;

    local procedure GetUnitAmount(CalledByFieldNo: Integer)
    var
        Item: Record Item;
        UnitCostValue: Decimal;
    begin
        RetrieveCosts;
        UnitCostValue := UnitCost;

        if (Type = Type::Item) then begin
          GetItem(Item);
          if (CalledByFieldNo = FieldNo(Quantity)) and
             (Item."No." <> '') and (Item."Costing Method" <> Item."Costing Method"::Standard)
          then
            UnitCostValue := "Unit Cost" / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
        end;

        case "Entry Type" of
          "Entry Type"::Return:
            "Unit Amount" := Round(
              ((UnitCostValue - "Overhead Rate") * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
              GLSetup."Unit-Amount Rounding Precision");
          "Entry Type"::Issue,
          "Entry Type"::Timesheet:
            "Unit Amount" := UnitCostValue * "Qty. per Unit of Measure"
        end;
    end;

    local procedure UpdateAmount()
    begin
        Amount := Round(Quantity * "Unit Amount");
    end;

    local procedure RetrieveCosts()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        Resource: Record Resource;
        MaintTeam: Record "MCH Maintenance Team";
    begin
        GetSetup;
        case Type of
          Type::Item:
            begin
              GetItem(Item);
              if InventorySetup."Average Cost Calc. Type" = InventorySetup."Average Cost Calc. Type"::Item then
                UnitCost := Item."Unit Cost"
              else
                if GetSKU(SKU) then
                  UnitCost := SKU."Unit Cost"
                else
                  UnitCost := Item."Unit Cost";
              if Item."Costing Method" <> Item."Costing Method"::Standard then
                UnitCost := Round(UnitCost,GLSetup."Unit-Amount Rounding Precision");
            end;
          Type::Resource:
            begin
              Resource.Get("No.");
              UnitCost :=  Resource."Unit Cost";
            end;
          Type::Team:
            begin
              MaintTeam.Get("No.");
              UnitCost := MaintTeam."Unit Cost";
            end;
          else begin
            // Types not handled in Maint. Journal -"Spare Part" Type::Cost Type::Trade
          end;
        end;
    end;

    local procedure CalcUnitCost(ItemLedgEntryNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.Reset;
        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.",ItemLedgEntryNo);
        ValueEntry.CalcSums("Invoiced Quantity","Cost Amount (Actual)");
        exit(ValueEntry."Cost Amount (Actual)" / ValueEntry."Invoiced Quantity" * "Qty. per Unit of Measure");
    end;

    local procedure UpdateHours()
    begin
        if Type in [Type::Resource,Type::Team,Type::Cost,Type::Trade] then
          Hours := AMFunction.GetHoursPerTimeUOM(Quantity,"Unit of Measure Code")
        else
          Hours := 0;
    end;

    local procedure GetMaintAsset(var MaintAsset: Record "MCH Maintenance Asset")
    begin
        if ("Asset No." = '') then begin
          Clear(MaintAsset);
          exit;
        end;
        if "Asset No." <> MaintAsset."No." then begin
          MaintAsset.Get("Asset No.");
          MaintAsset.TestField(Blocked,false);
          MaintAsset.TestField("Posting Group");
          MaintAsset.TestField("Gen. Bus. Posting Group");
        end;
    end;

    local procedure GetItem(var Item: Record Item)
    begin
        TestField(Type,Type::Item);
        TestField("No.");
        if GlobalItem."No." <> "No." then
          GlobalItem.Get("No.");
        Item := GlobalItem;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
        Location.TestField("Bin Mandatory",false);
        Location.TestField("Directed Put-away and Pick",false);
    end;

    local procedure GetSKU(var SKU: Record "Stockkeeping Unit"): Boolean
    begin
        if (Type <> Type::Item) or ("No." = '') then
          exit(false);
        if (SKU."Location Code" = "Location Code") and
           (SKU."Item No." = "No.") and
           (SKU."Variant Code" = "Variant Code")
        then
          exit(true);
        if SKU.Get("Location Code","No.","Variant Code") then
          exit(true)
        else
          exit(false);
    end;

    local procedure GetBin(LocationCode: Code[10];BinCode: Code[20])
    begin
        if BinCode = '' then
          Clear(Bin)
        else
          if Bin.Code <> BinCode then
            Bin.Get(LocationCode,BinCode);
    end;

    local procedure GetSetup()
    begin
        if not SetupRead then begin
          GLSetup.Get;
          InventorySetup.Get;
          AMSetup.Get;
          AMSetup.TestField("Source Code");
        end;
        SetupRead := true;
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(Round(Qty * "Qty. per Unit of Measure",0.00001));
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        MaintJnlLine2: Record "MCH Maint. Journal Line";
    begin
        if (Type <> Type::Item) or ("No." = '') then
          exit;
        ItemLedgEntry.SetCurrentKey("Item No.",Positive);
        ItemLedgEntry.SetRange("Item No.","No.");
        ItemLedgEntry.SetRange(Correction,false);

        if "Location Code" <> '' then
          ItemLedgEntry.SetRange("Location Code","Location Code");

        if CurrentFieldNo = FieldNo("Applies-to Item Entry") then begin
          ItemLedgEntry.SetRange(Positive,true);
          ItemLedgEntry.SetCurrentKey("Item No.",Open);
          ItemLedgEntry.SetRange(Open,true);
        end else
          ItemLedgEntry.SetRange(Positive,false);

        if PAGE.RunModal(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK then begin
          MaintJnlLine2 := Rec;
          if CurrentFieldNo = FieldNo("Applies-to Item Entry") then
            MaintJnlLine2.Validate("Applies-to Item Entry",ItemLedgEntry."Entry No.")
          else
            MaintJnlLine2.Validate("Applies-from Item Entry",ItemLedgEntry."Entry No.");
          CheckItemAvailable(CurrentFieldNo);
          Rec := MaintJnlLine2;
        end;
    end;

    local procedure Signed(Value: Decimal): Decimal
    begin
        case "Entry Type" of
          "Entry Type"::Return,
          "Entry Type"::Timesheet :
            exit(Value);
          "Entry Type"::Issue:
            exit(-Value);
        end;
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    var
        DummyItemJnlLine: Record "Item Journal Line" temporary;
    begin
        if (CurrFieldNo = 0) or (CurrFieldNo <> CalledByFieldNo) then // Prevent two checks on quantity
          exit;

        if (CurrFieldNo <> 0) and
           (Type = Type::Item) and ("No." <> '') and
           ((("Entry Type" = "Entry Type"::Issue) and (Quantity > 0)) or
            (("Entry Type" = "Entry Type"::Return) and (Quantity < 0)))
        then begin
          DummyItemJnlLine."Item No." := "No.";
          DummyItemJnlLine."Value Entry Type" := DummyItemJnlLine."Value Entry Type"::"Direct Cost";
          DummyItemJnlLine."Entry Type" := DummyItemJnlLine."Entry Type"::"Negative Adjmt.";
          DummyItemJnlLine."Posting Date" := "Posting Date";
          DummyItemJnlLine."Location Code" := "Location Code";
          DummyItemJnlLine."Variant Code" := "Variant Code";
          DummyItemJnlLine."Bin Code" := "Bin Code";
          DummyItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
          DummyItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          DummyItemJnlLine.Quantity := Quantity;

          ItemCheckAvail.ItemJnlCheckLine(DummyItemJnlLine);
        end;
    end;


    procedure ShowItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        DummyItemJnlLine: Record "Item Journal Line" temporary;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
    begin
        if not ((Type = Type::Item) and ("No." <> '')) then
          exit;
        DummyItemJnlLine."Item No." := "No.";
        DummyItemJnlLine."Posting Date" := "Posting Date";
        DummyItemJnlLine."Location Code" := "Location Code";
        DummyItemJnlLine."Variant Code" := "Variant Code";
        ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(DummyItemJnlLine,AvailabilityType);
    end;


    procedure EmptyLine(): Boolean
    begin
        exit(("Work Order No." = '') and ("Asset No." = '') and (Quantity = 0));
    end;

    local procedure PickDimension(TableArray: array [10] of Integer;CodeArray: array [10] of Code[20];InheritFromDimSetID: Integer;InheritFromTableNo: Integer)
    var
        ItemJournalTemplate: Record "Item Journal Template";
        SourceCode: Code[10];
    begin
        GetSetup;
        SourceCode := AMSetup."Source Code";
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec,CurrFieldNo,TableArray,CodeArray,SourceCode,
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",InheritFromDimSetID,InheritFromTableNo);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    local procedure CreateCodeArray(var CodeArray: array [10] of Code[20];No1: Code[20])
    begin
        Clear(CodeArray);
        CodeArray[1] := No1;
    end;

    local procedure CreateTableArray(var TableID: array [10] of Integer;Type1: Integer)
    begin
        Clear(TableID);
        TableID[1] := Type1;
    end;


    procedure CreateDim(Type1: Integer;No1: Code[20])
    var
        WorkOrderLine: Record "MCH Work Order Line";
        DimSetIDArr: array [10] of Integer;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        CreateTableArray(TableID,Type1);
        CreateCodeArray(No,No1);
        PickDimension(TableID,No,0,0);

        if "Work Order Line No." <> 0 then begin
          if WorkOrderLine.Get(WorkOrderLine.Status::Released,"Work Order No.","Work Order Line No.") then begin
            DimSetIDArr[1] := "Dimension Set ID";
            DimSetIDArr[2] := WorkOrderLine."Dimension Set ID";
            "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
          end;
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    local procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin
        if Type = Type::Item then
          if not Item2.Get(ItemNo) then
            exit(false);
        exit(true);
    end;


    procedure IsItemNonInventoriable(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin
        if (Type = Type::Item) and (ItemNo <> '') then begin
          if not Item2.Get(ItemNo) then
            exit(false);
          exit(Item2.IsNonInventoriableType);
        end;
        exit(false);
    end;

    local procedure CheckProgStatusBlocking()
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        case "Entry Type" of
          "Entry Type"::Issue : AMFunctions.CheckIfInvtIssueBlocked("Work Order No.",true);
          "Entry Type"::Return : AMFunctions.CheckIfInvtReturnBlocked("Work Order No.",true);
          "Entry Type"::Timesheet :
            begin
              if (CurrFieldNo <> 0) then
                AMFunctions.CheckIfTimeEntryBlocked("Work Order No.",true);
            end;
        end;
    end;

    local procedure CheckUserWorkOrderRespGroupAccess(var WorkOrder: Record "MCH Work Order Header")
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
          if not MaintUserMgt.UserHasAccessToRespGroup(UserId,WorkOrder."Responsibility Group Code") then
            Error(Text010,
              WorkOrder.TableCaption,WorkOrder."No.",
              WorkOrder.FieldCaption("Responsibility Group Code"),WorkOrder."Responsibility Group Code");
        end;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID",StrSubstNo('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;


    procedure IsOpenedFromBatch(): Boolean
    var
        JournalBatch: Record "MCH Maint. Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GetFilter("Journal Batch Name");
        if BatchFilter <> '' then begin
          TemplateFilter := GetFilter("Journal Template Name");
          if TemplateFilter <> '' then
            JournalBatch.SetFilter("Journal Template Name",TemplateFilter);
          JournalBatch.SetFilter(Name,BatchFilter);
          JournalBatch.FindFirst;
        end;
        exit((("Journal Batch Name" <> '') and ("Journal Template Name" = '')) or (BatchFilter <> ''));
    end;
}

