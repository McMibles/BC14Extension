TableExtension 52000064 tableextension52000064 extends "Employee Ledger Entry" 
{
    fields
    {
        field(52092287;"Cash Advance Doc. No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092288;"Entry Type";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Cash Advance,Cash Adv. Payment,Retirement,Retirement Payment,Retirement Receipt';
            OptionMembers = " ","Cash Advance","Cash Adv. Payment",Retirement,"Retirement Payment","Retirement Receipt";
        }
        field(52092289;"Payment Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Payment Currency Code"=filter('')) "Bank Account"
                            else if ("Payment Currency Code"=filter(<>'')) "Bank Account" where ("Currency Code"=field("Payment Currency Code"));
        }
        field(52092290;"Payment Method";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";
        }
        field(52092291;"Payment Currency Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(52092292;"Amount to Pay";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092293;"Mark to Pay";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 6)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Employee No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Type" := GenJnlLine."Document Type";
        #4..15
        "Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";
        "No. Series" := GenJnlLine."Posting No. Series";
        "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        "Applies-to ID" := GenJnlLine."Applies-to ID";

        OnAfterCopyEmployeeLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..18

        OnAfterCopyEmployeeLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
        */
    //end;
}

