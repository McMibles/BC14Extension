Table 52092290 "Payment Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Payment Voucher,Cash Advance,Retirement';
            OptionMembers = "Payment Voucher","Cash Advance",Retirement;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(6; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                GLSetup.Get;
                if CurrFieldNo = FieldNo("Account Type") then begin
                    TestStatusOpen;
                    if "Document Type" <> "document type"::Retirement then begin
                        if ("Account Type" <> xRec."Account Type") and ("Request No." <> '') then
                            Error(Text023, FieldCaption("Account Type"));
                    end;
                end;
                GetPaymentHeader;
                CheckAccountTypeWithPaymentType;
                if CurrFieldNo = FieldNo("Account Type") then
                    Validate("Account No.", '');

                if (CurrFieldNo <> 0) then
                    TestField("Loan ID", '');

                if (not ("Account Type" in ["account type"::"G/L Account"]))
                  then begin
                    Validate("Gen. Posting Type", "gen. posting type"::" ");
                    Validate("Gen. Bus. Posting Group", '');
                    Validate("Gen. Prod. Posting Group", '');
                end;
                case PaymentHeader."Payment Type" of
                    PaymentHeader."payment type"::"Supp. Invoice":
                        Validate("Account No.", PaymentHeader."Payee No.");
                end;
            end;
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No." where("Direct Posting" = const(true))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const(Employee)) Employee;

            trigger OnValidate()
            begin
                GetPaymentHeader;

                if CurrFieldNo = FieldNo("Account No.") then begin
                    TestStatusOpen;

                    if "Account No." <> xRec."Account No." then
                        TestField("Applies-to ID", '');

                    if not (PaymentHeader."Payment Type" in [3, 5]) then begin
                        if ("Account No." <> xRec."Account No.") and ("Request No." <> '') then
                            Error(Text023, FieldCaption("Account No."));
                    end;
                    CheckAccountTypeWithPaymentType;
                    if PaymentHeader."Payment Type" in [0, 1, 2] then
                        PaymentHeader.TestField("Payee No.");
                end;

                "Currency Code" := PaymentHeader."Currency Code";

                if "Account No." = '' then begin
                    if CurrFieldNo = FieldNo("Account No.") then
                        Init;
                    exit;
                end;

                if (CurrFieldNo <> 0) then
                    TestField("Loan ID", '');
                "IC Partner Code" := '';
                GLSetup.Get;

                if xRec."Account No." <> '' then
                    ClearPostingGroups;

                case "Account Type" of
                    "account type"::"G/L Account":
                        begin
                            GLAcc.Get("Account No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TestField("Direct Posting", true);
                            "Account Name" := GLAcc.Name;
                            "Gen. Posting Type" := GLAcc."Gen. Posting Type";
                            "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                            Validate("VAT Prod. Posting Group", GLAcc."VAT Prod. Posting Group");
                        end;
                    "account type"::Customer:
                        begin
                            Customer.Get("Account No.");
                            "Account Name" := Customer.Name;
                            if PaymentHeader."Payee No." <> '' then
                                TestField("Account No.", PaymentHeader."Payee No.");
                            Customer.TestField("Customer Posting Group");
                            if (Customer."IC Partner Code" <> '') and (ICPartner.Get(Customer."IC Partner Code")) then begin
                                ICPartner.CheckICPartnerIndirect(Format("Account Type"), "Account No.");
                                "IC Partner Code" := Customer."IC Partner Code";
                            end;
                            ClearPostingGroups;
                        end;
                    "account type"::Vendor:
                        begin
                            Vendor.Get("Account No.");
                            if Vendor.Blocked = Vendor.Blocked::Payment then
                                Error(Text000, Vendor."No.");
                            if PaymentHeader."Payee No." <> '' then
                                TestField("Account No.", PaymentHeader."Payee No.");
                            Vendor.TestField("Vendor Posting Group");
                            "Account Name" := Vendor.Name;
                            if (Vendor."IC Partner Code" <> '') and (ICPartner.Get(Vendor."IC Partner Code")) then begin
                                ICPartner.CheckICPartnerIndirect(Format("Account Type"), "Account No.");
                                "IC Partner Code" := Vendor."IC Partner Code";
                            end;
                            ClearPostingGroups;
                        end;
                    "account type"::Employee:
                        begin
                            Employee.Get("Account No.");
                            if PaymentHeader."Payee No." <> '' then
                                TestField("Account No.", PaymentHeader."Payee No.");
                            Employee.TestField("Employee Posting Group");
                            "Account Name" := Employee.FullName;
                            ClearPostingGroups;
                        end;
                    "account type"::"Bank Account":
                        begin
                            Bank.Get("Account No.");
                            Bank.TestField(Blocked, false);
                            "Account Name" := Bank.Name;
                            ClearPostingGroups;
                        end;
                    "account type"::"Fixed Asset":
                        begin
                            FixedAsset.Get("Account No.");
                            FixedAsset.TestField(Blocked, false);
                            FixedAsset.TestField(Inactive, false);
                            FixedAsset.TestField("Budgeted Asset", false);
                            "Account Name" := FixedAsset.Description;
                            GetFAPostingGroup;
                            ClearPostingGroups;
                        end;
                    "account type"::"IC Partner":
                        begin
                            ICPartner.Get("Account No.");
                            ICPartner.CheckICPartner;
                            "Account Name" := ICPartner.Name;
                            "IC Partner Code" := "Account No.";
                            ClearPostingGroups;
                        end;
                end;
                Validate("Currency Code");
                Validate("VAT Prod. Posting Group");
                Validate("WHT Posting Group");
                CreateDim(DimMgt.TypeToTableID1("Account Type"), "Account No.",
                          Database::Job, "Job No.");
            end;
        }
        field(8; Description; Text[100])
        {
        }
        field(9; "Currency Code"; Code[10])
        {
        }
        field(10; "Payment Type"; Option)
        {
            OptionCaption = 'Supp. Invoice,Cust. Refund,Cash Advance,Retirement,Others,Float Reimbursement,Salary';
            OptionMembers = "Supp. Invoice","Cust. Refund","Cash Advance",Retirement,Others,"Float Reimbursement",Salary;
        }
        field(11; "Source Code"; Code[20])
        {
        }
        field(12; "Loan ID"; Code[20])
        {
        }
        field(14; "IC Partner Code"; Code[20])
        {
            TableRelation = "IC Partner";
        }
        field(15; "IC Partner G/L Acc. No."; Code[20])
        {
            TableRelation = "IC G/L Account";

            trigger OnValidate()
            begin
                if "IC Partner G/L Acc. No." <> '' then begin
                    if ICGLAccount.Get("IC Partner G/L Acc. No.") then
                        ICGLAccount.TestField(Blocked, false);
                    if "Account Type" = "account type"::"IC Partner" then
                        Error(Text006, FieldCaption("IC Partner G/L Acc. No."));
                end
            end;
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(18; "Dimension Set ID"; Integer)
        {

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(19; "Job No."; Code[20])
        {
            TableRelation = Job;

            trigger OnValidate()
            begin
                if "Job No." <> xRec."Job No." then begin
                    Validate("Job Task No.", '');
                    Validate("Job Planning Line No.", 0);
                end;
                if "Job No." = '' then begin
                    CreateDim(DimMgt.TypeToTableID1("Account Type"), "Account No.",
                      Database::Job, "Job No.");
                    exit;
                end;
                if not ("Account Type" in ["account type"::"G/L Account"]) then
                    FieldError("Job No.", StrSubstNo(Text012, FieldCaption("Account Type"), "Account Type"));

                Job.Get("Job No.");
                Job.TestBlocked;
                "Job Currency Code" := Job."Currency Code";
                CreateDim(DimMgt.TypeToTableID1("Account Type"), "Account No.",
                    Database::Job, "Job No.");
            end;
        }
        field(20; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));

            trigger OnValidate()
            begin
                if "Job Task No." <> xRec."Job Task No." then
                    Validate("Job Planning Line No.", 0);

                if "Job Task No." = '' then begin
                    Clear(TempJobJnlLine);
                    "Job Line Type" := "job line type"::" ";
                    //UpdateJobPrices;
                    CreateDim(DimMgt.TypeToTableID1("Account Type"), "Account No.",
                      Database::Job, "Job No.");
                    exit;
                end;
                JobSetCurrencyFactor;
            end;
        }
        field(21; "Maintenance Code"; Code[20])
        {
            TableRelation = Maintenance;

            trigger OnValidate()
            begin
                if "Maintenance Code" <> '' then
                    TestField("FA Posting Type", "fa posting type"::Maintenance);
            end;
        }
        field(22; "FA Posting Type"; Option)
        {
            OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;

            trigger OnValidate()
            begin
                if "FA Posting Type" <> "fa posting type"::Maintenance then
                    TestField("Maintenance Code", '');
            end;
        }
        field(23; "Payment Req. Line No."; Integer)
        {
        }
        field(24; "Consignment PO No."; Code[20])
        {
            TableRelation = "Consignment Line"."PO No." where("Consignment Code" = field("Consignment Code"));

            trigger OnValidate()
            begin
                TestField("Account Type", "account type"::"G/L Account");
            end;
        }
        field(25; "Consignment Code"; Code[20])
        {
            TableRelation = "Consignment Header";

            trigger OnValidate()
            var
                Consignment: Record "Consignment Header";
                ConsignmentLine: Record "Consignment Line";
            begin
                if "Consignment Code" <> '' then begin
                    TestField("Account Type", "account type"::"G/L Account");
                    Consignment.Get("Consignment Code");
                    Consignment.TestField(Open, true);
                    if "Consignment PO No." <> '' then begin
                        ConsignmentLine.Get("Consignment Code", "Consignment PO No.");
                        ConsignmentLine.TestField("GIT Account");
                        if (CurrFieldNo = FieldNo("Consignment Code")) and ("Account No." = '') then begin
                            Validate("Account Type", "account type"::"G/L Account");
                            Validate("Account No.", ConsignmentLine."GIT Account");
                        end;
                    end else begin
                        Consignment.TestField("GIT Account");
                        if (CurrFieldNo = FieldNo("Consignment Code")) and ("Account No." = '') then begin
                            Validate("Account Type", "account type"::"G/L Account");
                            Validate("Account No.", Consignment."GIT Account");
                        end;
                    end;
                end else begin
                    "Consignment Charge Code" := '';
                    "Consignment PO No." := '';
                end;
            end;
        }
        field(26; "Consignment Charge Code"; Code[20])
        {
            // TableRelation = "Consignment Charge";

            // trigger OnValidate()
            // begin
            //     TestField("Account Type", "account type"::"G/L Account");
            //     if "Consignment Charge Code" <> '' then
            //         TestField("Consignment Code");
            // end;
        }
        field(27; "Depreciation Book Code"; Code[10])
        {
        }
        field(28; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(30; "Request Code"; Code[20])
        {
            TableRelation = "Payment Request Code";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Request Code" <> xRec."Request Code") and ("Request Code" <> '') then begin
                    PaymentReqCode.Get("Request Code");
                    Validate("Account Type", PaymentReqCode."Account Type");
                    Validate("Account No.", PaymentReqCode."Account No.");
                end;
                if "Request Code" = '' then
                    "Account No." := '';
            end;
        }
        field(40; "Check Entry No."; Integer)
        {
        }
        field(43; "VAT %"; Decimal)
        {
        }
        field(44; "Gen. Posting Type"; Option)
        {
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(45; "VAT Bus. Posting Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("VAT Bus. Posting Group", '');

                Validate("VAT Prod. Posting Group");
            end;
        }
        field(46; "VAT Prod. Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("VAT Prod. Posting Group", '');
                "VAT %" := 0;
                "Vat Calculation Type" := "vat calculation type"::"Normal VAT";
                if "Gen. Posting Type" <> 0 then begin
                    if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                        VATPostingSetup.Init;
                    "Vat Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    case "Vat Calculation Type" of
                        "vat calculation type"::"Normal VAT":
                            "VAT %" := VATPostingSetup."VAT %";
                        "vat calculation type"::"Full VAT":
                            case "Gen. Posting Type" of
                                "gen. posting type"::Sale:
                                    begin
                                        VATPostingSetup.TestField("Sales VAT Account");
                                        TestField("Account No.", VATPostingSetup."Sales VAT Account");
                                    end;
                                "gen. posting type"::Purchase:
                                    begin
                                        VATPostingSetup.TestField("Purchase VAT Account");
                                        TestField("Account No.", VATPostingSetup."Purchase VAT Account");
                                    end;
                            end;
                    end;
                end;
                Validate("VAT %");
            end;
        }
        field(47; "Full VAT"; Boolean)
        {
        }
        field(48; "Vat Calculation Type"; Option)
        {
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(49; "Gen. Bus. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Gen. Prod. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(97; "Interest Amount"; Decimal)
        {
        }
        field(98; "Interest Amount (LCY)"; Decimal)
        {
        }
        field(99; "Request Amount"; Decimal)
        {
            Editable = false;
        }
        field(100; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then begin
                    TestStatusOpen;
                    CalcFields("Schedule Amount");
                    if ("Schedule Amount" <> Amount) and ("Schedule Amount" <> 0) then
                        Error(Text025);
                end;

                if "Document Type" = "document type"::Retirement then
                    TestField("Attached Doc. No.")
                else begin
                    if (Amount <> xRec.Amount) and ("Request No." <> '') then
                        Error(Text023, FieldCaption(Amount));
                end;

                GetPaymentHeader;
                "Currency Code" := PaymentHeader."Currency Code";

                if "Currency Code" = '' then
                    "Amount (LCY)" := Amount
                else
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        PaymentHeader."Document Date", "Currency Code",
                        Amount, PaymentHeader."Currency Factor"));

                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
            end;
        }
        field(101; "Amount (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                GetPaymentHeader;
                if CurrFieldNo = FieldNo("Amount (LCY)") then
                    if PaymentHeader."Currency Code" = '' then begin
                        Amount := "Amount (LCY)";
                    end else begin
                        Currency.Get(PaymentHeader."Currency Code");
                        Amount := ROUND(
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            PaymentHeader."Document Date", "Currency Code",
                            "Amount (LCY)", PaymentHeader."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        if "Amount (LCY)" <> 0 then
                            PaymentHeader."Currency Factor" := Amount / "Amount (LCY)";
                    end;
            end;
        }
        field(102; "WHT Posting Group"; Code[10])
        {
            TableRelation = "WHT Posting Group";

            trigger OnValidate()
            begin
                if "WHT Line" then
                    exit;

                if CurrFieldNo <> 0 then
                    TestStatusOpen;
                if "Account Type" in ["account type"::"Bank Account"] then
                    TestField("WHT Posting Group", '');

                "WHT%" := 0;
                if "WHT Posting Type" <> 0 then begin
                    if not WHTPostingGrp.Get("WHT Posting Group") then
                        WHTPostingGrp.Init;
                    "WHT Calculation Type" := WHTPostingGrp."WHT Calculation Type";
                    case "WHT Calculation Type" of
                        "wht calculation type"::"Normal WHT":
                            "WHT%" := WHTPostingGrp."WithHolding Tax %";
                        "wht calculation type"::"Full WHT":
                            case "WHT Posting Type" of
                                "wht posting type"::Sale:
                                    begin
                                        WHTPostingGrp.TestField(WHTPostingGrp."Sales WHT Tax Account");
                                        TestField("Account No.", WHTPostingGrp."Sales WHT Tax Account");
                                    end;
                                "gen. posting type"::Purchase:
                                    begin
                                        WHTPostingGrp.TestField(WHTPostingGrp."Purchase WHT Tax Account");
                                        TestField("Account No.", WHTPostingGrp."Purchase WHT Tax Account");
                                    end;
                            end;
                    end;
                end;
                Validate("WHT%");
            end;
        }
        field(103; "WHT%"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                GetPaymentHeader;
                if CurrFieldNo <> 0 then
                    TestStatusOpen;

                "WHT Amount" := ROUND(Amount * ("WHT%" / 100), Currency."Amount Rounding Precision");
                if PaymentHeader."Payment Date" <> 0D then
                    CurrencyDate := PaymentHeader."Payment Date"
                else
                    CurrencyDate := WorkDate;

                if "Currency Code" = '' then
                    "WHT Amount (LCY)" := "WHT Amount"
                else
                    "WHT Amount (LCY)" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          CurrencyDate, PaymentHeader."Currency Code",
                          "WHT Amount", PaymentHeader."Currency Factor"));
            end;
        }
        field(104; "WHT Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                GetPaymentHeader;

                if CurrFieldNo <> 0 then
                    TestStatusOpen;

                if PaymentHeader."Payment Date" <> 0D then
                    CurrencyDate := PaymentHeader."Payment Date"
                else
                    CurrencyDate := WorkDate;

                if "Currency Code" = '' then
                    "WHT Amount (LCY)" := "WHT Amount"
                else
                    "WHT Amount (LCY)" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          CurrencyDate, PaymentHeader."Currency Code",
                          "WHT Amount", PaymentHeader."Currency Factor"));
            end;
        }
        field(105; "WHT Amount (LCY)"; Decimal)
        {
        }
        field(106; "Applies-to Doc. Type"; Option)
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnValidate()
            begin
                if "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" then
                    Validate("Applies-to Doc. No.", '');
            end;
        }
        field(107; "Applies-to Doc. No."; Code[20])
        {

            trigger OnLookup()
            var
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
                AccNo: Code[20];
            begin
                GetAccTypeAndNo(AccType, AccNo);
                Clear(CustLedgEntry);
                Clear(VendLedgEntry);
                Clear(EmpLedgEntry);
                case AccType of
                    Acctype::Customer:
                        LookUpAppliesToDocCust(AccNo);
                    Acctype::Vendor:
                        LookUpAppliesToDocVend(AccNo);
                    Acctype::Employee:
                        LookUpAppliesToDocEmp(AccNo);
                end;
            end;

            trigger OnValidate()
            begin
                if "Applies-to Doc. No." <> '' then
                    TestField("Applies-to ID", '');
                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') then begin
                    TestField("Applies-to ID", '');
                    if PostedCashAdvance.Get(1, xRec."Applies-to Doc. No.") then begin
                        PostedCashAdvance."Voucher No." := '';
                        PostedCashAdvance.Modify;
                    end;
                end;
            end;
        }
        field(108; "Applies-to ID"; Code[20])
        {

            trigger OnValidate()
            begin
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    ClearCustVendEmpApplnEntry;
                    UndoPVAttachtoCashAdv("Document No.");
                end;
            end;
        }
        field(109; "Vendor Entry No."; Integer)
        {
        }
        field(110; "Source PO No."; Code[20])
        {
        }
        field(111; "Applied to Entry No."; Integer)
        {
        }
        field(112; "Cash Advance Amount"; Decimal)
        {
            Editable = false;
        }
        field(113; "Cash Advance Amount (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(114; "Attached Doc. No."; Code[20])
        {
            TableRelation = "Posted Payment Header"."No." where("Document Type" = const("Cash Advance"),
                                                                 "Entry Status" = const(Posted),
                                                                 "Retirement Status" = const(Open));

            trigger OnValidate()
            begin
                if xRec."Attached Doc. No." = "Attached Doc. No." then
                    exit;
                if (xRec."Attached Doc. No." <> '') and (xRec."Attached Doc. No." <> "Attached Doc. No.") then
                    if "Cash Advance Amount" <> 0 then
                        Error(Text010);
                if "Attached Doc. No." <> '' then begin
                    PostedCashAdvance.Get("document type"::"Cash Advance", "Attached Doc. No.");
                    if PostedCashAdvance."Retirement No." <> "Document No." then
                        Error(Text011)
                end;
            end;
        }
        field(115; "Attached Line No."; Integer)
        {
        }
        field(116; "WHT Posting Type"; Option)
        {
            Caption = 'WHT Posting Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;

            trigger OnValidate()
            begin
                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("WHT Posting Type", "wht posting type"::" ");
                if ("WHT Posting Type" = "wht posting type"::Settlement) and (CurrFieldNo <> 0) then
                    Error(Text020, "WHT Posting Type");
            end;
        }
        field(117; "WHT Calculation Type"; Option)
        {
            Caption = 'WHT Calculation Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Normal WHT,Full WHT';
            OptionMembers = "Normal WHT","Full WHT";
        }
        field(118; "WHT Base Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                GetPaymentHeader;

                if CurrFieldNo <> 0 then
                    TestStatusOpen;

                if PaymentHeader."Payment Date" <> 0D then
                    CurrencyDate := PaymentHeader."Payment Date"
                else
                    CurrencyDate := WorkDate;

                if "Currency Code" = '' then
                    "WHT Base Amount (LCY)" := "WHT Base Amount"
                else
                    "WHT Base Amount (LCY)" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          CurrencyDate, PaymentHeader."Currency Code",
                          "WHT Base Amount", PaymentHeader."Currency Factor"));
            end;
        }
        field(119; "WHT Base Amount (LCY)"; Decimal)
        {
        }
        field(1002; "Job Line Type"; Option)
        {
            AccessByPermission = TableData Job = R;
            Caption = 'Job Line Type';
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF "Job Planning Line No." <> 0 THEN
                  ERROR(Text048,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));*/

            end;
        }
        field(1003; "Job Unit Price"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Job Unit Price';

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Unit Price","Job Unit Price");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1004; "Job Total Price"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Job Total Price';
            Editable = false;
        }
        field(1005; "Job Line Amount"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Amount';

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Amount","Job Line Amount");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1006; "Job Line Discount Amount"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Discount Amount';

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Discount Amount","Job Line Discount Amount");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1007; "Job Line Discount %"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Job Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Discount %","Job Line Discount %");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1008; "Job Unit Price (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Job Unit Price (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Unit Price (LCY)","Job Unit Price (LCY)");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1009; "Job Total Price (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Job Total Price (LCY)';
            Editable = false;
        }
        field(1010; "Job Line Amount (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Amount (LCY)","Job Line Amount (LCY)");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1011; "Job Line Disc. Amount (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Disc. Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                /*TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Discount Amount (LCY)","Job Line Disc. Amount (LCY)");
                  UpdateJobPrices;
                END;*/

            end;
        }
        field(1012; "Job Currency Factor"; Decimal)
        {
            BlankZero = true;
            Caption = 'Job Currency Factor';
        }
        field(1013; "Job Currency Code"; Code[20])
        {
            Caption = 'Job Currency Code';
        }
        field(1019; "Job Planning Line No."; Integer)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Job Planning Line No.';

            trigger OnLookup()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                /*JobPlanningLine.SETRANGE("Job No.","Job No.");
                JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                CASE Type OF
                  Type::"G/L Account":
                    JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::"G/L Account");
                  Type::Item:
                    JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
                END;
                JobPlanningLine.SETRANGE("No.","No.");
                JobPlanningLine.SETRANGE("Usage Link",TRUE);
                JobPlanningLine.SETRANGE("System-Created Entry",FALSE);
                
                IF PAGE.RUNMODAL(0,JobPlanningLine) = ACTION::LookupOK THEN
                  VALIDATE("Job Planning Line No.",JobPlanningLine."Line No.");*/

            end;

            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                /*IF "Job Planning Line No." <> 0 THEN BEGIN
                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                  CASE Type OF
                    Type::"G/L Account":
                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                    Type::Item:
                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::Item);
                  END;
                  JobPlanningLine.TESTFIELD("No.","No.");
                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - "Qty. to Invoice");
                END ELSE
                  VALIDATE("Job Remaining Qty.",0);*/

            end;
        }
        field(1030; "Job Remaining Qty."; Decimal)
        {
            AccessByPermission = TableData Job = R;
            Caption = 'Job Remaining Qty.';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                /*IF ("Job Remaining Qty." <> 0) AND ("Job Planning Line No." = 0) THEN
                  ERROR(Text047,FIELDCAPTION("Job Remaining Qty."),FIELDCAPTION("Job Planning Line No."));
                
                IF "Job Planning Line No." <> 0 THEN BEGIN
                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                  IF JobPlanningLine.Quantity >= 0 THEN BEGIN
                    IF "Job Remaining Qty." < 0 THEN
                      "Job Remaining Qty." := 0;
                  END ELSE BEGIN
                    IF "Job Remaining Qty." > 0 THEN
                      "Job Remaining Qty." := 0;
                  END;
                END;
                "Job Remaining Qty. (Base)" := CalcBaseQty("Job Remaining Qty.");*/

            end;
        }
        field(1031; "Job Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Job Remaining Qty. (Base)';
        }
        field(5000; "Request No."; Code[20])
        {
        }
        field(5001; "Request Line No."; Integer)
        {
        }
        field(5002; "WHT Line"; Boolean)
        {
        }
        field(5003; "Schedule Amount"; Decimal)
        {
            // CalcFormula = sum("Payment Schedule".Amount where("Source Document No." = field("Document No."),
            //                                                    "Source Line No." = field("Line No.")));
            // Editable = false;
            // FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Attached Doc. No.")
        {
            SumIndexFields = "Cash Advance Amount", Amount;
        }
        key(Key3; "Check Entry No.", "Document No.")
        {
            SumIndexFields = Amount, "Amount (LCY)", "WHT Amount", "WHT Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen;
        if ("Document Type" = "document type"::Retirement) and ("Attached Doc. No." <> '') then
            Error(Text009);
        if "WHT Line" then
            Error(Text022);
        case "Document Type" of
            "document type"::"Payment Voucher":
                PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Payment Voucher");
            "document type"::"Cash Advance":
                PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Cash Advance");
            "document type"::Retirement:
                PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Cash Adv. Retirement");
        end;
        PmtCommentLine.SetRange("No.", "Document No.");
        PmtCommentLine.SetRange("Table Line No.", "Line No.");
        if not PmtCommentLine.IsEmpty then
            PmtCommentLine.DeleteAll;

        ClearCustVendEmpApplnEntry;
        UndoPVAttachtoCashAdv("Document No.");
        DeletePVSchedules;
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    trigger OnModify()
    begin
        if not FromPaymentDate then
            TestStatusOpen;
    end;

    var
        PaymentHeader: Record "Payment Header";
        PostedCashAdvance: Record "Posted Payment Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Job: Record Job;
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        GLAcc: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Employee: Record Employee;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        ICGLAccount: Record "IC G/L Account";
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        PmtCommentLine: Record "Payment Comment Line";
        WHTPostingGrp: Record "WHT Posting Group";
        PaymentReqCode: Record "Payment Request Code";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        EmpLedgEntry: Record "Employee Ledger Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        TempJobJnlLine: Record "Job Journal Line" temporary;
        StatusCheckSuspended: Boolean;
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        DimMgt: Codeunit DimensionManagement;
        Text000: label 'Vendor %1 has been blocked from payment. Contact your Payable Officer for Assistance.';
        Text001: label 'Fixed Asset %1 has not been properly set up. Depreciation book must be established for the asset.';
        Text003: label 'The update has been interrupted to respect the warning.';
        Text004: label 'The %1 in the %2 cannot be changed from %3 to %4';
        Text005: label 'Function not available. Contact your System Administrator for Assistance.';
        Text006: label '%1 must not be specified when the document is not an intercompany transaction.';
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        WHTMgt: Codeunit "WHT Management";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        EmpEntrySetApplID: Codeunit "Empl. Entry-SetAppl.ID";
        CurrencyDate: Date;
        Text007: label 'This combination of account type %1 and payment ype %2 are not allowed on document %3';
        Text008: label 'You have to setup a new asset code for this asset\Contact accounts';
        Text009: label 'The attached line cannot be deleted';
        Text010: label 'The attached doc. no. cannot be changed';
        Text012: label 'must not be specified when %1 = %2';
        Text011: label 'You cannot select an unattached cash advance';
        Text020: label 'The %1 option can only be used internally in the system.';
        Text022: label 'You cannot delete a WHT line directly\\ Unapply the entry';
        Text023: label 'You cannot change the requested %1';
        Text024: label 'This is cash advance, the account type must be G/L Account';
        FromPaymentDate: Boolean;
        Text025: label 'Schedule amount must be the same as amount';


    procedure GetPaymentHeader()
    begin
        TestField("Document No.");
        if ("Document No." <> PaymentHeader."No.") then begin
            PaymentHeader.Get("Document Type", "Document No.");
            if PaymentHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                PaymentHeader.TestField("Currency Factor");
                Currency.Get(PaymentHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetPaymentHeader;
        PaymentHeader.TestField(Status, PaymentHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        /*TableID[3] := Type3;
        No[3] := No3;*/
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetPaymentHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, '',
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            PaymentHeader."Dimension Set ID", Database::"Bank Account");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgtHook: Codeunit "Dimension Hook";
    begin
        DimMgtHook.GetMappedDimValue(ShortcutDimCode, "Dimension Set ID", FieldNumber, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FAPostingGr: Record "FA Posting Group";
    begin
        if ("Account Type" <> "account type"::"Fixed Asset") or ("Account No." = '') then
            exit;
        if "Depreciation Book Code" = '' then begin
            FASetup.Get;
            "Depreciation Book Code" := FASetup."Default Depr. Book";
            if not FADeprBook.Get("Account No.", "Depreciation Book Code") then
                "Depreciation Book Code" := '';
            if "Depreciation Book Code" = '' then
                exit;
        end;
        if "FA Posting Type" = "fa posting type"::" " then
            "FA Posting Type" := "fa posting type"::"Acquisition Cost";
        FADeprBook.Get("Account No.", "Depreciation Book Code");
        FADeprBook.TestField("FA Posting Group");
        FAPostingGr.Get(FADeprBook."FA Posting Group");
        if "FA Posting Type" = "fa posting type"::"Acquisition Cost" then begin
            FAPostingGr.TestField("Acquisition Cost Account");
            LocalGLAcc.Get(FAPostingGr."Acquisition Cost Account");

            //Prevent acquisition from being posted twice
            FADeprBook.CalcFields("Acquisition Cost");
            if FADeprBook."Acquisition Cost" <> 0 then
                Error(Text008);

        end else begin
            FAPostingGr.TestField("Maintenance Expense Account");
            LocalGLAcc.Get(FAPostingGr."Maintenance Expense Account");
        end;
        LocalGLAcc.CheckGLAcc;
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        if not PaymentHeader.Get("Document Type", "Document No.") then begin
            PaymentHeader."No." := '';
            PaymentHeader.Init;
        end;

        //EXIT('2,0,' + GetFieldCaption(FieldNumber));
    end;


    procedure ApplyEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        EmpLedgEntry: Record "Employee Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        ApplyEmpEntries: Page "Apply Employee Entries";
        AccNo: Code[20];
        CurrencyCode2: Code[10];
        OK: Boolean;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        Text000: label 'You must specify %1 or %2.';
        Text001: label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text002: label 'Do you wish to continue?';
        Text003: label 'The update has been interrupted to respect the warning.';
        Text005: label 'The %1  must be Customer or Vendor.';
        Text006: label 'All entries in one application must be in the same currency.';
        Text007: label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
    begin
        GetPaymentHeader;
        TestStatusOpen;
        TestField("Applies-to Doc. No.", '');
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := PaymentHeader."Document Date";
        GenJnlLine."Line No." := "Line No.";
        GenJnlLine.Validate("Account Type", Rec."Account Type");
        GenJnlLine.Validate("Account No.", Rec."Account No.");
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";

        case "Account Type" of
            "account type"::Vendor:
                GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
            "account type"::Employee:
                GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
            else
                GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
        end;
        if GenJnlLine.Insert then;
        Commit;
        AccType := "Account Type";
        AccNo := "Account No.";
        case AccType of
            Acctype::Customer:
                begin
                    CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                    CustLedgEntry.SetRange("Customer No.", AccNo);
                    CustLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "Document No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("Document No."), FieldCaption("Applies-to ID"));
                    GenJnlLine."Applies-to ID" := "Applies-to ID";
                    ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                    ApplyCustEntries.SetRecord(CustLedgEntry);
                    ApplyCustEntries.SetTableview(CustLedgEntry);
                    ApplyCustEntries.LookupMode(true);
                    OK := ApplyCustEntries.RunModal = Action::LookupOK;
                    Clear(ApplyCustEntries);
                    if not OK then
                        exit;
                    WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
                    CustLedgEntry.Reset;
                    CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                    CustLedgEntry.SetRange("Customer No.", AccNo);
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if CustLedgEntry.Find('-') then begin
                        CurrencyCode2 := CustLedgEntry."Currency Code";
                        if Amount = 0 then begin
                            repeat
                                PaymentToleranceMgt.DelPmtTolApllnDocNo(GenJnlLine, CustLedgEntry."Document No.");
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, CustLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Customer, true);

                                CustLedgEntry.CalcFields("Remaining Amount");
                                CustLedgEntry."Remaining Amount" :=
                                  CurrExchRate.ExchangeAmount(
                                    CustLedgEntry."Remaining Amount",
                                    CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                CustLedgEntry."Remaining Amount" :=
                                  ROUND(CustLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  CurrExchRate.ExchangeAmount(
                                    CustLedgEntry."Remaining Pmt. Disc. Possible",
                                    CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
                                WHTMgt.GetCustWHTAmount(CustLedgEntry, GenJnlLine, Database::"Payment Line");
                                CustLedgEntry."Amount to Apply" :=
                                  CurrExchRate.ExchangeAmount(
                                    CustLedgEntry."Amount to Apply",
                                    CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                CustLedgEntry."Amount to Apply" :=
                                  ROUND(CustLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");

                                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) and
                                   (Abs(CustLedgEntry."Amount to Apply") >=
                                    Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
                                then
                                    Amount := Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                                else
                                    Amount := Amount - (CustLedgEntry."Amount to Apply");
                            until CustLedgEntry.Next = 0;
                            Validate(Amount);
                        end else
                            repeat
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, CustLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Customer, true);

                                WHTMgt.GetCustWHTAmount(CustLedgEntry, GenJnlLine, Database::"Payment Line");
                            until CustLedgEntry.Next = 0;
                        if GenJnlLine."Currency Code" <> CurrencyCode2 then
                            if Amount = 0 then begin
                                if not
                                   Confirm(
                                     Text001 +
                                     Text002, true,
                                     FieldCaption("Currency Code"), TableCaption, GenJnlLine."Currency Code",
                                     CustLedgEntry."Currency Code")
                                then
                                    Error(Text003);
                                GenJnlLine."Currency Code" := CustLedgEntry."Currency Code"
                            end else
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  GenJnlLine."Currency Code", CustLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Customer, true);

                        "Applies-to Doc. Type" := 0;
                        "Applies-to Doc. No." := '';
                    end else
                        "Applies-to ID" := '';
                    Modify;
                    // Check Payment Tolerance
                    if Rec.Amount <> 0 then
                        if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                            exit;
                    WHTMgt.CreateWHTPaymentLine(Rec, 1);
                end;
            Acctype::Vendor:
                begin
                    VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                    VendLedgEntry.SetRange("Vendor No.", AccNo);
                    VendLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "Document No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("Document No."), FieldCaption("Applies-to ID"));
                    GenJnlLine."Applies-to ID" := "Applies-to ID";
                    ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                    ApplyVendEntries.SetRecord(VendLedgEntry);
                    ApplyVendEntries.SetTableview(VendLedgEntry);
                    ApplyVendEntries.LookupMode(true);
                    OK := ApplyVendEntries.RunModal = Action::LookupOK;
                    Clear(ApplyVendEntries);
                    if not OK then
                        exit;
                    WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
                    "WHT Amount" := 0;
                    "WHT Amount (LCY)" := 0;
                    VendLedgEntry.Reset;
                    VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                    VendLedgEntry.SetRange("Vendor No.", AccNo);
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if VendLedgEntry.Find('-') then begin
                        CurrencyCode2 := VendLedgEntry."Currency Code";
                        if Amount = 0 then begin
                            repeat
                                PaymentToleranceMgt.DelPmtTolApllnDocNo(GenJnlLine, VendLedgEntry."Document No.");
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, VendLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Vendor, true);

                                //CheckAgainstApplnCurrency(CurrencyCode2,VendLedgEntry."Currency Code",AccType::Vendor,TRUE);
                                VendLedgEntry.CalcFields("Remaining Amount");
                                VendLedgEntry."Remaining Amount" :=
                                  CurrExchRate.ExchangeAmount(
                                    VendLedgEntry."Remaining Amount",
                                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                VendLedgEntry."Remaining Amount" :=
                                  ROUND(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  CurrExchRate.ExchangeAmount(
                                    VendLedgEntry."Remaining Pmt. Disc. Possible",
                                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
                                WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, Database::"Payment Line");
                                VendLedgEntry."Amount to Apply" :=
                                  CurrExchRate.ExchangeAmount(
                                    VendLedgEntry."Amount to Apply",
                                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                VendLedgEntry."Amount to Apply" :=
                                  ROUND(VendLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");

                                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) and
                                   (Abs(VendLedgEntry."Amount to Apply") >=
                                    Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible"))
                                then
                                    Amount := Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                                else
                                    Amount := Amount - VendLedgEntry."Amount to Apply";

                            until VendLedgEntry.Next = 0;
                            Validate(Amount);
                        end else
                            repeat
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, VendLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Vendor, true);
                                WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, Database::"Payment Line");
                            until VendLedgEntry.Next = 0;
                        if GenJnlLine."Currency Code" <> CurrencyCode2 then
                            if Amount = 0 then begin
                                if not
                                   Confirm(
                                     Text001 +
                                     Text002, true,
                                     FieldCaption("Currency Code"), TableCaption, GenJnlLine."Currency Code",
                                     VendLedgEntry."Currency Code")
                                then
                                    Error(Text003);
                                "Currency Code" := VendLedgEntry."Currency Code"
                            end else
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  GenJnlLine."Currency Code", VendLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Vendor, true);

                        "Applies-to Doc. Type" := 0;
                        "Applies-to Doc. No." := '';
                    end else begin
                        "Applies-to ID" := '';
                    end;
                    Modify;
                    // Check Payment Tolerance
                    if Rec.Amount <> 0 then
                        if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                            exit;
                    WHTMgt.CreateWHTPaymentLine(Rec, 0);
                end;
            Acctype::Employee:
                begin
                    EmpLedgEntry.SetCurrentkey("Employee No.", Open, Positive);
                    EmpLedgEntry.SetRange("Employee No.", AccNo);
                    EmpLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "Document No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("Document No."), FieldCaption("Applies-to ID"));
                    GenJnlLine."Applies-to ID" := "Applies-to ID";
                    ApplyEmpEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                    ApplyEmpEntries.SetRecord(EmpLedgEntry);
                    ApplyEmpEntries.SetTableview(EmpLedgEntry);
                    ApplyEmpEntries.LookupMode(true);
                    OK := ApplyEmpEntries.RunModal = Action::LookupOK;
                    Clear(ApplyEmpEntries);
                    if not OK then
                        exit;
                    WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
                    "WHT Amount" := 0;
                    "WHT Amount (LCY)" := 0;
                    EmpLedgEntry.Reset;
                    EmpLedgEntry.SetCurrentkey("Employee No.", Open, Positive);
                    EmpLedgEntry.SetRange("Employee No.", AccNo);
                    EmpLedgEntry.SetRange(Open, true);
                    EmpLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if EmpLedgEntry.Find('-') then begin
                        CurrencyCode2 := EmpLedgEntry."Currency Code";
                        if Amount = 0 then begin
                            repeat
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, EmpLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Employee, true);
                                EmpLedgEntry.CalcFields("Remaining Amount");
                                EmpLedgEntry."Remaining Amount" :=
                                  CurrExchRate.ExchangeAmount(
                                    EmpLedgEntry."Remaining Amount",
                                    EmpLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                EmpLedgEntry."Remaining Amount" :=
                                  ROUND(EmpLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                //WHTMgt.GetEmpWHTAmount(EmpLedgEntry,GenJnlLine,DATABASE::"Payment Line");
                                EmpLedgEntry."Amount to Apply" :=
                                  CurrExchRate.ExchangeAmount(
                                    EmpLedgEntry."Amount to Apply",
                                    EmpLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                EmpLedgEntry."Amount to Apply" :=
                                  ROUND(EmpLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");

                                Amount := Amount - EmpLedgEntry."Amount to Apply";
                                AttachPVToCashAdv(EmpLedgEntry, "Applies-to ID");
                            until EmpLedgEntry.Next = 0;
                            Validate(Amount);
                        end else
                            repeat
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, EmpLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Employee, true);
                                //WHTMgt.GetEmpWHTAmount(EmpLedgEntry,GenJnlLine,DATABASE::"Payment Line");
                                AttachPVToCashAdv(EmpLedgEntry, "Applies-to ID");
                            until EmpLedgEntry.Next = 0;
                        if GenJnlLine."Currency Code" <> CurrencyCode2 then
                            if Amount = 0 then begin
                                if not
                                   Confirm(
                                     Text001 +
                                     Text002, true,
                                     FieldCaption("Currency Code"), TableCaption, GenJnlLine."Currency Code",
                                     EmpLedgEntry."Currency Code")
                                then
                                    Error(Text003);
                                "Currency Code" := EmpLedgEntry."Currency Code"
                            end else
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  GenJnlLine."Currency Code", EmpLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Employee, true);

                        "Applies-to Doc. Type" := 0;
                        "Applies-to Doc. No." := '';
                    end else begin
                        UndoPVAttachtoCashAdv("Applies-to ID");
                        "Applies-to ID" := '';
                    end;
                    Modify;

                    WHTMgt.CreateWHTPaymentLine(Rec, 0);
                end;
            else
                Error(
                  Text005,
                  FieldCaption("Account Type"));
        end;

        Validate(Amount, Abs(Amount));
        Modify;
    end;


    procedure LookUpAppliesToDocCust(AccNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line" temporary;
        ApplyCustEntries: Page "Apply Customer Entries";
    begin
        GetPaymentHeader;
        TestStatusOpen;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := PaymentHeader."Document Date";
        GenJnlLine."Line No." := 10000;
        case "Account Type" of
            "account type"::Customer, "account type"::Vendor:
                begin
                    GenJnlLine.Validate("Account Type", Rec."Account Type");
                    GenJnlLine.Validate("Account No.", Rec."Account No.");
                end;
            else
                exit
        end;
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";

        if "Account Type" = "account type"::Vendor then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
        else
            GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
        if GenJnlLine.Insert then;

        Clear(CustLedgEntry);
        CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if CustLedgEntry.IsEmpty then begin
                CustLedgEntry.SetRange("Document Type");
                CustLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange("Document Type");
        end;
        if Amount <> 0 then begin
            CustLedgEntry.SetRange(Positive, Amount < 0);
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange(Positive);
        end;
        ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyCustEntries.SetTableview(CustLedgEntry);
        ApplyCustEntries.SetRecord(CustLedgEntry);
        ApplyCustEntries.LookupMode(true);
        if ApplyCustEntries.RunModal = Action::LookupOK then begin
            ApplyCustEntries.GetRecord(CustLedgEntry);
            if AccNo = '' then begin
                AccNo := CustLedgEntry."Customer No.";
                if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Customer then
                    Validate("Account No.", AccNo)
                else
                    Validate("Account No.", AccNo);
            end;
            if GenJnlLine."Currency Code" <> CustLedgEntry."Currency Code" then
                if Amount = 0 then begin
                    FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                    ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
                    Error(Text004, FieldCaption("Currency Code"), PaymentHeader.TableCaption, FromCurrencyCode, ToCurrencyCode);
                end else
                    GenJnlApply.CheckAgainstApplnCurrency(
                      GenJnlLine."Currency Code", CustLedgEntry."Currency Code",
                      GenJnlLine."account type"::Customer, true);
            if Amount = 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                if CustLedgEntry."Amount to Apply" <> 0 then begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then begin
                        if Abs(CustLedgEntry."Amount to Apply") >=
                           Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                        then
                            Amount := -(CustLedgEntry."Remaining Amount" -
                                        CustLedgEntry."Remaining Pmt. Disc. Possible")
                        else
                            Amount := -CustLedgEntry."Amount to Apply";
                    end else
                        Amount := -CustLedgEntry."Amount to Apply";
                end else begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then
                        Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        Amount := -CustLedgEntry."Remaining Amount";
                end;
                if "Account Type" in ["account type"::Customer, "account type"::Vendor] then
                    Amount := -Amount;
                Validate(Amount);
            end;
            "Applies-to Doc. Type" := CustLedgEntry."Document Type";
            "Applies-to Doc. No." := CustLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;
    end;


    procedure LookUpAppliesToDocVend(AccNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        ApplyVendEntries: Page "Apply Vendor Entries";
    begin
        GetPaymentHeader;
        TestStatusOpen;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := PaymentHeader."Document Date";
        GenJnlLine."Line No." := 10000;
        case "Account Type" of
            "account type"::Customer, "account type"::Vendor, "account type"::Employee:
                begin
                    GenJnlLine.Validate("Account Type", Rec."Account Type");
                    GenJnlLine.Validate("Account No.", Rec."Account No.");
                end;
            else
                exit
        end;
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";

        if "Account Type" = "account type"::Vendor then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
        else
            GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
        if GenJnlLine.Insert then;

        Commit;

        Clear(VendLedgEntry);
        VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.IsEmpty then begin
                VendLedgEntry.SetRange("Document Type");
                VendLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Document Type");
        end;
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Document No.");
        end;
        if Amount <> 0 then begin
            VendLedgEntry.SetRange(Positive, Amount < 0);
            if VendLedgEntry.IsEmpty then;
            VendLedgEntry.SetRange(Positive);
        end;
        ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyVendEntries.SetTableview(VendLedgEntry);
        ApplyVendEntries.SetRecord(VendLedgEntry);
        ApplyVendEntries.LookupMode(true);
        if ApplyVendEntries.RunModal = Action::LookupOK then begin
            ApplyVendEntries.GetRecord(VendLedgEntry);
            if AccNo = '' then begin
                AccNo := VendLedgEntry."Vendor No.";
                if "Account Type" = "account type"::Vendor then
                    Validate("Account No.", AccNo)
                else
                    Validate("Account No.", AccNo);
            end;
            WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
            "WHT Amount" := 0;
            "WHT Amount (LCY)" := 0;
            if GenJnlLine."Currency Code" <> VendLedgEntry."Currency Code" then
                /*IF Amount = 0 THEN BEGIN
                  FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                  ToCurrencyCode := GetShowCurrencyCode(VendLedgEntry."Currency Code");
                  IF NOT
                     CONFIRM(
                       Text004,TRUE,FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,ToCurrencyCode)
                  THEN
                    ERROR(Text003);
                  VALIDATE("Currency Code",VendLedgEntry."Currency Code");
                END ELSE */
              GenJnlApply.CheckAgainstApplnCurrency(
                GenJnlLine."Currency Code", VendLedgEntry."Currency Code", GenJnlLine."account type"::Vendor, true);
            if Amount = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                VendLedgEntry."Remaining Amount" :=
                  CurrExchRate.ExchangeAmount(
                    VendLedgEntry."Remaining Amount",
                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                VendLedgEntry."Remaining Amount" :=
                  ROUND(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                  CurrExchRate.ExchangeAmount(
                    VendLedgEntry."Remaining Pmt. Disc. Possible",
                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                  ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
                WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, Database::"Payment Line");
                if VendLedgEntry."Amount to Apply" <> 0 then begin
                    VendLedgEntry."Amount to Apply" :=
                      CurrExchRate.ExchangeAmount(
                        VendLedgEntry."Amount to Apply",
                        VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                    VendLedgEntry."Amount to Apply" :=
                      ROUND(VendLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) then begin
                        if Abs(VendLedgEntry."Amount to Apply") >=
                           Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                        then
                            Amount := -(VendLedgEntry."Remaining Amount" -
                                        VendLedgEntry."Remaining Pmt. Disc. Possible")
                        else
                            Amount := -VendLedgEntry."Amount to Apply";
                    end else
                        Amount := -VendLedgEntry."Amount to Apply";
                end else begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) then
                        Amount := -(VendLedgEntry."Remaining Amount" -
                                    VendLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        Amount := -VendLedgEntry."Remaining Amount";
                end;
                if GenJnlLine."Bal. Account Type" in
                   [GenJnlLine."bal. account type"::Customer, GenJnlLine."bal. account type"::Vendor]
                then
                    Amount := -Amount;
                Validate(Amount, Abs(Amount));
            end;
            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            "Applies-to Doc. No." := VendLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;

    end;


    procedure LookUpAppliesToDocEmp(AccNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        ApplyEmpEntries: Page "Apply Employee Entries";
    begin
        GetPaymentHeader;
        TestStatusOpen;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := PaymentHeader."Document Date";
        GenJnlLine."Line No." := 10000;
        case "Account Type" of
            "account type"::Customer, "account type"::Vendor, "account type"::Employee:
                begin
                    GenJnlLine.Validate("Account Type", Rec."Account Type");
                    GenJnlLine.Validate("Account No.", Rec."Account No.");
                end;
            else
                exit
        end;
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";

        if "Account Type" = "account type"::Employee then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
        else
            GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
        if GenJnlLine.Insert then;

        Commit;

        Clear(EmpLedgEntry);
        EmpLedgEntry.SetCurrentkey("Employee No.", Open, Positive);
        if AccNo <> '' then
            EmpLedgEntry.SetRange("Employee No.", AccNo);
        EmpLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            EmpLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            EmpLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if EmpLedgEntry.IsEmpty then begin
                EmpLedgEntry.SetRange("Document Type");
                EmpLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            EmpLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if EmpLedgEntry.IsEmpty then
                EmpLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            EmpLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if EmpLedgEntry.IsEmpty then
                EmpLedgEntry.SetRange("Document Type");
        end;
        if "Applies-to Doc. No." <> '' then begin
            EmpLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if EmpLedgEntry.IsEmpty then
                EmpLedgEntry.SetRange("Document No.");
        end;
        if Amount <> 0 then begin
            EmpLedgEntry.SetRange(Positive, Amount < 0);
            if EmpLedgEntry.IsEmpty then;
            EmpLedgEntry.SetRange(Positive);
        end;
        ApplyEmpEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyEmpEntries.SetTableview(EmpLedgEntry);
        ApplyEmpEntries.SetRecord(EmpLedgEntry);
        ApplyEmpEntries.LookupMode(true);
        if ApplyEmpEntries.RunModal = Action::LookupOK then begin
            ApplyEmpEntries.GetRecord(EmpLedgEntry);
            if AccNo = '' then begin
                AccNo := EmpLedgEntry."Employee No.";
                if "Account Type" = "account type"::Employee then
                    Validate("Account No.", AccNo)
                else
                    Validate("Account No.", AccNo);
            end;
            WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
            "WHT Amount" := 0;
            "WHT Amount (LCY)" := 0;
            if GenJnlLine."Currency Code" <> EmpLedgEntry."Currency Code" then
                /*IF Amount = 0 THEN BEGIN
                  FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                  ToCurrencyCode := GetShowCurrencyCode(VendLedgEntry."Currency Code");
                  IF NOT
                     CONFIRM(
                       Text004,TRUE,FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,ToCurrencyCode)
                  THEN
                    ERROR(Text003);
                  VALIDATE("Currency Code",VendLedgEntry."Currency Code");
                END ELSE */
              GenJnlApply.CheckAgainstApplnCurrency(
                GenJnlLine."Currency Code", EmpLedgEntry."Currency Code", GenJnlLine."account type"::Employee, true);
            if Amount = 0 then begin
                EmpLedgEntry.CalcFields("Remaining Amount");
                EmpLedgEntry."Remaining Amount" :=
                  CurrExchRate.ExchangeAmount(
                    EmpLedgEntry."Remaining Amount",
                    EmpLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                EmpLedgEntry."Remaining Amount" :=
                  ROUND(EmpLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                //WHTMgt.GetVendWHTAmount(EmpLedgEntry,GenJnlLine,DATABASE::"Payment Line");
                if EmpLedgEntry."Amount to Apply" <> 0 then begin
                    EmpLedgEntry."Amount to Apply" :=
                      CurrExchRate.ExchangeAmount(
                        EmpLedgEntry."Amount to Apply",
                        EmpLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                    EmpLedgEntry."Amount to Apply" :=
                      ROUND(EmpLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
                    Amount := -EmpLedgEntry."Amount to Apply";
                end else begin
                    Amount := -EmpLedgEntry."Remaining Amount";
                end;
                if GenJnlLine."Bal. Account Type" in
                   [GenJnlLine."bal. account type"::Customer, GenJnlLine."bal. account type"::Vendor, GenJnlLine."bal. account type"::Employee]
                then
                    Amount := -Amount;
                Validate(Amount, Abs(Amount));
            end;
            "Applies-to Doc. Type" := EmpLedgEntry."Document Type";
            "Applies-to Doc. No." := EmpLedgEntry."Document No.";
            "Applies-to ID" := '';
            AttachPVToCashAdv(EmpLedgEntry, "Document No.");
        end;

    end;


    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        if CurrencyCode <> '' then
            exit(CurrencyCode);

        exit(Text009);
    end;

    local procedure GetAccTypeAndNo(var AccType: Option; var AccNo: Code[20])
    begin
        AccType := "Account Type";
        AccNo := "Account No.";
    end;


    procedure ClearCustVendEmpApplnEntry()
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry";
        TempVendLedgEntry: Record "Vendor Ledger Entry";
        TempEmpLedgEntry: Record "Employee Ledger Entry";
        CustEntryEdit: Codeunit "Cust. Entry-Edit";
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        EmpEntryEdit: Codeunit "Empl. Entry-Edit";
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        AccNo: Code[20];
    begin
        GetAccTypeAndNo(AccType, AccNo);
        case AccType of
            Acctype::Customer:
                if "Applies-to ID" <> '' then begin
                    if FindFirstCustLedgEntryWithAppliesToID(AccNo) then begin
                        ClearCustApplnEntryFields;
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                        WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
                    end
                end else
                    if "Applies-to Doc. No." <> '' then
                        if FindFirstCustLedgEntryWithAppliesToDocNo(AccNo) then begin
                            ClearCustApplnEntryFields;
                            CustEntryEdit.Run(CustLedgEntry);
                        end;
            Acctype::Vendor:
                if "Applies-to ID" <> '' then begin
                    if FindFirstVendLedgEntryWithAppliesToID(AccNo) then begin
                        ClearVendApplnEntryFields;
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                        WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");

                    end
                end else
                    if "Applies-to Doc. No." <> '' then
                        if FindFirstVendLedgEntryWithAppliesToDocNo(AccNo) then begin
                            ClearVendApplnEntryFields;
                            VendEntryEdit.Run(VendLedgEntry);
                            WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
                        end;
            Acctype::Employee:
                if "Applies-to ID" <> '' then begin
                    if FindFirstEmpLedgEntryWithAppliesToID(AccNo) then begin
                        ClearEmpApplnEntryFields;
                        EmpEntrySetApplID.SetApplId(EmpLedgEntry, TempEmpLedgEntry, '');
                        WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");

                    end
                end else
                    if "Applies-to Doc. No." <> '' then
                        if FindFirstEmpLedgEntryWithAppliesToDocNo(AccNo) then begin
                            ClearEmpApplnEntryFields;
                            EmpEntryEdit.Run(EmpLedgEntry);
                            WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Payment Line");
                        end;
        end;
    end;

    local procedure ClearCustApplnEntryFields()
    begin
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearVendApplnEntryFields()
    begin
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearEmpApplnEntryFields()
    begin
        EmpLedgEntry."Amount to Apply" := 0;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Customer No.", "Applies-to ID", Open);
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.FindFirst)
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
        CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.FindFirst)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Vendor No.", "Applies-to ID", Open);
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
        VendLedgEntry.SetRange(Open, true);
        exit(VendLedgEntry.FindFirst)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Document No.");
        VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
        VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        exit(VendLedgEntry.FindFirst)
    end;

    local procedure FindFirstEmpLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        EmpLedgEntry.Reset;
        EmpLedgEntry.SetCurrentkey("Employee No.", "Applies-to ID", Open);
        EmpLedgEntry.SetRange("Employee No.", AccNo);
        EmpLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
        EmpLedgEntry.SetRange(Open, true);
        exit(EmpLedgEntry.FindFirst)
    end;

    local procedure FindFirstEmpLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        EmpLedgEntry.Reset;
        EmpLedgEntry.SetCurrentkey("Document No.");
        EmpLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
        EmpLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        EmpLedgEntry.SetRange("Employee No.", AccNo);
        EmpLedgEntry.SetRange(Open, true);
        exit(EmpLedgEntry.FindFirst)
    end;


    procedure CheckAccountTypeWithPaymentType()
    begin
        GetPaymentHeader;
        case "Account Type" of
            "account type"::Vendor:
                begin
                    if not (PaymentHeader."Payment Type" in [0]) then
                        Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));
                end;
            "account type"::Customer:
                begin
                    if not (PaymentHeader."Payment Type" in [1, 4]) then
                        Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));
                end;
            "account type"::Employee:
                begin
                    if not (PaymentHeader."Payment Type" in [2, 3]) then
                        Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));
                end;
        end;
        if (PaymentHeader."Payment Type" in [0]) and ("Account Type" <> "account type"::Vendor) then
            Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));
        if (PaymentHeader."Payment Type" in [1]) and ("Account Type" <> "account type"::Customer) then
            Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));
        if (PaymentHeader."Payment Type" in [5]) and ("Account Type" <> "account type"::"Bank Account") then
            Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));
        if "Document Type" = "document type"::"Payment Voucher" then
            if (PaymentHeader."Payment Type" in [2, 3]) and ("Account Type" <> "account type"::Employee) then
                Error(Text007, Format("Account Type"), Format(PaymentHeader."Payment Type"));

        if "Document Type" = "document type"::"Cash Advance" then
            if "Account Type" <> "account type"::"G/L Account" then
                Error(Text024);
    end;

    local procedure ClearPostingGroups()
    begin
        "Gen. Posting Type" := "gen. posting type"::" ";
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
        "WHT Posting Group" := '';
    end;


    procedure AttachPVToCashAdv(EmpLedgerEntry: Record "Employee Ledger Entry"; AppliestoDocNo: Code[20])
    begin
        if AppliestoDocNo = '' then
            exit;

        with EmpLedgerEntry do begin
            case "Entry Type" of
                "entry type"::"Cash Advance":
                    begin
                        PostedCashAdvance.Get(PostedCashAdvance."document type"::"Cash Advance", EmpLedgerEntry."Document No.");
                        PostedCashAdvance."Voucher No." := AppliestoDocNo;
                        PostedCashAdvance.Modify;
                    end;
            end;
        end;
    end;


    procedure UndoPVAttachtoCashAdv(AppliestoDocNo: Code[20])
    begin
        if AppliestoDocNo = '' then
            exit;
        PostedCashAdvance.LockTable;
        PostedCashAdvance.SetRange(PostedCashAdvance."Voucher No.", AppliestoDocNo);
        PostedCashAdvance.ModifyAll("Voucher No.", '');
    end;


    procedure SetFromPaymentDate()
    begin
        FromPaymentDate := true;
    end;


    procedure ApplyDirectEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Text000: label 'You must specify %1 or %2.';
        Text001: label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text002: label 'Do you wish to continue?';
        Text003: label 'The update has been interrupted to respect the warning.';
        Text005: label 'The %1  must be Customer or Vendor.';
        Text006: label 'All entries in one application must be in the same currency.';
        Text007: label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
    begin
        GetPaymentHeader;
        TestField("Applies-to Doc. No.", '');

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := PaymentHeader."Document Date";
        GenJnlLine."Line No." := "Line No.";
        GenJnlLine.Validate("Account Type", Rec."Account Type");
        GenJnlLine.Validate("Account No.", Rec."Account No.");
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";

        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
        VendLedgEntry.SetRange("Vendor No.", "Account No.");
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
        if VendLedgEntry.Find('-') then begin
            repeat
                GenJnlApply.CheckAgainstApplnCurrency(
                  PaymentHeader."Currency Code", VendLedgEntry."Currency Code",
                    GenJnlLine."account type"::Vendor, true);
                //VendLedgEntry."Amount to Apply" := -Amount;
                //VendLedgEntry.MODIFY;
                WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, Database::"Payment Line");
            until VendLedgEntry.Next = 0;
        end;
        WHTMgt.CreateWHTPaymentLine(Rec, 0);
    end;


    procedure JobTaskIsSet(): Boolean
    begin
        exit(("Job No." <> '') and ("Job Task No." <> '') and ("Account Type" in ["account type"::"G/L Account"]));
    end;


    procedure CreateTempJobJnlLine(GetPrices: Boolean)
    begin
        /*GetPaymentHeader;
        CLEAR(TempJobJnlLine);
        TempJobJnlLine.DontCheckStdCost;
        TempJobJnlLine.VALIDATE("Job No.","Job No.");
        TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
        //TempJobJnlLine.VALIDATE("Posting Date",PaymentHeader."Payment Date");
        TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
        IF "Account Type" = "Account Type"::"G/L Account" THEN
          TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account");
        TempJobJnlLine.VALIDATE("No.","Account No.");
        TempJobJnlLine.VALIDATE(Quantity,1);
        IF NOT GetPrices THEN BEGIN
          IF xRec."Line No." <> 0 THEN BEGIN
            TempJobJnlLine."Unit Cost" := xRec."Unit Cost";
            TempJobJnlLine."Unit Cost (LCY)" := xRec."Unit Cost (LCY)";
            TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
            TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
            TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
            TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
          END ELSE BEGIN
            TempJobJnlLine."Unit Cost" := "Unit Cost";
            TempJobJnlLine."Unit Cost (LCY)" := "Unit Cost (LCY)";
            TempJobJnlLine."Unit Price" := "Job Unit Price";
            TempJobJnlLine."Line Amount" := "Job Line Amount";
            TempJobJnlLine."Line Discount %" := "Job Line Discount %";
            TempJobJnlLine."Line Discount Amount" := "Job Line Discount Amount";
          END;
          TempJobJnlLine.VALIDATE("Unit Price");
        END ELSE
          TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");*/

    end;


    procedure UpdateJobPrices()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        "Job Unit Price" := TempJobJnlLine."Unit Price";
        "Job Total Price" := TempJobJnlLine."Total Price";
        "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
        "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
        "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
        "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
        "Job Line Amount" := TempJobJnlLine."Line Amount";
        "Job Line Discount %" := TempJobJnlLine."Line Discount %";
        "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
    end;


    procedure JobSetCurrencyFactor()
    begin
        GetPaymentHeader;
        Clear(TempJobJnlLine);
        TempJobJnlLine.Validate("Job No.", "Job No.");
        TempJobJnlLine.Validate("Job Task No.", "Job Task No.");
        TempJobJnlLine.Validate("Posting Date", PaymentHeader."Payment Date");
        "Job Currency Factor" := TempJobJnlLine."Currency Factor";
    end;


    procedure SetPaymentHeader(NewPaymentHeader: Record "Payment Header")
    begin
        PaymentHeader := NewPaymentHeader;

        if PaymentHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            PaymentHeader.TestField("Currency Factor");
            Currency.Get(PaymentHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;


    procedure ShowPVSchedules()
    var
    //     PVScheduleLine: Record "Payment Schedule";
    //     PVScheduleLines: Page "Payment Schedules";
    begin
        //     TestField("Document No.");
        //     TestField("Line No.");
        //     GetPaymentHeader;
        //     if (PaymentHeader."Payment Type" in [PaymentHeader."payment type"::Others,PaymentHeader."payment type"::Salary]) then
        //       begin
        //         PVScheduleLine.SetRange("Source Document No.","Document No.");
        //         PVScheduleLine.SetRange("Source Line No.","Line No.");
        //         PVScheduleLines.SetTableview(PVScheduleLine);
        //         PVScheduleLines.RunModal;
        //         CalcFields("Schedule Amount");
        //         Validate(Amount,"Schedule Amount");
        //       end else
        //         exit;
    end;


    procedure DeletePVSchedules()
    var
    //     PVScheduleLine: Record "Payment Schedule";
    begin
        //     PVScheduleLine.SetRange("Source Document No.","Document No.");
        //     PVScheduleLine.SetRange("Source Line No.","Line No.");
        //     if PVScheduleLine.FindSet then
        //       PVScheduleLine.DeleteAll;
    end;
}

