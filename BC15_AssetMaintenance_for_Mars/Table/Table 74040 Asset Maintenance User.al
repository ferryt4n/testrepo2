table 74040 "MCH Asset Maintenance User"
{
    Caption = 'Asset Maintenance User';
    DataCaptionFields = "User ID","Job Description";
    DrillDownPageID = "MCH Asset Maint. User List";
    LookupPageID = "MCH Asset Maint. User Lookup";
    PasteIsValid = false;

    fields
    {
        field(1;"User ID";Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                User: Record User;
            begin
                if "User ID" <> '' then begin
                  User.SetCurrentKey("User Name");
                  User.SetRange("User Name","User ID");
                  if not User.FindFirst then
                    Error(Text000,"User ID")
                  else
                    "User Security ID" := User."User Security ID";
                end;
            end;
        }
        field(2;"User Security ID";Guid)
        {
            Caption = 'User Security ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Security ID";
        }
        field(10;"Change WO Status to Planned";Boolean)
        {
            Caption = 'Allow Change WO Status to Planned';
        }
        field(11;"Change WO Status to Released";Boolean)
        {
            Caption = 'Allow Change WO Status to Released';
        }
        field(12;"Change WO Status to Finished";Boolean)
        {
            Caption = 'Allow Change WO Status to Finished';
        }
        field(13;"Reopen Finished WO to Released";Boolean)
        {
            Caption = 'Allow Reopen Finished WO to Released';
            DataClassification = CustomerContent;
        }
        field(20;"Resource No.";Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(30;"Default Maint. Location Code";Code[20])
        {
            Caption = 'Default Maint. Location Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Maintenance Location";
        }
        field(50;"Allow Cancel Usage Mon. Entry";Boolean)
        {
            Caption = 'Allow Cancel Usage Monitor Entry';
            DataClassification = CustomerContent;
        }
        field(60;"Asset Resp. Group View";Option)
        {
            Caption = 'Asset Resp. Group View';
            DataClassification = CustomerContent;
            OptionMembers = Unrestricted,Limited;

            trigger OnValidate()
            var
                MaintUserAssetRespGrp: Record "MCH Maint. User-Asset Resp.Grp";
            begin
                if ("Asset Resp. Group View" <> xRec."No. of Resp. Groups (Limited)") then begin
                  if ("Asset Resp. Group View" = "Asset Resp. Group View"::Limited) then begin
                    CalcFields("No. of Resp. Groups (Limited)");
                    if ("No. of Resp. Groups (Limited)" = 0) then
                      Error(Text002,
                        FieldCaption("Asset Resp. Group View"),"Asset Resp. Group View",TableCaption,"User ID");
                  end;
                  if ("Asset Resp. Group View" = "Asset Resp. Group View"::Unrestricted) then begin
                    CalcFields("No. of Resp. Groups (Limited)");
                    if ("No. of Resp. Groups (Limited)" > 0) then begin
                      if (CurrFieldNo > 0) then begin
                        if not Confirm(Text003,false,
                          "User ID","No. of Resp. Groups (Limited)",FieldCaption("Asset Resp. Group View"),xRec."Asset Resp. Group View","Asset Resp. Group View")
                        then begin
                          "Asset Resp. Group View" := xRec."Asset Resp. Group View";
                          exit;
                        end;
                      end;
                      Modify(true);
                      MaintUserAssetRespGrp.SetRange("Maint. User ID","User ID");
                      MaintUserAssetRespGrp.DeleteAll;
                    end;
                  end;
                end;
            end;
        }
        field(61;"Default Resp. Group Code";Code[20])
        {
            Caption = 'Default Resp. Group Code';
            TableRelation = IF ("Asset Resp. Group View"=CONST(Unrestricted)) "MCH Asset Responsibility Group"
                            ELSE IF ("Asset Resp. Group View"=CONST(Limited)) "MCH Maint. User-Asset Resp.Grp"."Resp. Group Code" WHERE ("Maint. User ID"=FIELD("User ID"));
        }
        field(62;"No. of Resp. Groups (Limited)";Integer)
        {
            BlankZero = true;
            CalcFormula = Count("MCH Maint. User-Asset Resp.Grp" WHERE ("Maint. User ID"=FIELD("User ID")));
            Caption = 'No. of Resp. Groups (Limited)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"User Full Name";Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE ("User Security ID"=FIELD("User Security ID")));
            Caption = 'User Full Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Job Description";Text[50])
        {
            Caption = 'Job Description';
            DataClassification = CustomerContent;
        }
        field(200;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(201;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(202;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(203;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1;"User ID")
        {
            Clustered = true;
        }
        key(Key2;"User Security ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"User ID","Job Description")
        {
        }
        fieldgroup(Brick;"User ID","Job Description")
        {
        }
    }

    trigger OnDelete()
    var
        AMFunctions: Codeunit "MCH AM Functions";
    begin
        if ("User ID" <> '') then begin
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);
        end;
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;

    var
        Text000: Label 'The user name %1 does not exist.';
        Text001: Label '%1 (%2) cannot be later than %3 (%4).';
        Text002: Label '%1 cannot be %2 because no asset responsibility groups assigned for %3 %4.';
        Text003: Label 'The user %1 is currently setup with limited view of %2 Asset Responsibility Group(s).\\Do you want to continue and change the %3 from %4 to %5 ?';


    procedure GetStyleTxtForRespGroupView() StyleTxt: Text
    begin
        if ("Asset Resp. Group View" = "Asset Resp. Group View"::Limited) then
          exit('StrongAccent');
    end;
}

