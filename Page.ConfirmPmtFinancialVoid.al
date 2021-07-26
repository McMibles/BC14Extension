Page 52092660 "Confirm Pmt Financial Void"
{
    Caption = 'Confirm Financial Void';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            label(Control19)
            {
                ApplicationArea = Basic;
                //CaptionClass = FORMAT(Text002);
                //Editable = false;
            }
            field(VoidDate; VoidDate)
            {
                ApplicationArea = Basic;
                Caption = 'Void Date';

                trigger OnValidate()
                begin
                    if VoidDate < PostedPaymentHeader."Payment Date" then
                        Error(Text000, PostedPaymentHeader.FieldCaption("Payment Date"));
                end;
            }
            field(VoidType; VoidType)
            {
                ApplicationArea = Basic;
                Caption = 'Type of Void';
                OptionCaption = 'Unapply and void payment,Void payment only';

                trigger OnValidate()
                begin
                    case PostedPaymentHeader."Document Type" of
                        PostedPaymentHeader."document type"::Retirement:
                            begin
                                if VoidType <> 0 then
                                    Error(Text003);
                            end;
                    end;
                end;
            }
            group(Details)
            {
                Caption = 'Details';
                field(PaymentSource; PostedPaymentHeader."Payment Source")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Source';
                    Editable = false;
                    Visible = ShowSource;
                }
                field(DocumentNo; PostedPaymentHeader."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
                    Editable = false;
                }
                field(Amount; PostedPaymentHeader.Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    trigger OnOpenPage()
    begin
        with PostedPaymentHeader do begin
            VoidDate := "Payment Date";
            case PostedPaymentHeader."Payment Type" of
                0, 1:
                    VoidType := Voidtype::"Unapply and void document"
                else
                    VoidType := Voidtype::"Void document only";
            end;
        end;
        EnableFields;
    end;

    var
        PostedPaymentHeader: Record "Posted Payment Header";
        VoidDate: Date;
        VoidType: Option "Unapply and void document","Void document only";
        Text000: label 'Void Date must not be before the original %1.';
        Text001: label '%1 No.';
        Text002: label 'Do you want to void this document?';
        Text003: label 'Unapply and void document, must be selected for this type of transaction';
        [InDataSet]
        ShowSource: Boolean;


    procedure SetPostedPaymentHeader(var NewPostedPaymentHeader: Record "Posted Payment Header")
    begin
        PostedPaymentHeader := NewPostedPaymentHeader;
    end;


    procedure GetVoidDate(): Date
    begin
        exit(VoidDate);
    end;


    procedure GetVoidType(): Integer
    begin
        exit(VoidType);
    end;


    procedure InitializeRequest(VoidPaydate: Date; VoidPayType: Option)
    begin
        VoidDate := VoidPaydate;
        VoidType := VoidPayType;
    end;


    procedure EnableFields()
    begin
        ShowSource := PostedPaymentHeader."Document Type" = PostedPaymentHeader."document type"::"Payment Voucher"
    end;
}

