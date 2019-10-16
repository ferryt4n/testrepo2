page 74105 "MCH Usage Monitor Entries"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Usage Monitor Entries';
    DataCaptionFields = "Asset No.","Monitor Code";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Usage Monitor Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Reading Time";
                ShowCaption = false;
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Monitor Code";"Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Reading Date";"Reading Date")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Reading Time";"Reading Time")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Reading Value";"Reading Value")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Usage Value";"Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reading Type";"Reading Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Registered Date-Time";"Registered Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Registered By";"Registered By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Closing Meter Reading";"Closing Meter Reading")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Cancelled By";"Cancelled By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Cancellation Date-Time";"Cancellation Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Cancellation Reason Code";"Cancellation Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reading Date-Time";"Reading Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Original Reading Value";"Original Reading Value")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CancelEntry)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cancel Entry';
                Ellipsis = true;
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MAUsageEntry: Record "MCH Usage Monitor Entry";
                    AMUserSetup: Record "MCH Asset Maintenance User";
                    ReasonCode: Record "Reason Code";
                    CancelUsageMonitorEntry: Page "MCH Cancel Usage Monitor Entry";
                    UsageJnlRegisterBatch: Codeunit "MCH Usage Jnl.-Reg. Batch";
                    NoOfEntries: Integer;
                    MissingReasonCodeErr: Label 'You must specify a reason code.';
                begin
                    CurrPage.SetSelectionFilter(MAUsageEntry);
                    MAUsageEntry.SetRange(Cancelled,false);
                    if MAUsageEntry.IsEmpty then
                      exit;
                    AMUserSetup.Get(UserId);
                    AMUserSetup.TestField("Allow Cancel Usage Mon. Entry",true);
                    NoOfEntries := MAUsageEntry.Count;

                    CancelUsageMonitorEntry.SetValues(NoOfEntries);
                    if CancelUsageMonitorEntry.RunModal <> ACTION::OK then
                      exit;
                    CancelUsageMonitorEntry.GetValues(ReasonCode.Code);
                    if not ReasonCode.Get(ReasonCode.Code) then
                      Error(MissingReasonCodeErr);
                    UsageJnlRegisterBatch.UsageEntryCancellation(MAUsageEntry,ReasonCode.Code,true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    var
        [InDataSet]
        StyleTxt: Text;

    local procedure SetStyle(): Text
    begin
        if Cancelled then begin
          exit('Unfavorable')
        end else
          if "Closing Meter Reading" then
            exit('StrongAccent');
        exit('');
    end;
}

