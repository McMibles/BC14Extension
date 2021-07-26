PageExtension 52000043 pageextension52000043 extends "Workflow User Group" 
{
    layout
    {
        addafter(Description)
        {
            field("No. of Required Approvals";"No. of Required Approvals")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

