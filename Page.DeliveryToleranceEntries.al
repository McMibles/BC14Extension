Page 52092817 "Delivery Tolerance Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = "Delivery Tolerance Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo;"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType;"Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate;"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo;"External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType;"Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceNo;"Source No.")
                {
                    ApplicationArea = Basic;
                }
                field(DeliveryToleranceCode;"Delivery Tolerance Code")
                {
                    ApplicationArea = Basic;
                }
                field(OverdeliveryTolerance;"Overdelivery Tolerance %")
                {
                    ApplicationArea = Basic;
                }
                field(UnderdeliveryTolerance;"Underdelivery Tolerance %")
                {
                    ApplicationArea = Basic;
                }
                field(QtyperUnitofMeasure;"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode;"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(QuantityBase;"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingQuantity;"Outstanding Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingQuantityBase;"Outstanding Quantity (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(QtytoHandle;"Qty. to Handle")
                {
                    ApplicationArea = Basic;
                }
                field(QtytoHandleBase;"Qty. to Handle (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(OriginalQuantity;"Original Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(OriginalQuantityBase;"Original Quantity (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }


    procedure SetShow(lTableNumber: Integer;lCaption: Text)
    begin

        CurrPage.Caption := lCaption + ' - ' + CurrPage.Caption;
    end;
}

