Table 52092197 "Skill Entry"
{

    fields
    {
        field(1;"Skill Code";Code[10])
        {
            NotBlank = true;
            TableRelation = Skill;

            trigger OnValidate()
            begin
                if "Skill Code" <> '' then begin
                  Skill.Get("Skill Code");
                  Description := Skill.Description;
                  if "Record Type" = "record type"::"Training Category" then
                    "Acquisition Method" := "acquisition method"::Training;
                end;
            end;
        }
        field(2;"Record Type";Option)
        {
            OptionCaption = 'Employee,Applicant,Job Title,Training Category,Courses Attended,Vacancy';
            OptionMembers = Employee,Applicant,"Job Title","Training Category","Courses Attended",Vacancy;
        }
        field(3;"No.";Code[20])
        {
        }
        field(4;"Line No.";Integer)
        {
        }
        field(8;Description;Text[40])
        {
            Editable = false;
        }
        field(9;"Institution/Company";Text[50])
        {
        }
        field(10;"From Date";Date)
        {
        }
        field(11;"To Date";Date)
        {
        }
        field(12;"Acquisition Method";Option)
        {
            OptionMembers = Education,Training,Talent,"On-the-Job","Informal Training","Self Acquired",Others;
        }
        field(13;Instructor;Text[30])
        {
        }
        field(14;Name;Text[30])
        {
        }
        field(15;"Employee Status";Option)
        {
            OptionMembers = Active,Inactive,Terminated;
        }
        field(16;Rating;Integer)
        {
        }
        field(17;"Training Required";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Record Type","No.","Line No.","Skill Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Skill: Record Skill;
}

