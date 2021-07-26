Report 52092153 "PRoll; Copy Emp. Group Lines"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Employee Group Header"; "Payroll-Employee Group Header")
        {
            DataItemTableView = sorting(Code);

            trigger OnAfterGetRecord()
            begin
                Window.Update(2, Code);

                SourceGroupLines.Find('-');
                repeat
                    TargetGroupLines := SourceGroupLines;
                    TargetGroupLines."Employee Group" := Code;
                    if not CopyDetail then
                        TargetGroupLines.Validate(TargetGroupLines."E/D Code");
                    if not TargetGroupLines.Insert then
                        if Overwrite then
                            TargetGroupLines.Modify;
                until (SourceGroupLines.Next = 0);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text004);
            end;

            trigger OnPreDataItem()
            begin
                if SourceGroup.Code = '' then Error(Text001);
                if TargetGroupCode = '' then Error(Text002);

                if SourceGroup.Code = TargetGroupCode then
                    Error(Text003);

                SetFilter(Code, TargetGroupCode);

                SourceGroupLines.SetRange("Employee Group", SourceGroup.Code);
                if EDFilter <> '' then
                    SourceGroupLines.SetFilter(SourceGroupLines."E/D Code", EDFilter);

                if RECORDLEVELLOCKING then
                    TargetGroupLines.LockTable(true)
                else
                    TargetGroupLines.LockTable(false);

                Window.Open(Text005 + Text006);

                Window.Update(1, SourceGroup.Code);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(EnterEmployeeGrouptocopyfrom; SourceGroup.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Enter Employee Group to copy from';
                        TableRelation = "Payroll-Employee Group Header";
                    }
                    field(TargetGroupCode; TargetGroupCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Enter Employee Group(s) to copy to';
                        TableRelation = "Payroll-Employee Group Header";
                    }
                    field(EDFilter; EDFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'E/D Filter';
                        TableRelation = "Payroll-E/D";
                    }
                    field(CopyDetail; CopyDetail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Copy Detail';
                    }
                    field(Overwrite; Overwrite)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Overwrite lines in current group that also appear in source group?';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            TargetGroupCode := "Payroll-Employee Group Header".GetFilter("Payroll-Employee Group Header".Code);
        end;
    }

    labels
    {
    }

    var
        Overwrite: Boolean;
        CopyDetail: Boolean;
        SourceGroup: Record "Payroll-Employee Group Header";
        TargetGroupCode: Code[250];
        SourceGroupLines: Record "Payroll-Employee Group Line";
        TargetGroupLines: Record "Payroll-Employee Group Line";
        EDFilter: Code[250];
        Window: Dialog;
        Text001: label 'Source Group must be specified';
        Text002: label 'Target Group must be specified';
        Text003: label 'A group cannot be copied to itself';
        Text004: label 'FUNCTION COMPLETED!';
        Text005: label 'Copying From Employee Group   #1#########\';
        Text006: label 'Current Target Employee Group  #2#########';
}

