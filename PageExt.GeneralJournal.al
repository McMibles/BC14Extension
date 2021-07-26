PageExtension 52000007 pageextension52000007 extends "General Journal" 
{
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode3(Control 134)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode4(Control 133)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode5(Control 128)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode6(Control 121)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode7(Control 63)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode8(Control 61)".

        addafter("Business Unit Code")
        {
            field("IC Partner Code";"IC Partner Code")
            {
                ApplicationArea = Basic;
            }
            field("IC Partner G/L Acc. No.";"IC Partner G/L Acc. No.")
            {
                ApplicationArea = Basic;
            }
            field("IC Partner Transaction No.";"IC Partner Transaction No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field("WHT Posting Group";"WHT Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Source Vend/Cust  No.";"Source Vend/Cust  No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "ShowStatementLineDetails(Action 21)".

    }
}

