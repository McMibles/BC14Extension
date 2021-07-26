Page 52093070 "Schedule Overview"
{
    //     DeleteAllowed = false;
    //     InsertAllowed = false;
    //     ModifyAllowed = false;
    //     PageType = List;
    //     SourceTable = Schedule;
    //     SourceTableTemporary = true;

    //     layout
    //     {
    //         area(content)
    //         {
    //             repeater(Control1)
    //             {
    //                 IndentationColumn = NameIndent;
    //                 IndentationControls = Name;
    //                 ShowAsTree = true;
    //                 field(ScheduleCode;"Schedule Code")
    //                 {
    //                     ApplicationArea = Basic,Suite;
    //                     Style = Strong;
    //                     StyleExpr = NoEmphasize;
    //                 }
    //                 field(Name;Name)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Style = Strong;
    //                     StyleExpr = NameEmphasize;
    //                 }
    //                 field(Type;Type)
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(Totaling;Totaling)
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(StartTime;"Start Time")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(ExpectedEndTime;"Expected End Time")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(BreakTimeStart;"Break Time Start")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(BreakTimeEnd;"Break Time End")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(EarlyInBefore;"Early In Before")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(OvertimeAllowed;"Overtime Allowed")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(ExpectedWorkHour;"Expected Work Hour")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(WorkingDayID;"Working Day ID")
    //                 {
    //                     ApplicationArea = Basic;
    //                 }
    //                 field(NoOfEmployee;"No.Of Employee")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Visible = false;
    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(navigation)
    //         {
    //             action(Card)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Card';
    //                 Image = Edit;
    //                 Promoted = true;
    //                 PromotedCategory = Process;
    //                 PromotedIsBig = true;
    //                 PromotedOnly = true;
    //                 RunObject = Page "Schedule Card";
    //                 RunPageOnRec = true;
    //                 ShortCutKey = 'Shift+F7';
    //             }
    //         }
    //     }

    //     trigger OnAfterGetRecord()
    //     begin
    //         NameIndent := 0;
    //         FormatLine;
    //         NoEmphasize := Type <> Type::Standard;
    //         NameIndent := Indentation;
    //         NameEmphasize := Type <> Type::Standard;
    //     end;

    //     trigger OnOpenPage()
    //     begin
    //         ExpandAll
    //     end;

    //     var
    //         [InDataSet]
    //         Emphasize: Boolean;
    //         [InDataSet]
    //         NameIndent: Integer;
    //         [InDataSet]
    //         NoEmphasize: Boolean;
    //         [InDataSet]
    //         NameEmphasize: Boolean;

    //     local procedure ExpandAll()
    //     begin
    //         CopyScheduleToTemp(false);
    //     end;

    //     local procedure CopyScheduleToTemp(OnlyRoot: Boolean)
    //     var
    //         Schedule: Record Schedule;
    //     begin
    //         Reset;
    //         DeleteAll;
    //         SetCurrentkey("Schedule Code");

    //         if OnlyRoot then
    //           Schedule.SetRange(Indentation,0);
    //         Schedule.SetFilter(Type,'<>%1',Schedule.Type::"End Group");
    //         if Schedule.Find('-') then
    //           repeat
    //             Rec := Schedule;
    //             if Schedule.Type = Schedule.Type::"Begin Group" then
    //               Totaling := GetEndTotal(Schedule);
    //             Insert;
    //           until Schedule.Next = 0;

    //         if FindFirst then;
    //     end;

    //     local procedure GetEndTotal(var Schedule: Record Schedule): Text[250]
    //     var
    //         Schedule2: Record Schedule;
    //     begin
    //         Schedule2.SetFilter("Schedule Code",'>%1',Schedule."Schedule Code");
    //         Schedule2.SetRange(Indentation,Schedule.Indentation);
    //         Schedule2.SetRange(Type,Schedule.Type::"End Group");
    //         if Schedule2.FindFirst then
    //           exit(Schedule2.Totaling);

    //         exit('');
    //     end;

    //     local procedure FormatLine()
    //     begin
    //         NameIndent := Indentation;
    //         Emphasize := Type = Type::Standard;
    //     end;
}

