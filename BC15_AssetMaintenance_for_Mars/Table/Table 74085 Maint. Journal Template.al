table 74085 "MCH Maint. Journal Template"
{
    Caption = 'Maintenance Journal Template';
    PasteIsValid = false;

    fields
    {
        field(1;Name;Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2;Description;Text[80])
        {
            Caption = 'Description';
        }
        field(5;"Test Report ID";Integer)
        {
            Caption = 'Test Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Report));
        }
        field(6;"Page ID";Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Page));

            trigger OnValidate()
            begin
                if "Page ID" = 0 then
                  Validate(Type);
            end;
        }
        field(7;"Posting Report ID";Integer)
        {
            Caption = 'Posting Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Report));
        }
        field(8;"Force Posting Report";Boolean)
        {
            Caption = 'Force Posting Report';
        }
        field(9;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Inventory,Timesheet';
            OptionMembers = Inventory,Timesheet;

            trigger OnValidate()
            begin
                "Test Report ID" := REPORT::"MCH Maint. Journal - Test";
                "Posting Report ID" := REPORT::"MCH Asset Maintenance Register";
                AMSetup.Get;

                case Type of
                  Type::Inventory:
                    begin
                      "Page ID" :=  PAGE::"MCH Maint. Inventory Journal";
                    end;
                  Type::Timesheet:
                    begin
                      "Page ID" :=  PAGE::"MCH Maint. Timesheet Jnl.";
                    end;
                end;
            end;
        }
        field(11;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(15;"Test Report Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Report),
                                                                           "Object ID"=FIELD("Test Report ID")));
            Caption = 'Test Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Page Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Page),
                                                                           "Object ID"=FIELD("Page ID")));
            Caption = 'Page Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Posting Report Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Report),
                                                                           "Object ID"=FIELD("Posting Report ID")));
            Caption = 'Posting Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                  if "No. Series" = "Posting No. Series" then
                    "Posting No. Series" := '';
                end;
            end;
        }
        field(20;"Posting No. Series";Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                  FieldError("Posting No. Series",StrSubstNo(Text001,"Posting No. Series"));
            end;
        }
    }

    keys
    {
        key(Key1;Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        MaintJnlLine.SetRange("Journal Template Name",Name);
        MaintJnlLine.DeleteAll(true);
        MaintJnlBatch.SetRange("Journal Template Name",Name);
        MaintJnlBatch.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Page ID");
    end;

    var
        Text001: Label 'must not be %1';
        MaintJnlBatch: Record "MCH Maint. Journal Batch";
        MaintJnlLine: Record "MCH Maint. Journal Line";
        AMSetup: Record "MCH Asset Maintenance Setup";
}

