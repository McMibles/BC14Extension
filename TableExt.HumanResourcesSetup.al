TableExtension 52000062 tableextension52000062 extends "Human Resources Setup" 
{
    fields
    {
        field(52092186;"Job Title Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092187;"AutoUpdate Payroll Employee";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092188;"Employee Absence No.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092189;"Applicant Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092190;"Vacancy Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092191;"Document Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092192;"Interview Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092193;"Travel Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092194;"Referee Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092195;"Query Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092196;"Annual Leave Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence";
        }
        field(52092197;"Casual Leave Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence";
        }
        field(52092198;"Min. Day(s) for Leave Allow.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52092199;"Training Schedule Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092200;"Appraisal Template Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092201;"Interview Score Recording";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'By Interviewers, By HR';
            OptionMembers = "By Interviewers"," By HR";
        }
        field(52092202;"Document Temp. Storage Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Embedded,"Disk File";
        }
        field(52092203;"Document Temp. Storage Path";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52092204;"AutoUpdatePayroll Employee";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092205;"Exit No.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092206;"Travel Line Schedule Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092207;"Travel Tolerance Day(s)";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52092208;"Leave Allowance Payment Option";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Payroll,Voucher';
            OptionMembers = Payroll,Voucher;
        }
        field(52092209;"Req. Month for Leave Allow.";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092210;"Employee Update Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}

