Page 52092467 "Travel Request-Admin"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Travel Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Enabled = false;
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(Beneficiary; Beneficiary)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeName; "Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Designation; Designation)
                {
                    ApplicationArea = Basic;
                }
                field(ManagerNo; "Manager No.")
                {
                    ApplicationArea = Basic;
                }
                field(TravelType; "Travel Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DocumentDate; "Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DepartureDate; "Departure Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ReturnDate; "Return Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrencyCode; "Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(TotalAllowanceCost; "Total Allowance Cost")
                {
                    ApplicationArea = Basic;
                }
                field(TotalAllowanceCostLCY; "Total Allowance Cost (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Admin)
            {
                field(Ticketed; Ticketed)
                {
                    ApplicationArea = Basic;
                }
                field(TicketVendor; "Ticket Vendor")
                {
                    ApplicationArea = Basic;
                }
                field(TicketAmountLCY; "Ticket Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(PurchaseInvoiceNo; "Purchase Invoice No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(VendorInvoiceNo; "Vendor Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field(VoucherFollowupStatus; "Voucher Follow-up Status")
                {
                    ApplicationArea = Basic;
                }
                field(AirportPickupProvided; "Airport Pickup Provided")
                {
                    ApplicationArea = Basic;
                }
                field(VisaProvided; "Visa Provided")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000015; "Travel Request Line")
            {
                Caption = 'Itinerary';
                Editable = false;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CloseRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Close Request';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TestField(Ticketed);
                    TestField("Ticket Vendor");
                    TestField("Ticket Amount (LCY)");

                    if not Confirm(Text002, false) then
                        Error(Text003);

                    TravelMgt.CreatePurchInvFromTravelReq(Rec);

                    CurrPage.Update;
                end;
            }
            separator(Action1000000027)
            {
            }
            action(CreateVoucher)
            {
                ApplicationArea = Basic;
                Caption = 'Create Voucher';
                Image = Voucher;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //TESTFIELD("Approved Pmt. Method");
                    //TESTFIELD("Voucher Paying Account");
                    TravelMgt.CreateVoucher(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //UpdateVoucherStatus;
    end;

    trigger OnOpenPage()
    begin
        UpdateVoucherStatus;
    end;

    var
        Text001: label 'Travel cost successfully created.';
        UserSetup: Record "User Setup";
        CalledFromApproval: Boolean;
        Text002: label 'Are you sure you have completed the processing of this request? ';
        Text003: label 'Please ensure that the request is fully processed before closing it';
        PaymentVoucherHeader: Record "Payment Header";
        PaymentVoucherHeader2: Record "Payment Header";
        PaymentVoucherHeader3: Record "Payment Header";
        Text004: label 'Action Aborted.';
        Text005: label 'Voucher processing by Finance not yet completed, Are you sure you want to complete the travel request?';
        TravelMgt: Codeunit "Travel Management";
        PaymentManagement: Codeunit PaymentManagement;
        [InDataSet]
        CreateVoucherVisible: Boolean;
        [InDataSet]
        PmtMethodVisible: Boolean;
        [InDataSet]
        PayingBankVisisble: Boolean;
        [InDataSet]
        PrePmtMethodVisible: Boolean;
        [InDataSet]
        PrePayingBankVisisble: Boolean;
        [InDataSet]
        PreferredBankCodeEditable: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        TravelRequest: Record "Travel Header";


    procedure "SetCalledFrom Approval"()
    begin
        CalledFromApproval := true;
    end;


    procedure UpdateVoucherStatus()
    begin
        /*PaymentVoucherHeader.SETRANGE(PaymentVoucherHeader."Travel Code","No.");
        PaymentVoucherHeader.SETRANGE(PaymentVoucherHeader."Entry Status",0);
        IF PaymentVoucherHeader.FINDLAST THEN
          "Voucher Status" := "Voucher Status"::"In-Process";
        
        PaymentVoucherHeader2.SETRANGE(PaymentVoucherHeader2."Travel Code","No.");
          IF PaymentVoucherHeader2.FINDFIRST THEN BEGIN
          IF ((PaymentVoucherHeader2.Void = TRUE) AND
          (PaymentVoucherHeader2."Document Status" <> PaymentVoucherHeader2."Document Status"::Paid))THEN
          "Voucher Status" := "Voucher Status"::Voided;
        END;
        PaymentVoucherHeader3.SETRANGE(PaymentVoucherHeader3."Travel Code","No.");
        IF PaymentVoucherHeader3.FINDFIRST THEN BEGIN
          IF ((PaymentVoucherHeader3.Void = FALSE) AND
          (PaymentVoucherHeader3."Document Status" = PaymentVoucherHeader3."Document Status"::Paid))THEN
          "Voucher Status" := "Voucher Status"::Completed;
        END;
        CurrPage.UPDATE(TRUE);*/

    end;
}

