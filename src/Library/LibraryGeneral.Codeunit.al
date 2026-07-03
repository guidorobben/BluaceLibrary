codeunit 83957 "Library - General LIB"
{
    Permissions =
        tabledata "Allowed Language" = RI,
        tabledata "No. Series" = R,
        tabledata "Payment Method" = RI,
        tabledata "Time Window CBLC" = RI,
        tabledata "Unit of Measure" = RI,
        tabledata "Work Type" = RI;

    procedure CreateTimeWindow(TimeWindowType: Enum "Time Window Type CBLC"; Code: Code[20]; StartingTime: Time; EndingTime: Time; IsDefault: Boolean)
    var
        TimeWindowCBLC: Record "Time Window CBLC";
    begin
        if TimeWindowCBLC.Get(TimeWindowType, Code) then
            exit;

        TimeWindowCBLC.Init();
        TimeWindowCBLC.Validate(Type, TimeWindowType);
        TimeWindowCBLC.Validate(Code, Code);
        TimeWindowCBLC.Validate("Starting Time", StartingTime);
        TimeWindowCBLC.Validate("Ending Time", EndingTime);
        TimeWindowCBLC.Validate(Default, IsDefault);
        TimeWindowCBLC.Insert(true);
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
        UnitOfMeasure.Validate("Rounding Precision CBLC", RoundingPercision);
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
        WorkType.Validate("Gen. Prod. Posting Group CBLC", GenProdPostingGroup);
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

    procedure CreatePaymentMethod(Code: Code[10]; Description: Text[100]; BalAccountType: Enum "Payment Balance Account Type"; BalAccountNo: Code[20]; DirectDebit: Boolean; DirectDebitPmtTermsCode: Code[10])
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
