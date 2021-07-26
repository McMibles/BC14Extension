Table 52092343 "Purch. Doc./Supp. Combination"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = 'Requisition,Quote';
            OptionMembers = Requisition,Quote;
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;"Vendor No.";Code[20])
        {
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Vendor No." <> '' then begin
                  TestField(Confirmed,false);
                  case "Document Type" of
                    "document type"::Quote: begin
                      Vendor.Get("Vendor No.");
                      "Vendor Name" := Vendor.Name;
                      "Vendor Address" := Vendor.Address;
                      "Vendor Address2" := Vendor."Address 2" ;
                      "Vendor Phone No."  := Vendor."Phone No.";
                      "Registered Vendor No." := Vendor."No.";
                      Vendor.TestField(Name);
                      Vendor.TestField(Blocked,0);
                      Vendor.TestField("Gen. Bus. Posting Group");
                      Vendor.TestField("VAT Bus. Posting Group");
                      Vendor.TestField("Vendor Posting Group");
                      Confirmed := true;
                      Priority := Vendor.Priority;
                    end;
                    "document type"::Requisition: begin
                      if Vendor.Get("Vendor No.") then begin
                        "Vendor Name" := Vendor.Name;
                        "Vendor Address" := Vendor.Address;
                        "Vendor Address2" := Vendor."Address 2" ;
                        "Vendor Phone No."  := Vendor."Phone No.";
                        "Registered Vendor No." := Vendor."No.";
                        Vendor.TestField(Name);
                        Vendor.TestField(Blocked,0);
                        Vendor.TestField("Gen. Bus. Posting Group");
                        Vendor.TestField("VAT Bus. Posting Group");
                        Vendor.TestField("Vendor Posting Group");
                        Confirmed := true;
                        Priority := Vendor.Priority;
                      end;
                    end;
                  end;
                end else
                  Priority := 0;

                "User ID" := UserId;
            end;
        }
        field(4;Status;Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Cancelled,LPO Raised';
            OptionMembers = Open,"Pending Approval",Approved,Cancelled,"LPO Raised";
        }
        field(5;"User ID";Code[50])
        {
        }
        field(6;Confirmed;Boolean)
        {
        }
        field(7;Priority;Integer)
        {
        }
        field(8;"RFQ No.";Code[20])
        {
        }
        field(9;"Vendor Name";Text[50])
        {
        }
        field(10;"Vendor Address";Text[50])
        {
        }
        field(11;"Vendor Address2";Text[50])
        {
        }
        field(12;"Vendor Phone No.";Text[30])
        {
        }
        field(13;"Registered Vendor No.";Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if "Registered Vendor No." <> '' then begin
                  PurchVendor.SetRange("Document No.","Document No.");
                  PurchVendor.SetFilter("Vendor No.",'<>%1',"Vendor No.");
                  PurchVendor.SetRange("Registered Vendor No.","Registered Vendor No.");
                  if PurchVendor.FindFirst then
                    Error(Text006,PurchVendor."Registered Vendor No.");
                end;
                if Confirmed = false then
                  Confirmed := true
                else begin
                  if Vendor.Get("Vendor No.") then
                    Error(Text003)
                end;
            end;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Document No.","Vendor No.","Vendor Name")
        {
        }
    }

    var
        Vendor: Record Vendor;
        Text001: label 'You can not Change the Priority Level Set By %1';
        Text002: label 'Vendor with status %1 cannot be used for this type of document. Contact your Procurement Manager for Assistance.';
        PurchVendor: Record "Purch. Doc./Supp. Combination";
        Text003: label 'Reqistered vendor  cannot be changed';
        Text006: label 'Reqistered vendor %1 already Exist!';
}

