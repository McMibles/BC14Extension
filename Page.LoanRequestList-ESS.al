Page 52092183 "Loan Request List- ESS"
{
    Caption = 'Loan Request List';
    CardPageID = "Loan Request Card - ESS";
    Editable = false;
    PageType = List;
    Permissions = TableData Customer=rimd;
    SourceTable = "Payroll-Loan";
    SourceTableView = where("Loan Type"=const(Internal));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LoanID;"Loan ID")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(AccountNo;"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevel;"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field(LoanED;"Loan E/D")
                {
                    ApplicationArea = Basic;
                }
                field(DeductionStartingDate;"Deduction Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(OpenYN;"Open(Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(LoanType;"Loan Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(LoanAmount;"Loan Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(MonthlyRepayment;"Monthly Repayment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RemainingAmount;"Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RepaidAmount;"Repaid Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Balance;Balance)
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
            group("<Action1000000000>")
            {
                Caption = 'Request';
                action("<Action1000000001>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send to HR';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SendToHR;
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1000000003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recall from HR';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if "Voucher No." <> '' then
                          Error(Text007);
                        RecallFromHR;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        SetRange("Employee No.",UserSetup."Employee No.");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
        Text007: label 'Voucher already raised';
}

