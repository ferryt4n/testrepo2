table 74031 "MCH AM Report Selections"
{
    Caption = 'Asset Maint. Report Selections';

    fields
    {
        field(1;Usage;Option)
        {
            Caption = 'Usage';
            OptionCaption = 'Work Order Request,Planned Work Order,Released Work Order,Finished Work Order';
            OptionMembers = "Work Order Request","Planned Work Order","Released Work Order","Finished Work Order";
        }
        field(2;Sequence;Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(3;"Report ID";Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Report));

            trigger OnValidate()
            begin
                CalcFields("Report Caption");
            end;
        }
        field(4;"Report Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Report),
                                                                           "Object ID"=FIELD("Report ID")));
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;Usage,Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AMReportSelection2: Record "MCH AM Report Selections";


    procedure NewRecord()
    begin
        AMReportSelection2.SetRange(Usage,Usage);
        if AMReportSelection2.Find('+') and (AMReportSelection2.Sequence <> '') then
          Sequence := IncStr(AMReportSelection2.Sequence)
        else
          Sequence := '1';
    end;
}

