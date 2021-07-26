Table 52092151 "Payroll-Posting Group Line"
{
    // Created           : FTN, 14/3/93
    // File name         : KI03 P.BookGrps Line
    // Comments          : The Header card that is to be used to enter the detail
    //                     lines for booking groups
    // File details      : Primary Key is;
    //                      Booking Group, E/D Code
    //                   : Relations;
    //                      To E/D File
    //                      To Finance Account


    fields
    {
        field(1;"Posting Group";Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Payroll-Posting Group Header";
        }
        field(2;"E/D Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                 EDFileRec.Get( "E/D Code");
                "E/D Description" := UpperCase(EDFileRec.Description);
                if EDFileRec.Posting < 2 then
                  Error('Posting cannot be %1 in the ED setup',EDFileRec.Posting);
            end;
        }
        field(3;"Debit Account No.";Code[20])
        {
            TableRelation = if ("Debit Acc. Type"=const("G/l Account")) "G/L Account"
                            else if ("Debit Acc. Type"=const("Staff Debtor")) Customer
                            else if ("Debit Acc. Type"=const(Creditor)) Vendor;

            trigger OnValidate()
            begin
                if "Debit Account No." = '' then
                  exit;
                //G/l Account,Customer,Supplier
                case "Debit Acc. Type" of
                  0:begin  //G/l
                   FinanceAccRec.Get("Debit Account No.");
                   FinanceAccRec.TestField(Blocked,false);
                   FinanceAccRec.TestField("Direct Posting",true);
                   FinanceAccRec.TestField("Account Type",FinanceAccRec."account type"::Posting);
                  end;
                  1:begin
                    Customer.Get("Debit Account No.");
                    Customer.TestField("Customer Posting Group");
                    Customer.TestField(Blocked,0);
                  end;
                  2:begin
                    Vendor.Get("Debit Account No.");
                    Vendor.TestField(Vendor."Vendor Posting Group");
                    Vendor.TestField(Blocked,0);
                  end;
                end;
            end;
        }
        field(4;"Credit Account No.";Code[20])
        {
            TableRelation = if ("Credit Acc. Type"=const("G/l Account")) "G/L Account"
                            else if ("Credit Acc. Type"=const("Staff Debtor")) Customer
                            else if ("Credit Acc. Type"=const(Creditor)) Vendor;

            trigger OnValidate()
            begin
                if "Credit Account No." = '' then
                  exit;

                //G/l Account,Customer,Supplier
                case "Debit Acc. Type" of
                  0:begin  //G/l
                   FinanceAccRec.Get("Credit Account No.");
                   FinanceAccRec.TestField(Blocked,false);
                   FinanceAccRec.TestField("Direct Posting",true);
                   FinanceAccRec.TestField("Account Type",FinanceAccRec."account type"::Posting);
                  end;
                  1:begin
                    Customer.Get("Credit Account No.");
                    Customer.TestField("Customer Posting Group");
                    Customer.TestField(Blocked,0);
                  end;
                  2:begin
                    Vendor.Get("Credit Account No.");
                    Vendor.TestField(Vendor."Vendor Posting Group");
                    Vendor.TestField(Blocked,0);
                  end;
                end;
            end;
        }
        field(5;"Debit Acc. Type";Option)
        {
            OptionCaption = 'G/l Account,Staff Debtor,Creditor';
            OptionMembers = "G/l Account","Staff Debtor",Creditor;
        }
        field(6;"Credit Acc. Type";Option)
        {
            OptionCaption = 'G/l Account,Staff Debtor,Creditor';
            OptionMembers = "G/l Account","Staff Debtor",Creditor;
        }
        field(7;"Global Dimension 1 Code";Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(8;"Global Dimension 2 Code";Code[10])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(9;"Transfer Global Dim. 1 Code";Boolean)
        {
            CaptionClass = '1,3,1,Transfer ';
            Caption = 'Transfer Global Dim. 1 Code';
            InitValue = true;
        }
        field(10;"Transfer Global Dim. 2 Code";Boolean)
        {
            CaptionClass = '1,3,2,Transfer ';
            Caption = 'Transfer Global Dim. 2 Code';
            InitValue = true;
        }
        field(11;"E/D Description";Text[40])
        {
        }
        field(12;"Transfer Job No.";Boolean)
        {
        }
        field(13;"Staff Advance";Boolean)
        {
        }
        field(14;"Transfer Global Dim. 3 Code";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Posting Group","E/D Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        CheckPostingAccount;
    end;

    var
        EDFileRec: Record "Payroll-E/D";
        FinanceAccRec: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Text000: label '%1 must be specified!\Do you want to continue?';
        Text001: label 'Record Update not saved  ';


    procedure CheckPostingAccount()
    begin
        //Check The ED Posting set up consistencey with the set up
        if "E/D Code" = '' then begin
          TestField("Credit Account No.",'');
          TestField("Debit Account No.",'');
        end;

        EDFileRec.Get("E/D Code");
        // ,None,Debit Only,Credit Only,Both

        case EDFileRec.Posting of
          0,1:begin
            TestField("Debit Account No.",'');
            TestField("Credit Account No.",'');
          end;
          2:begin
            TestField("Debit Account No.");
            TestField("Credit Account No.",'');
          end;
          3:begin
            TestField("Debit Account No.",'');
            if "Credit Acc. Type" <> "credit acc. type"::"Staff Debtor" then
              TestField("Credit Account No.");
          end;
          4:begin
            if "Debit Account No." = '' then
              if not Confirm(Text000,false,FieldCaption("Debit Account No.")) then
                Error(Text001);
            if "Credit Account No." = '' then
              if not Confirm(Text000,false,FieldCaption("Credit Account No.")) then
                Error(Text001);
          end;
        end;
    end;
}

