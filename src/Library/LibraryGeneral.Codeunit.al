codeunit 83957 "Library - General LIB"
{
    Permissions =
        tabledata "Allowed Language" = ri,
        tabledata "No. Series" = r,
        tabledata "Payment Method" = ri,
        tabledata "Time Window TPZS" = ri,
        tabledata "Unit of Measure" = ri,
        tabledata "Work Type" = ri;

    procedure CreateTimeWindow(TimeWindowType: Enum "Time Window Type TPZS"; Code: Code[20];
                                                   StartingTime: Time;
                                                   EndingTime: Time;
                                                   IsDefault: Boolean)
    var
        TimeWindowTPZS: Record "Time Window TPZS";
    begin
        if TimeWindowTPZS.Get(TimeWindowType, Code) then
            exit;

        TimeWindowTPZS.Init();
        TimeWindowTPZS.Validate(Type, TimeWindowType);
        TimeWindowTPZS.Validate(Code, Code);
        TimeWindowTPZS.Validate("Starting Time", StartingTime);
        TimeWindowTPZS.Validate("Ending Time", EndingTime);
        TimeWindowTPZS.Validate(Default, IsDefault);
        TimeWindowTPZS.Insert(true);
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

    procedure CreatePaymentMethod(Code: Code[10]; Description: Text[100]; BalAccountType: Enum "Payment Balance Account Type"; BalAccountNo: Code[20];
                                                                                              DirectDebit: Boolean;
                                                                                              DirectDebitPmtTermsCode: Code[10])
    var
        PaymentMethod: Record "Payment Method";
    begin
        if PaymentMethod.Get(Code) then
            exit;

        PaymentMethod.Init();
        PaymentMethod.Validate(Code, Code);
        PaymentMethod.Validate(Description, Description);
        PaymentMethod.Validate("Bal. Account Type", BalAccountType);
        PaymentMethod.Validate("Bal. Account No.", BalAccountNo);
        PaymentMethod.Validate("Direct Debit", DirectDebit);
        PaymentMethod.Validate("Direct Debit Pmt. Terms Code", DirectDebitPmtTermsCode);
        PaymentMethod.Insert(true);
    end;

    procedure AddAllowedLanguage(LanguageId: Integer)
    var
        AllowedLanguage: Record "Allowed Language";
    begin
        if AllowedLanguage.Get(LanguageId) then
            exit;

        AllowedLanguage.Init();
        AllowedLanguage.Validate("Language Id", LanguageId);
        AllowedLanguage.Insert(true);
    end;
}
