Table 52092132 "Default Dim Value  Multiple"
{
    Caption = 'Default Dimension';

    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = Object.ID where (Type=const(Table));

            trigger OnLookup()
            var
                TempAllObjWithCaption: Record AllObjWithCaption temporary;
            begin
                Clear(TempAllObjWithCaption);
                DimMgt.DefaultDimObjectNoList(TempAllObjWithCaption);
                if Page.RunModal(Page::Objects,TempAllObjWithCaption) = Action::LookupOK then begin
                  "Table ID" := TempAllObjWithCaption."Object ID";
                  Validate("Table ID");
                end;
            end;

            trigger OnValidate()
            var
                TempAllObjWithCaption: Record AllObjWithCaption temporary;
            begin
                CalcFields("Table Caption");
                DimMgt.DefaultDimObjectNoList(TempAllObjWithCaption);
                TempAllObjWithCaption."Object Type" := TempAllObjWithCaption."object type"::Table;
                TempAllObjWithCaption."Object ID" := "Table ID";
                if not TempAllObjWithCaption.Find then
                  FieldError("Table ID");
            end;
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = if ("Table ID"=const(13)) "Salesperson/Purchaser"
                            else if ("Table ID"=const(15)) "G/L Account"
                            else if ("Table ID"=const(18)) Customer
                            else if ("Table ID"=const(23)) Vendor
                            else if ("Table ID"=const(27)) Item
                            else if ("Table ID"=const(152)) "Resource Group"
                            else if ("Table ID"=const(156)) Resource
                            else if ("Table ID"=const(167)) Job
                            else if ("Table ID"=const(270)) "Bank Account"
                            else if ("Table ID"=const(413)) "IC Partner"
                            else if ("Table ID"=const(5071)) Campaign
                            else if ("Table ID"=const(5200)) Employee
                            else if ("Table ID"=const(5600)) "Fixed Asset"
                            else if ("Table ID"=const(5628)) Insurance
                            else if ("Table ID"=const(5903)) "Service Order Type"
                            else if ("Table ID"=const(5904)) "Service Item Group"
                            else if ("Table ID"=const(5940)) "Service Item"
                            else if ("Table ID"=const(5714)) "Responsibility Center"
                            else if ("Table ID"=const(5800)) "Item Charge"
                            else if ("Table ID"=const(99000754)) "Work Center"
                            else if ("Table ID"=const(5965)) "Service Contract Header"
                            else if ("Table ID"=const(5105)) "Customer Template";
        }
        field(3;"Dimension Code";Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                if not DimMgt.CheckDim("Dimension Code") then
                  Error(DimMgt.GetDimErr);
            end;
        }
        field(4;"Dimension Value Code";Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code where ("Dimension Code"=field("Dimension Code"));

            trigger OnValidate()
            begin
                if not DimMgt.CheckDimValue("Dimension Code","Dimension Value Code") then
                  Error(DimMgt.GetDimErr);
                if "Value Posting" = "value posting"::"No Code" then
                  TestField("Dimension Value Code",'');
            end;
        }
        field(5;"Value Posting";Option)
        {
            Caption = 'Value Posting';
            OptionCaption = ' ,Code Mandatory,Same Code,No Code';
            OptionMembers = " ","Code Mandatory","Same Code","No Code";

            trigger OnValidate()
            begin
                if "Value Posting" = "value posting"::"No Code" then
                  TestField("Dimension Value Code",'');
            end;
        }
        field(6;"Table Caption";Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where ("Object Type"=const(Table),
                                                                           "Object ID"=field("Table ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Multi Selection Action";Option)
        {
            Caption = 'Multi Selection Action';
            OptionCaption = ' ,Change,Delete';
            OptionMembers = " ",Change,Delete;
        }
        field(8;Name;Text[50])
        {
            CalcFormula = lookup("Dimension Value".Name where ("Dimension Code"=field("Dimension Code"),
                                                               Code=field("Dimension Value Code")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Exclude from Budget Control";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Table ID","No.","Dimension Code","Dimension Value Code")
        {
            Clustered = true;
        }
        key(Key2;"Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if DefaultDim.Get("Table ID","No.","Dimension Code") then
          DefaultDim.TestField(DefaultDim."Value Posting",DefaultDim."value posting"::"Same Code")
        else begin
          DefaultDim.Init;
          DefaultDim."Table ID" := "Table ID";
          DefaultDim."No." := "No.";
          DefaultDim."Dimension Code" := "Dimension Code";
          DefaultDim."Value Posting" := "value posting"::"Same Code";
          DefaultDim.Insert;
        end;
        "Value Posting" := "value posting"::"Same Code";
    end;

    trigger OnModify()
    begin
        TestField("Value Posting","value posting"::"Same Code");
    end;

    var
        Text000: label 'You can''t rename a %1.';
        GLSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        DimHook: Codeunit "Dimension Hook";


    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        CurrTableID: Integer;
        NewTableID: Integer;
        NewNo: Code[20];
        SourceTableName: Text[100];
    begin
        if not Evaluate(NewTableID,GetFilter("Table ID")) then
          exit('');

        if NewTableID = 0 then
          if GetRangeMin("Table ID") = GetRangemax("Table ID") then
            NewTableID := GetRangeMin("Table ID")
          else
            NewTableID := 0;

        if NewTableID <> CurrTableID then
          SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,NewTableID);
        CurrTableID := NewTableID;

        if GetFilter("No.") <> '' then
          if GetRangeMin("No.") = GetRangemax("No.") then
            NewNo := GetRangeMin("No.")
          else
            NewNo := '';

        if NewTableID <> 0 then
          exit(StrSubstNo('%1 %2',SourceTableName,NewNo));

        exit('');
    end;
}

