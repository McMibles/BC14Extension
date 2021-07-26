Table 52092157 "Payroll-Lookup Line"
{

    fields
    {
        field(1;TableId;Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2;"Lower Amount";Decimal)
        {
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                PayrollLookupHeader.Get(TableId);
                if PayrollLookupHeader.Type = 1 then
                  "Lower Amount" := 0;
            end;
        }
        field(3;"Upper Amount";Decimal)
        {
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                PayrollLookupHeader.Get( Rec.TableId);
                if PayrollLookupHeader.Type = 1 then
                  "Upper Amount" := 0;

                if PayrollLookupHeader.Type = 2 then
                  Validate("Tax Rate %");
            end;
        }
        field(4;"Lower Code";Code[20])
        {

            trigger OnValidate()
            begin
                PayrollLookupHeader.Get( Rec.TableId);
                if (PayrollLookupHeader.Type = 0) or (PayrollLookupHeader.Type = 2) then
                  "Lower Code" := '';
            end;
        }
        field(5;"Upper Code";Code[20])
        {

            trigger OnValidate()
            begin
                PayrollLookupHeader.Get( Rec.TableId);
                if (PayrollLookupHeader.Type = 0) or (PayrollLookupHeader.Type = 2) then
                  "Upper Code" := '';
            end;
        }
        field(8;"Extract Amount";Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                PayrollLookupHeader.Get( Rec.TableId);
                if (PayrollLookupHeader.Type = 2) then
                  "Extract Amount" := 0;
            end;
        }
        field(9;"Tax Rate %";Decimal)
        {
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                PayrollLookupHeader.Get(Rec.TableId);
                if (PayrollLookupHeader.Type = 0) or (PayrollLookupHeader.Type = 1) then
                begin
                  "Tax Rate %" := 0;
                  "Cum. Tax Payable" := 0
                end
                else begin
                  PayrollLookupLines.SetRange(TableId, TableId);
                  PayrollLookupLines.SetRange("Lower Code", '');
                  if not PayrollLookupLines.Find('-') then
                  begin
                    if "Upper Amount" <> 0 then
                      "Cum. Tax Payable" := (1/100 ) * ("Tax Rate %" *
                                            ("Upper Amount" - "Lower Amount"))
                  end
                  else begin

                    if PayrollLookupLines."Lower Amount" = "Lower Amount" then
                      PayrollLookupLines := Rec;

                    if PayrollLookupLines."Upper Amount" <> 0 then
                      PayrollLookupLines."Cum. Tax Payable" := (1/100 ) *
                      (PayrollLookupLines."Tax Rate %" * (PayrollLookupLines."Upper Amount"
                                                   - PayrollLookupLines."Lower Amount"))
                    else
                      PayrollLookupLines."Cum. Tax Payable" := 0;

                    if PayrollLookupLines."Lower Amount" = "Lower Amount" then
                      "Cum. Tax Payable" := PayrollLookupLines."Cum. Tax Payable"
                    else
                       PayrollLookupLines.Modify;
                    PrevRec := PayrollLookupLines;

                    if ( PayrollLookupLines.Next <> 0) then
                    repeat

                      if PayrollLookupLines."Lower Amount" = "Lower Amount" then
                        PayrollLookupLines := Rec;

                      if PayrollLookupLines."Upper Amount" = 0 then
                        PayrollLookupLines."Cum. Tax Payable" := 0
                      else
                      begin
                        PayrollLookupLines."Cum. Tax Payable" := (1/100 ) *
                        (PayrollLookupLines."Tax Rate %" * (PayrollLookupLines."Upper Amount" -
                                                     PrevRec."Upper Amount"));
                        PayrollLookupLines."Cum. Tax Payable" := PayrollLookupLines."Cum. Tax Payable" +
                                                           PrevRec."Cum. Tax Payable";
                      end;
                      if PayrollLookupLines."Lower Amount" = "Lower Amount" then
                        "Cum. Tax Payable" := PayrollLookupLines."Cum. Tax Payable"
                      else
                         PayrollLookupLines.Modify;
                      PrevRec := PayrollLookupLines;
                    until ( PayrollLookupLines.Next = 0)
                  end
                end
            end;
        }
        field(10;"Cum. Tax Payable";Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;TableId,"Lower Amount","Lower Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PayrollLookupHeader: Record "Payroll-Lookup Header";
        PayrollLookupLines: Record "Payroll-Lookup Line";
        PrevRec: Record "Payroll-Lookup Line";
        EmployeeRec: Record Employee;
}

