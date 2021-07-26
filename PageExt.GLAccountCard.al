PageExtension 52000002 pageextension52000002 extends "G/L Account Card"
{
    layout
    {
        addafter("Default Deferral Template Code")
        {
            field("GIT Clearing Account"; "GIT Clearing Account")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Cost Accounting")
        {
            group("Budget Control")
            {
                Caption = 'Budget Control';
                field("Excl. from Budget Ctrl"; "Excl. from Budget Ctrl")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Control Period"; "Budget Control Period")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        addafter("Where-Used List")
        {
            action("Sharing Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Sharing Setup';
                RunObject = Page "Sharing Setup";
                RunPageLink = "Sharing Account No." = field("No.");
            }
        }
    }
}

