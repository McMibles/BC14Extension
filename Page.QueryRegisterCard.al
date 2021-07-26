Page 52092389 "Query Register Card"
{
    PageType = Card;
    SourceTable = "Employee Query Entry";
    SourceTableView = where(Status = const(" "));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(QueryRefNo; "Query Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(DateofQuery; "Date of Query")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(CauseofQueryCode; "Cause of Query Code")
                {
                    ApplicationArea = Basic;
                }
                field(Offence; Offence)
                {
                    ApplicationArea = Basic;
                }
                field(Level; Level)
                {
                    ApplicationArea = Basic;
                }
                field(QueriedBy; "Queried By Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Queried By';
                }
                field(ResponseDueDate; "Response Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(ResponseDeadLine; "Response DeadLine")
                {
                    ApplicationArea = Basic;
                }
                field(Control1; "Queried By")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    HideValue = true;
                    Visible = false;
                }
                field(PreviousQueries; "No. of Queries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Previous Queries';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Query")
            {
                Caption = 'Query';
                action("<Action1000000013>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Comment';
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const(Employee),
                                  "No." = field("Query Ref. No."),
                                  "Table Line No." = const(0);
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("<Action1000000018>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register/Print Query letter';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RegisterQueryAndPrintLetter;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
}

