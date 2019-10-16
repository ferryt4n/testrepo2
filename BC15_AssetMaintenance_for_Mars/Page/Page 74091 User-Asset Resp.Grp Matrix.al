page 74091 "MCH User-Asset Resp.Grp Matrix"
{
    Caption = 'Filter Setup Matrix';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "MCH Asset Maintenance User";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "User Full Name";
                ShowCaption = false;
                field("User ID";"User ID")
                {
                    ApplicationArea = Suite;
                    Enabled = false;
                    Lookup = false;
                    ToolTip = 'Specifies the ID for the Asset Maintenance User.';
                    Visible = false;
                }
                field("User Full Name";"User Full Name")
                {
                    ApplicationArea = Suite;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the Job Description for the Maintenance User.';
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
                field("Asset Resp. Group View";"Asset Resp. Group View")
                {
                    ApplicationArea = All;
                    Editable = AssetRespGroupViewEditable;
                    StyleExpr = StyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("No. of Resp. Groups (Limited)";"No. of Resp. Groups (Limited)")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    StyleExpr = StyleTxt;
                }
                field("Default Resp. Group Code";"Default Resp. Group Code")
                {
                    ApplicationArea = All;
                    DrillDown = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Field1;MATRIX_CellData[1])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Visible = Field1Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(1);
                    end;
                }
                field(Field2;MATRIX_CellData[2])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Visible = Field2Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(2);
                    end;
                }
                field(Field3;MATRIX_CellData[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Visible = Field3Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(3);
                    end;
                }
                field(Field4;MATRIX_CellData[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Visible = Field4Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(4);
                    end;
                }
                field(Field5;MATRIX_CellData[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Visible = Field5Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(5);
                    end;
                }
                field(Field6;MATRIX_CellData[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Visible = Field6Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(6);
                    end;
                }
                field(Field7;MATRIX_CellData[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Visible = Field7Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(7);
                    end;
                }
                field(Field8;MATRIX_CellData[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Visible = Field8Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(8);
                    end;
                }
                field(Field9;MATRIX_CellData[9])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    Visible = Field9Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(9);
                    end;
                }
                field(Field10;MATRIX_CellData[10])
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    Visible = Field10Visible;

                    trigger OnValidate()
                    begin
                        UpdateSelection(10);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        AssetRespGroupViewEditable := ("Asset Resp. Group View" = "Asset Resp. Group View"::Limited);
    end;

    trigger OnAfterGetRecord()
    var
        CurrentColumnNo: Integer;
        MATRIX_Steps: Integer;
    begin
        CurrentColumnNo := 0;
        if MATRIX_OnFindRecord('=><') then begin
          CurrentColumnNo := 1;
          repeat
            ColumnNo := CurrentColumnNo;
            MATRIX_OnAfterGetRecord;
            MATRIX_Steps := MATRIX_OnNextRecord(1);
            CurrentColumnNo := CurrentColumnNo + MATRIX_Steps;
          until (CurrentColumnNo - MATRIX_Steps = MaxColumnNo) or (MATRIX_Steps = 0);
          if CurrentColumnNo <> 1 then
            MATRIX_OnNextRecord(1 - CurrentColumnNo);
        end;

        StyleTxt := GetStyleTxtForRespGroupView;
    end;

    trigger OnInit()
    begin
        Field10Visible := true;
        Field9Visible := true;
        Field8Visible := true;
        Field7Visible := true;
        Field6Visible := true;
        Field5Visible := true;
        Field4Visible := true;
        Field3Visible := true;
        Field2Visible := true;
        Field1Visible := true;
    end;

    trigger OnOpenPage()
    begin
        MaxColumnNo := ArrayLen(MatrixRecordArray);
    end;

    var
        MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
        MatrixRecord: Record "MCH Asset Responsibility Group";
        MatrixRecordArray: array [10] of Record "MCH Asset Responsibility Group";
        [InDataSet]
        AssetRespGroupViewEditable: Boolean;
        [InDataSet]
        StyleTxt: Text;
        ColumnNo: Integer;
        MaxColumnNo: Integer;
        MATRIX_CellData: array [10] of Boolean;
        MATRIX_ColumnCaption: array [10] of Text[1024];
        SeeCombinationsQst: Label 'Do you want to see the list of values?';
        Text001: Label 'No limitations,Limited,Blocked';
        [InDataSet]
        Field1Visible: Boolean;
        [InDataSet]
        Field2Visible: Boolean;
        [InDataSet]
        Field3Visible: Boolean;
        [InDataSet]
        Field4Visible: Boolean;
        [InDataSet]
        Field5Visible: Boolean;
        [InDataSet]
        Field6Visible: Boolean;
        [InDataSet]
        Field7Visible: Boolean;
        [InDataSet]
        Field8Visible: Boolean;
        [InDataSet]
        Field9Visible: Boolean;
        [InDataSet]
        Field10Visible: Boolean;


    procedure Load(NewColumnCaption: array [10] of Text[1024];var NewMatrixRecordArray: array [10] of Record "MCH Asset Responsibility Group";DoShowColumnName: Boolean)
    begin
        CopyArray(MATRIX_ColumnCaption,NewColumnCaption,1);
        CopyArray(MatrixRecordArray,NewMatrixRecordArray,1);
    end;

    local procedure UpdateSelection(ColumnID: Integer)
    var
        AssetRespGroup: Record "MCH Asset Responsibility Group";
    begin
        if not AssetRespGroup.Get(MatrixRecordArray[ColumnID].Code) then
          exit;
        with MaintUserAssetRespGrp do begin
          if Get("User ID",AssetRespGroup.Code) then begin
            Delete(true);
          end else begin
            Init;
            Validate("Maint. User ID","User ID");
            Validate("Resp. Group Code",AssetRespGroup.Code);
            Insert(true);
          end;
          Commit;
          CurrPage.Update(false);
        end;
    end;

    local procedure MATRIX_OnAfterGetRecord()
    begin
        MATRIX_CellData[ColumnNo] := MaintUserAssetRespGrp.Get("User ID",MatrixRecordArray[ColumnNo].Code);
        SetVisible;
    end;

    local procedure MATRIX_OnFindRecord(Which: Text[1024]): Boolean
    begin
        exit(MatrixRecord.Find(Which));
    end;

    local procedure MATRIX_OnNextRecord(Steps: Integer): Integer
    begin
        exit(MatrixRecord.Next(Steps));
    end;

    local procedure SetVisible()
    begin
        Field1Visible := MATRIX_ColumnCaption[1] <> '';
        Field2Visible := MATRIX_ColumnCaption[2] <> '';
        Field3Visible := MATRIX_ColumnCaption[3] <> '';
        Field4Visible := MATRIX_ColumnCaption[4] <> '';
        Field5Visible := MATRIX_ColumnCaption[5] <> '';
        Field6Visible := MATRIX_ColumnCaption[6] <> '';
        Field7Visible := MATRIX_ColumnCaption[7] <> '';
        Field8Visible := MATRIX_ColumnCaption[8] <> '';
        Field9Visible := MATRIX_ColumnCaption[9] <> '';
        Field10Visible := MATRIX_ColumnCaption[10] <> '';
    end;
}

