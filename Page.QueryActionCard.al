Page 52092393 "Query Action Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Employee Query Entry";
    SourceTableView = where(Status = const("Awaiting HR Action"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Query';
                Editable = false;
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
                field(ResponseDeadLine; "Response DeadLine")
                {
                    ApplicationArea = Basic;
                }
                field(PreviousQueries; "No. of Queries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Previous Queries';
                }
            }
            group(Response)
            {
                Caption = 'Response';
                Editable = false;
                field(Explanation; Explanation)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    MultiLine = true;
                }
            }
            group("Action")
            {
                Caption = 'Action';
                field(Control1000000024; Action)
                {
                    ApplicationArea = Basic;
                }
                field(EffectiveDateofAction; "Effective Date of Action")
                {
                    ApplicationArea = Basic;
                }
                field(SuspensionDuration; "Suspension Duration")
                {
                    ApplicationArea = Basic;
                }
                field(CauseofInactivityCode; "Cause of Inactivity Code")
                {
                    ApplicationArea = Basic;
                }
                field(GroundsforTermCode; "Grounds for Term. Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000022; Notes)
            {
            }
            systempart(Control1000000023; Links)
            {
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
                    Image = Comment;
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
                action("<Action1000000017>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Action';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ProcessAction;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
}

