Table 52092298 "Payment Request Code"
{
    //DrillDownPageID = "Payment Request Code List";
    //LookupPageID = "Payment Request Code List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            begin
                if "Account Type" <> xRec."Account Type" then
                    "Account No." := '';
            end;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                case "Account Type" of
                    "account type"::"G/L Account":
                        begin
                            GLAcc.Get("Account No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TestField("Direct Posting", true);
                        end;
                    "account type"::Customer:
                        begin
                            Customer.Get("Account No.");
                            Customer.TestField("Customer Posting Group");
                        end;
                    "account type"::Vendor:
                        begin
                            Vendor.Get("Account No.");
                            Vendor.TestField("Vendor Posting Group");
                        end;
                    "account type"::"Bank Account":
                        begin
                            Bank.Get("Account No.");
                            Bank.TestField(Blocked, false);
                        end;
                    "account type"::"Fixed Asset":
                        begin
                            FixedAsset.Get("Account No.");
                            FixedAsset.TestField(Blocked, false);
                            FixedAsset.TestField(Inactive, false);
                            FixedAsset.TestField("Budgeted Asset", false);
                        end;
                    "account type"::"IC Partner":
                        begin
                            ICPartner.Get("Account No.");
                            ICPartner.CheckICPartner;
                        end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PaymentReqLine.SetRange("Request Code", Code);
        if PaymentReqLine.FindFirst then
            Error(Text000, Code);
    end;

    var
        PaymentReqLine: Record "Payment Request Line";
        Text000: label 'You cannot delete %1 because it has been used on one or more payment request lines. ';
        GLAcc: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
}

