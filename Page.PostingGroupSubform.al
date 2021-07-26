Page 52092168 "Posting Group Subform"
{
    PageType = ListPart;
    SourceTable = "Payroll-Posting Group Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(PostingGroup;"Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'E/D Description';
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(DebitAccType;"Debit Acc. Type")
                {
                    ApplicationArea = Basic;
                }
                field(DebitAccountNo;"Debit Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(CreditAccType;"Credit Acc. Type")
                {
                    ApplicationArea = Basic;
                }
                field(CreditAccountNo;"Credit Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(TransferGlobalDim3Code;"Transfer Global Dim. 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransferJobNo;"Transfer Job No.")
                {
                    ApplicationArea = Basic;
                }
                field(TransferGlobalDim1Code;"Transfer Global Dim. 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransferGlobalDim2Code;"Transfer Global Dim. 2 Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        PayrollEDCodes.SetRange(PayrollEDCodes."E/D Code","E/D Code");
        if not PayrollEDCodes.Find('-') then
          Description := ''
        else
          Description := PayrollEDCodes.Description;
    end;

    var
        PayrollEDCodes: Record "Payroll-E/D";
        Description: Text[40];
}

