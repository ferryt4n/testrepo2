table 74050 "MCH Work Order Progress Status"
{
    Caption = 'Work Order Progress Status';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH WO Progress Status List";
    LookupPageID = "MCH WO Progress Status Lookup";

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
        field(5;"Lookup Sorting Order";Integer)
        {
            BlankZero = true;
            Caption = 'Lookup Sorting Order';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(6;Blocked;Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Code <> '') and Blocked then begin
                  WOProgressStatus.Reset;
                  WOProgressStatus := Rec;
                  WOProgressStatus.SetFilter(
                    "Work Order Status Filter",'%1..%2',"Work Order Status Filter"::Request,"Work Order Status Filter"::Released);
                  WOProgressStatus.CalcFields("In-Use on Work Order");
                  if WOProgressStatus."In-Use on Work Order" then
                    Error(Text003,TableCaption,Code);
                end;
            end;
        }
        field(10;"Allow on WO Request";Boolean)
        {
            BlankZero = true;
            Caption = 'Allow on WO Request';

            trigger OnValidate()
            begin
                if not "Allow on WO Request" then begin
                  TestField("Def. on WO Request",false);
                  CheckDisallowOnWorkOrder(FieldCaption("Allow on WO Request"));
                end;
            end;
        }
        field(11;"Def. on WO Request";Boolean)
        {
            BlankZero = true;
            Caption = 'Def. on WO Request';

            trigger OnValidate()
            begin
                if "Def. on WO Request" then begin
                  TestField("Allow on WO Request",true);
                  CheckNewDefSelection(FieldCaption("Def. on WO Request"));
                end;
            end;
        }
        field(30;"Allow on Planned WO";Boolean)
        {
            BlankZero = true;
            Caption = 'Allow on Planned WO';

            trigger OnValidate()
            begin
                if not "Allow on Planned WO" then begin
                  TestField("Def. on Planned WO",false);
                  CheckDisallowOnWorkOrder(FieldCaption("Allow on Planned WO"));
                end;
            end;
        }
        field(31;"Def. on Planned WO";Boolean)
        {
            BlankZero = true;
            Caption = 'Def. on Planned WO';

            trigger OnValidate()
            begin
                if "Def. on Planned WO" then begin
                  TestField("Allow on Planned WO",true);
                  CheckNewDefSelection(FieldCaption("Def. on Planned WO"));
                end;
            end;
        }
        field(40;"Allow on Released WO";Boolean)
        {
            BlankZero = true;
            Caption = 'Allow on Released WO';

            trigger OnValidate()
            begin
                if not "Allow on Released WO" then begin
                  TestField("Def. on Released WO",false);
                  CheckDisallowOnWorkOrder(FieldCaption("Allow on Released WO"));
                end;
            end;
        }
        field(41;"Def. on Released WO";Boolean)
        {
            BlankZero = true;
            Caption = 'Def. on Released WO';

            trigger OnValidate()
            begin
                if "Def. on Released WO" then begin
                  TestField("Allow on Released WO",true);
                  CheckNewDefSelection(FieldCaption("Def. on Released WO"));
                end;
            end;
        }
        field(60;"Allow on Finished WO";Boolean)
        {
            BlankZero = true;
            Caption = 'Allow on Finished WO';
        }
        field(70;"Block Additional Purchasing";Boolean)
        {
            BlankZero = true;
            Caption = 'Block Additional Purchasing';
        }
        field(71;"Block Purchase Posting";Boolean)
        {
            BlankZero = true;
            Caption = 'Block Purchase Posting';
        }
        field(72;"Block Inventory Issue";Boolean)
        {
            BlankZero = true;
            Caption = 'Block Inventory Issue';
        }
        field(73;"Block Inventory Return";Boolean)
        {
            BlankZero = true;
            Caption = 'Block Inventory Return';
        }
        field(74;"Block Timesheet Entry";Boolean)
        {
            BlankZero = true;
            Caption = 'Block Timesheet Entry';
        }
        field(75;"Block Timesheet Posting";Boolean)
        {
            BlankZero = true;
            Caption = 'Block Timesheet Posting';
        }
        field(100;"Maint. Location Mandatory";Boolean)
        {
            BlankZero = true;
            Caption = 'Maint. Location Mandatory';
            DataClassification = CustomerContent;
        }
        field(101;"Person Responsible Mandatory";Boolean)
        {
            Caption = 'Person Responsible Mandatory';
            DataClassification = CustomerContent;
        }
        field(200;"Work Order Status Filter";Option)
        {
            Caption = 'Work Order Status Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(210;"In-Use on Work Order";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH Work Order Header" WHERE (Status=FIELD("Work Order Status Filter"),
                                                               "Progress Status Code"=FIELD(Code)));
            Caption = 'In-Use on Work Order';
            Editable = false;
            FieldClass = FlowField;
        }
        field(220;"No. of Request Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Request),
                                                               "Progress Status Code"=FIELD(Code)));
            Caption = 'No. of Request Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(221;"No. of Planned Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Planned),
                                                               "Progress Status Code"=FIELD(Code)));
            Caption = 'No. of Planned Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(223;"No. of Released Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Released),
                                                               "Progress Status Code"=FIELD(Code)));
            Caption = 'No. of Released Work Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(224;"No. of Finished Work Orders";Integer)
        {
            CalcFormula = Count("MCH Work Order Header" WHERE (Status=CONST(Finished),
                                                               "Progress Status Code"=FIELD(Code)));
            Caption = 'No. of Finished Work Orders';
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
        key(Key2;"Lookup Sorting Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if (Code <> '') then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);
    end;

    var
        Text001: Label '%1 %2 is already setup as %3.';
        WOProgressStatus: Record "MCH Work Order Progress Status";
        Text002: Label 'You cannot change %1 because %2 work order(s) exist with %3 %4.';
        Text003: Label '%1 %2 cannot be Blocked because it is used on one or more ongoing work orders.';
        AMFunctions: Codeunit "MCH AM Functions";

    local procedure CheckNewDefSelection(ChangedFieldCaption: Text[100])
    begin
        WOProgressStatus.Reset;
        case ChangedFieldCaption of
          FieldCaption("Def. on WO Request"):
            WOProgressStatus.SetRange("Def. on WO Request",true);
          FieldCaption("Def. on Planned WO"):
            WOProgressStatus.SetRange("Def. on Planned WO",true);
          FieldCaption("Def. on Released WO"):
            WOProgressStatus.SetRange("Def. on Released WO",true);
          else
            exit;
        end;
        WOProgressStatus.SetFilter(Code,'<>%1',Code);
        if WOProgressStatus.FindFirst then
          Error(Text001,
            TableCaption,WOProgressStatus.Code,ChangedFieldCaption);
    end;

    local procedure CheckDisallowOnWorkOrder(ChangedFieldCaption: Text[100])
    var
        WorkOrder: Record "MCH Work Order Header";
        NoOfWorkOrders: Integer;
    begin
        CalcFields("No. of Request Work Orders","No. of Planned Work Orders","No. of Released Work Orders");
        case ChangedFieldCaption of
          FieldCaption("Allow on WO Request"):
            NoOfWorkOrders := "No. of Request Work Orders";
          FieldCaption("Allow on Planned WO"):
            NoOfWorkOrders := "No. of Planned Work Orders";
          FieldCaption("Allow on Released WO"):
            NoOfWorkOrders := "No. of Released Work Orders";
          else
            exit;
        end;
        if (NoOfWorkOrders = 0) then
          exit;
        Error(
          Text002,ChangedFieldCaption,NoOfWorkOrders,WorkOrder.FieldCaption("Progress Status Code"),Code);
    end;
}

