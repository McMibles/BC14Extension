Page 52092392 "Query Action List"
{
    CardPageID = "Query Action Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Query Entry";
    SourceTableView = where(Status = const("Awaiting HR Action"));

    layout
    {
        area(content)
        {
            repeater(General)
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
                    Caption = 'Forward to HR';
                    Image = SendTo;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        sendToHR;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
}

