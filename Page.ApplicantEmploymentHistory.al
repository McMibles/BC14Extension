Page 52092366 "Applicant Employment History"
{
    PageType = List;
    SourceTable = "Employment History";
    SourceTableView = where("Record Type"=const(Applicant));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(PositionHeld;"Position Held")
                {
                    ApplicationArea = Basic;
                }
                field(InstitutionCompany;"Institution/Company")
                {
                    ApplicationArea = Basic;
                }
                field(FromDate;"From Date")
                {
                    ApplicationArea = Basic;
                }
                field(ToDate;"To Date")
                {
                    ApplicationArea = Basic;
                }
                field(Remark;Remark)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Record Type" := "record type"::Applicant;
    end;
}

