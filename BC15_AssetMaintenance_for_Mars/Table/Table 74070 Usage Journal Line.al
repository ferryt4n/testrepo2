table 74070 "MCH Usage Journal Line"
{
    Caption = 'Usage Journal Line';
    DataCaptionFields = "Journal Batch Name","Line No.";

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "MCH Usage Journal Template";
        }
        field(2;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "MCH Usage Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(3;"Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Line No.';
        }
        field(4;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "MCH Maintenance Asset";

            trigger OnValidate()
            var
                MAUsageMonitor2: Record "MCH Asset Usage Monitor";
            begin
                if ("Asset No." <> xRec."Asset No.") then begin
                  "Monitor Code" := '';
                  if (CurrFieldNo = FieldNo("Asset No.")) and ("Asset No." <> '') then begin
                    MAUsageMonitor2.SetRange("Asset No.","Asset No.");
                    MAUsageMonitor2.SetRange(Blocked,false);
                    if MAUsageMonitor2.Find('-') then
                      if MAUsageMonitor2.Next = 0 then
                        "Monitor Code" := MAUsageMonitor2."Monitor Code";
                  end;
                  Validate("Monitor Code");
                end;
            end;
        }
        field(5;"Monitor Code";Code[20])
        {
            Caption = 'Monitor Code';
            TableRelation = "MCH Asset Usage Monitor"."Monitor Code" WHERE ("Asset No."=FIELD("Asset No."));

            trigger OnValidate()
            begin
                if "Monitor Code" <> '' then begin
                  MAUsageMonitor.Get("Asset No.","Monitor Code");
                  MAUsageMonitor.TestField("Unit of Measure Code");
                  MAUsageMonitor.TestField(Blocked,false);
                  "Identifier Code" := MAUsageMonitor."Identifier Code";
                  if (MAUsageMonitor."Reading Type" <> MAUsageMonitor."Reading Type"::Meter) then
                    "Closing Meter Reading" := false;
                end else begin
                  "Reading Value" := 0;
                  "Closing Meter Reading" := false;
                  "Identifier Code" := '';
                end;
            end;
        }
        field(7;"Reading Date";Date)
        {
            Caption = 'Reading Date';

            trigger OnValidate()
            begin
                UpdateDatetime;
            end;
        }
        field(8;"Reading Time";Time)
        {
            Caption = 'Reading Time';

            trigger OnValidate()
            begin
                Validate("Reading Date");
            end;
        }
        field(9;"Reading Date-Time";DateTime)
        {
            Caption = 'Reading Date-Time';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Reading Date" := DT2Date("Reading Date-Time");
                "Reading Time" := DT2Time("Reading Date-Time");
                Validate("Reading Time");
            end;
        }
        field(10;"Reading Value";Decimal)
        {
            Caption = 'Reading Value';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if ("Reading Value" <> 0) then begin
                  TestField("Asset No.");
                  TestField("Monitor Code");
                end;
            end;
        }
        field(11;"Original Reading Value";Decimal)
        {
            Caption = 'Original Reading Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:5;
        }
        field(15;"Closing Meter Reading";Boolean)
        {
            BlankZero = true;
            Caption = 'Closing Meter Reading';
            DataClassification = CustomerContent;
        }
        field(25;Description;Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(26;"Identifier Code";Code[100])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                MAUsageMonitor2: Record "MCH Asset Usage Monitor";
            begin
                MAUsageMonitor2.SetCurrentKey("Identifier Code");
                MAUsageMonitor2.SetFilter("Identifier Code",'<>%1','');
                MAUsageMonitor2.SetRange(Blocked,false);
                if PAGE.RunModal(0,MAUsageMonitor2) = ACTION::LookupOK then
                  Validate("Identifier Code",MAUsageMonitor2."Identifier Code");
            end;

            trigger OnValidate()
            var
                MAUsageMonitor2: Record "MCH Asset Usage Monitor";
            begin
                if ("Identifier Code" <> '') then begin
                  MAUsageMonitor2.SetCurrentKey("Identifier Code");
                  MAUsageMonitor2.SetRange("Identifier Code","Identifier Code");
                  MAUsageMonitor2.FindFirst;
                  if ("Asset No." <> MAUsageMonitor2."Asset No.") then
                    Validate("Asset No.",MAUsageMonitor2."Asset No.");
                  Validate("Monitor Code",MAUsageMonitor2."Monitor Code");
                end;
            end;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Asset No.","Monitor Code","Reading Date","Reading Time")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UsageJnlTemplate: Record "MCH Usage Journal Template";
        UsageJnlBatch: Record "MCH Usage Journal Batch";
        UsageJnlLine: Record "MCH Usage Journal Line";
        MAUsageMonitor: Record "MCH Asset Usage Monitor";


    procedure SetUpNewLine(LastUsageJnlLine: Record "MCH Usage Journal Line")
    begin
        UsageJnlTemplate.Get("Journal Template Name");
        UsageJnlBatch.Get("Journal Template Name","Journal Batch Name");
        UsageJnlLine.SetRange("Journal Template Name","Journal Template Name");
        UsageJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
        if (not UsageJnlLine.IsEmpty) and (LastUsageJnlLine."Reading Date" <> 0D) then
          "Reading Date" := LastUsageJnlLine."Reading Date"
        else
          "Reading Date" := WorkDate;
        Validate("Reading Date");
    end;


    procedure EmptyLine(): Boolean
    begin
        exit(("Asset No." = '') and ("Reading Value" = 0));
    end;

    local procedure UpdateDatetime()
    begin
        if ("Reading Date" <> 0D) then begin
          "Reading Date-Time" := CreateDateTime("Reading Date","Reading Time");
        end else begin
          "Reading Date-Time" := 0DT;
          Clear("Reading Time");
        end;
    end;


    procedure IsOpenedFromBatch(): Boolean
    var
        JournalBatch: Record "MCH Usage Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GetFilter("Journal Batch Name");
        if BatchFilter <> '' then begin
          TemplateFilter := GetFilter("Journal Template Name");
          if TemplateFilter <> '' then
            JournalBatch.SetFilter("Journal Template Name",TemplateFilter);
          JournalBatch.SetFilter(Name,BatchFilter);
          JournalBatch.FindFirst;
        end;
        exit((("Journal Batch Name" <> '') and ("Journal Template Name" = '')) or (BatchFilter <> ''));
    end;
}

