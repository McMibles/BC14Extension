Codeunit 52092143 "Format No. to Text"
{

    trigger OnRun()
    begin
    end;

    var
        OnesText: array [20] of Text[30];
        TensText: array [10] of Text[30];
        ExponentText: array [5] of Text[30];


    procedure FormatNoText(var NoText: array [2] of Text[150];No: Decimal;Unit1: Text[30];Unit2: Text[30])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        UnitofMeasure: Text[30];
        SubUnitofMeasure: Text[30];
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';
        
        if (Unit1 <> '') or (Unit2 <> '') then begin
          UnitofMeasure := Unit1;
          SubUnitofMeasure := Unit2;
        end else begin
          UnitofMeasure := 'NAIRA';
          SubUnitofMeasure := 'KOBO';
        end;
        
        if No < 1 then
          AddToNoText(NoText,NoTextIndex,PrintExponent,'ZERO')
        else begin
          for Exponent := 4 downto 1 do begin
            PrintExponent := false;
            Ones := No DIV Power(1000,Exponent - 1);
            Hundreds := Ones DIV 100;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            if Hundreds > 0 then begin
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,'HUNDRED');
              if (Tens > 0) or (Ones > 0) then
                AddToNoText(NoText,NoTextIndex,PrintExponent,'AND')
            end;
            if Tens >= 2 then begin
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              if Ones > 0 then
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            end else
              if (Tens * 10 + Ones) > 0 then
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            if PrintExponent and (Exponent > 1) then
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000,Exponent - 1);
          end;
        end;
        
        AddToNoText(NoText,NoTextIndex,PrintExponent,UnitofMeasure);
        
        if No <> 0 then
        begin
          No := ROUND(No * 100,1,'=');
          PrintExponent := false;
          Tens := No DIV 10;
          Ones := No MOD 10;
          if Tens >= 2 then begin
            AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
            if Ones > 0 then
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
          end else
            if (Tens * 10 + Ones) > 0 then
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
        
          AddToNoText(NoText,NoTextIndex,PrintExponent,SubUnitofMeasure);
        end;
          AddToNoText(NoText,NoTextIndex,PrintExponent,'****');
        /*
          AddToNoText(NoText,NoTextIndex,PrintExponent,'AND');
          AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');
        */

    end;

    local procedure AddToNoText(var NoText: array [2] of Text[150];var NoTextIndex: Integer;var PrintExponent: Boolean;AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
          NoTextIndex := NoTextIndex + 1;
          if NoTextIndex > ArrayLen(NoText) then
            Error('%1 results in a written number that is too long Max Len is %2.',AddText,ArrayLen(NoText));
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText,'<');
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := 'ONE';
        OnesText[2] := 'TWO';
        OnesText[3] := 'THREE';
        OnesText[4] := 'FOUR';
        OnesText[5] := 'FIVE';
        OnesText[6] := 'SIX';
        OnesText[7] := 'SEVEN';
        OnesText[8] := 'EIGHT';
        OnesText[9] := 'NINE';
        OnesText[10] := 'TEN';
        OnesText[11] := 'ELEVEN';
        OnesText[12] := 'TWELVE';
        OnesText[13] := 'THIRTEEN';
        OnesText[14] := 'FOURTEEN';
        OnesText[15] := 'FIFTEEN';
        OnesText[16] := 'SIXTEEN';
        OnesText[17] := 'SEVENTEEN';
        OnesText[18] := 'EIGHTEEN';
        OnesText[19] := 'NINETEEN';

        TensText[1] := '';
        TensText[2] := 'TWENTY';
        TensText[3] := 'THIRTY';
        TensText[4] := 'FORTY';
        TensText[5] := 'FIFTY';
        TensText[6] := 'SIXTY';
        TensText[7] := 'SEVENTY';
        TensText[8] := 'EIGHTY';
        TensText[9] := 'NINETY';

        ExponentText[1] := '';
        ExponentText[2] := 'THOUSAND';
        ExponentText[3] := 'MILLION';
        ExponentText[4] := 'BILLION';
    end;
}

