codeunit 83956 "Init. Property LIB"
{
    var
        LibraryProperty: Codeunit "Library - Property LIB";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init. All LIB", OnInitialize, '', false, false)]
    local procedure OnInitialize()
    begin
        Initialize();
    end;

    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        InitializeObjectProperties();
        InitializeObjectPropertyValues();
        CreatePropertyMappings();
    end;

    procedure InitializeObjectProperties()
    var
        PropertyCode: Code[20];
    begin
        PropertyCode := 'BOUWJAAR';
        LibraryProperty.CreateProperty(Database::"Object TPZS", PropertyCode, 'Bouwjaar', Enum::"Property Type RBLC"::Integer, true);

        PropertyCode := 'PLAATSINGSDATUM';
        LibraryProperty.CreateProperty(Database::"Object TPZS", PropertyCode, 'Plaatsingsdatum', Enum::"Property Type RBLC"::Date, true);

        PropertyCode := 'VERMOGEN';
        LibraryProperty.CreateProperty(Database::"Object TPZS", PropertyCode, 'Vermogen', Enum::"Property Type RBLC"::Text, false);

        PropertyCode := 'KLEUR';
        LibraryProperty.CreateProperty(Database::"Object TPZS", PropertyCode, 'Kleur', Enum::"Property Type RBLC"::Text, false);
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, 'Zwart');
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, 'Wit');

        PropertyCode := 'VOLTAGE';
        LibraryProperty.CreateProperty(Database::"Object TPZS", PropertyCode, 'Voltage', Enum::"Property Type RBLC"::Integer, true);
    end;

    procedure InitializeObjectPropertyValues()
    var
        PropertyCode: Code[20];
    begin
        // PropertyCode := 'BOUWJAAR';
        // LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '1977');

        PropertyCode := 'VERMOGEN';
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '<50');
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '>50');
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '<150');
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '>150');
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '>=666');
        LibraryProperty.CreatePropertyValue(Database::"Object TPZS", PropertyCode, '>=1000');
    end;

    procedure CreatePropertyMappings()
    begin
        if not LibraryProperty.HasPropertyMapping(Database::"Object Template TPZS", Database::"Object TPZS") then
            LibraryProperty.CreatePropertyMapping(Database::"Object Template TPZS", Database::"Object TPZS");
    end;

    // ObjectImportLineTPZS."Property 1" := Format(LibraryRandom.RandIntInRange(2010, 2021)); //BOUWJAAR
    //     ObjectImportLineTPZS."Property 2" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupTPZS."Property 2 Code");
    //     ObjectImportLineTPZS."Property 3" := Format(LibraryRandom.RandDateFromInRange(20200101D, 1, 100)); //PLAATSINGSDATUM
    //     ObjectImportLineTPZS."Property 4" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupTPZS."Property 4 Code");
    //     ObjectImportLineTPZS."Property 5" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupTPZS."Property 5 Code"); //VERMOGEN
    //     O
}
