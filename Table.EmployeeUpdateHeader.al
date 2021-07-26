Table 52092232 "Employee Update Header"
{
    DrillDownPageID = "Employee Update List";
    LookupPageID = "Employee Update List";

    fields
    {
        field(1;"Entry Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Promotion,Transfer,Salary Change,Upgrading,Redesignation,Redesignation/Transfer';
            OptionMembers = Promotion,Transfer,"Salary Change",Upgrading,Redesignation,"Redesignation/Transfer";
        }
        field(2;"Document No.";Code[20])
        {
            Editable = false;
        }
        field(3;Description;Text[50])
        {
        }
        field(4;Status;Option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(5;"User ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Document Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26;"No. Series";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(27;"Date Created";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Processed Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(29;"Processed By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Document No." = '' then begin
          HumanResSetup.Get;
          HumanResSetup.TestField(HumanResSetup."Employee Update Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Employee Update Nos.",xRec."No. Series",0D,"Document No.","No. Series");
        end;
        "User ID" := UserId;
        "Document Date" := WorkDate;
        "Date Created" := WorkDate;
    end;

    var
        Text001: label 'The Batch has unposted journals\Delete anyway?';
        Text002: label 'Batch cannot be deleted!';
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

