Table 52092337 "Consignment Header"
{
    //DrillDownPageID = UnknownPage60630;
    //LookupPageID = UnknownPage60630;

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;
        }
        field(2; Description; Text[80])
        {
        }
        field(4; Open; Boolean)
        {
            Editable = false;
        }
        field(6; "Closed By"; Code[50])
        {
            TableRelation = "User Setup";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(8; "Bill Of Lading No."; Code[20])
        {
        }
        field(9; "Expected Date of Arrival"; Date)
        {
        }
        field(10; "Actual Date of Arrival"; Date)
        {
        }
        field(11; "Date of Rcpt. of Ship. Doc"; Date)
        {
        }
        field(12; "Date Applied for Custom Duty"; Date)
        {
        }
        field(13; "Date Custom Duty Received"; Date)
        {
        }
        field(14; "Date Goods Received"; Date)
        {
        }
        field(15; "Clearing Agent"; Text[50])
        {
        }
        field(17; "Site ETA"; Date)
        {
        }
        field(18; ETS; Date)
        {
        }
        field(19; Remarks; Text[50])
        {
        }
        field(20; "Action"; Text[50])
        {
        }
        field(21; "Date of Rcpt. of RAR"; Date)
        {
        }
        field(22; "Requested Shipment Date"; Date)
        {
        }
        field(23; "Clearing Status"; Text[250])
        {
        }
        field(24; "Proforma No."; Code[20])
        {
        }
        field(25; "Proforma Date"; Date)
        {
        }
        field(26; "Form M No."; Code[20])
        {
        }
        field(27; "Form M Date"; Date)
        {
        }
        field(28; "Form M Exch. Rate"; Decimal)
        {
        }
        field(29; "Form M Bank"; Text[30])
        {
            TableRelation = "Bank Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(30; "Final Invoice No."; Code[10])
        {
        }
        field(31; "Final Invoice Date"; Date)
        {
        }
        field(32; "LC Date of Issue"; Date)
        {
        }
        field(33; "Form M Bank Name"; Text[50])
        {
        }
        field(34; "LC Number"; Code[30])
        {
        }
        field(37; "GIT Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                TestField(Open, true);
                if "GIT Account" <> '' then begin
                    GLAcc.Get("GIT Account");
                    if not (GLAcc."GIT Clearing Account") then
                        Error(Text001, "GIT Account");
                end;

                if (xRec."GIT Account" <> "GIT Account") and (xRec."GIT Account" <> '') then begin
                    CalcFields("Balance Amount");
                    if "Balance Amount" <> 0 then
                        Error(Text002);
                    if Confirm(Text003) then begin
                        ConsignmentLine.SetRange("Consignment Code", "No.");
                        ConsignmentLine.ModifyAll("GIT Account", "GIT Account");
                    end;
                end;
            end;
        }
        field(38; "Balance Amount"; Decimal)
        {
            //CalcFormula = sum("Consignment Ledger Entry".Amount where("Consignment Code" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Consignment Amount"; Decimal)
        {
            //CalcFormula = sum("Consignment/Purch. Order Line".Amount where("Consignment Code" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Consignment Amount (LCY)"; Decimal)
        {
            //CalcFormula = sum("Consignment/Purch. Order Line"."Amount (LCY)" where("Consignment Code" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Charge Code Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            //TableRelation = "Consignment Charge";
        }
        field(42; "Net Change"; Decimal)
        {
            //CalcFormula = sum("Consignment Ledger Entry".Amount where("Consignment Code" = field("No."),
            //                                                         "Charge Code" = field("Charge Code Filter"),
            //                                                       "Posting Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(44; "GIT Cost Recognition Date"; Date)
        {
        }
        field(50000; "PO NO."; Code[20])
        {
            //CalcFormula = lookup("Consignment/Purch. Order Line"."PO No." where("Consignment Code" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ConsignmentLineExsists then
            if Confirm(Text006, false) then
                ConsignmentLine.Delete(true);
        //ConsgtLedgEntry.SetRange("Consignment Code", "No.");
        // if ConsgtLedgEntry.FindFirst then
        //     Error(Text005);
    end;

    trigger OnInsert()
    begin
        PurchSetup.Get;
        if "No." = '' then begin
            PurchSetup.TestField(PurchSetup."Consignment Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Consignment Nos.", PurchSetup."Consignment Nos.", 0D, "No.", PurchSetup."Consignment Nos.");
        end;
        Open := true;
    end;

    trigger OnRename()
    begin
        Error(Text007, TableCaption);
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        GLAcc: Record "G/L Account";
        ConsignmentLine: Record "Consignment Line";
        //ConsgtLedgEntry: Record "Consignment Ledger Entry";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'The Account  %1 selected cannot be used as a GIT Account';
        Text002: label 'There are ledger entries already created; GIT Account cannnot be changed';
        Text003: label 'You have changed the GIT Account on the Consigment. Do you want to update GIT Account on the Consigment line';
        Text004: label 'Transaction cannot be carried out on closed consignment card. Are you sure you want to close %1?';
        Text005: label 'Consignment card with ledger entry cannot be deleted.';
        Text006: label 'All existing lines will be deleted. Are you sure you want to continue?';
        Text007: label 'You cannot rename %1.';
        Text008: label '%1 %2 has some outstanding %3 and cannot be closed.';
        Text009: label 'Function successfully completed.';
        DirectCostEntryOnly: Boolean;


    procedure ConsignmentLineExsists(): Boolean
    var
    //     ConsignmentLine: Record "Consignment Line";
    begin
        //     ConsignmentLine.SetRange("Consignment Code","No.");
        //     ConsignmentLine.SetFilter("PO No.",'<>%1','');
        //     if ConsignmentLine.FindSet then
        //       exit(true)
        //     else
        //       exit(false)
    end;


    procedure ConsignmentQtyLineExsists(): Boolean
    var
    //     ConsignmentPOLine: Record "Consignment/Purch. Order Line";
    begin
        //     ConsignmentPOLine.SetRange("Consignment Code","No.");
        //     ConsignmentPOLine.SetFilter("PO No.",'<>%1','');
        //     ConsignmentPOLine.SetFilter(Quantity,'<>0');
        //     exit(ConsignmentPOLine.FindFirst);
    end;


    procedure CloseCard()
    var
    //     PurchLine: Record "Purchase Line";
    //     UsersPermission: Codeunit "User Permissions";
    begin
        //     if not Confirm(Text004,false,"No.") then
        //       exit;

        //     CalcFields("Balance Amount");
        //     if "Balance Amount" <> 0 then
        //       Error(Text008,TableCaption,"No.",ConsgtLedgEntry.TableCaption);
        //     PurchLine.SetRange("Consignment Code","No.");
        //     PurchLine.SetFilter("Outstanding Quantity",'<>0');
        //     if PurchLine.FindFirst then
        //       Error(Text008,TableCaption,"No.",PurchLine.TableCaption);
        //     Open := false;
        //     "Closed By" := UserId;
        //     Modify;

        //     Message(Text009);
    end;


    procedure IndirectCostExist(PONo: Code[20]): Boolean
    var
    //     ConsgtLedgEntry: Record "Consignment Ledger Entry";
    begin
        //     ConsgtLedgEntry.SetRange("Consignment Code","No.");
        //     ConsgtLedgEntry.SetRange("PO No.");
        //     ConsgtLedgEntry.SetRange("Direct Cost Invoice",false);
        //     exit(ConsgtLedgEntry.FindFirst);
    end;


    procedure DirectCostExist(PONo: Code[20]): Boolean
    var
    //     ConsgtLedgEntry: Record "Consignment Ledger Entry";
    begin
        //     ConsgtLedgEntry.SetRange("Consignment Code","No.");
        //     ConsgtLedgEntry.SetRange("PO No.");
        //     ConsgtLedgEntry.SetRange("Direct Cost Invoice",true);
        //     exit(ConsgtLedgEntry.FindFirst);
    end;


    procedure OutstandingIndirectCost(OrderNo: Code[20]): Decimal
    begin
        //     ConsgtLedgEntry.SetCurrentkey("Consignment Code","PO No.","Direct Cost Invoice");
        //     ConsgtLedgEntry.SetRange("Consignment Code","No.");
        //     if OrderNo <> '' then
        //       ConsgtLedgEntry.SetRange("PO No.",OrderNo)
        //      else
        //        ConsgtLedgEntry.SetRange("PO No.");

        //     ConsgtLedgEntry.SetRange("Direct Cost Invoice",false);
        //     ConsgtLedgEntry.CalcSums(Amount);
        //     exit(ConsgtLedgEntry.Amount);
    end;


    procedure OutstandingDirectCost(OrderNo: Code[20]): Decimal
    begin
        //     PurchSetup.Get;
        //     PurchSetup.TestField("Consignment Charge Option");
        //     ConsgtLedgEntry.SetCurrentkey("Consignment Code","PO No.","Direct Cost Invoice");
        //     ConsgtLedgEntry.SetRange("Consignment Code","No.");
        //     if OrderNo <> '' then
        //       ConsgtLedgEntry.SetRange("PO No.",OrderNo)
        //     else
        //       ConsgtLedgEntry.SetRange("PO No.");
        //     if (PurchSetup."Consignment Charge Option" = PurchSetup."consignment charge option"::"Indirect Cost") or DirectCostEntryOnly then
        //       ConsgtLedgEntry.SetRange("Direct Cost Invoice",true)
        //     else
        //       ConsgtLedgEntry.SetRange("Direct Cost Invoice");
        //     ConsgtLedgEntry.CalcSums(Amount);
        //     exit(ConsgtLedgEntry.Amount);
    end;


    procedure GetConsignmentCost(DateFilter: Text; DirectCost: Boolean): Decimal
    begin
        //     ConsgtLedgEntry.SetCurrentkey("Consignment Code","PO No.","Direct Cost Invoice","Posting Date");
        //     ConsgtLedgEntry.SetRange("Consignment Code","No.");
        //     ConsgtLedgEntry.SetRange("Direct Cost Invoice",DirectCost);
        //     if not DirectCost then
        //       ConsgtLedgEntry.SetRange("Charge Code",'');
        //     if DateFilter <> '' then
        //       ConsgtLedgEntry.SetFilter("Posting Date",DateFilter)
        //     else
        //       ConsgtLedgEntry.SetRange("Posting Date");
        //     ConsgtLedgEntry.CalcSums(Amount);
        //     exit(ConsgtLedgEntry.Amount);
    end;


    procedure SetDirectCostEntryOnly()
    begin
        DirectCostEntryOnly := true;
    end;
}

