page 74132 "MCH AM Planning Wksh. Names"
{
    Caption = 'Maintenance Planning Worksheets';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "MCH AM Planning Wksh. Name";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Worksheet Template Name";"Worksheet Template Name")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Template Type";"Template Type")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Wksh. Lines";"No. of Wksh. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
    }

    local procedure DataCaption(): Text[250]
    var
        MaintPlanWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Worksheet Template Name") <> '' then
            if GetRangeMin("Worksheet Template Name") = GetRangeMax("Worksheet Template Name") then
              if MaintPlanWkshTemplate.Get(GetRangeMin("Worksheet Template Name")) then
                exit(MaintPlanWkshTemplate.Name + ' ' + MaintPlanWkshTemplate.Description);
    end;
}

