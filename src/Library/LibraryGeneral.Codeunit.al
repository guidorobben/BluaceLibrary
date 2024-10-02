codeunit 83957 "Library - General LIB"
{
    Permissions =
        tabledata "No. Series" = R,
        tabledata "Time Window TPZS" = RI,
        tabledata "Unit of Measure" = RI,
        tabledata "Work Type" = RI;

    procedure CreateTimeWindow(Type: Enum "Time Window Type TPZS"; Code: Code[20]; StartingTime: Time; EndingTime: Time; IsDefault: Boolean)
    var
        TimeWindowTPZS: Record "Time Window TPZS";
    begin
        TimeWindowTPZS.Init();
        TimeWindowTPZS.Validate(Type, Type);
        TimeWindowTPZS.Validate(Code, Code);
        TimeWindowTPZS.Validate("Starting Time", StartingTime);
        TimeWindowTPZS.Validate("Ending Time", EndingTime);
        TimeWindowTPZS.Validate(Default, IsDefault);
        if TimeWindowTPZS.Insert(true) then; //Easy
    end;


    procedure CreateUnitOfMeasureCode(Code: Code[10]; Description: Text[50]; RoundingPercision: Decimal; SkipWhenExist: Boolean)
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if SkipWhenExist then
            if UnitOfMeasure.Get(Code) then
                exit;

        CreateUnitOfMeasureCode(Code, Description, RoundingPercision);
    end;

    procedure CreateUnitOfMeasureCode(Code: Code[10]; Description: Text[50]; RoundingPercision: Decimal)
    var
        UnitOfMeasure: Record "Unit of Measure";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        UnitOfMeasure.Init();
        if Code <> '' then
            UnitOfMeasure.Validate(Code, Code)
        else
            UnitOfMeasure.Validate(Code, LibraryUtility.GenerateRandomCode(UnitOfMeasure.FieldNo(Code), Database::"Unit of Measure"));
        UnitOfMeasure.Validate(Description, Description);
        // UnitOfMeasure.Validate("International Standard Code",
        //   LibraryUtility.GenerateRandomCode(UnitOfMeasure.FieldNo("International Standard Code"), DATABASE::"Unit of Measure"));
        // UnitOfMeasure.Validate(Symbol,
        //   LibraryUtility.GenerateRandomCode(UnitOfMeasure.FieldNo(Symbol), DATABASE::"Unit of Measure"));
        UnitOfMeasure.Validate("Rounding Precision TPZS", RoundingPercision);
        UnitOfMeasure.Insert(true);
    end;

    procedure CreateWorkType(WorkTypeCode: Code[10]; Description: Text[100]; UnitOfMeasureCode: Code[10])
    begin
        CreateWorkType(WorkTypeCode, Description, UnitOfMeasureCode, '');
    end;

    procedure CreateWorkType(WorkTypeCode: Code[10]; Description: Text[100]; UnitOfMeasureCode: Code[10]; GenProdPostingGroup: Code[10])
    var
        WorkType: Record "Work Type";
    begin
        WorkType.Init();
        WorkType.Validate(Code, WorkTypeCode);
        WorkType.Validate(Description, Description);
        WorkType.Validate("Unit of Measure Code", UnitOfMeasureCode);
        WorkType.Validate("Gen. Prod. Posting Group TPZS", GenProdPostingGroup);
        WorkType.Insert(true);
    end;

    procedure NoSeriesExists(NoSeriesCode: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeriesCode = '' then
            exit;

        exit(NoSeries.Get(NoSeriesCode));
    end;
}
