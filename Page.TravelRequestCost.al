Page 52092460 "Travel Request Cost"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Travel Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field(DocumentNo;"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(TravelGroup;"Travel Group")
                {
                    ApplicationArea = Basic;
                }
                field(FromDestination;"From Destination")
                {
                    ApplicationArea = Basic;
                }
                field(ToDestination;"To Destination")
                {
                    ApplicationArea = Basic;
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoofNights;"No. of Nights")
                {
                    ApplicationArea = Basic;
                }
            }
            group(CostLines)
            {
                Caption = 'Cost Lines';
                part(Control1000000010;"Travel Request Line Cost")
                {
                    Editable = "Line Editable";
                    SubPageLink = "Document No."=field("Document No."),
                                  "Line No."=field("Line No.");
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000012;"Travel Cost Budget Stats")
            {
                Provider = Control1000000010;
                SubPageLink = "Document No."=field("Document No."),
                              "Line No."=field("Line No."),
                              "Cost Code"=field("Cost Code");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        EnableFields;
    end;

    trigger OnInit()
    begin
        "Line Editable" := true;
    end;

    var
        TravelHeader: Record "Travel Header";
        [InDataSet]
        "Line Editable": Boolean;


    procedure EnableFields()
    begin
        if TravelHeader.Get("Document No.") then
          "Line Editable" := TravelHeader.Status = TravelHeader.Status::Open
        else
          "Line Editable" := true;
    end;
}

