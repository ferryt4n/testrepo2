table 74056 "MCH Work Instruction Line"
{
    Caption = 'Work Instruction Line';

    fields
    {
        field(1;"Work Instruction No.";Code[20])
        {
            Caption = 'Work Instruction No.';
            TableRelation = "MCH Work Instruction Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(10;Text;Text[80])
        {
            Caption = 'Text';
        }
    }

    keys
    {
        key(Key1;"Work Instruction No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

