Table 52092291 "Payment Comment Line"
{
    Caption = 'Payment Comment Line';
    DataCaptionFields = "No.";

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Payment Request,Payment Voucher,Cash Advance,Cash Adv. Retirement,Cash Receipt,Archived Payment Request,Posted Payment Voucher,Posted Cash Advance,Posted Retirement,Posted Cash Receipt';
            OptionMembers = "Payment Request","Payment Voucher","Cash Advance","Cash Adv. Retirement","Cash Receipt","Archived Payment Request","Posted Payment Voucher","Posted Cash Advance","Posted Retirement","Posted Cash Receipt";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if ("Table Name" = const("Payment Request")) "Payment Request Header"."No."
            else
            if ("Table Name" = const("Payment Voucher")) "Payment Header"."No." where("Document Type" = const("Payment Voucher"))
            else
            if ("Table Name" = const("Cash Advance")) "Payment Header"."No." where("Document Type" = const("Cash Advance"))
            else
            if ("Table Name" = const("Cash Adv. Retirement")) "Payment Header"."No." where("Document Type" = const(Retirement))
            else
            if ("Table Name" = const("Cash Receipt")) "Cash Receipt Header"."No."
            else
            if ("Table Name" = const("Archived Payment Request")) "Payment Request Header Archive"."No."
            else
            if ("Table Name" = const("Posted Payment Voucher")) "Posted Payment Header"."No." where("Document Type" = const("Payment Voucher"))
            else
            if ("Table Name" = const("Posted Cash Advance")) "Posted Payment Header"."No." where("Document Type" = const("Cash Advance"))
            else
            if ("Table Name" = const("Posted Retirement")) "Posted Payment Header"."No." where("Document Type" = const(Retirement))
            else
            if ("Table Name" = const("Posted Cash Receipt")) "Posted Cash Receipt Header"."No.";
        }
        field(3; "Table Line No."; Integer)
        {
            Caption = 'Table Line No.';
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
        field(8; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(9; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Table Name", "No.", "Table Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetUpNewLine()
    var
        PaymentCommentLine: Record "Payment Comment Line";
    begin
        PaymentCommentLine := Rec;
        PaymentCommentLine.SetRecfilter;
        PaymentCommentLine.SetRange("Line No.");
        PaymentCommentLine.SetRange(Date, WorkDate);
        if not PaymentCommentLine.FindFirst then
            Date := WorkDate;
    end;
}

