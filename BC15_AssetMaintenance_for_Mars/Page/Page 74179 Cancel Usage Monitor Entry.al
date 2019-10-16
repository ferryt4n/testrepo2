page 74179 "MCH Cancel Usage Monitor Entry"
{
    Caption = 'Cancel - Usage Monitor Entry';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(NoOfEntries;NoOfEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of Entries to Cancel';
                    Editable = false;
                    QuickEntry = false;
                }
                field(ReasonCode;ReasonCode.Code)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cancellation Reason Code';
                    ShowMandatory = true;
                    TableRelation = "Reason Code".Code;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then begin
          if (ReasonCode.Code = '') then
            exit(false)
          else begin
            exit(Confirm(ConfirmMsg,false));
          end;
        end else
          exit(true);
    end;

    var
        ReasonCode: Record "Reason Code";
        NoOfEntries: Integer;
        ConfirmMsg: Label 'Do you want to continue and cancel the selected entries ?';


    procedure SetValues(NoOfEntries2: Integer)
    begin
        NoOfEntries := NoOfEntries2;
    end;


    procedure GetValues(var NewReasonCode: Code[10])
    begin
        NewReasonCode := ReasonCode.Code;
    end;
}

