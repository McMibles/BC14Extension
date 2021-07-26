TableExtension 52000072 tableextension52000072 extends "Finance Cue" 
{
    fields
    {
        field(52092287;"PVs Pending Approval";Integer)
        {
            CalcFormula = count("Payment Header" where ("Document Type"=const("Payment Voucher"),
                                                        Status=const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52092288;"Approved Payment Vouchers";Integer)
        {
            CalcFormula = count("Payment Header" where ("Document Type"=const("Payment Voucher"),
                                                        Status=const(Approved)));
            FieldClass = FlowField;
        }
        field(52092289;"Cash Adv. Pending Approval";Integer)
        {
            CalcFormula = count("Payment Header" where ("Document Type"=const("Cash Advance"),
                                                        Status=const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52092290;"Approved Cash Advances";Integer)
        {
            CalcFormula = count("Payment Header" where ("Document Type"=const("Cash Advance"),
                                                        Status=const(Approved)));
            FieldClass = FlowField;
        }
        field(52092291;"Approved Payment Request";Integer)
        {
            CalcFormula = count("Payment Request Header" where (Status=const(Approved)));
            FieldClass = FlowField;
        }
        field(52092292;"Checks Pending Approval";Integer)
        {
            CalcFormula = count("Cheque File" where (Status=const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52092293;"Payment Req. Pending Approval";Integer)
        {
            CalcFormula = count("Payment Request Header" where (Status=const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52092294;"Cash Adv. Rtm Pending Approval";Integer)
        {
            CalcFormula = count("Payment Header" where ("Document Type"=const(Retirement),
                                                        Status=const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(52092295;"Approved Cash Adv. Retirement";Integer)
        {
            CalcFormula = count("Payment Header" where ("Document Type"=const(Retirement),
                                                        Status=const(Approved)));
            FieldClass = FlowField;
        }
    }
}

