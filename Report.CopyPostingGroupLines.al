Report 52092178 "Copy Posting Group Lines"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Posting Group Header";"Payroll-Posting Group Header")
        {
            DataItemTableView = sorting("Posting Group Code");
            column(ReportForNavId_7149; 7149)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(2,SourceGroup."Posting Group Code");

                SourceGroupLines.Find( '-');
                repeat
                  TargetGroupLines := SourceGroupLines;
                  TargetGroupLines."Posting Group" := "Payroll-Posting Group Header"."Posting Group Code";
                  if not CopyDetail then
                    TargetGroupLines.Validate(TargetGroupLines."E/D Code");
                  if not  TargetGroupLines.Insert then
                    if Overwrite then
                       TargetGroupLines.Modify;
                until (SourceGroupLines.Next = 0);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text006);
            end;

            trigger OnPreDataItem()
            begin
                if SourceGroup."Posting Group Code" = '' then Error(Text001);
                if TargetGroupCode = '' then Error(Text002);

                if SourceGroup."Posting Group Code" = TargetGroupCode then
                  Error (Text003);

                SetFilter("Posting Group Code",TargetGroupCode);

                SourceGroupLines.SetRange("Posting Group", SourceGroup."Posting Group Code");
                if EDFilter <> '' then
                  SourceGroupLines.SetFilter(SourceGroupLines."E/D Code",EDFilter);

                //TargetGroupLines.LOCKTABLE(FALSE);

                Window.Open (Text004 + Text005);

                Window.Update(1,SourceGroup."Posting Group Code");
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
                    field(EnterPostingGrouptocopyfrom;SourceGroup."Posting Group Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Enter Posting Group to copy from';
                        TableRelation = "Payroll-Posting Group Header";
                    }
                    field(TargetGroupCode;TargetGroupCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Enter Posting Group(s) to copy to';
                        TableRelation = "Payroll-Posting Group Header";
                    }
                    field(EDFilter;EDFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'E/D Filter';
                        TableRelation = "Payroll-E/D";
                    }
                    field(CopyDetail;CopyDetail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Copy Detail';
                    }
                    field(Overwrite;Overwrite)
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
            TargetGroupCode := "Payroll-Posting Group Header".GetFilter("Posting Group Code");
        end;
    }

    labels
    {
    }

    var
        Overwrite: Boolean;
        CopyDetail: Boolean;
        SourceGroup: Record "Payroll-Posting Group Header";
        TargetGroupCode: Code[250];
        SourceGroupLines: Record "Payroll-Posting Group Line";
        TargetGroupLines: Record "Payroll-Posting Group Line";
        EDFilter: Code[250];
        Window: Dialog;
        Text001: label 'Source Group must be specified';
        Text002: label 'Target Group must be specified';
        Text003: label 'A group cannot be copied to itself';
        Text004: label 'Copying From Posting Group   #1########\';
        Text005: label 'Current Target Posting Group  #2#########';
        Text006: label 'FUNCTION COMPLETED!';
}

