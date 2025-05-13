codeunit 83981 "Library - Utility LIB"
{
    Permissions =
        tabledata "No. Series" = RI,
        tabledata "No. Series Line" = RI;

    var
        // LibraryUtility: Codeunit "Library - Utility";
        KeyNotFoundErr: Label 'Field "%1" must be part of the primary key in the Table "%2".', Comment = '%1=FieldNo, %2=TableNo';

    procedure CreateNoSeries(NewCode: Code[20]; Default: Boolean; Manual: Boolean; DateOrder: Boolean)
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Init();
        NoSeries.Validate(Code, NewCode);
        NoSeries.Validate("Default Nos.", Default);
        NoSeries.Validate("Manual Nos.", Manual);
        NoSeries.Validate("Date Order", DateOrder);
        NoSeries.Insert(true);
    end;

    procedure CreateNoSeriesLine(SeriesCode: Code[20]; StartingNo: Code[20]; EndingNo: Code[20])
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesLineRecordRef: RecordRef;
    begin
        NoSeriesLine.Init();
        NoSeriesLine.Validate("Series Code", SeriesCode);
        NoSeriesLineRecordRef.GetTable(NoSeriesLine);
        NoSeriesLine.Validate("Line No.", GetNewLineNo(NoSeriesLineRecordRef, NoSeriesLine.FieldNo("Line No.")));

        if StartingNo = '' then
            NoSeriesLine.Validate("Starting No.", PadStr(InsStr(SeriesCode, '00000000', 3), 10))
        else
            NoSeriesLine.Validate("Starting No.", StartingNo);

        if EndingNo = '' then
            NoSeriesLine.Validate("Ending No.", PadStr(InsStr(SeriesCode, '99999999', 3), 10))
        else
            NoSeriesLine.Validate("Ending No.", EndingNo);

        NoSeriesLine.Insert(true)
    end;

    procedure GetNewLineNo(NoSeriesLineRecordRef: RecordRef; FieldNo: Integer): Integer
    begin
        exit(GetNewLineNoByRecordRef(NoSeriesLineRecordRef, FieldNo));
    end;

    procedure GetNewLineNoByRecordRef(SourceRecordRef: RecordRef; FieldNo: Integer): Integer
    var
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        LineNumberFound: Boolean;
        FieldCount: Integer;
        KeyRef: KeyRef;
    begin
        // Find the value of Line No. for a new line in the Record passed as Record Ref.
        // 1. It is assumed that the field passed is part of the primary key.
        // 2. It is assumed that all the primary key fields except Line No. field are already validated on the record.
        RecordRef2.Open(SourceRecordRef.Number(), false, CompanyName());
        KeyRef := SourceRecordRef.KeyIndex(1);  // The Primary Key always has index as 1.
        for FieldCount := 1 to KeyRef.FieldCount() do begin
            FieldRef := KeyRef.FieldIndex(FieldCount);
            if FieldRef.Number() <> FieldNo then begin
                FieldRef2 := RecordRef2.Field(FieldRef.Number());
                FieldRef2.SetRange(FieldRef.Value());  // Set filter on fields other than Line No with value as filled in on RecRef.
            end else
                LineNumberFound := true;
        end;

        if not LineNumberFound then begin
            FieldRef := RecordRef2.Field(FieldNo);
            Error(KeyNotFoundErr, FieldRef.Name(), RecordRef2.Name());
        end;

        if RecordRef2.FindLast() then begin
            FieldRef := RecordRef2.Field(FieldNo);
            FieldCount := FieldRef.Value();
        end else
            FieldCount := 0;
        exit(FieldCount + 10000);  // Add 10000 to the last Line No.
    end;

}
