Table 52092310 "CashLite Trans Lines"
{

    fields
    {
        field(4; "Batch Number"; Code[12])
        {
            Description = 'Unique Batch Details no, Part of the Primary Key';
        }
        field(5; "Currency Code"; Code[3])
        {
        }
        field(6; "Bank CBN Code"; Code[6])
        {
            Editable = true;
            TableRelation = Bank;

            trigger OnValidate()
            begin
                if "Bank CBN Code" <> '' then begin
                    CBNBanks.Get("Bank CBN Code");
                    "Bank Name" := CBNBanks.Name;
                end;
            end;
        }
        field(16; "Reference Number"; Code[25])
        {
            Description = 'Unique Ref no., Part of the Primary Key';
            Editable = false;
        }
        field(17; TransactionType; Option)
        {
            OptionCaption = '50';
            OptionMembers = "50";
        }
        field(18; "To Account Number"; Code[30])
        {
        }
        field(19; "To Account Type"; Option)
        {
            OptionCaption = '10,20';
            OptionMembers = "10","20";
        }
        field(20; Amount; Decimal)
        {
        }
        field(21; Surcharge; Decimal)
        {
            Editable = false;
        }
        field(22; Description; Text[100])
        {
        }
        field(23; "Bank Name"; Text[50])
        {
            Editable = false;
        }
        field(26; "Interswitch Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Created,Error cannot process,In Queue/Still Processing,Processed Ok,Processed with Error';
            OptionMembers = "-1","0","1","2","3";
        }
        field(27; "Line No."; Integer)
        {
            Description = 'Part of the Primary Key';
        }
        field(28; "Date Created"; DateTime)
        {
            Editable = false;
        }
        field(29; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(30; "Last Modified By"; Code[50])
        {
            Editable = false;
        }
        field(31; "Last Modified Date"; DateTime)
        {
            Editable = false;
        }
        field(32; "Source No."; Code[20])
        {
        }
        field(33; "Source Type"; Option)
        {
            OptionCaption = 'Bank Account,Vendor,Staff,Customer,Import,Retieree,Pension Fund Administrator';
            OptionMembers = "Bank Account",Vendor,Staff,Customer,Import,Retieree,"Pension Fund Administrator";
        }
        field(34; Payee; Text[80])
        {
        }
        field(35; "Reference Type"; Option)
        {
            OptionCaption = ' ,Voucher,Payroll,Import';
            OptionMembers = " ",Voucher,Payroll,Import;
        }
        field(36; "Record ID"; RecordID)
        {
        }
        field(37; Posted; Boolean)
        {
        }
        field(38; "Old Reference Number"; Code[25])
        {
            Description = 'To keep the last reference no if copied to another batch';
            Editable = false;
        }
        field(39; "NIBSS Status"; Code[10])
        {
            Caption = 'Status';
            Editable = false;
        }
        field(40; "NIBSS Status Description"; Text[50])
        {
            Caption = ' Status Description';
            Editable = false;
        }
        field(41; "Reason Code"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(42; Processed; Boolean)
        {
        }
        field(43; "Payee No."; Code[30])
        {
            TableRelation = if ("Source Type" = filter(Staff)) Employee
            else
            if ("Source Type" = filter(Vendor)) Vendor
            else
            if ("Source Type" = filter(Customer)) Customer
            else
            if ("Source Type" = filter("Bank Account")) "Bank Account"
            else
            if ("Source Type" = filter("Pension Fund Administrator")) "Pension Administrator";
        }
        field(44; "Payee BVN"; Code[20])
        {
        }
        field(45; "Uploaded Schedule Page No."; Integer)
        {
            Description = 'This is the page number used to upload this record';
        }
        field(46; "Uploaded Schedule Serial No."; Integer)
        {
            Description = 'This is the serial number used to upload this record';
        }
        field(47; "Uploaded Status Text"; Text[50])
        {
        }
        field(48; "Uploaded Status Code"; Code[10])
        {
        }
        field(49; "Payment Batch"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Schedule Page No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Schedule Serial No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52; Stan; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Date Time Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Value Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(55; "From Account Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "From Bank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(57; "From Bank Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Batch Number", "Reference Number", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Batch Number", "Interswitch Status")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        /*
        CASE "Reference Type" OF
          1: BEGIN
              //RecdRef.OPEN(DATABASE::"Payment Header");
              //RecdRef.GET("Record ID");
              //RecdRef.SETTABLE(PaymentVoucher);
              PaymentVoucher.GET(CashLiteLine."Source No.");
              CashLiteLine.SETRANGE("Source No.",PaymentVoucher."No.");
              CashLiteLine.SETFILTER("Line No.",'<>%1',"Line No.");
              CashLiteLine.DELETEALL;
              PaymentVoucher."Payment Ref No." := '';
              PaymentVoucher.MODIFY;
              RecdRef.CLOSE;
          END;
          2: BEGIN
              //RecdRef.OPEN(DATABASE::"Payroll-Payslip Header");
              //RecdRef.GET("Record ID");
              //RecdRef.SETTABLE(PayrollHeader);
              PayrollHeader.GET(TransHeader."Payroll Period","Source No.");
              PayrollHeader.p := '';
              PayrollHeader.MODIFY;
              RecdRef.CLOSE;
          END;
        END;
        */

    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        if "Reference Number" = '' then begin
            CashLiteSetup.Get;
            CashLiteSetup.TestField(CashLiteSetup."Reference No. Series");
            NoSeriesMgt.InitSeries(CashLiteSetup."Reference No. Series", CashLiteSetup."Reference No. Series", 0D, "Reference Number",
                                    CashLiteSetup."Reference No. Series");
        end;

        "Date Created" := CreateDatetime(Today, Time);
        "Created By" := UserId;

        CashLiteSetup.Get;
        Surcharge := CashLiteSetup.Surcharge;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
        TransHeader.Get("Batch Number");
        if TransHeader.Submitted then
            Error(Text001, TransHeader."Batch Number");

        "Last Modified Date" := CreateDatetime(Today, Time);
        "Last Modified By" := UserId;
    end;

    trigger OnRename()
    begin
        TestStatusOpen;
        TransHeader.Get("Batch Number");
        if TransHeader.Submitted then
            Error(Text001, TransHeader."Batch Number");
    end;

    var
        BankRec: Record "Bank Account";
        CBNBanks: Record Bank;
        CashLiteSetup: Record "CashLite Setup";
        TransHeader: Record "CashLite Trans Header";
        PaymentVoucher: Record "Payment Header";
        PayrollHeader: Record "Payroll-Payslip Header";
        CashLiteLine: Record "CashLite Trans Lines";
        RecdRef: RecordRef;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'Batch Number %1 already submitted, Transaction cannot be modified';
        Text002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
        StatusCheckSuspended: Boolean;
        PaymentHeader: Record "Payment Header";
        Text003: label 'Batch Number %1 already Approved, Transaction cannot be modified';


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetCashLiteHeader;
        TransHeader.TestField(Status, TransHeader.Status::Open);
    end;


    procedure GetCashLiteHeader()
    begin
        TestField("Batch Number");
        if ("Batch Number" <> TransHeader."Batch Number") then
            TransHeader.Get("Batch Number");
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure ShowVoucher()
    var
        PaymentVouchers: Page "Payment Voucher";
        CashAdvances: Page "Cash Advances";
    begin
        RecdRef.Open(Database::"Payment Header");
        RecdRef.Get("Record ID");
        RecdRef.SetTable(PaymentVoucher);
        case PaymentVoucher."Document Type" of
            0:
                begin
                    PaymentVoucher.Reset;
                    PaymentVoucher.FilterGroup(2);
                    PaymentVoucher.SetRange(PaymentVoucher."No.", "Source No.");
                    PaymentVoucher.FilterGroup(0);
                    PaymentVouchers.SetTableview(PaymentVoucher);
                    PaymentVouchers.Editable := false;
                    PaymentVouchers.RunModal;
                end;
            1:
                begin
                    PaymentVoucher.Reset;
                    PaymentVoucher.FilterGroup(2);
                    PaymentVoucher.SetRange(PaymentVoucher."No.", "Source No.");
                    PaymentVoucher.FilterGroup(0);
                    CashAdvances.SetTableview(PaymentVoucher);
                    CashAdvances.Editable := false;
                    CashAdvances.RunModal;
                end;
        end;
        RecdRef.Close;
    end;
}

