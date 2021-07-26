Page 52092815 "Purchase Req. Types"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Purchase Req. Type";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(AccountNoFilter;"Account No. Filter")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Type of
                          1:begin
                            GLAccList.LookupMode(true);
                            if not (GLAccList.RunModal = Action::LookupOK) then
                              exit(false)
                            else
                              Text := GLAccList.GetSelectionFilter;
                            exit(true);
                          end;
                          2:begin
                            ItemList.LookupMode(true);
                            if not (ItemList.RunModal = Action::LookupOK) then
                              exit(false)
                            else
                              Text := ItemList.GetSelectionFilter;
                            exit(true);
                          end;
                          3:begin
                            FAList.LookupMode(true);
                            if not (FAList.RunModal = Action::LookupOK) then
                              exit(false)
                            else
                              Text := FAList.GetSelectionFilter;
                            exit(true);
                          end;
                        end;
                    end;
                }
                field(ItemCategoryFilter;"Item Category Filter")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Type of
                          2:begin
                            ItemCategoryList.LookupMode(true);
                            ItemCategoryList.Editable := false;
                            if not (ItemCategoryList.RunModal = Action::LookupOK) then
                              exit(false)
                            else
                              Text := ItemCategoryList.GetSelectionFilter;
                            exit(true);
                          end;
                        end;
                    end;
                }
                field(JobNoReq;"Job No. Req.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GlobalDimension1Filter;"Global Dimension 1 Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                        DimensionValues: Page "Dimension Value List";
                    begin
                        DimensionValue.SetRange("Global Dimension No.",1);
                        DimensionValue.SetRange("Dimension Value Type",DimensionValue."dimension value type"::Standard);
                        DimensionValues.SetTableview(DimensionValue);
                        DimensionValues.LookupMode(true);
                        if not (DimensionValues.RunModal = Action::LookupOK) then
                          exit(false)
                        else
                          Text := DimensionValues.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field(GlobalDimension2Filter;"Global Dimension 2 Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimensionValue.SetRange("Global Dimension No.",2);
                        DimensionValue.SetRange("Dimension Value Type",DimensionValue."dimension value type"::Standard);
                        DimensionValues.SetTableview(DimensionValue);
                        DimensionValues.LookupMode(true);
                        if not (DimensionValues.RunModal = Action::LookupOK) then
                          exit(false)
                        else
                          Text := DimensionValues.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Route;Route)
                {
                    ApplicationArea = Basic;
                }
                field(AllowRFQtoPO;"Allow RFQ to PO")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter;"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        DimensionValue: Record "Dimension Value";
        ItemCategoryList: Page "Item Categories";
        GLAccList: Page "G/L Account List";
        ItemList: Page "Item List";
        FAList: Page "Fixed Asset List";
        DimensionValues: Page "Dimension Value List";
}

