Table 52092292 "Payment Request Header Archive"
{

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
        }
        field(2;"Posting Description";Text[100])
        {
        }
        field(3;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(4;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(5;"Dimension Set ID";Integer)
        {
        }
        field(6;"Document Date";Date)
        {
        }
        field(7;"Document Type";Option)
        {
            OptionCaption = 'Cash Account,Float Account';
            OptionMembers = "Cash Account","Float Account";
        }
        field(11;"Currency Code";Code[10])
        {
            TableRelation = Currency;
        }
        field(12;"Currency Factor";Decimal)
        {
        }
        field(13;"Creation Date";Date)
        {
            Editable = false;
        }
        field(14;"Creation Time";Time)
        {
            Editable = false;
        }
        field(15;"No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(16;"Preferred Pmt. Method";Option)
        {
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";
        }
        field(17;"User ID";Code[50])
        {
            Editable = false;
        }
        field(18;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Voided';
            OptionMembers = Open,Approved,"Pending Approval",Voided;
        }
        field(19;"Voided By";Code[50])
        {
            Editable = false;
        }
        field(20;"Date-Time Voided";DateTime)
        {
            Editable = false;
        }
        field(21;"Last Date Modified";Date)
        {
        }
        field(22;"Last Modified By";Code[50])
        {
        }
        field(23;"System Created";Boolean)
        {
            Editable = false;
        }
        field(24;Beneficiary;Code[20])
        {
            TableRelation = Employee;
        }
        field(25;"Beneficiary Name";Text[100])
        {
            Editable = false;
        }
        field(27;"Preferred  Bank Code";Code[10])
        {
        }
        field(28;"Payee Bank Account No.";Text[30])
        {
        }
        field(29;"Payee Bank Account Name";Text[50])
        {
        }
        field(32;"No. Printed";Integer)
        {
            Editable = false;
        }
        field(33;"Voucher No.";Code[20])
        {
        }
        field(34;"Request Type";Option)
        {
            OptionCaption = ' ,Direct Expense,Cash Advance,Float Reimbursement';
            OptionMembers = " ","Direct Expense","Cash Advance","Float Reimbursement";
        }
        field(100;Amount;Decimal)
        {
            CalcFormula = sum("Payment Request Line Archive".Amount where ("Document Type"=field("Document Type"),
                                                                           "Document No."=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Amount (LCY)";Decimal)
        {
            CalcFormula = sum("Payment Request Line Archive"."Amount (LCY)" where ("Document Type"=field("Document Type"),
                                                                                   "Document No."=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5000;"Retirement Status";Option)
        {
            OptionMembers = Open,Retired;
        }
        field(5001;"Retirement No.";Code[20])
        {
        }
        field(5002;"Payment Date";Date)
        {
        }
        field(5003;"Posted By";Code[50])
        {
        }
        field(5004;"Entry Status";Option)
        {
            OptionCaption = ' ,Posted';
            OptionMembers = " ",Posted;
        }
        field(70000;"Portal ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001;"Mobile User ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70002;"Created from External Portal";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        Text004: label 'Voided payment request cannot be modified.';
        DimMgt: Codeunit DimensionManagement;
        Text006: label 'If you change %1, the existing request lines will be deleted and new request lines based on the new information on the header will be created.\\';
        Text007: label 'Do you want to change %1?';
        Text008: label 'You must delete the existing payment request lines before you can change %1.';
        Text012: label 'Are you sure you want to Void payment request %1?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2',TableCaption,"No."));
    end;


    procedure InsertReqLineFromArchLine(var PaymentReqLine: Record "Payment Request Line")
    var
        PaymentReqLine2: Record "Payment Request Line Archive";
        TempPaymentReqLine: Record "Payment Request Line";
        NextLineNo: Integer;
    begin
        PaymentReqLine2.SetRange("Document Type","Document Type");
        PaymentReqLine2.SetRange("Document No.","No.");

        TempPaymentReqLine := PaymentReqLine;
        if PaymentReqLine.Find('+') then
          NextLineNo := PaymentReqLine."Line No." + 10000
        else
          NextLineNo := 10000;

        if PaymentReqLine2.Find('-') then
          repeat
            PaymentReqLine.TransferFields(PaymentReqLine2);
            PaymentReqLine."Document Type" := TempPaymentReqLine."Document Type" ;
            PaymentReqLine."Document No." := TempPaymentReqLine."Document No.";
            PaymentReqLine."Float Amount" := PaymentReqLine.Amount;
            PaymentReqLine."Line No." := NextLineNo;
            PaymentReqLine.Insert;
            NextLineNo := NextLineNo + 10000 ;
          until PaymentReqLine2.Next = 0 ;

        //PaymentLine2.MODIFYALL("Retirement No.",TempPaymentLine."Document No.");
    end;
}

