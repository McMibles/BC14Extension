Table 52092222 "Employee Appraisal Template"
{

    fields
    {
        field(1;"Section Code";Code[20])
        {
            TableRelation = "Appraisal Section";
        }
        field(2;"Group Code";Code[20])
        {
        }
        field(3;"Appraisal Type";Option)
        {
            OptionMembers = "Mid Year","Year End";
        }
        field(4;"Employee No.";Code[30])
        {
            TableRelation = Employee where ("Termination Date"=filter(''));

            trigger OnValidate()
            begin
                //Checking if there is any Certified template for d employee
                AppraisalGroup.Reset;
                AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
                AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
                AppraisalGroup.SetRange(AppraisalGroup."Employee No.","Employee No.");
                AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);
                if AppraisalGroup.Find('-') then
                begin
                  Message('Employee No %1 Already has a Certified Template For %2\'+
                  'Group Code is %3',"Employee No.",AppraisalGroup."Section Code",AppraisalGroup."Template Code");
                 "Employee No." := '';
                end;

                //Checking if employee already attached to a similar section and same appraisal type
                AttachEmployeeRec.Reset;
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Section Code","Section Code");
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Appraisal Type","Appraisal Type");
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Employee No.","Employee No.");
                if AttachEmployeeRec.Find('-') then
                 begin

                   Message('Employee No %1 already attached To %2\'+
                  'Group Code is %3',"Employee No.",AttachEmployeeRec."Section Code",AttachEmployeeRec."Group Code");
                 "Employee No." := '';

                  end;
            end;
        }
        field(5;Status;Option)
        {
            OptionMembers = " ","Under Development",Certified,InActive;
        }
    }

    keys
    {
        key(Key1;"Section Code","Group Code","Appraisal Type","Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        if AppraisalGroup.Find('-') then
        Status := AppraisalGroup.Status::Approved
    end;

    var
        AppraisalGroup: Record "Appraisal Template Header";
        AttachEmployeeRec: Record "Employee Appraisal Template";
}

