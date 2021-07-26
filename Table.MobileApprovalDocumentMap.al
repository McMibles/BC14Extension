Table 52092137 "Mobile Approval Document Map"
{
    Caption = 'Mobile Approval Document- Report  Mapping';

    fields
    {
        field(1;"Page ID";Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where ("Object Type"=const(Page));
        }
        field(2;"Page Name";Text[50])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where ("Object ID"=field("Page ID"),
                                                                        "Object Type"=const(Page)));
            FieldClass = FlowField;
        }
        field(3;"Report ID";Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where ("Object Type"=const(Report));
        }
        field(4;"Report Name";Text[50])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where ("Object ID"=field("Report ID"),
                                                                        "Object Type"=const(Report)));
            FieldClass = FlowField;
        }
        field(5;TemBlob;Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Page ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

