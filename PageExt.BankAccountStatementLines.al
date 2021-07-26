PageExtension 52000033 pageextension52000033 extends "Bank Account Statement Lines" 
{
    layout
    {
        addafter(Description)
        {
            field("Unpresented Payment";"Unpresented Payment")
            {
                ApplicationArea = Basic;
            }
            field("Uncredited Payment";"Uncredited Payment")
            {
                ApplicationArea = Basic;
            }
            field("Unpresented Amount";"Unpresented Amount")
            {
                ApplicationArea = Basic;
            }
            field("Uncredited Amount";"Uncredited Amount")
            {
                ApplicationArea = Basic;
            }
            field("Credit in Statement";"Credit in Statement")
            {
                ApplicationArea = Basic;
            }
            field("Debit in Statement";"Debit in Statement")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

