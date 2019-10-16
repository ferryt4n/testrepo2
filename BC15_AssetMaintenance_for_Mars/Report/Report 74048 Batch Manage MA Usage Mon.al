report 74048 "MCH Batch Manage MA Usage Mon."
{
    Caption = 'Batch Create/Delete Asset Usage Monitors';
    ProcessingOnly = true;

    dataset
    {
        dataitem(MaintAsset;"MCH Maintenance Asset")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.",Blocked,"Posting Group","Category Code","Fixed Maint. Location Code","Responsibility Group Code";

            trigger OnAfterGetRecord()
            begin
                case RunAction of
                  RunAction::"Create New" :
                    begin
                      if not MAUsageMonitor.Get(MaintAsset."No.",UsageMonitor.Code) then begin
                        Clear(MAUsageMonitor);
                        MAUsageMonitor.Validate("Asset No.",MaintAsset."No.");
                        MAUsageMonitor.Validate("Monitor Code",UsageMonitor.Code);
                        MAUsageMonitor.Insert(true);
                        HandledCounter := HandledCounter + 1;
                      end;
                    end;
                  RunAction::"Delete Existing" :
                    begin
                      if MAUsageMonitor.Get(MaintAsset."No.",UsageMonitor.Code) then begin
                        if not MAUsageMonitor.UsageEntriesExist(true) then begin
                          HandledCounter := HandledCounter + 1;
                          MAUsageMonitor.Delete(true);
                        end else
                          SkippedCounter := SkippedCounter + 1;
                      end;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if HandledCounter > 0 then
                  Commit;
                case RunAction of
                  RunAction::"Create New" :
                    Message(CreateMsg,HandledCounter,MAUsageMonitor.TableCaption);
                  RunAction::"Delete Existing" :
                    begin
                      if SkippedCounter = 0 then
                        Message(DeleteMsg,HandledCounter,MAUsageMonitor.TableCaption)
                      else
                        Message(DeleteMsg+SkippedDeleteMsg,HandledCounter,MAUsageMonitor.TableCaption,SkippedCounter);
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Usage Monitor")
                {
                    Caption = 'Usage Monitor';
                    field(UsageMonitorCode;UsageMonitor.Code)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Code';
                        Editable = false;
                    }
                    field(RunAction;RunAction)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionClass = StrSubstNo(ActionText,MAUsageMonitor.TableCaption);
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
              case RunAction of
                RunAction::"Create New" :
                  if Confirm(CreateQst,true,UsageMonitor.Code,MAUsageMonitor.TableCaption,MaintAsset.TableCaption) then
                    exit(true);
                RunAction::"Delete Existing" :
                  if Confirm(DeleteQst,true,UsageMonitor.Code,MAUsageMonitor.TableCaption,MaintAsset.TableCaption) then
                    exit(true);
              end;
              exit(false);
            end else
              exit(true);
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        RunAction := RunAction::" ";
    end;

    trigger OnPreReport()
    begin
        UsageMonitor.Get(UsageMonitor.Code);
        MAUsageMonitor.LockTable;
        if MAUsageMonitor.FindFirst then ;
    end;

    var
        UsageMonitor: Record "MCH Master Usage Monitor";
        CreateQst: Label 'Do you want to Create a new %1 %2 for each %3 within the specified filter?';
        MAUsageMonitor: Record "MCH Asset Usage Monitor";
        HandledCounter: Integer;
        DeleteQst: Label 'Do you really want to Delete any existing %1 %2 for each %3 within the specified filter?';
        CreateMsg: Label '%1 new %2 record(s) created.';
        SkippedCounter: Integer;
        RunAction: Option " ","Create New","Delete Existing";
        DeleteMsg: Label '%1 %2 record(s) deleted.';
        SkippedDeleteMsg: Label '\%3 asset usage monitor(s) could not be deleted because of existing usage entries.';
        ActionText: Label '3,%1 - Action';


    procedure SetUsageMonitor(var UsageMonitor2: Record "MCH Master Usage Monitor")
    begin
        UsageMonitor := UsageMonitor2;
    end;
}

