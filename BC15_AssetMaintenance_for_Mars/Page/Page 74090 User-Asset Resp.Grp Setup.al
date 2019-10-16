page 74090 "MCH User-Asset Resp.Grp Setup"
{
    Caption = 'Maint. User-Asset Responsibility Group Setup';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(RespGroupCodeFilter;AssetRespGroupCodeFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Responsibility Group Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AssetRespGroupList: Page "MCH Asset Resp. Group Lookup";
                    begin
                        AssetRespGroupList.LookupMode := true;
                        if AssetRespGroupList.RunModal = ACTION::LookupOK then
                          Text := AssetRespGroupList.GetSelectionFilter
                        else
                          exit(false);
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        GenerateColumnCaptions(MATRIX_SetWanted::Initial);
                        UpdateMatrixSubpage;
                    end;
                }
                field(ShowColumnName;ShowColumnName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Resp. Group Description';
                    ToolTip = 'Specifies that the names of columns are shown in the matrix window.';

                    trigger OnValidate()
                    begin
                        GenerateColumnCaptions(MATRIX_SetWanted::Same);
                        UpdateMatrixSubpage;
                    end;
                }
            }
            part(MatrixForm;"MCH User-Asset Resp.Grp Matrix")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next;
                begin
                    GenerateColumnCaptions(Step::Previous);
                    UpdateMatrixSubpage;
                end;
            }
            action(PreviousColumn)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous column.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
                begin
                    GenerateColumnCaptions(Step::PreviousColumn);
                    UpdateMatrixSubpage;
                end;
            }
            action(NextColumn)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next column.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
                begin
                    GenerateColumnCaptions(Step::NextColumn);
                    UpdateMatrixSubpage;
                end;
            }
            action(NextSet)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next;
                begin
                    GenerateColumnCaptions(Step::Next);
                    UpdateMatrixSubpage;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        MaintUser: Record "MCH Asset Maintenance User";
    begin
        MaximumNoOfCaptions := ArrayLen(MATRIX_CaptionSet);

        case OnOpenCalledFrom of
          OnOpenCalledFrom::AssetRespGroup:
            begin
              AssetRespGroupCodeFilter := CalledFromAssetRespGrpCode;
              GenerateColumnCaptions(MATRIX_SetWanted::Initial);
              UpdateMatrixSubpage;
              AssetRespGroupCodeFilter := '';
              GenerateColumnCaptions(MATRIX_SetWanted::Same);
              UpdateMatrixSubpage;
            end;
          else begin
            GenerateColumnCaptions(MATRIX_SetWanted::Initial);
            UpdateMatrixSubpage;
          end;
        end;
        Clear(OnOpenCalledFrom);
    end;

    var
        ColumnRecordArray: array [10] of Record "MCH Asset Responsibility Group";
        AssetRespGroupCodeFilter: Text;
        MATRIX_CaptionSet: array [10] of Text[80];
        MATRIX_ColumnSet: Text[80];
        MATRIX_CaptionFieldNo: Integer;
        ShowColumnName: Boolean;
        MaximumNoOfCaptions: Integer;
        PrimaryKeyFirstCaptionInCurrSe: Text;
        MATRIX_CurrSetLength: Integer;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        NoColumnRecordsErr: Label 'No %1 records available.';
        PrimaryKeyFieldNo: Integer;
        ShowColNameFieldNo: Integer;
        OnOpenCalledFrom: Option " ",AssetRespGroup;
        CalledFromAssetRespGrpCode: Code[20];

    local procedure GenerateColumnCaptions(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        ColumnRecord: Record "MCH Asset Responsibility Group";
        RecRef: RecordRef;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        if AssetRespGroupCodeFilter <> '' then
          ColumnRecord.SetFilter(Code,AssetRespGroupCodeFilter);

        RecRef.GetTable(ColumnRecord);
        if RecRef.IsEmpty then
          Error(NoColumnRecordsErr,RecRef.Caption);

        PrimaryKeyFieldNo := ColumnRecord.FieldNo(Code);
        ShowColNameFieldNo := ColumnRecord.FieldNo(Description);
        if ShowColumnName then
          MATRIX_CaptionFieldNo := ShowColNameFieldNo
        else
          MATRIX_CaptionFieldNo := PrimaryKeyFieldNo;

        GenerateMatrixData(
          RecRef,SetWanted,MaximumNoOfCaptions,PrimaryKeyFirstCaptionInCurrSe,
          MATRIX_CaptionSet,MATRIX_ColumnSet,MATRIX_CurrSetLength);

        Clear(ColumnRecordArray);
        ColumnRecord.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
        CurrentMatrixRecordOrdinal := 1;
        repeat
          ColumnRecordArray[CurrentMatrixRecordOrdinal].Copy(ColumnRecord);
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
        until (CurrentMatrixRecordOrdinal = ArrayLen(ColumnRecordArray)) or (ColumnRecord.Next <> 1);
    end;

    local procedure UpdateMatrixSubpage()
    begin
        CurrPage.MatrixForm.PAGE.Load(MATRIX_CaptionSet,ColumnRecordArray,ShowColumnName);
        CurrPage.Update(false);
    end;

    local procedure GenerateMatrixData(var RecRef: RecordRef;SetWanted: Option;MaximumSetLength: Integer;var RecordPosition: Text;var CaptionSet: array [32] of Text[80];var CaptionRange: Text;var CurrSetLength: Integer)
    var
        Steps: Integer;
        Caption: Text;
        MaxCaptionLength: Integer;
        SetOption: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        Text001: Label 'The previous column set could not be found.';
    begin
        Clear(CaptionSet);
        CaptionRange := '';
        CurrSetLength := 0;

        if RecRef.IsEmpty then begin
          RecordPosition := '';
          exit;
        end;

        case SetWanted of
          SetOption::Initial:
            RecRef.FindFirst;
          SetOption::Previous:
            begin
              RecRef.SetPosition(RecordPosition);
              RecRef.Get(RecRef.RecordId);
              Steps := RecRef.Next(-MaximumSetLength);
              if not (Steps in [-MaximumSetLength..0]) then
                Error(Text001);
            end;
          SetOption::Same:
            begin
              RecRef.SetPosition(RecordPosition);
              RecRef.Get(RecRef.RecordId);
            end;
          SetOption::Next:
            begin
              RecRef.SetPosition(RecordPosition);
              RecRef.Get(RecRef.RecordId);
              if not (RecRef.Next(MaximumSetLength) = MaximumSetLength) then begin
                RecRef.SetPosition(RecordPosition);
                RecRef.Get(RecRef.RecordId);
              end;
            end;
          SetOption::PreviousColumn:
            begin
              RecRef.SetPosition(RecordPosition);
              RecRef.Get(RecRef.RecordId);
              Steps := RecRef.Next(-1);
              if not (Steps in [-1,0]) then
                Error(Text001);
            end;
          SetOption::NextColumn:
            begin
              RecRef.SetPosition(RecordPosition);
              RecRef.Get(RecRef.RecordId);
              if not (RecRef.Next(1) = 1) then begin
                RecRef.SetPosition(RecordPosition);
                RecRef.Get(RecRef.RecordId);
              end;
            end;
        end;

        RecordPosition := RecRef.GetPosition;

        repeat
          CurrSetLength := CurrSetLength + 1;

          if (not ShowColumnName) then
            Caption := Format(RecRef.Field(PrimaryKeyFieldNo).Value)
          else begin
            Caption := Format(RecRef.Field(ShowColNameFieldNo).Value);
            if Caption = '' then
              Caption := Format(RecRef.Field(PrimaryKeyFieldNo).Value);
          end;
          MaxCaptionLength := MaxStrLen(CaptionSet[CurrSetLength]);
          if StrLen(Caption) <= MaxCaptionLength then
            CaptionSet[CurrSetLength] := CopyStr(Caption,1,MaxCaptionLength)
          else
            CaptionSet[CurrSetLength] := CopyStr(Caption,1,MaxCaptionLength - 3) + '...';
        until (CurrSetLength = MaximumSetLength) or (RecRef.Next <> 1);

        if CurrSetLength = 1 then
          CaptionRange := CaptionSet[1]
        else
          CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrSetLength];
    end;


    procedure SetCalledFromAssetRespGrpCode(CalledFromAssetRespGrpCode2: Code[20])
    begin
        OnOpenCalledFrom := OnOpenCalledFrom::AssetRespGroup;
        CalledFromAssetRespGrpCode := CalledFromAssetRespGrpCode2;
    end;
}

