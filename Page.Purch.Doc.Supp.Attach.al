Page 52092813 "Purch. Doc./Supp. Attach"
{
    PageType = List;
    SourceTable = "Purch. Doc./Supp. Combination";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(VendorNo;"Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(VendorName;"Vendor Name")
                {
                    ApplicationArea = Basic;
                }
                field(VendorAddress;"Vendor Address")
                {
                    ApplicationArea = Basic;
                }
                field(VendorAddress2;"Vendor Address2")
                {
                    ApplicationArea = Basic;
                }
                field(VendorPhoneNo;"Vendor Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(RegisteredVendorNo;"Registered Vendor No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

