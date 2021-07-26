Page 52092439 "Document Templates"
{
    PageType = List;
    SourceTable = "Document Template";

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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(TermEmployees;"Term. Employees")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MailMergeTable;"MailMerge Table")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(ImportTemplate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Template';
                    Image = Import;

                    trigger OnAction()
                    begin
                        OK := ImportTemplateFromClientFile('',false,false);
                        if OK then
                          CurrPage.SaveRecord;
                        CurrPage.Update(false);
                    end;
                }
                action(ExportTemplate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Export Template';
                    Image = Export;

                    trigger OnAction()
                    begin
                        OK := ExportTemplatetoClientFile("Storage Pointer");
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1000000011>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Template';
                    Image = CreateForm;

                    trigger OnAction()
                    begin
                        CreateTemplate('New Template');
                        CurrPage.SaveRecord;
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1000000005>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Edit Template';
                    Image = Edit;

                    trigger OnAction()
                    begin
                        OpenAttachment('Edit Template',true);
                        CurrPage.SaveRecord;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        DocumentMgt: Codeunit DocumentManagement;
        TemplateRec: Record "Document Template";
        Path: Text[128];
        OK: Boolean;
}

