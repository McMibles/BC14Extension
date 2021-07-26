Table 52092313 "CashLite Bank Mapping"
{
    // DrillDownPageID = "CashLite Bank List";
    //LookupPageID = "CashLite Bank List";

    fields
    {
        field(1; "Bank Code"; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                BankRec.Get("Bank Code");
                Name := BankRec.Name;
                "Bank Account No." := BankRec."Bank Account No.";
            end;
        }
        field(2; Name; Text[80])
        {
            Caption = 'Name';
        }
        field(3; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(4; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(5; "Last Modified By"; Code[50])
        {
            Editable = false;
        }
        field(6; Blocked; Boolean)
        {
        }
        field(70000; "Bank CBN Code"; Code[20])
        {
            TableRelation = Bank;

            trigger OnValidate()
            begin
                if "Bank CBN Code" <> '' then begin
                    CbnBankCode.Get("Bank CBN Code");
                    "Bank CBN Code Description" := CbnBankCode.Name;
                end;
            end;
        }
        field(70001; CardPAN; Text[30])
        {
        }
        field(70002; CardPINBlock; Text[25])
        {
        }
        field(70003; CardExpiryDay; Code[2])
        {
        }
        field(70004; CardExpiryMonth; Code[2])
        {
        }
        field(70005; CardExpiryYear; Code[4])
        {
        }
        field(70006; CardSequenceNumber; Integer)
        {
        }
        field(70007; CardTerminalId; Code[10])
        {
        }
        field(70008; "CashLite Currency Code"; Code[10])
        {
        }
        field(80000; Submitted; Boolean)
        {
            Editable = false;
        }
        field(80001; "Submission Response Code"; Text[250])
        {
            Editable = false;
        }
        field(80002; "Submitted by"; Code[50])
        {
            Editable = false;
        }
        field(80003; "Date Submitted"; DateTime)
        {
            Editable = false;
        }
        field(80004; "Submission Status Code"; Code[10])
        {
            Editable = false;
        }
        field(80005; "Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(80006; "Nibbs Bank"; Boolean)
        {
        }
        field(80007; "Bank CBN Code Description"; Text[30])
        {
            CalcFormula = lookup(Bank.Name where(Code = field("Bank Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Bank Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
    end;

    var
        BankRec: Record "Bank Account";
        CbnBankCode: Record Bank;
}

