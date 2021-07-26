TableExtension 52000069 tableextension52000069 extends "Warehouse Receipt Header"
{
    fields
    {
        field(52092342; "Received By"; Code[50])
        {
            TableRelation = "Warehouse Employee"."User ID" where("Location Code" = field("Location Code"));
        }
        field(52092343; "Inspected By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(52092344; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(52092345; "Creation DateTime"; DateTime)
        {
            Editable = false;
        }
        field(52092346; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(52092347; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = ToBeClassified;
            Description = 'If Invoice of receipt thru Whse';
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WhseSetup.GET;
    IF "No." = '' THEN BEGIN
      WhseSetup.TESTFIELD("Whse. Receipt Nos.");
      NoSeriesMgt.InitSeries(WhseSetup."Whse. Receipt Nos.",xRec."No. Series","Posting Date","No.","No. Series");
    END;
    #6..9
    VALIDATE("Bin Code",Location."Receipt Bin Code");
    VALIDATE("Cross-Dock Bin Code",Location."Cross-Dock Bin Code");
    "Posting Date" := WORKDATE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WhseSetup.GET;
    IF "No." = '' THEN BEGIN

      WhseHook.CheckBlankDocumentExist(Rec);

    #3..12

    //Gems
    "Creation DateTime" := CREATEDATETIME(TODAY,TIME);
    "User ID" := UPPERCASE(USERID);
    */
    //end;

    var
        WhseHook: Codeunit "Warehouse Hook";
}

