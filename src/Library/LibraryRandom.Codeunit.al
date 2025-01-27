codeunit 83989 "Library - Random LIB"
{
    Permissions =
        tabledata "Consumable LIB" = R,
        tabledata Contact = R,
        tabledata "Contract Setup TPZS" = R,
        tabledata Item = R,
        tabledata "Item Category" = R,
        tabledata "Property Mapping RBLC" = R,
        tabledata "Property Value RBLC" = R,
        tabledata Resource = R,
        tabledata "Skill Code" = R;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";

    procedure GetGLNRandom() GLN: Code[13]
    var
        Consumable: Record "Consumable LIB";
    begin
        Consumable.SetRange(Type, Consumable.Type::GLN);
        FindRandomConsumable(Consumable);
        GLN := Consumable.Value;
    end;

    local procedure FindRandomConsumable(var Consumable: Record "Consumable LIB")
    var
        Count: Integer;
        NextCount: Integer;
    begin
        Count := Consumable.Count();

        if Count = 0 then
            exit;

        NextCount := LibraryRandom.RandIntInRange(1, Count);
        if Consumable.Next(NextCount) <> 0 then; //No Error
    end;

    procedure FindAddressRandom() Result: Text[50]
    var
        Consumable: Record "Consumable LIB";
        Count: Integer;
        NextCount: Integer;
    begin
        Consumable.SetRange(Type, Consumable.Type::Address);
        Count := Consumable.Count();

        if Count = 0 then
            exit;

        NextCount := LibraryRandom.RandIntInRange(1, Count);
        if Consumable.Next(NextCount) <> 0 then
            Result := Consumable.Value;
    end;

    procedure FindAddressCompleteRandom(var Address: Text[100]; var HouseNo: Text[20]; var HouseNoAdd: Text[10]; var PostCode: Code[20]; var City: Text[30])
    begin
        Address := FindAddressRandom();
        HouseNo := Format(LibraryRandom.RandIntInRange(1, 100));
        HouseNoAdd := CopyStr(FindHouseNoAdditionalRandom(), 1, MaxStrLen(HouseNoAdd));
        PostCode := CopyStr(FindPostCodeRandom(), 1, MaxStrLen(PostCode));
        City := CopyStr(FindCityRandom(), 1, MaxStrLen(City));
    end;

    procedure FindCompleteNameRandom() Result: Text[100]
    var
        CompleteName: Text;
    begin
        CompleteName := FindFirstNameRandom() + ' ' + FindLastNameRandom();
        Result := CopyStr(CompleteName, 1, 100);
    end;

    procedure FindFirstNameRandom() Result: Text[50]
    var
        Consumable: Record "Consumable LIB";
        Count: Integer;
        NextCount: Integer;
    begin
        Consumable.SetRange(Type, Consumable.Type::"First Name");
        Count := Consumable.Count();

        if Count = 0 then exit;

        NextCount := LibraryRandom.RandIntInRange(1, Count);
        if Consumable.Next(NextCount) <> 0 then
            Result := Consumable.Value;
    end;

    procedure FindCityRandom() Result: Text[50]
    var
        ConsumableType: Enum "Consumable Type LIB";
    begin
        exit(FindConsumableRandom(ConsumableType::City));
    end;

    procedure FindPostCodeRandom() Result: Text[50]
    var
        ConsumableType: Enum "Consumable Type LIB";
    begin
        exit(FindConsumableRandom(ConsumableType::"Post Code"));
    end;

    procedure FindHouseNoAdditionalRandom() Result: Text[50]
    var
        ConsumableType: Enum "Consumable Type LIB";
    begin
        exit(FindConsumableRandom(ConsumableType::"House No. Additional"));
    end;

    procedure FindLocationRandom() Result: Text[50]
    var
        ConsumableType: Enum "Consumable Type LIB";
    begin
        exit(FindConsumableRandom(ConsumableType::Location));
    end;

    local procedure FindConsumableRandom(ConsumableType: Enum "Consumable Type LIB") Result: Text[50]
    var
        Consumable: Record "Consumable LIB";
        Count: Integer;
        NextCount: Integer;
    begin
        Consumable.SetRange(Type, ConsumableType);
        Count := Consumable.Count();

        if Count = 0 then exit;

        NextCount := LibraryRandom.RandIntInRange(1, Count);
        if Consumable.Next(NextCount) <> 0 then
            Result := Consumable.Value;
    end;

    procedure FindObjectPropertyValueRandom(PropertyCode: Code[20]) Result: Text[2048]
    var
        // ObjectTPZS: Record "Object TPZS";
        PropertyValueRBLC: Record "Property Value RBLC";
        Count: Integer;
        NextCount: Integer;
        TableId: Integer;
    begin
        if PropertyCode = '' then
            exit;

        TableId := GetPropertyMapping(Database::"Object TPZS");
        PropertyValueRBLC.SetRange("Table ID", TableId);
        PropertyValueRBLC.SetRange("Property Code", PropertyCode);
        Count := PropertyValueRBLC.Count();

        if Count = 0 then
            exit;

        NextCount := LibraryRandom.RandIntInRange(1, Count);
        if PropertyValueRBLC.Next(NextCount) <> 0 then
            PropertyValueRBLC.PopulateValue(Result);
    end;

    local procedure GetPropertyMapping(TableId: Integer): Integer
    var
        PropertyMappingRBLC: Record "Property Mapping RBLC";
    begin
        if PropertyMappingRBLC.Get(TableId) then
            exit(PropertyMappingRBLC."Property Table ID");

        exit(TableId);
    end;

    procedure FindLastNameRandom() Result: Text[50]
    var
        Consumable: Record "Consumable LIB";
        Count: Integer;
        NextCount: Integer;
    begin
        Consumable.SetRange(Type, Consumable.Type::"Last Name");
        Count := Consumable.Count();

        if Count = 0 then exit;

        NextCount := LibraryRandom.RandIntInRange(1, Count);
        if Consumable.Next(NextCount) <> 0 then
            Result := Consumable.Value;
    end;

    procedure FindItemNoRandom(ItemType: Enum "Item Type") ItemNo: Code[20]
    var
        Item: Record Item;
        SourceRecordRef: RecordRef;
        FoundItemNo: Text;
    begin
        Item.SetRange(Type, ItemType);
        SourceRecordRef.GetTable(Item);
        FoundItemNo := GetRandomValueByRecordRef(SourceRecordRef, 1);
        exit(CopyStr(FoundItemNo, 1, MaxStrLen(ItemNo)));
    end;

    procedure FindSkillCodeRandom(SkillType: Enum "Skill Type TPZS") Result: Code[10]
    var
        SKillCode: Record "Skill Code";
        SourceRecordRef: RecordRef;
        FoundSkillCodeNo: Text;
    begin
        SKillCode.SetRange("Skill Type TPZS", SkillType);
        SourceRecordRef.GetTable(SKillCode);
        FoundSkillCodeNo := GetRandomValueByRecordRef(SourceRecordRef, 1);
        exit(CopyStr(FoundSkillCodeNo, 1, MaxStrLen(Result)));
    end;

    procedure FindItemServiceRandom() ItemOfTypeServiceNo: Code[20]
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        TempItem: Record Item temporary;
        ItemCategory: Record "Item Category";
        NextCount, RecordCount : Integer;
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Item Category Service");

        ItemCategory.Get(ContractSetupTPZS."Item Category Service");
        ItemCategory.CreateItemBufferTPZS(TempItem, '');
        if TempItem.FindFirst() then; //Easy

        RecordCount := TempItem.Count();
        if RecordCount = 0 then exit;

        NextCount := LibraryRandom.RandIntInRange(1, RecordCount);
        if TempItem.Next(NextCount) <> 0 then
            ItemOfTypeServiceNo := TempItem."No.";
    end;

    procedure FindResourceRandom(ResourceGroupNo: Code[20]) ResourceNo: Code[20]
    var
        Resource: Record Resource;
        SourceRecordRef: RecordRef;
        FoundItemNo: Text;
    begin
        if ResourceGroupNo <> '' then
            Resource.SetRange("Resource Group No.", ResourceGroupNo);
        SourceRecordRef.GetTable(Resource);
        FoundItemNo := GetRandomValueByRecordRef(SourceRecordRef, 1);
        exit(CopyStr(FoundItemNo, 1, MaxStrLen(ResourceNo)));
    end;

    procedure GenerateRandomNumericText(Length: Integer) String: Text
    var
        I: Integer;
    begin
        for I := 1 to Length do
            String[I] := LibraryRandom.RandIntInRange(48, 57);
    end;

    procedure GetRandomContact(ContactType: Enum "Contact Type") ContactNo: Code[20]
    var
        Contact: Record Contact;
        SourceRecordRef: RecordRef;
        FoundContactNo: Text;
    begin
        Contact.SetRange(Type, ContactType);
        SourceRecordRef.GetTable(Contact);
        FoundContactNo := GetRandomValueByRecordRef(SourceRecordRef, 1);
        exit(CopyStr(FoundContactNo, 1, MaxStrLen(ContactNo)));
    end;

    procedure GetRandomValueByRecordRef(var SourceRecordRef: RecordRef; FieldID: Integer) Result: Text
    var
        SourceFieldRef: FieldRef;
        // FR2: FieldRef;
        NextCount: Integer;
        //RelRecRef: RecordRef;
        RecCount: Integer;
    begin
        RecCount := SourceRecordRef.Count();
        if RecCount = 0 then
            exit;

        NextCount := LibraryRandom.RandIntInRange(1, RecCount);
        if SourceRecordRef.Next(NextCount) <> 0 then begin
            SourceFieldRef := SourceRecordRef.Field(FieldID);
            Result := Format(SourceFieldRef.Value);
        end;
    end;

    procedure GetRandomValueByTableAndField(TableID: Integer; FieldID: Integer) Result: Text
    var
        RelRecordRef: RecordRef;
        FR2FieldRef: FieldRef;
        FRFieldRef: FieldRef;
        NextCount: Integer;
        RecCount: Integer;
    begin
        Assert.IsTrue(TableID <> 0, 'TableID = 0');
        Assert.IsTrue(FieldID <> 0, 'FieldID = 0');

        RelRecordRef.Open(TableID);

        //Hack
        if TableID = Database::"G/L Account" then begin
            FR2FieldRef := RelRecordRef.Field(14); //Direct Posting
            FR2FieldRef.SetRange(true);
        end;

        if TableID = Database::Item then begin
            FR2FieldRef := RelRecordRef.Field(54); //Blocked
            FR2FieldRef.SetRange(false);

            FR2FieldRef := RelRecordRef.Field(91); //Gen. Prod. Posting Group
            FR2FieldRef.SetFilter('<>%1', '');
        end;

        RecCount := RelRecordRef.Count();
        if RecCount = 0 then
            exit;

        NextCount := LibraryRandom.RandIntInRange(1, RecCount);
        if RelRecordRef.Next(NextCount) <> 0 then begin
            FRFieldRef := RelRecordRef.Field(FieldID);
            Result := Format(FRFieldRef.Value);
        end;
    end;

    procedure GetRandomValueByTable(TableID: Integer) Result: Text
    begin
        exit(GetRandomValueByTableAndField(TableID, 1));
    end;

    procedure GetRandomValueByTableCode10(TableID: Integer) Code: Code[10]
    var
        Result: Text;
    begin
        Result := GetRandomValueByTableAndField(TableID, 1);
        Code := CopyStr(Result, 1, 10);
    end;

    procedure GetRandomValueByTableCode20(TableID: Integer) Code: Code[20]
    var
        Result: Text;
    begin
        Result := GetRandomValueByTableAndField(TableID, 1);
        Code := CopyStr(Result, 1, 20);
    end;

    procedure RandDecInRange(Min: Integer; Max: Integer; Decimals: Integer; Precision: Integer) Result: Decimal
    begin
        Result := LibraryRandom.RandDecInRange(Min, Max, Decimals);
        Result := Round(Result, Precision);
    end;

    procedure IsRandomMod(Min: Integer; Max: Integer; ModInt: Integer): Boolean
    var
        RandomInt: Integer;
    begin
        RandomInt := LibraryRandom.RandIntInRange(Min, Max);
        if RandomInt mod ModInt = 0 then
            exit(true);
    end;

    procedure IsRandomMod(ModInt: Integer): Boolean
    begin
        exit(IsRandomMod(1, 10, ModInt));
    end;

    procedure RandDecInRange("Min": Integer; "Max": Integer; Decimals: Integer): Decimal
    begin
        // Returns a pseudo random decimal in the interval (Min,Max]
        exit(LibraryRandom.RandDecInRange(Min, Max, Decimals));
    end;

    procedure RandIntInRange("Min": Integer; "Max": Integer): Integer
    begin
        exit(LibraryRandom.RandIntInRange(Min, Max));
    end;

    procedure RandText(Length: Integer): Text
    begin
        exit(LibraryRandom.RandText(Length));
    end;

    // /// <summary>
    // /// Provides a Unicode text
    // /// </summary>
    // /// <param name="Length">Desired length of the text</param>
    // /// <returns>Pseudo-random Unicode text</returns>
    // procedure UnicodeText(Length: Integer) String: Text
    // var
    //     I: Integer;
    // begin
    //     for I := 1 to Length do
    //         String[I] := IntegerInRange(1072, 1103); // Cyrillic alphabet (to guarantee only printable chars)

    //     exit(String)
    // end;

    // /// <summary>
    // /// Provides an integer between 1 and the given value
    // /// </summary>
    // /// <param name="MaxValue">Upper value for the number, if the number is negative 1 is returned.</param>
    // /// <returns>Pseudo-random integer value</returns>
    // procedure IntegerInRange(MaxValue: Integer): Integer
    // begin
    //     if MaxValue < 1 then
    //         exit(1);

    //     exit(GetNextValue(MaxValue));
    // end;

    // /// <summary>
    // /// Provides an integer between the given values
    // /// </summary>
    // /// <param name="MinValue">Lower value for the number</param>
    // /// <param name="MaxValue">Upper value for the number</param>
    // /// <returns>Pseudo-random integer value</returns>
    // procedure IntegerInRange(MinValue: Integer; MaxValue: Integer): Integer
    // begin
    //     exit(MinValue - 1 + GetNextValue(MaxValue - MinValue + 1));
    // end;

    // /// <summary>.
    // /// This function must be called from all functions that want to use Pseudo-random generation.
    // /// This function will call the SetSeed with the default value to ensure the same numbers are returned
    // /// </summary>
    // /// <param name="MaxValue">Upper range for the number</param>
    // /// <returns>Pseudo-random integer value</returns>
    // local procedure GetNextValue(MaxValue: Integer): Integer
    // begin
    //     if Seed = 0 then
    //         SetSeed(1);

    //     exit(Random(MaxValue));
    // end;

    // /// <summary>.
    // /// Sets the Seed for Pseudo-random number generation.
    // /// Setting this value will change the numbers returned.
    // /// </summary>
    // /// <param name="NewSeed">New seed to be used.</param>
    // procedure SetSeed(NewSeed: Integer)
    // begin
    //     Seed := NewSeed;
    //     Randomize(Seed);
    // end;
}