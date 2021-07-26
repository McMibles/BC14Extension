Table 52092192 "Leave Schedule Header"
{

    fields
    {
        field(1;"Year No.";Integer)
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"Manager No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(4;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(5;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(6;"No. of Days Entitled";Decimal)
        {
            CalcFormula = sum("Employee Absence"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                          "Employee No."=field("Employee No."),
                                                                          "Year No."=field("Year No."),
                                                                          "Opening/Closing Entry"=const(Opening)));
            FieldClass = FlowField;
        }
        field(7;"No. of Days B/F";Decimal)
        {
            CalcFormula = sum("Employee Absence"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                          "Employee No."=field("Employee No."),
                                                                          "From Date"=field("Date Filter"),
                                                                          "Year No."=field("Year Filter")));
            FieldClass = FlowField;
        }
        field(8;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(9;"No. of Days Utilised";Decimal)
        {
            CalcFormula = -sum("Employee Absence"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                           "Employee No."=field("Employee No."),
                                                                           "Year No."=field("Year No."),
                                                                           "Entry Type"=const(Application)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;Closed;Boolean)
        {
        }
        field(11;"Absence Code";Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(12;"Leave Allowance %";Decimal)
        {
        }
        field(13;"Employment Date";Date)
        {
        }
        field(15;"No. of Approved Committed Days";Decimal)
        {
            CalcFormula = sum("Leave Application"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                           "Employee No."=field("Employee No."),
                                                                           "Year No."=field("Year No."),
                                                                           "Entry Type"=const(Application),
                                                                           Status=filter(Approved)));
            FieldClass = FlowField;
        }
        field(16;"Employee Name";Text[100])
        {
        }
        field(17;"No. of Days Added";Decimal)
        {
            CalcFormula = sum("Employee Absence"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                          "Employee No."=field("Employee No."),
                                                                          "Year No."=field("Year No."),
                                                                          "Entry Type"=const("Positive Adjustment"),
                                                                          "Opening/Closing Entry"=const(" ")));
            FieldClass = FlowField;
        }
        field(18;"No. of Days Subtracted";Decimal)
        {
            CalcFormula = -sum("Employee Absence"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                           "Employee No."=field("Employee No."),
                                                                           "Year No."=field("Year No."),
                                                                           "Entry Type"=const("Negative Adjustment")));
            FieldClass = FlowField;
        }
        field(19;"No. of Days Committed";Decimal)
        {
            CalcFormula = sum("Leave Application"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                           "Employee No."=field("Employee No."),
                                                                           "Year No."=field("Year No."),
                                                                           "Entry Type"=const(Application),
                                                                           Status=filter("Pending Approval"|Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(21;"Year Filter";Integer)
        {
            FieldClass = FlowFilter;
        }
        field(22;Balance;Decimal)
        {
            CalcFormula = sum("Employee Absence"."Quantity (Base)" where ("Cause of Absence Code"=field("Absence Code"),
                                                                          "Employee No."=field("Employee No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Year No.","Employee No.","Absence Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

