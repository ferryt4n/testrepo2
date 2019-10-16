tableextension 74037 "MCH AM Unit of Measure" extends "Unit of Measure"
{
    fields
    {
        field(74030; "MCH Time Unit"; Boolean)
        {
            Caption = 'Time Unit';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not "MCH Time Unit" then begin
                    TestField("MCH Time Unit of Measure", "MCH Time Unit of Measure"::" ");
                    TestField("MCH Units per Time UoM", 0);
                end;
            end;
        }
        field(74031; "MCH Time Unit of Measure"; Option)
        {
            Caption = 'Time Unit of Measure';
            DataClassification = CustomerContent;
            OptionCaption = ' ,100/Hour,Minute,Hour,Day (24 Hours)';
            OptionMembers = " ","100/Hour",Minute,Hour,"Day (24 Hours)";

            trigger OnValidate()
            begin
                if "MCH Units per Time UoM" <> 0 then
                    TestField("MCH Time Unit");
            end;
        }
        field(74032; "MCH Units per Time UoM"; Decimal)
        {
            BlankZero = true;
            Caption = 'Units per Time Unit of Measure';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "MCH Time Unit of Measure" <> "MCH Time Unit of Measure"::" " then
                    TestField("MCH Time Unit");
            end;
        }
    }
}