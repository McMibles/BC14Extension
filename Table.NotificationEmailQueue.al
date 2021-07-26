Table 52092139 "Notification Email Queue"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2;"From Name";Text[100])
        {
            Caption = 'From Name';
            DataClassification = ToBeClassified;
        }
        field(3;"From Address";Text[250])
        {
            Caption = 'From Address';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
            end;
        }
        field(4;"Send to";Text[250])
        {
            Caption = 'Send to';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ;
            end;
        }
        field(5;"Send CC";Text[250])
        {
            Caption = 'Send CC';
            DataClassification = ToBeClassified;
        }
        field(6;"Send BCC";Text[250])
        {
            Caption = 'Send BCC';
            DataClassification = ToBeClassified;
        }
        field(7;Subject;Text[250])
        {
            Caption = 'Subject';
            DataClassification = ToBeClassified;
        }
        field(8;Body;Blob)
        {
            Caption = 'Body';
            DataClassification = ToBeClassified;
        }
        field(9;"Attachment File Path";Text[250])
        {
            Caption = 'Attachment File Path';
            DataClassification = ToBeClassified;
        }
        field(10;"Attachment Name";Text[250])
        {
            Caption = 'Attachment Name';
            DataClassification = ToBeClassified;
        }
        field(11;"Plaintext Formatted";Boolean)
        {
            Caption = 'Plaintext Formatted';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(12;"Body File Path";Text[250])
        {
            Caption = 'Body File Path';
            DataClassification = ToBeClassified;
        }
        field(13;"Message Type";Option)
        {
            Caption = 'Message Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Custom Message,From Email Body Template';
            OptionMembers = "Custom Message","From Email Body Template";
        }
        field(14;"Sending Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Sending Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(16;Status;Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Processed,Error';
            OptionMembers = " ",Processed,Error;
        }
        field(17;"Document Type";Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Service Order';
            OptionMembers = " ","Service Order";
        }
        field(18;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        NotifEmailQueue: Record "NAV Mobile User Setup";
    begin
        /*IF "Mobile Administrator ID" = 0 THEN BEGIN
          NotifEmailQueue.RESET;
          IF NotifEmailQueue.FINDLAST THEN
            "Mobile Administrator ID" := NotifEmailQueue."Mobile Administrator ID" + 1
          ELSE
            "Mobile Administrator ID" := 1;
        END;
        */
        "Sending Date" := Today;
        "Sending Time" := Time;

    end;


    procedure ScheduleInJobQueue()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Init;
        JobQueueEntry.Validate("Object Type to Run",JobQueueEntry."object type to run"::Codeunit);
        JobQueueEntry.Validate("Object ID to Run",Codeunit::"Process Notif Email Queue");
        JobQueueEntry.Validate("Record ID to Process",RecordId);
        Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
    end;
}

