Table 52092346 "Purchase Req. Type"
{

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Type;Option)
        {
            OptionCaption = ' ,G/L Account,Item,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset","Charge (Item)";

            trigger OnValidate()
            begin
                if (xRec.Type <> Type) then
                  "Account No. Filter" := '';

                case Type of
                  2,4: "Order Type" := 0
                  else
                     "Order Type" := 1
                end;
            end;
        }
        field(5;"Account No. Filter";Text[250])
        {
            TableRelation = if (Type=const("G/L Account")) "G/L Account"
                            else if (Type=const(Item)) Item
                            else if (Type=const("Fixed Asset")) "Fixed Asset";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if ("Account No. Filter" <> '') and (Type = Type::Item) then begin
                  if "Item Category Filter" <> '' then
                    Error(Text006);
                end;
            end;
        }
        field(7;"Job No. Req.";Boolean)
        {
        }
        field(8;Description;Text[100])
        {
        }
        field(9;Blocked;Boolean)
        {
        }
        field(10;"Global Dimension 1 Filter";Text[250])
        {
            CaptionClass = '1,3,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11;"Global Dimension 2 Filter";Text[250])
        {
            CaptionClass = '1,3,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(12;"Minimum Order Amount";Decimal)
        {
        }
        field(13;"Order Type";Option)
        {
            OptionCaption = 'Invt PO,Service PO';
            OptionMembers = "Invt PO","Service PO";
        }
        field(14;"Item Category Filter";Text[250])
        {

            trigger OnValidate()
            begin
                if "Item Category Filter" <> '' then begin
                  TestField(Type,Type::Item);
                  if "Account No. Filter" <> '' then
                    Error(Text005);
                end;
            end;
        }
        field(15;Route;Option)
        {
            OptionCaption = 'PO,Invoice';
            OptionMembers = PO,Invoice;

            trigger OnValidate()
            begin
                if Route = Route::Invoice then
                  TestField("Order Type","order type"::"Service PO");
            end;
        }
        field(16;"Allow RFQ to PO";Boolean)
        {
        }
        field(17;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(18;"Responsibility Center";Code[10])
        {
            Caption = 'Procurement Unit';
            TableRelation = "Responsibility Center";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Type,Description,"Account No. Filter","Item Category Filter")
        {
        }
    }

    var
        Text001: label 'Invalid Type Selection! ';
        Text002: label 'Order below %1 %2 not allowed for %3 order creation.';
        Text003: label 'Account Code %1 not allowd for %2.';
        Text004: label '%1 Code %2 not allowed for code %3!';
        GLSetup: Record "General Ledger Setup";
        EntryError: label '%1 must not be blank';
        RepCentre: Record "Responsibility Center";
        Text005: label 'Account No. Filter must be blank';
        Text006: label 'Item Category Filter must be blank';
        DimMgt: Codeunit DimensionManagement;
        DimMgtHook: Codeunit "Dimension Hook";


    procedure ValidateDimCode(FieldNo: Integer;DimCode: Code[20])
    var
        DimValue: Record "Dimension Value";
        DimensionCode: Code[20];
        CodeExist: Boolean;
    begin
        if (DimCode = '') then
          exit;

        DimValue.Reset;
        DimValue.SetRange("Global Dimension No.",FieldNo);
        case FieldNo of
          1 : begin
            if "Global Dimension 1 Filter" = '' then
              exit
            else
              DimValue.SetFilter(DimValue.Code,"Global Dimension 1 Filter");
          end;
          2 : begin
            if "Global Dimension 2 Filter" = '' then
              exit
            else
              DimValue.SetFilter(DimValue.Code,"Global Dimension 2 Filter");
          end else
            exit;
        end;

        CodeExist := false;
        if DimValue.Find('-') then begin
          DimensionCode := DimValue."Dimension Code";
          repeat
            CodeExist := (DimValue.Code = DimCode);
          until CodeExist or (DimValue.Next = 0);
        end;

        if not CodeExist then
          Error(Text004,DimensionCode,DimCode,Code);
    end;


    procedure ValidateAccountNo(ReqType: Option " ","Account (G/L)",Item,"Fixed Asset","Charge (Item)";AccountNo: Code[20])
    var
        CodeExist: Boolean;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FA: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";
    begin
        case Type of
          0 : if ReqType <> 1 then                                        // blank - no restriction
                exit;
          1,3: if (ReqType <> Type) and (ReqType <> 0) then
                Error(Text001);
          2,4 : if not (ReqType in [0,2,4]) then
                Error(Text001);
        end;

        if (AccountNo = '') then
          exit;

        if "Account No. Filter" = '' then
          exit;

        CodeExist := false;

        case Type of
          0,1 : begin
            GLAcc.Reset;
            GLAcc.SetFilter(GLAcc."No.","Account No. Filter");
            if GLAcc.Find('-') then
              repeat
                if GLAcc."No." = AccountNo then
                  CodeExist := true;
              until GLAcc.Next = 0;
          end;
          2 : begin
            Item.Reset;
            Item.SetFilter(Item."No.","Account No. Filter");
            if Item.Find('-') then
              repeat
                if Item."No." = AccountNo then
                  CodeExist := true;
              until Item.Next = 0;
          end;
          3 : begin
            FA.Reset;
            FA.SetFilter(FA."No.","Account No. Filter");
            if FA.Find('-') then
              repeat
                if FA."No." = AccountNo then
                  CodeExist := true;
              until FA.Next = 0;
          end;
          4 : begin
            ItemCharge.Reset;
            ItemCharge.SetFilter(ItemCharge."No.","Account No. Filter");
            if ItemCharge.Find('-') then
              repeat
                if ItemCharge."No." = AccountNo then
                  CodeExist := true;
              until ItemCharge.Next = 0;
          end;
          else
            exit;
        end;

        if not CodeExist then
          Error(Text003,AccountNo,Code);
    end;


    procedure ValidateItemCategory(ReqType: Option " ","Account (G/L)",Item,"Fixed Asset","Charge (Item)";AccountNo: Code[20])
    var
        CodeExist: Boolean;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FA: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";
    begin
        if (AccountNo = '') then
          exit;

        if "Item Category Filter" = '' then
          exit;

        CodeExist := false;

        case Type of
          2 : begin
            Item.Reset;
            Item.SetFilter("Item Category Code","Item Category Filter");
            if Item.Find('-') then
              repeat
                if Item."No." = AccountNo then
                  CodeExist := true;
              until Item.Next = 0;
          end;
          else
            exit;
        end;

        if not CodeExist then
          Error(Text003,AccountNo,Code);
    end;


    procedure CheckOrderRequirement(OrderAmount: Decimal)
    begin
        if ("Minimum Order Amount" = 0) or (OrderAmount = 0) then
          exit;

        GLSetup.Get;
        if OrderAmount < "Minimum Order Amount" then
          Error(Text002,"Minimum Order Amount",GLSetup."LCY Code",Code);
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    end;
}

