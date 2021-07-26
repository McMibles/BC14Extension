Table 52092304 "Posted Cash Lodgement"
{

    fields
    {
        field(1;"No.";Code[20])
        {
        }
        field(2;Description;Text[100])
        {
        }
        field(4;"Lodgement Document No.";Code[20])
        {
        }
        field(5;"Lodgement Type";Option)
        {
            OptionCaption = ' ,Cash,Cheque,Draft';
            OptionMembers = " ",Cash,Cheque,Draft;
        }
        field(8;"Last Modified By ID";Code[50])
        {
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;"Document Date";Date)
        {
        }
        field(14;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(15;"User ID";Code[50])
        {
        }
        field(17;"No. Series";Code[10])
        {
        }
        field(18;"Account Type";Option)
        {
            Editable = false;
            InitValue = "Bank Account";
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(19;"Account No.";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(20;"Currency Code";Code[10])
        {
            TableRelation = Currency;
        }
        field(21;"Amount (LCY)";Decimal)
        {
            Editable = false;
        }
        field(22;"Currency Factor";Decimal)
        {
        }
        field(23;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(24;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(25;"Dimension Set ID";Integer)
        {
        }
        field(30;"Transaction Time";Time)
        {
        }
        field(31;"Last Date-Time Modified";DateTime)
        {
        }
        field(35;"Date Lodged";Date)
        {
        }
        field(36;"Bank Lodged";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(39;"Creation Date";Date)
        {
        }
        field(40;"Responsibility Center";Code[10])
        {
            TableRelation = "Responsibility Center";
        }
        field(43;"Entry Status";Option)
        {
            Editable = false;
            OptionCaption = ' ,Voided,Posted,Financially Voided';
            OptionMembers = " ",Voided,Posted,"Financially Voided";
        }
        field(60;"Voided By";Code[50])
        {
        }
        field(61;"Date-Time Voided";DateTime)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2',TableCaption,"No."));
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Date Lodged","No.");
        NavigateForm.Run;
    end;
}

