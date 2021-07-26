Codeunit 52000046 SelectionFilterManagement46
{

    trigger OnRun()
    begin

        //  OBJECT Modification SelectionFilterManagement(Codeunit 46)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=04242020D;
        //      Time=131254T;
        //      Modified=Yes;
        //      Version List=NAVW114.03;
        //    }
        //    PROPERTIES
        //    {
        //      Target=SelectionFilterManagement(Codeunit 46);
        //    }
        //    CHANGES
        //   {
        //      { Insertion         ;InsertAfter=GetSelectionFilterForFixedAsset(PROCEDURE 36);
        //                           ChangedElements=PROCEDURECollection
        //                           {
    end;

    PROCEDURE GetSelectionFilterForEmployeeCategory(VAR EmployeeCategory: Record "Employee Category"): Text;
    VAR
        RecRef: RecordRef;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    BEGIN
        RecRef.GETTABLE(EmployeeCategory);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, EmployeeCategory.FIELDNO(Code)));
    END;
    //  
    PROCEDURE GetSelectionFilterForPayrollED(VAR PayrollED: Record "Payroll-E/D"): Text;
    VAR
        RecRef: RecordRef;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;

    BEGIN
        RecRef.GETTABLE(PayrollED);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, PayrollED.FIELDNO("E/D Code")));
    END;
    //  
    //}
    //      }
    //    }

    //  }
    //  
    //  

    //end;
}

