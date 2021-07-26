Table 52092289 "Payment Header"
{
    //LookupPageID = "Payment List";
    Permissions = TableData Customer=rim,
                  TableData Vendor=rim;

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
        }
        field(2;"Document Type";Option)
        {
            OptionCaption = 'Payment Voucher,Cash Advance,Retirement';
            OptionMembers = "Payment Voucher","Cash Advance",Retirement;
        }
        field(3;"Posting Description";Text[100])
        {
        }
        field(4;"Currency Code";Code[10])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then
                  TestField(Status,Status::Open);

                PaymentMgt.CheckCurrCode("Currency Code");

                if "Payment Source" <> '' then begin
                  BankAccount.Get("Payment Source");
                  BankAccount.TestField("Currency Code","Currency Code");
                end;

                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                  UpdateCurrencyFactor
                else begin
                  if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    RecreatePymtLines(FieldCaption("Currency Code"));
                  end else
                    if "Currency Code" <> '' then begin
                      UpdateCurrencyFactor;
                      if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                    end;
                end;
            end;
        }
        field(5;"Currency Factor";Decimal)
        {

            trigger OnValidate()
            begin
                if FromPaymentDate = false then
                  TestField(Status,Status::Open);
                if "Currency Factor" <> xRec."Currency Factor" then
                  UpdatePaymentLines(FieldCaption("Currency Factor"),false);
            end;
        }
        field(6;"Document Date";Date)
        {
        }
        field(7;"User ID";Code[50])
        {
            Editable = false;
        }
        field(8;"Payment Date";Date)
        {

            trigger OnValidate()
            begin
                FromPaymentDate := true;
                if "Document Type" <> "document type"::"Cash Advance" then
                 TestField(Status,Status::Approved);

                if "Currency Code" <> '' then begin
                  UpdateCurrencyFactor;
                  if "Currency Factor" <> xRec."Currency Factor" then
                    ConfirmUpdateCurrencyFactor;
                end;
            end;
        }
        field(9;"Payment Method";Option)
        {
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";

            trigger OnValidate()
            begin
                case "Payment Method" of
                  0,1,2:begin
                    "Payee Bank Code" := '';
                    "Payee Bank Account Name" := '';
                    "Payee Bank Account No." := '';
                  end;
                end;
            end;
        }
        field(10;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";

            trigger OnValidate()
            begin
                PmtMgtSetup.Get;
                case Status of
                  Status::Approved,Status::"Pending Approval":
                    begin
                      if PmtMgtSetup."Budget Expense Control Enabled" then
                        CreateCommitment;
                    end;
                  Status::Open:
                    begin
                      if PmtMgtSetup."Budget Expense Control Enabled" then
                        DeleteCommitment;
                      "Payment Date" := 0D;
                      if (Status = Status::Open) and ("Check Entry No." <>0) then
                        Error(Text015);
                    end;
                end;
            end;
        }
        field(11;"System Created Entry";Boolean)
        {
            Editable = false;
        }
        field(12;"Payment Type";Option)
        {
            InitValue = Others;
            OptionCaption = 'Supp. Invoice,Cust. Refund,Cash Advance,Retirement,Others,Float Reimbursement,Salary';
            OptionMembers = "Supp. Invoice","Cust. Refund","Cash Advance",Retirement,Others,"Float Reimbursement",Salary;

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                if (CurrFieldNo = FieldNo("Payment Type")) and ("Payment Type" in [1]) then
                  Error(Text013);

                if xRec."Payment Type" <> "Payment Type" then begin
                  if PaymentLinesExist then begin
                    if (xRec."Payment Type" = 2) and (CheckIfCashAdvAttached) then
                      Error(Text009);
                    if (xRec."Payment Type" = 5) and (CheckIfCashAdvAttached) then
                      Error(Text011);
                    if not Confirm(Text023,false) then
                     Error(Text010);
                    PaymentLine.SetRange("Document Type","Document Type");
                    PaymentLine.SetRange("Document No.","No.");
                    PaymentLine.DeleteAll(true);
                  end;
                end;
                if "Document Type" = "document type"::Retirement then begin
                  if "Payment Type" <> "payment type"::Retirement then
                    Error(Text029);
                end;
            end;
        }
        field(13;"Source No.";Code[20])
        {
        }
        field(14;"Requested By";Code[20])
        {
        }
        field(15;"Payment Request No.";Code[20])
        {
            Editable = false;
            TableRelation = "Payment Request Header";
        }
        field(16;"Check Entry No.";Integer)
        {
            Editable = false;
        }
        field(17;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(18;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
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
            Editable = false;
        }
        field(22;"Last Modified By";Code[50])
        {
            Editable = false;
        }
        field(23;"Payment Source";Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                //TESTFIELD(Status,Status::Open);
                CreateDim(Database::"Bank Account","Payment Source");

                if "Payment Source" <> '' then begin
                  BankAccount.Get("Payment Source");
                  if SetCurrencyCode(3,"Payment Source") then
                    TestField("Currency Code",BankAccount."Currency Code")
                  else
                    "Currency Code" := BankAccount."Currency Code";
                end;
            end;
        }
        field(24;"Bal. Account Type";Option)
        {
            OptionCaption = 'Vendor,Bank Account,Employee';
            OptionMembers = Vendor,"Bank Account",Employee;
        }
        field(25;"Bal. Account No.";Code[20])
        {
            TableRelation = if ("Bal. Account Type"=const(Vendor)) Vendor
                            else if ("Bal. Account Type"=const("Bank Account")) "Bank Account"
                            else if ("Bal. Account Type"=const(Employee)) Employee;

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                case "Bal. Account Type" of
                  "bal. account type"::"Bank Account":
                    CreateDim(Database::"Bank Account","Bal. Account No.");
                  "bal. account type"::Vendor:
                    CreateDim(Database::Vendor,"Bal. Account No.");
                  "bal. account type"::Employee:
                    CreateDim(Database::Employee,"Bal. Account No.");
                end;
            end;
        }
        field(26;"No. Series";Code[10])
        {
        }
        field(27;"Creation Date";Date)
        {
            Editable = false;
        }
        field(28;"Creation Time";Time)
        {
            Editable = false;
        }
        field(29;"Payee No.";Code[20])
        {
            TableRelation = if ("Payment Type"=const("Supp. Invoice")) Vendor
                            else if ("Payment Type"=const("Cust. Refund")) Customer
                            else if ("Payment Type"=filter("Cash Advance"|Retirement|Others)) Employee;

            trigger OnValidate()
            begin
                if (xRec."Payee No." <> "Payee No.") and (xRec."Payee No." <> '') then begin
                  Payee := '';
                  "Payee Bank Code" := '';
                  "Payee Bank Account Name" := '';
                  "Payee Bank Account No." := '';
                  case "Document Type" of
                    "document type"::Retirement:
                      begin
                        if PaymentLinesExist then
                          Error(Text005)
                      end;
                  end;
                end;
                if "Payee No." <> '' then begin
                  case "Payment Type" of
                    0:begin
                      Vendor.Get("Payee No.");
                      Payee := Vendor.Name;
                      "Bal. Account No." := '';
                      if VendBank.Get("Payee No.",Vendor."Preferred Bank Account Code") then begin
                        "Payee Bank Account No." := VendBank."Bank Account No.";
                        "Payee Bank Account Name" := VendBank.Name;
                        "Payee Bank Code" := VendBank.Code;
                      end;
                    end;
                    1:begin
                      Customer.Get("Payee No.");
                      Payee := Customer.Name;
                      "Bal. Account No." := '';
                      if CustBank.Get("Payee No.",Customer."Preferred Bank Account Code") then begin
                        "Payee Bank Account No." := CustBank."Bank Account No.";
                        "Payee Bank Account Name" := CustBank.Name;
                        "Payee Bank Code" := CustBank.Code;
                      end;
                    end;
                    2,3:begin
                      Employee.Get("Payee No.");
                      Payee := Employee.FullName;
                      "Bal. Account Type" := "bal. account type"::Employee;
                      "Bal. Account No." := Employee."No.";
                      "Employee Posting Group" := Employee."Employee Posting Group";
                      "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                      "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    end;
                    4:begin
                      Employee.Get("Payee No.");
                      Payee := Employee.FullName;
                      "Bal. Account No." := '';
                      "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                      "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";

                    end;

                  end;
                end;
            end;
        }
        field(30;Payee;Text[100])
        {
        }
        field(31;"Payee Bank Code";Code[20])
        {
            TableRelation = if ("Payment Type"=const("Supp. Invoice")) "Vendor Bank Account".Code where ("Vendor No."=field("Payee No."))
                            else if ("Payment Type"=const("Cust. Refund")) "Customer Bank Account".Code where ("Customer No."=field("Payee No."))
                            else if ("Payment Type"=filter("Cash Advance"|Others)) "Employee Bank Account".Code where ("Employee No."=field("Payee No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Payee Bank Code" <> '' then begin
                  case "Payment Type" of
                    "payment type"::"Supp. Invoice":
                      begin
                        VendBank.Get("Payee No.","Payee Bank Code");
                        "Payee Bank Account Name" := VendBank.Name;
                        "Payee Bank Account No." := VendBank."Bank Account No.";
                      end;
                    "payment type"::"Cust. Refund":
                      begin
                        CustBank.Get("Payee No.","Payee Bank Code");
                        "Payee Bank Account Name" := CustBank.Name;
                        "Payee Bank Account No." := CustBank."Bank Account No.";
                      end;
                    else begin
                      EmployeeBank.Get("Payee No.","Payee Bank Code");
                      "Payee Bank Account Name" := EmployeeBank."Bank Account Name" ;
                      "Payee Bank Account No." := EmployeeBank."Bank Account No.";
                      "Payee CBN Bank Code" := EmployeeBank."CBN Bank Code";
                    end;
                  end;
                end;
            end;
        }
        field(32;"Payee Bank Account Name";Text[80])
        {
        }
        field(33;"Payee Bank Account No.";Text[30])
        {
        }
        field(34;"Payee CBN Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(36;"Retirement No.";Code[20])
        {
        }
        field(37;"Retirement Date";Date)
        {
        }
        field(38;"Retirement Amount";Decimal)
        {
            CalcFormula = sum("Payment Line"."Cash Advance Amount" where ("Document No."=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;"Retirement Amount (LCY)";Decimal)
        {
            CalcFormula = sum("Payment Line"."Cash Advance Amount (LCY)" where ("Document No."=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"External Document No.";Code[20])
        {
        }
        field(41;"Due Date";Date)
        {
        }
        field(42;"Entry Status";Option)
        {
            Editable = false;
            OptionCaption = ',Voided,Posted,Financially Voided';
            OptionMembers = ,Voided,Posted,"Financially Voided";
        }
        field(43;"No. Printed";Integer)
        {
            Editable = false;
        }
        field(44;"Employee Posting Group";Code[10])
        {
            TableRelation = "Employee Posting Group";
        }
        field(45;"Create Voucher";Boolean)
        {
        }
        field(46;"Voucher No.";Code[20])
        {
        }
        field(47;"Responsibility Center";Code[10])
        {
        }
        field(48;"Due Date Calc. Period";DateFormula)
        {
        }
        field(49;"Source Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Travel,Leave';
            OptionMembers = Travel,Leave;
        }
        field(99;"Travel Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Travel Header";
        }
        field(100;"Dimension Set ID";Integer)
        {
        }
        field(101;Amount;Decimal)
        {
            CalcFormula = sum("Payment Line".Amount where ("Document No."=field("No."),
                                                           "Document Type"=field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"Amount (LCY)";Decimal)
        {
            CalcFormula = sum("Payment Line"."Amount (LCY)" where ("Document No."=field("No."),
                                                                   "Document Type"=field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"WHT Amount";Decimal)
        {
            CalcFormula = sum("Payment Line"."WHT Amount" where ("Document No."=field("No."),
                                                                 "Document Type"=field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(104;"WHT Amount (LCY)";Decimal)
        {
            CalcFormula = sum("Payment Line"."WHT Amount (LCY)" where ("Document No."=field("No."),
                                                                       "Document Type"=field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(500;"CashLite ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(501;"Schedule Amount";Decimal)
        {
            //CalcFormula = sum("Payment Schedule".Amount where ("Source Document No."=field("No.")));
            FieldClass = FlowField;
        }
        field(502;"Payroll Period";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Added so as to be able the call get payroll entries';
            TableRelation = "Payroll-Period";

            trigger OnValidate()
            begin
                if "Payroll Period"<>'' then begin
                  PayrollPeriodRec.Get("Payroll Period");
                  Validate("Closed Payroll(Yes/No)",PayrollPeriodRec.Closed);
                end else
                  Clear("Closed Payroll(Yes/No)");
            end;
        }
        field(503;"Payroll-E/DCode";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                if "Payroll-E/DCode" <>'' then begin
                  PayrollEDRec.Get("Payroll-E/DCode");
                  Validate("Payroll E/D Description",PayrollEDRec.Description);
                end else
                  Clear("Payroll E/D Description");
            end;
        }
        field(504;"Payroll E/D Description";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(505;"Closed Payroll(Yes/No)";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(506;"Pension Administrator";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Pension Administrator";
        }
        field(507;"Schedule Count";Integer)
        {
            //CalcFormula = count("Payment Schedule" where ("Source Document No."=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70000;"Portal ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001;"Mobile User ID";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "User ID" := "Mobile User ID";
            end;
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
        key(Key2;"Payee No.",Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status,Status::Open);
        TestField("Payment Request No.",'');

        ApprovalMgt.DeleteApprovalEntries(RecordId);

        PaymentLine.LockTable;
        PaymentLine.SetRange("Document Type","Document Type");
        PaymentLine.SetRange("Document No.","No.");
        DeletePaymentLines;

        PmtCommentLine.SetRange("Table Name","Document Type" + 1);
        PmtCommentLine.SetRange("No.","No.");
        PmtCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        PmtMgtSetup.Get;
        if "No." = '' then begin
          CheckBlankDoc;
          case "Document Type" of
            0:begin                   //********* transaction type = Voucher
              PmtMgtSetup.TestField("Payment Voucher Nos.");
              NoSeriesMgt.InitSeries(PmtMgtSetup."Payment Voucher Nos.",xRec."No. Series",
                                     0D,"No.","No. Series");
        
            end;
            1: begin                  //********* transaction type = Cash Advance
               PmtMgtSetup.TestField(PmtMgtSetup."Cash Advance Nos.");
               "Payment Type" := "payment type"::"Cash Advance";
               "Bal. Account Type":= "bal. account type"::Employee;
               "Due Date Calc. Period" := PmtMgtSetup."Cash Adv. Due Period";
               if "Payee No." = '' then begin
                  UserSetup.Get(UserId);
                  UserSetup.TestField("Employee No.");
                  Validate("Payee No.",UserSetup."Employee No.");
               end;
               NoSeriesMgt.InitSeries(PmtMgtSetup."Cash Advance Nos.",xRec."No. Series",
                 0D,"No.","No. Series");
            end;
            2: begin                 //********** transaction type = Cash Advance Retirement
              PmtMgtSetup.TestField(PmtMgtSetup."Cash Adv. Retirement Nos.");
              "Payment Type" := "payment type"::Retirement;
              "Bal. Account Type":= "bal. account type"::Employee ;
              UserSetup.Get(UserId);
              UserSetup.TestField("Employee No.");
              Validate("Payee No.",UserSetup."Employee No.");
              "Payment Source" := '';
              NoSeriesMgt.InitSeries(PmtMgtSetup."Cash Adv. Retirement Nos.",xRec."No. Series",
              0D,"No.","No. Series");
            end;
          end;/*End Case*/
        end;
        
        if "Document Date" = 0D then
          "Document Date" := Today;
        "Creation Date" := Today;
        "Creation Time" := Time;
        "Responsibility Center" := UserSetupMgt.GetRespCenter(3,"Responsibility Center");
        "User ID" := UserId;

    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "Last Modified By" := UpperCase(UserId);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        UserSetup: Record "User Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        PmtCommentLine: Record "Payment Comment Line";
        Employee: Record Employee;
        Vendor: Record Vendor;
        Customer: Record Customer;
        BankAccount: Record "Bank Account";
        VendBank: Record "Vendor Bank Account";
        CustBank: Record "Customer Bank Account";
        EmployeeBank: Record "Employee Bank Account";
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        BudgetControlMgt: Codeunit "Budget Control Management";
        UserSetupMgt: Codeunit "User Setup Management";
        PaymentMgt: Codeunit PaymentManagement;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        Text004: label 'Voided payment voucher cannot be modified.';
        Text005: label 'Retirement line(s) already created, payee cannot be changed!';
        Text006: label 'If you change %1, the existing payment lines will be deleted and new payment lines based on the new information on the header will be created.\\';
        Text007: label 'Do you want to change %1?';
        Text008: label 'You must delete the existing payment voucher lines before you can change %1.';
        Text009: label 'This voucher is already applied to a posted cash advance\\ Action not allowed';
        Text010: label 'Action aborted';
        Text011: label 'This voucher is applied to a reimbursement retirement\\ Action not allowed';
        Text012: label 'Are you sure you want to Void payment voucher %1?';
        Text013: label 'This option is not allowed!';
        Text014: label 'This option is not allowed! for this type of document';
        Text015: label 'Document already attached to a check, action not allowed';
        Text023: label 'Changing the source type will cause the system to delete the lines\ Do you want to continue?';
        Text029: label 'This is a retirement Document so the payment type must be retirement';
        Text035: label 'No Budget Entry created for Account %1, please Contact your Budget Control Unit';
        Text036: label 'Your Expense for this Period have been Exceeded by =N= %1,Please Contact your Budget Control Unit';
        Text037: label 'Your Expense for this Period have been Exceeded by =N= %1, Do want to Continue?';
        Text038: label 'Transaction blocked to respect budget control';
        Text039: label 'The amount for account %1 will make you go above your budget\\ Please Contact your Budget Control Unit';
        Text040: label 'The amount for account %1 will make you go above your budget\\ Do you want to continue?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text065: label 'New voucher number cannot be created because There is no line created for %1. Press Escape to use the number.';
        Text080: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text081: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text082: label 'The dimensions used in %1 %2 are invalid. %3';
        Text083: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        FromPaymentDate: Boolean;
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        PayrollEDRec: Record "Payroll-E/D";
        PayrollPeriodRec: Record "Payroll-Period";


    procedure CreateDim(Type1: Integer;No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,'',"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

        if (OldDimSetID <> "Dimension Set ID") and ("Dimension Set ID" <> 0) and PaymentLinesExist then begin
          Modify;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
        DimMgtHook: Codeunit "Dimension Hook";
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgtHook.GetMappedDimValue(ShortcutDimCode,"Dimension Set ID",FieldNumber,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        if "No." <> '' then
          Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
          Modify;
          if PaymentLinesExist then
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        end;
    end;


    procedure PaymentLinesExist(): Boolean
    begin
        PaymentLine.Reset;
        PaymentLine.SetRange("Document Type","Document Type");
        PaymentLine.SetRange("Document No.","No.");
        exit(PaymentLine.FindFirst);
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",StrSubstNo('%1 %2',"Document Type","No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
          Modify;
          if PaymentLinesExist then
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
          exit;
        if not Confirm(Text064) then
          exit;

        PaymentLine.Reset;
        PaymentLine.SetRange("Document Type","Document Type");
        PaymentLine.SetRange("Document No.","No.");
        PaymentLine.LockTable;
        if PaymentLine.Find('-') then
          repeat
            NewDimSetID := DimMgt.GetDeltaDimSetID(PaymentLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            if PaymentLine."Dimension Set ID" <> NewDimSetID then begin
              PaymentLine."Dimension Set ID" := NewDimSetID;
              DimMgt.UpdateGlobalDimFromDimSetID(
                PaymentLine."Dimension Set ID",PaymentLine."Shortcut Dimension 1 Code",PaymentLine."Shortcut Dimension 2 Code");
              PaymentLine.Modify;
            end;
          until PaymentLine.Next = 0;
    end;


    procedure GetCurrency()
    begin
        CurrencyCode := "Currency Code";

        if CurrencyCode = '' then begin
          Clear(Currency);
          Currency.InitRoundingPrecision
        end else
          if CurrencyCode <> Currency.Code then begin
            Currency.Get(CurrencyCode);
            Currency.TestField("Amount Rounding Precision");
          end;
    end;


    procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
          if  ("Payment Date" = 0D) then
            CurrencyDate := WorkDate
          else
            CurrencyDate := "Payment Date";

          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        end else
          "Currency Factor" := 0;
    end;


    procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
          Confirmed := true
        else
          Confirmed := Confirm(Text001,false);
        if Confirmed then
          Validate("Currency Factor")
        else
          "Currency Factor" := xRec."Currency Factor";
    end;


    procedure RecreatePymtLines(ChangedFieldName: Text[100])
    var
        PaymentVouchLineTemp: Record "Payment Line" temporary;
    begin
        if PaymentLinesExist then begin
          if HideValidationDialog or not GuiAllowed then
            Confirmed := true
          else
            Confirmed :=
              Confirm(
                Text006 +
                Text007,false,ChangedFieldName);
          if Confirmed then begin
            PaymentLine.LockTable;
            Modify;

            PaymentLine.Reset;
            PaymentLine.SetRange("Document Type","Document Type");
            PaymentLine.SetRange("Document No.","No.");
            if PaymentLine.FindSet then begin
              repeat
                //PaymentLine.TESTFIELD("Job No.",'');
                PaymentVouchLineTemp := PaymentLine;
                PaymentVouchLineTemp.Insert;
              until PaymentLine.Next = 0;

              PaymentLine.DeleteAll(true);

              PaymentLine.Init;
              PaymentLine."Line No." := 0;
              PaymentVouchLineTemp.FindSet;
              repeat
                PaymentLine := PaymentVouchLineTemp;
                PaymentLine."Currency Code" := "Currency Code";
                PaymentLine.Validate(Amount,PaymentVouchLineTemp.Amount);
                PaymentLine.Insert;
              until PaymentVouchLineTemp.Next = 0;
            end;
          end else
            Error(
              Text008,ChangedFieldName);
        end;
    end;


    procedure UpdatePaymentLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        Question: Text[250];
    begin
        if not(PaymentLinesExist) then
          exit;

        if AskQuestion then begin
          Question := StrSubstNo(
            Text002 +
            Text003,ChangedFieldName);
          if GuiAllowed then
            if not Dialog.Confirm(Question,true) then
              exit;
        end;

        PaymentLine.LockTable;
        Modify;

        PaymentLine.Reset;
        PaymentLine.SetRange("Document Type","Document Type");
        PaymentLine.SetRange("Document No.","No.");
        if PaymentLine.FindSet then
          repeat
            if FromPaymentDate then
              PaymentLine.SetFromPaymentDate;
            case ChangedFieldName of
              FieldCaption("Currency Factor"):begin
                  PaymentLine.Validate(Amount);
                  PaymentLine.Validate("Amount (LCY)");
              end;
            end;
            PaymentLine.Modify(true);
          until PaymentLine.Next = 0;
    end;


    procedure CheckBlankDoc()
    begin
        if "System Created Entry"  then
           exit;

        PaymentHeader.SetRange("Document Type","Document Type");
        PaymentHeader.SetRange("User ID",UpperCase(UserId));
        PaymentHeader.SetRange(Status,PaymentHeader.Status::Open);
        if PaymentHeader.Find('-') then
          repeat
            if not  PaymentHeader.PaymentLinesExist then
              Error(Text065,PaymentHeader."No.");
          until PaymentHeader.Next(1) = 0;
    end;


    procedure CheckDim()
    var
        PaymentLine2: Record "Payment Line";
    begin
        PaymentLine2."Line No." := 0;
        CheckDimValuePosting(PaymentLine2);
        CheckDimComb(PaymentLine2);

        PaymentLine2.SetRange("Document Type","Document Type");
        PaymentLine2.SetRange("Document No.","No.");
        if PaymentLine2.FindSet then
          repeat
            begin
              CheckDimComb(PaymentLine2);
              CheckDimValuePosting(PaymentLine2);
            end
          until PaymentLine2.Next = 0;
    end;

    local procedure CheckDimComb(PaymentLine: Record "Payment Line")
    begin
        if PaymentLine."Line No." = 0 then
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(
              Text080,
              "Document Type","No.",DimMgt.GetDimCombErr);

        if PaymentLine."Line No." <> 0 then
          if not DimMgt.CheckDimIDComb(PaymentLine."Dimension Set ID") then
            Error(
              Text081,
              "Document Type","No.",PaymentLine."Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var PaymentLine2: Record "Payment Line")
    var
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        if PaymentLine2."Line No." = 0 then begin
          TableIDArr[1] := Database::"Bank Account";
          NumberArr[1] := "Payment Source";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") then
            Error(
              Text082,
              "Document Type","No.",DimMgt.GetDimValuePostingErr);
        end else begin
          TableIDArr[1] := DimMgt.TypeToTableID1(PaymentLine2."Account Type");
          NumberArr[1] := PaymentLine2."Account No.";
          TableIDArr[2] := Database::Job;
          NumberArr[2] := PaymentLine2."Job No.";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,PaymentLine2."Dimension Set ID") then
            Error(
              Text083,
              "Document Type","No.",PaymentLine2."Line No.",DimMgt.GetDimValuePostingErr);
        end;
    end;


    procedure InsertRetLineFromAdvLine(var PaymentLine: Record "Payment Line")
    var
        PaymentLine2: Record "Payment Line";
        TempPaymentLine: Record "Payment Line";
        NextLineNo: Integer;
    begin
        PaymentLine2.SetRange("Document Type","Document Type");
        PaymentLine2.SetRange("Document No.","No.");

        TempPaymentLine := PaymentLine;
        if PaymentLine.Find('+') then
          NextLineNo := PaymentLine."Line No." + 10000
        else
          NextLineNo := 10000;

        if PaymentLine2.Find('-') then
          repeat
            PaymentLine := PaymentLine2;
            PaymentLine."Document Type" := TempPaymentLine."Document Type" ;
            PaymentLine."Document No." := TempPaymentLine."Document No.";
            PaymentLine."Line No." := NextLineNo;
            PaymentLine."Cash Advance Amount" := PaymentLine2.Amount;
            PaymentLine."Cash Advance Amount (LCY)" := PaymentLine2."Amount (LCY)";
            PaymentLine.Amount := 0;
            PaymentLine."Amount (LCY)" := 0;
            PaymentLine.Insert;
            NextLineNo := NextLineNo + 10000 ;
          until PaymentLine2.Next = 0
    end;


    procedure AttachmentExists(): Boolean
    var
        PostedPaymentHeader: Record "Posted Payment Header";
    begin
        PostedPaymentHeader.SetRange("Retirement No.","No.");
        if PostedPaymentHeader.FindSet then
          exit(true)
        else
          exit(false);
    end;


    procedure ApplyCheck(CheckNo: Integer)
    begin
        "Check Entry No." := CheckNo;
        Modify;

        if PaymentLinesExist then
          repeat
            PaymentLine."Check Entry No." := CheckNo;
            PaymentLine.Modify;
          until PaymentLine.Next(1) = 0;
    end;

    local procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account";AccNo2: Code[20]): Boolean
    var
        BankAcc2: Record "Bank Account";
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
          if AccType2 = Acctype2::"Bank Account" then
            if BankAcc2.Get(AccNo2) then
              "Currency Code" := BankAcc2."Currency Code";
        exit("Currency Code" <> '');
    end;


    procedure DeletePaymentLines()
    begin
        if PaymentLine.FindSet then begin
          repeat
            PaymentLine.SuspendStatusCheck(true);
            PaymentLine.Delete(true);
          until PaymentLine.Next = 0;
        end;
    end;


    procedure CreateCommitment()
    var
        AnalysisView: Record "Analysis View";
    begin
        PmtMgtSetup.Get;
        if (PmtMgtSetup."Budget Expense Control Enabled") then begin
          AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
          with PaymentLine do begin
            SetRange("Document No.","No.");
            SetRange("Account Type","account type"::"G/L Account");
            SetFilter("Account No.",AnalysisView."Account Filter");
            if Find('-') then
             repeat
                if BudgetControlMgt.ControlBudget("Account No.") then
                  case PaymentLine."Document Type" of
                    "document type"::Retirement:
                      begin
                        if PaymentLine."Cash Advance Amount (LCY)" < PaymentLine."Amount (LCY)" then begin
                          BudgetControlMgt.UpdateCommitment("Document No.","Line No.",Rec."Document Date",("Amount (LCY)" - "Cash Advance Amount (LCY)"),
                            "Account No.","Dimension Set ID");
                        end;
                      end;
                    "document type"::"Payment Voucher":
                      begin
                        if "Payment Type" = "payment type":: Others then
                          BudgetControlMgt.UpdateCommitment("Document No.","Line No.",Rec."Document Date","Amount (LCY)",
                            "Account No.","Dimension Set ID");
                      end;
                    "document type"::"Cash Advance":
                      BudgetControlMgt.UpdateCommitment("Document No.","Line No.",Rec."Document Date","Amount (LCY)",
                        "Account No.","Dimension Set ID");
                  end;
            until Next = 0;
          end;
        end;
    end;


    procedure DeleteCommitment()
    var
        AnalysisView: Record "Analysis View";
    begin
        PmtMgtSetup.Get;
        if (PmtMgtSetup."Budget Expense Control Enabled") then begin
          AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
          with PaymentLine do begin
            SetRange("Document No.","No.");
            SetRange("Account Type","account type"::"G/L Account");
            SetFilter("Account No.",AnalysisView."Account Filter");
            if Find('-') then
              repeat
                if PaymentLine."Document Type" <> PaymentLine."document type"::Retirement then begin
                  if (PaymentLine."Request No." = '') and (PaymentLine."Payment Req. Line No." = 0) then
                    BudgetControlMgt.DeleteCommitment("Document No.","Line No.","Account No.");
                end else
                  BudgetControlMgt.DeleteCommitment("Document No.","Line No.","Account No.");
              until Next = 0;
          end;
        end;
    end;


    procedure CheckIfCashAdvAttached(): Boolean
    var
        PostedCashAdv: Record "Posted Payment Header";
    begin
        PostedCashAdv.SetRange("Voucher No.","No.");
        if PostedCashAdv.FindFirst then
          exit(true)
        else
          exit(false);
    end;


    procedure CheckBudgetLimit()
    var
        RecRef: RecordRef;
        AnalysisView: Record "Analysis View";
        GLAccount: Record "G/L Account";
        TotalExpAmount: Decimal;
        TotalBudgetAmount: Decimal;
        TotalCommittedAmount: Decimal;
        Variance: Decimal;
        LineAmountLCY: Decimal;
        AboveBudget: Boolean;
        WorkflowMgt: Codeunit "Gems Workflow Event";
    begin
        PmtMgtSetup.Get;
        AboveBudget := false;
        if PmtMgtSetup."Budget Expense Control Enabled" then begin
          AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
          PaymentLine.SetRange("Document No.","No.");
          PaymentLine.SetRange("Account Type",PaymentLine."account type"::"G/L Account");
          PaymentLine.SetFilter("Account No.",AnalysisView."Account Filter");
          if PaymentLine.FindFirst then begin
            repeat
              if BudgetControlMgt.ControlBudget(PaymentLine."Account No.") then begin
                TotalExpAmount := 0;
                TotalBudgetAmount  := 0;
                TotalCommittedAmount  := 0;
                BudgetControlMgt.GetAmounts(PaymentLine."Dimension Set ID",Rec."Document Date",PaymentLine."Account No.",
                  TotalBudgetAmount,TotalExpAmount, TotalCommittedAmount);
                if TotalBudgetAmount = 0 then
                  AboveBudget := true;
                if "Document Type" in[1,2] then begin
                  if (TotalBudgetAmount <> 0) then begin
                    if ((TotalExpAmount + TotalCommittedAmount)  > TotalBudgetAmount) then
                      AboveBudget := true
                    else begin
                      LineAmountLCY := PaymentLine."Amount (LCY)" ;
                      if (TotalExpAmount + LineAmountLCY + TotalCommittedAmount ) >  TotalBudgetAmount then
                        AboveBudget := true;
                    end;
                  end;
                end else begin
                  if (TotalBudgetAmount <> 0) and (PaymentLine."Cash Advance Amount (LCY)" < PaymentLine."Amount (LCY)") then begin
                    if ((TotalExpAmount + TotalCommittedAmount)  > TotalBudgetAmount) then
                      AboveBudget := true
                    else begin
                      LineAmountLCY := PaymentLine."Amount (LCY)" - PaymentLine."Cash Advance Amount (LCY)"  ;
                      if (TotalExpAmount + LineAmountLCY + TotalCommittedAmount ) >  TotalBudgetAmount then
                       AboveBudget := true;
                    end;
                  end;
                end;
              end;
            until PaymentLine.Next = 0;
          end;
        end;
        RecRef.GetTable(Rec);
        if AboveBudget then
          WorkflowMgt.OnPaymentDocumentBudgetExceeded(RecRef)
        else
          WorkflowMgt.OnPaymentDocumentBudgetNotExceeded(RecRef);
    end;
}

