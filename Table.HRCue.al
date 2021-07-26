Table 52092218 "HR Cue"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
        }
        field(2;"Emp. Req. Pending Approval";Integer)
        {
            CalcFormula = count("Employee Requisition" where (Status=filter(Open|"Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Approved Emp. Req.";Integer)
        {
            CalcFormula = count("Employee Requisition" where (Status=filter(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Exit Doc. Pending Approval";Integer)
        {
            CalcFormula = count("Employee Exit" where (Status=filter(Open|Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Approved Exit Doc.";Integer)
        {
            CalcFormula = count("Employee Exit" where (Status=filter(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Leave App. Pending Approval";Integer)
        {
            CalcFormula = count("Leave Application" where (Status=filter("Pending Approval"),
                                                           "Entry Type"=const(Application)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Approved Leave Application";Integer)
        {
            CalcFormula = count("Leave Application" where (Status=filter(Approved),
                                                           "Entry Type"=const(Application)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Query Awaiting Action";Integer)
        {
            CalcFormula = count("Employee Query Entry" where (Status=const("Awaiting HR Action")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

