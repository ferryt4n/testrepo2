table 74080 "MCH AM Difference Buffer"
{
    Caption = 'AM Difference Buffer';
    ObsoleteState = Removed;

    fields
    {
        field(1;"Buffer Type";Option)
        {
            Caption = 'Buffer Type';
            OptionCaption = 'Budget,Actual,Misc.';
            OptionMembers = Budget,Actual,"Misc.";
        }
        field(2;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(3;"Work Order No.";Code[20])
        {
            Caption = 'Work Order No.';
        }
        field(4;"Work Order Line No.";Integer)
        {
            Caption = 'Work Order Line No.';
        }
        field(5;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
        }
        field(6;"Maint. Task Code";Code[20])
        {
            Caption = 'Maint. Task Code';
        }
        field(10;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Spare Part,Cost,Resource,Team,Trade';
            OptionMembers = " ",Item,"Spare Part",Cost,Resource,Team,Trade;
        }
        field(11;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(12;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
            end;
        }
        field(13;"Location Code";Code[10])
        {
            Caption = 'Location Code';
        }
        field(14;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
        }
        field(15;"Work Type Code";Code[10])
        {
            Caption = 'Work Type Code';
        }
        field(20;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(30;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(31;"Total Cost";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
        }
        field(32;Hours;Decimal)
        {
            Caption = 'Hours';
            DecimalPlaces = 2:5;
        }
    }

    keys
    {
        key(Key1;"Buffer Type",Status,"Work Order No.","Work Order Line No.","Asset No.","Maint. Task Code",Type,"No.","Unit of Measure Code","Location Code","Variant Code","Work Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

