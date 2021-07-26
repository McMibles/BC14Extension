Page 52092347 "Leave Schedule Line"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Leave Schedule Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo;"Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysScheduled;"No. of Days Scheduled")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysTaken;"No. of Days Taken")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingNoofDays;"Outstanding No. of Days")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                Caption = 'Functions';
                action(CreateLeaveApplication)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Leave Application';

                    trigger OnAction()
                    begin
                        CreateLeaveApplication;
                    end;
                }
                action(RecallApplication)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recall Application';

                    trigger OnAction()
                    begin
                        RecallLeaveApplication;
                    end;
                }
            }
        }
    }
}

