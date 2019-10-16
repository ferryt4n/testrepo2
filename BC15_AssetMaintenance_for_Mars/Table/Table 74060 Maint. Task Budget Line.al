table 74060 "MCH Maint. Task Budget Line"
{
    Caption = 'Maint. Task Budget Line';
    DrillDownPageID = "MCH Maint. Task Budget Lines";
    LookupPageID = "MCH Maint. Task Budget Lines";

    fields
    {
        field(2;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            NotBlank = true;
            TableRelation = "MCH Master Maintenance Task";
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;

            trigger OnValidate()
            var
                TempMaintTaskBudgetLine: Record "MCH Maint. Task Budget Line" temporary;
            begin
                TempMaintTaskBudgetLine := Rec;
                Init;
                Type := TempMaintTaskBudgetLine.Type;
            end;
        }
        field(11;"No.";Code[20])
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
                TempMaintTaskBudgetLine: Record "MCH Maint. Task Budget Line" temporary;
                Item: Record Item;
                SKU: Record "Stockkeeping Unit";
                SparePart: Record "MCH Maintenance Spare Part";
                MaintCost: Record "MCH Maintenance Cost";
                MaintTrade: Record "MCH Maintenance Trade";
                Resource: Record Resource;
                MaintTeam: Record "MCH Maintenance Team";
                ResCost: Record "Resource Cost";
                StdTxt: Record "Standard Text";
            begin
                TempMaintTaskBudgetLine := Rec;
                Init;
                Type := TempMaintTaskBudgetLine.Type;
                "No." := TempMaintTaskBudgetLine."No.";

                if "No." = '' then
                  exit;
                GetSetup;

                case Type of
                  Type::" ":
                    begin
                      StdTxt.Get("No.");
                      Description := StdTxt.Description;
                    end;
                  Type::Item:
                    begin
                      GetItem(Item);
                      Item.TestField(Blocked,false);
                      if (not Item.IsNonInventoriableType) then
                        Item.TestField("Gen. Prod. Posting Group");
                      Item.TestField("Base Unit of Measure");
                      "Item No." := Item."No.";
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Unit of Measure Code" := Item."Base Unit of Measure";
                      "Indirect Cost %" := Item."Indirect Cost %";
                      if GetSKU(SKU) and (SKU."Vendor No." <> '') then
                        "Vendor No." := SKU."Vendor No."
                      else
                        "Vendor No." := Item."Vendor No.";
                    end;
                  Type::"Spare Part":
                    begin
                      SparePart.Get("No.");
                      SparePart.TestField(Blocked,false);
                      SparePart.GetItemWithEffectiveValues(Item,true);
                      "Item No." := Item."No.";
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Unit of Measure Code" := Item."Purch. Unit of Measure";
                      "Indirect Cost %" := Item."Indirect Cost %";
                      "Vendor No." := Item."Vendor No.";
                    end;
                  Type::Cost:
                    begin
                      MaintCost.Get("No.");
                      MaintCost.TestField(Blocked,false);
                      MaintCost.GetItemWithEffectiveValues(Item,true);
                      "Item No." := Item."No.";
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Unit of Measure Code" := Item."Purch. Unit of Measure";
                      "Indirect Cost %" := Item."Indirect Cost %";
                      "Vendor No." := Item."Vendor No.";
                    end;
                  Type::Trade:
                    begin
                      MaintTrade.Get("No.");
                      MaintCost.TestField(Blocked,false);
                      MaintTrade.GetItemWithEffectiveValues(Item,true);
                      "Item No." := Item."No.";
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Unit of Measure Code" := Item."Purch. Unit of Measure";
                      "Indirect Cost %" := Item."Indirect Cost %";
                      "Vendor No." := Item."Vendor No.";
                    end;
                  Type::Resource:
                    begin
                      Resource.Get("No.");
                      Resource.TestField(Blocked,false);
                      Resource.TestField("Gen. Prod. Posting Group");
                      Resource.TestField("Base Unit of Measure");
                      Description := Resource.Name;
                      "Unit of Measure Code" := Resource."Base Unit of Measure";
                      "Indirect Cost %" := Resource."Indirect Cost %";
                    end;
                  Type::Team:
                    begin
                      MaintTeam.Get("No.");
                      MaintTeam.TestField(Blocked,false);
                      MaintTeam.TestField("Base Unit of Measure");
                      Description := MaintTeam.Description;
                      "Description 2" := MaintTeam."Description 2";
                      "Unit of Measure Code" := MaintTeam."Base Unit of Measure";
                      "Indirect Cost %" := MaintTeam."Indirect Cost %";
                    end;
                end;

                if Type <> Type::" " then begin
                  Quantity := xRec.Quantity;
                  Validate("Unit of Measure Code");
                  UpdateDirectUnitCost(FieldNo("No."));
                end;
            end;
        }
        field(12;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(13;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := CalcBaseQty(Quantity);

                UpdateDirectUnitCost(FieldNo(Quantity));
                UpdateHours;
            end;
        }
        field(17;"Direct Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                UpdateUnitCost;
                UpdateCostValues;
            end;
        }
        field(18;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                TestField("No.");
                TestField(Quantity);

                if (Type = Type::Item) then begin
                  GetItem(Item);
                  if Item."Costing Method" = Item."Costing Method"::Standard then
                    Error(
                      Text003,
                      FieldCaption("Unit Cost"),Item.FieldCaption("Costing Method"),Item."Costing Method");
                end;

                if ("Direct Unit Cost" <> 0) then
                  "Indirect Cost %" := Round(
                    ("Unit Cost" - "Direct Unit Cost" / Quantity) /
                    ("Direct Unit Cost" / Quantity) * 100,0.00001)
                else
                  "Indirect Cost %" := 0;
                UpdateCostValues;
            end;
        }
        field(19;"Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
        }
        field(20;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                TestField(Type);
                TestField("No.");
                if (Type = Type::Item) then begin
                  GetItem(Item);
                  if Item."Costing Method" = Item."Costing Method"::Standard then
                    Error(
                      Text003,
                      FieldCaption("Indirect Cost %"),Item.FieldCaption("Costing Method"),Item."Costing Method");
                end;
                Validate("Direct Unit Cost");
            end;
        }
        field(21;"Unit of Measure Code";Code[10])
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
                Item: Record Item;
                SparePart: Record "MCH Maintenance Spare Part";
                MaintCost: Record "MCH Maintenance Cost";
                MaintTrade: Record "MCH Maintenance Trade";
                Resource: Record Resource;
                MaintTeam: Record "MCH Maintenance Team";
                ResGr: Record "Resource Group";
                ResCost: Record "Resource Cost";
                StdTxt: Record "Standard Text";
                WorkType: Record "Work Type";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
                GetSetup;
                if ("No." <> '') then begin
                  TestField("Unit of Measure Code");
                  case Type of
                    Type::Item :
                      begin
                        GetItem(Item);
                        "Item No." := Item."No.";
                        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                        "Unit Cost" := Item."Unit Cost" * "Qty. per Unit of Measure";
                      end;
                    Type::"Spare Part" :
                      begin
                        SparePart.Get("No.");
                        SparePart.GetItem(Item);
                        "Item No." := Item."No.";
                        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                        "Unit Cost" := SparePart."Fixed Direct Unit Cost" * "Qty. per Unit of Measure";
                      end;
                    Type::Cost :
                      begin
                        MaintCost.Get("No.");
                        MaintCost.GetItem(Item);
                        "Item No." := Item."No.";
                        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                        "Unit Cost" := MaintCost."Fixed Direct Unit Cost" * "Qty. per Unit of Measure";
                      end;
                    Type::Trade :
                      begin
                        MaintTrade.Get("No.");
                        MaintTrade.GetItem(Item);
                        "Item No." := Item."No.";
                        AMFunction.TestIfUOMTimeBased("Unit of Measure Code",true);
                        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                        "Unit Cost" := MaintTrade."Fixed Direct Unit Cost" * "Qty. per Unit of Measure";
                      end;
                    Type::Resource :
                      begin
                        if "Resource Work Type Code" <> '' then begin
                          WorkType.Get("Resource Work Type Code");
                          if WorkType."Unit of Measure Code" <> '' then
                            TestField("Unit of Measure Code",WorkType."Unit of Measure Code");
                        end;
                        if "Unit of Measure Code" = '' then begin
                          Resource.Get("No.");
                          "Unit of Measure Code" := Resource."Base Unit of Measure";
                        end;
                        ResUnitofMeasure.Get("No.","Unit of Measure Code");
                        ResUnitofMeasure.TestField("Related to Base Unit of Meas.",true);
                        "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                        AMFunction.TestIfUOMTimeBased("Unit of Measure Code",true);
                        "Unit Cost" :=  Resource."Unit Cost" * "Qty. per Unit of Measure";
                      end;
                    Type::Team :
                      begin
                        MaintTeam.Get("No.");
                        "Qty. per Unit of Measure" := AMFunction.GetTeamQtyPerUOM(MaintTeam,"Unit of Measure Code");
                        AMFunction.TestIfUOMTimeBased("Unit of Measure Code",true);
                        "Unit Cost" :=  MaintTeam."Unit Cost" * "Qty. per Unit of Measure";
                      end;
                  end;
                end;

                UpdateDirectUnitCost(FieldNo("Unit of Measure Code"));
                Validate(Quantity);
            end;
        }
        field(22;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));

            trigger OnValidate()
            begin
                if Type = Type::Item then
                  UpdateDirectUnitCost(FieldNo("Location Code"));
            end;
        }
        field(23;"Resource Work Type Code";Code[10])
        {
            Caption = 'Resource Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate()
            var
                Resource: Record Resource;
                WorkType: Record "Work Type";
                ResUnitofMeasure: Record "Resource Unit of Measure";
                ResGroup: Record "Resource Group";
            begin
                if (Type <> Type::Resource) then
                  FieldError(Type);
                TestField("No.");
                GetSetup;

                if ("Resource Work Type Code" ='') and (xRec."Resource Work Type Code" <>'') then begin
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

                Validate("Unit of Measure Code");
                UpdateDirectUnitCost(FieldNo("Resource Work Type Code"));
            end;
        }
        field(24;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE ("Item No."=FIELD("No."));

            trigger OnValidate()
            var
                Item: Record Item;
                ItemVariant: Record "Item Variant";
            begin
                if "Variant Code" <> '' then
                  TestField(Type,Type::Item);
                if Type = Type::Item then
                  UpdateDirectUnitCost(FieldNo("Variant Code"))
                else
                  exit;

                if "Variant Code" = '' then begin
                  GetItem(Item);
                  Description := Item.Description;
                  "Description 2" := Item."Description 2";
                end else begin
                  ItemVariant.Get("No.","Variant Code");
                  Description := ItemVariant.Description;
                  "Description 2" := ItemVariant."Description 2";
                end;
            end;
        }
        field(25;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(26;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure",1);
                Validate(Quantity,"Quantity (Base)");
                UpdateDirectUnitCost(FieldNo("Quantity (Base)"));
            end;
        }
        field(27;Hours;Decimal)
        {
            BlankZero = true;
            Caption = 'Hours';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(70;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = IF (Type=CONST(Item)) Vendor
                            ELSE IF (Type=CONST("Spare Part")) Vendor
                            ELSE IF (Type=CONST(Cost)) Vendor
                            ELSE IF (Type=CONST(Trade)) Vendor;

            trigger OnValidate()
            begin
                if Type = Type::Item then
                  UpdateDirectUnitCost(FieldNo("Vendor No."));
            end;
        }
        field(71;"Vendor Name";Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Item;
        }
        field(200;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(201;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1;"Task Code","Line No.")
        {
            Clustered = true;
            SumIndexFields = "Cost Amount",Hours;
        }
        key(Key2;"Task Code",Type,"No.")
        {
            SumIndexFields = "Cost Amount",Hours;
        }
        key(Key3;Type,"No.")
        {
            MaintainSQLIndex = false;
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
        MasterMaintTask: Record "MCH Master Maintenance Task";
    begin
        MasterMaintTask.Get("Task Code");
        SetLastModified;
    end;

    trigger OnModify()
    begin
        SetLastModified;
    end;

    var
        Text002: Label 'You cannot rename a %1.';
        GLSetup: Record "General Ledger Setup";
        AMSetup: Record "MCH Asset Maintenance Setup";
        AMCostCalcMgt: Codeunit "MCH AM Cost Mgt.";
        UOMMgt: Codeunit "Unit of Measure Management";
        Text003: Label 'You cannot change %1 when %2 is %3.';
        AMFunction: Codeunit "MCH AM Functions";
        SetupRead: Boolean;

    local procedure UpdateDirectUnitCost(CalledByFieldNo: Integer)
    begin
        if ((CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0)) then
          exit;
        AMCostCalcMgt.FindMaintTaskBudgetLineDirUnitCost(Rec,CalledByFieldNo);
        Validate("Direct Unit Cost");
    end;


    procedure UpdateUnitCost()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
    begin
        GetSetup;
        "Unit Cost" := ("Direct Unit Cost") * (1 + "Indirect Cost %" / 100);
        if (Type = Type::Item) then begin
          GetItem(Item);
          if Item."Costing Method" = Item."Costing Method"::Standard then begin
            if GetSKU(SKU) then
              "Unit Cost" := SKU."Unit Cost" * "Qty. per Unit of Measure"
            else
              "Unit Cost" := Item."Unit Cost" * "Qty. per Unit of Measure";
          end;
        end;
        "Unit Cost" := Round("Unit Cost",GLSetup."Unit-Amount Rounding Precision");
    end;


    procedure UpdateCostValues()
    begin
        if (Quantity * "Unit Cost") = 0 then begin
          "Cost Amount" := 0;
        end else begin
          TestField(Type);
          TestField("No.");
          GetSetup;
          "Cost Amount" := Round(Quantity * "Unit Cost",GLSetup."Amount Rounding Precision");
        end;
    end;


    procedure UpdateHours()
    begin
        if Type in [Type::Cost,Type::Resource,Type::Team,Type::Trade] then
          Hours := AMFunction.GetHoursPerTimeUOM(Quantity,"Unit of Measure Code")
        else
          Hours := 0;
    end;

    local procedure GetItem(var Item: Record Item)
    begin
        TestField("No.");
        if Item."No." <> "No." then
          Item.Get("No.");
    end;

    local procedure GetSKU(var SKU: Record "Stockkeeping Unit"): Boolean
    begin
        TestField("No.");
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

    local procedure GetSetup()
    begin
        if SetupRead then
          exit;
        GLSetup.Get;
        AMSetup.Get;
        SetupRead := true;
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(Round(Qty * "Qty. per Unit of Measure",0.00001));
    end;


    procedure ShowItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    var
        DummyItemJnlLine: Record "Item Journal Line" temporary;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
    begin
        if not ((Type = Type::Item) and ("No." <> '')) then
          exit;
        DummyItemJnlLine."Item No." := "No.";
        DummyItemJnlLine."Posting Date" := WorkDate;
        DummyItemJnlLine."Location Code" := "Location Code";
        DummyItemJnlLine."Variant Code" := "Variant Code";
        ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(DummyItemJnlLine,AvailabilityType);
    end;


    procedure GetNextLineNo(MaintProcBudget: Record "MCH Maint. Task Budget Line";BelowxRec: Boolean): Integer
    var
        MaintProcBudget2: Record "MCH Maint. Task Budget Line";
        LoLineNo: Integer;
        HiLineNo: Integer;
        NextLineNo: Integer;
        LineStep: Integer;
    begin
        LoLineNo := 0;
        HiLineNo := 0;
        NextLineNo := 0;
        LineStep := 10000;
        MaintProcBudget2.SetRange("Task Code","Task Code");

        if MaintProcBudget."Line No." = 0 then begin
          if MaintProcBudget2.Find('+') then
            NextLineNo := MaintProcBudget2."Line No." + LineStep
          else
            NextLineNo := LineStep;
        end else begin
          MaintProcBudget2.Get(MaintProcBudget."Task Code",MaintProcBudget."Line No.");
          if BelowxRec then begin
            LoLineNo := MaintProcBudget2."Line No.";
            if MaintProcBudget2.Next = 1 then
              HiLineNo := MaintProcBudget2."Line No."
            else
              NextLineNo := MaintProcBudget."Line No." + LineStep;
          end else begin
            HiLineNo := MaintProcBudget2."Line No.";
            if MaintProcBudget2.Next(-1) = -1 then
              LoLineNo := MaintProcBudget2."Line No.";
          end;
        end;

        if NextLineNo = 0 then begin
          NextLineNo := Round((LoLineNo + HiLineNo) / 2,1,'<');
          if MaintProcBudget2.Get(MaintProcBudget."Task Code",NextLineNo)
          then begin
            if MaintProcBudget2.Find('+') then
              NextLineNo := MaintProcBudget2."Line No." + LineStep
            else
              NextLineNo := LineStep;
          end;
        end;

        exit(NextLineNo);
    end;

    local procedure SetLastModified()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;
}

