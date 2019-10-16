table 74075 "MCH Maintenance Team"
{
    Caption = 'Maintenance Team';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Maintenance Team List";
    LookupPageID = "MCH Maintenance Team List";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(3;"Description 2";Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(10;"Base Unit of Measure";Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "MCH Maint. Unit of Measure"."Unit of Measure Code" WHERE ("Table Name"=CONST(Team),
                                                                                       Code=FIELD(Code));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                MaintUnitOfMeasure: Record "MCH Maint. Unit of Measure";
                UnitOfMeasure: Record "Unit of Measure";
            begin
                if "Base Unit of Measure" <> xRec."Base Unit of Measure" then begin
                  if "Base Unit of Measure" <> '' then begin
                    UnitOfMeasure.Get("Base Unit of Measure");
                    AMFunctions.TestIfUOMTimeBased("Base Unit of Measure",true);

                    if not MaintUnitOfMeasure.Get(MaintUnitOfMeasure."Table Name"::Team,Code,"Base Unit of Measure") then begin
                      MaintUnitOfMeasure.Init;
                      MaintUnitOfMeasure."Table Name" := MaintUnitOfMeasure."Table Name"::Team;
                      if IsTemporary then
                        MaintUnitOfMeasure.Code := Code
                      else
                        MaintUnitOfMeasure.Validate(Code,Code);
                      MaintUnitOfMeasure.Validate("Unit of Measure Code","Base Unit of Measure");
                      MaintUnitOfMeasure."Qty. per Unit of Measure" := 1;
                      MaintUnitOfMeasure.Insert;
                    end else
                      MaintUnitOfMeasure.TestField("Qty. per Unit of Measure",1);
                  end;
                end;
            end;
        }
        field(11;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(15;"Gen. Prod. Posting Group";Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(20;"No. of Team Members";Integer)
        {
            CalcFormula = Count("MCH Maint. Team Member" WHERE ("Maint. Team Code"=FIELD(Code)));
            Caption = 'No. of Team Members';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Direct Unit Cost" := Round("Unit Cost" * (100 / (100 + "Indirect Cost %")));
                if ("Unit Cost" = 0) then
                  "Indirect Cost %" := 0;
            end;
        }
        field(22;"Direct Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                Validate("Indirect Cost %");
            end;
        }
        field(23;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 2:2;

            trigger OnValidate()
            begin
                Validate("Unit Cost",Round("Direct Unit Cost" * (1 + "Indirect Cost %" / 100)));
            end;
        }
        field(60;Comment;Boolean)
        {
            CalcFormula = Exist("MCH AM Comment Line" WHERE ("Table Name"=CONST(Team),
                                                             "No."=FIELD(Code)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        AMaintLedgEntry: Record "MCH Asset Maint. Ledger Entry";
        MaintTaskBudgetLine: Record "MCH Maint. Task Budget Line";
        WorkOrderBudgetLine: Record "MCH Work Order Budget Line";
        MaintCommentLine: Record "MCH AM Comment Line";
        MaintUnitOfMeasure: Record "MCH Maint. Unit of Measure";
        MaintTeamMember: Record "MCH Maint. Team Member";
        CannotDeleteErr: Label '%1 % cannot be deleted because it is referenced by one or more %3 records.';
    begin
        AMaintLedgEntry.SetRange(Type,AMaintLedgEntry.Type::Team);
        AMaintLedgEntry.SetRange("No.",Code);
        Error(CannotDeleteErr,TableCaption,Code,AMaintLedgEntry.TableCaption);

        MaintTaskBudgetLine.SetRange(Type,MaintTaskBudgetLine.Type::Team);
        MaintTaskBudgetLine.SetRange("No.",Code);
        Error(CannotDeleteErr,TableCaption,Code,MaintTaskBudgetLine.TableCaption);

        WorkOrderBudgetLine.SetRange(Type,WorkOrderBudgetLine.Type::Team);
        WorkOrderBudgetLine.SetRange("No.",Code);
        Error(CannotDeleteErr,TableCaption,Code,WorkOrderBudgetLine.TableCaption);

        MaintTeamMember.SetRange("Maint. Team Code",Code);
        MaintTeamMember.DeleteAll(true);
        if Code <> '' then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);

        MaintCommentLine.SetRange("Table Name",MaintCommentLine."Table Name"::Team);
        MaintCommentLine.SetRange("No.",Code);
        MaintCommentLine.DeleteAll;

        MaintUnitOfMeasure.SetRange("Table Name",MaintUnitOfMeasure."Table Name"::Team);
        MaintUnitOfMeasure.SetRange(Code,Code);
        MaintUnitOfMeasure.DeleteAll;
    end;

    var
        AMFunctions: Codeunit "MCH AM Functions";
}

