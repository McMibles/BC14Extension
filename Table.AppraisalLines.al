Table 52092225 "Appraisal Lines"
{
    PasteIsValid = false;

    fields
    {
        field(1;"Appraisal Period";Code[20])
        {
        }
        field(2;"Appraisal Type";Option)
        {
            OptionMembers = "Mid Year","Year End";
        }
        field(3;"Employee No.";Code[10])
        {
        }
        field(4;"Factor Code";Code[20])
        {
            TableRelation = "Appraisal Template Line".Code where ("Appraisal Type"=field("Appraisal Type"));

            trigger OnValidate()
            begin
                AppraisalFactor.Get("Factor Code","Appraisal Type");
                Description := AppraisalFactor.Description;
                Validate(Weight,AppraisalFactor.Weight);
            end;
        }
        field(5;Weight;Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0:2;
            Editable = false;

            trigger OnValidate()
            begin
                "Appraiser Weighted Score" := Weight * "Appraiser Score";
            end;
        }
        field(6;"Appraiser Score Code";Code[10])
        {
            TableRelation = "Score Setup".Code where ("Record Type"=const("Appraisal Score"));

            trigger OnValidate()
            var
                AppraisalLineScore: Decimal;
            begin
                if "Appraiser Score Code" <> '' then begin
                  AppraisalHeader.Get("Appraisal Period","Appraisal Type","Employee No.");
                  if (AppraisalHeader."Appraisal Ready")  then
                    Error(Text004);
                  if AppraisalSectionScore.Get("Section Code","Appraiser Score Code") then
                    AppraisalLineScore := AppraisalSectionScore.Marks
                  else begin
                    AppraisalScore.Get(1,"Appraiser Score Code");
                    AppraisalLineScore := AppraisalScore.Mark;
                  end;
                  if Weight <> 0 then
                    Validate("Appraiser Score",AppraisalLineScore)
                  else
                    begin
                      Message(Text003);
                      Rating := '';
                    end;
                end else
                  Validate("Appraiser Score",0);
            end;
        }
        field(7;"Appraiser Score";Decimal)
        {
            BlankZero = true;
            Editable = false;

            trigger OnValidate()
            begin
                "Appraiser Weighted Score" := Weight * "Appraiser Score";
                AppraisalSection.Reset;
                if AppraisalSection.Get("Section Code") then
                  "Appraiser Sectional Weight" := "Appraiser Weighted Score" * AppraisalSection."Sectional Weight";
            end;
        }
        field(8;"Appraiser Weighted Score";Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0:0;
        }
        field(9;Description;Text[80])
        {
            Editable = false;
        }
        field(10;"Section Code";Code[10])
        {
        }
        field(11;Rating;Code[10])
        {
        }
        field(12;"Appraiser Sectional Weight";Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0:2;
        }
        field(13;"Result Achieved";Text[30])
        {
        }
        field(14;"Achievement Date";Date)
        {
        }
        field(15;"Global Dimension 1 Code";Code[20])
        {
        }
        field(16;"Global Dimension 2 Code";Code[20])
        {
        }
        field(17;"Line No.";Integer)
        {
        }
        field(18;"Weighting %";Decimal)
        {
            BlankZero = true;
        }
        field(19;"Template Code";Code[10])
        {
        }
        field(20;"Grade Level Code";Code[10])
        {
            Editable = false;
            Enabled = true;
        }
        field(21;"Line Type";Option)
        {
            OptionCaption = 'Standard,Heading';
            OptionMembers = Standard,Heading;
        }
        field(22;"Appraisee Score Code";Code[10])
        {
            TableRelation = "Score Setup".Code where ("Record Type"=const("Appraisal Score"));

            trigger OnValidate()
            var
                AppraisalLineScore: Decimal;
            begin
                if "Appraisee Score Code" <> '' then begin
                  AppraisalHeader.Get("Appraisal Period","Appraisal Type","Employee No.");
                  if (AppraisalHeader."Appraisal Ready")  then
                    Error(Text004);
                  if AppraisalSectionScore.Get("Section Code","Appraisee Score Code") then
                    AppraisalLineScore := AppraisalSectionScore.Marks
                  else begin
                    AppraisalScore.Get(1,"Appraisee Score Code");
                    AppraisalLineScore := AppraisalScore.Mark;
                  end;
                  if Weight <> 0 then
                    Validate("Appraisee Score",AppraisalLineScore)
                  else
                    begin
                      Message(Text003);
                      Rating := '';
                    end;
                end else
                  Validate("Appraisee Score",0);
            end;
        }
        field(23;"Appraisee Score";Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                "Appraisee Weighted Score" := Weight * "Appraisee Score";
                AppraisalSection.Reset;
                if AppraisalSection.Get("Section Code") then
                  "Appraisee Sectional Weight" := "Appraisee Weighted Score" * AppraisalSection."Sectional Weight";
            end;
        }
        field(24;"Appraisee Sectional Weight";Decimal)
        {
            BlankZero = true;
        }
        field(25;"Appraisee Weighted Score";Decimal)
        {
            BlankZero = true;
        }
    }

    keys
    {
        key(Key1;"Appraisal Period","Appraisal Type","Employee No.","Section Code","Line No.")
        {
            Clustered = true;
            SumIndexFields = "Appraiser Weighted Score","Appraiser Sectional Weight";
        }
        key(Key2;"Appraisal Period","Global Dimension 1 Code","Global Dimension 2 Code")
        {
            SumIndexFields = "Appraiser Sectional Weight";
        }
        key(Key3;"Appraisal Period","Appraisal Type","Employee No.","Factor Code")
        {
        }
        key(Key4;"Section Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        AppraisalHeader.Get("Appraisal Period","Appraisal Type","Employee No.");
        if (AppraisalHeader.Closed)  then
          Error(Text001);
    end;

    var
        AppraisalHeader: Record "Appraisal Header";
        AppraisalFactor: Record "Appraisal Template Line";
        AppraisalSectionScore: Record "Appraisal Section Score";
        AppraisalScore: Record "Score Setup";
        AppraisalSection: Record "Appraisal Section";
        Text001: label 'Applied Appraisals cannot be modified!';
        Text002: label '%1 Is Not Allowed For''+ '' ''+ ''%2';
        Text003: label 'Rating Not Allowed For Current Line!';
        ScoreSetup: Record "Score Setup";
        Text004: label 'Submitted Appraisals cannot be modified!';
}

