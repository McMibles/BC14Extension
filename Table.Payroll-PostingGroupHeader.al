Table 52092150 "Payroll-Posting Group Header"
{
    // Created           : FTN, 143/93
    // File name         : KI03 P.Booking Grps.
    // Comments          : The Header card that is to be used to enter booking
    //                     groups
    // File details      : Primary Key is;
    //                      Code
    //                   : Relations;
    //                      None

    LookupPageID = "Posting Group List";

    fields
    {
        field(1;"Posting Group Code";Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                if (1 < CursorPos) and (CursorPos < MaxStrLen("Search Name")) then
                begin
                  "Search Name" := DelChr (CopyStr("Posting Group Code", CursorPos),'<>');
                  "Search Name" := PadStr ("Search Name" + ' ' + DelChr (CopyStr("Posting Group Code", 1, CursorPos-1), '<>'), MaxStrLen(
                "Search Name"));
                end
                else
                  "Search Name" := "Posting Group Code";
                "Search Name" := DelChr ("Search Name", '<');
            end;
        }
        field(2;"Search Name";Code[20])
        {
        }
        field(3;Description;Text[30])
        {
        }
        field(4;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(5;"New Posting Group";Code[20])
        {
        }
        field(6;"Service Scope";Option)
        {
            OptionCaption = 'Self Company,Group';
            OptionMembers = "Self Company",Group;
        }
    }

    keys
    {
        key(Key1;"Posting Group Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /* Confirm */
        if not Confirm ('All entries for this booking group '+
                        'will be deleted!'+
                        'Proceed with Deletion?    ')
        then
          Error ('Nothing was deleted');
        
        /* Lock 'parent' and 'child' files*/
        if RECORDLEVELLOCKING then
          LockTable(true)
        else
         LockTable( false);
        
        if RECORDLEVELLOCKING then
          BookGrpLinesRec.LockTable(true)
        else
          BookGrpLinesRec.LockTable( false);
        
        /* First delete the detail lines */
         BookGrpLinesRec.SetRange("Posting Group", "Posting Group Code");
         BookGrpLinesRec.DeleteAll;
        
        /* Disable the locking effect */
        Commit ;

    end;

    var
        BookGrpLinesRec: Record "Payroll-Posting Group Line";
        CursorPos: Integer;
}

