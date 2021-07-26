Table 52092309 "CashLite Trans Header"
{
    // DrillDownPageID = "CashLite List";
    //LookupPageID = "CashLite List";

    fields
    {
        field(3; "Search Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Batch Number"; Code[20])
        {
            Description = 'Unique Batch Details no';
            Editable = false;
        }
        field(5; "Currency Code"; Code[3])
        {
            Editable = false;
        }
        field(6; "Bank CBN Code"; Code[6])
        {
            Editable = false;
        }
        field(7; "Bank Account Number"; Code[25])
        {
            Description = 'This is the corresponding bank account no';
            Editable = false;
        }
        field(15; "Record Count"; Integer)
        {
            CalcFormula = count("CashLite Trans Lines" where("Batch Number" = field("Batch Number")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Bank Name"; Text[100])
        {
            Editable = false;
        }
        field(25; Submitted; Boolean)
        {
        }
        field(26; "Submission Response Code"; Text[250])
        {
        }
        field(27; "Created by"; Code[50])
        {
            Editable = false;
        }
        field(28; "Submitted by"; Code[50])
        {
        }
        field(29; Confirmed; Boolean)
        {

            trigger OnValidate()
            begin
                if Submitted then Error(Text001);

                if Confirmed then begin
                    TransLine.SetCurrentkey("Batch Number", "Reference Number", "Line No.");
                    TransLine.SetRange(TransLine."Batch Number", "Batch Number");
                    if not TransLine.FindFirst then Error(Text003, "Batch Number");
                    repeat
                        TransLine.TestField(TransLine.Surcharge);
                    until TransLine.Next = 0;

                    TestField("Bank Account Code");
                    TestField("Bank CBN Code");
                    TestField("Bank Account Number");
                    TestField("Currency Code");
                    TestField(Description);
                    "Confirmed by" := UserId
                end else
                    "Confirmed by" := '';
            end;
        }
        field(30; "Confirmed by"; Code[50])
        {
            Editable = false;
        }
        field(31; "Date Created"; DateTime)
        {
            Editable = false;
        }
        field(32; "Date Submitted"; DateTime)
        {
        }
        field(33; "Last modified by"; Code[50])
        {
            Editable = false;
        }
        field(34; "Last Modified Date"; DateTime)
        {
            Editable = false;
        }
        field(35; "Bank Account Code"; Code[20])
        {
            Description = 'This is Navision''s bank account no.';
            // TableRelation = "CashLite Bank Mapping";

            trigger OnValidate()
            begin
                if "Bank Account Code" <> '' then begin
                    if CashLiteBankMapping.Get("Bank Account Code") then begin
                        //CashLiteBankMapping.TestField(Blocked, false);
                        "Bank CBN Code" := CashLiteBankMapping."Bank CBN Code";
                        "Bank Account Number" := CashLiteBankMapping."Bank Account No.";
                        "Bank Name" := CashLiteBankMapping.Name;
                        "Currency Code" := CashLiteBankMapping."CashLite Currency Code"
                    end;
                end else begin
                    "Bank CBN Code" := '';
                    "Bank Account Number" := '';
                    "Bank Name" := '';
                    "Currency Code" := '';
                end;
            end;
        }
        field(36; "Recipient Email"; Text[250])
        {
            Description = 'For Mail Notification';
        }
        field(37; Description; Text[100])
        {
        }
        field(38; "Total Amount"; Decimal)
        {
            CalcFormula = sum("CashLite Trans Lines".Amount where("Batch Number" = field("Batch Number")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(40; "Old Batch Number"; Code[12])
        {
            Description = 'To keep the last Batch No. if copied to another batch';
            Editable = false;
        }
        field(41; Processed; Integer)
        {
            CalcFormula = count("CashLite Trans Lines" where("Batch Number" = field("Batch Number"),
                                                              "Interswitch Status" = filter("-1" | "1" | "2")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; ClientID; Text[100])
        {
        }
        field(43; "API Platform"; Option)
        {
            OptionCaption = 'Interswitch,NIBSS,UBA,Bank Branch,GEMS';
            OptionMembers = Interswitch,NIBSS,UBA,"Bank Branch",GEMS;
        }
        field(44; "Check Status Response"; Text[250])
        {
            Editable = false;
        }
        field(45; "Check Status Response Code"; Text[30])
        {
        }
        field(46; "Submission Status Code"; Code[10])
        {
        }
        field(50; "Create Schedule Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Payroll-E/DCode"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                if "Payroll-E/DCode" <> '' then begin
                    PayrollEDRec.Get("Payroll-E/DCode");
                    Validate("Payroll E/D Description", PayrollEDRec.Description);
                end else
                    Clear("Payroll E/D Description");
            end;
        }
        field(50005; "Payroll E/D Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Closed Payroll(Yes/No)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50007; "Pension Administrator"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Pension Administrator";
        }
        field(50016; "Payroll Payment"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Salary,Other Payroll Deductions,Pension Remittance';
            OptionMembers = " ",Salary,"Other Payroll Deductions","Pension Remitance";

            trigger OnValidate()
            begin
                PayrollSetup.Get;
                PayrollSetup.TestField("Total Pension Contri. E/D");
                PayrollSetup.TestField(PayrollSetup."Net Pay E/D Code");
                case "Payroll Payment" of
                    "payroll payment"::"Pension Remitance":
                        begin
                            Validate("Payroll-E/DCode", PayrollSetup."Total Pension Contri. E/D");
                        end;
                    "payroll payment"::Salary:
                        begin
                            Validate("Payroll-E/DCode", PayrollSetup."Net Pay E/D Code");
                        end;
                end;
            end;
        }
        field(50017; "Multiple Remittance Period"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                PayrollSetup.Get;
                case "Payroll Payment" of
                    "payroll payment"::"Pension Remitance":
                        begin
                            Validate("Payroll-E/DCode", PayrollSetup."Total Pension Contri. E/D");
                        end;
                    "payroll payment"::Salary:
                        begin
                            Validate("Payroll-E/DCode", PayrollSetup."Net Pay E/D Code");
                        end;
                end;
            end;
        }
        field(50018; "Start Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-Period";
        }
        field(50019; "End Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-Period";
        }
        field(52132416; "Requery Status"; Text[50])
        {
        }
        field(52132417; "Total Pages In Schedule"; Integer)
        {
        }
        field(52132418; "Global Dimension 1 Code Desc"; Text[100])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Global Dimension 1 Code"),
                                                               "Global Dimension No." = const(1)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52132419; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = filter(false));
        }
        field(52132420; "Number of Upload Attempt"; Integer)
        {
        }
        field(52132421; "Related Batches"; Text[100])
        {
        }
        field(52132422; "Payroll Period"; Code[10])
        {
            TableRelation = "Payroll-Period";
        }
        field(52132423; "Payment Type"; Option)
        {
            OptionCaption = 'Supp. Invoice,Cust. Refund,,,Others,Remittance,Salary,Payroll Deductions,State Monthly Pensioners,LG Monthly Pension,Benefit Payment,Settlement,Contribution,Finance';
            OptionMembers = "Supp. Invoice","Cust. Refund",,,Others,Remittance,Salary,"Payroll Deductions","State Monthly Pensioners","LG Monthly Pension","Benefit Payment",Settlement,Contribution,Finance;
        }
    }

    keys
    {
        key(Key1; "Batch Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CashLiteSetup.Get;
        if "Batch Number" = '' then begin
            CashLiteSetup.TestField(CashLiteSetup."Batch No. Series");
            CashLiteSetup.TestField(CashLiteSetup."Payment Platform");
            NoSeriesMgt.InitSeries(CashLiteSetup."Batch No. Series", CashLiteSetup."Batch No. Series", 0D, "Batch Number",
                                   CashLiteSetup."Batch No. Series");
        end;
        if ClientID = '' then
            ClientID := CashLiteSetup."Client ID";
        "Date Created" := CreateDatetime(Today, Time);
        "Created by" := UserId;
        "API Platform" := CashLiteSetup."Payment Platform";

        //Added for kaduna
    end;

    trigger OnModify()
    begin
        if Submitted then Error(Text001, "Batch Number");

        "Last Modified Date" := CreateDatetime(Today, Time);
        "Last modified by" := UserId;
        CashLiteSetup.Get;
        CashLiteSetup.TestField(CashLiteSetup."Payment Platform");
        //"API Platform":= CashLiteSetup."Payment Platform";
    end;

    var
        BankRec: Record "Bank Account";
        CashLiteSetup: Record "CashLite Setup";
        TransLine: Record "CashLite Trans Lines";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'Batch Number %1 already submitted, Transaction cannot be modified';
        Text002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
        Text003: label 'Line does not exist for Batch Number %1';
        EnablePayrollPeriodField: Boolean;
        CashlitLn: Record "CashLite Trans Lines";
        FileName: Text;
        CashLiteBankMapping: Record "CashLite Bank Mapping";
        PayrollEDRec: Record "Payroll-E/D";
        PayrollSetup: Record "Payroll-Setup";
}

