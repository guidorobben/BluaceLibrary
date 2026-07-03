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
        CreatePropertyMappings();
    end;

    procedure InitializeObjectProperties()
    var
        PropertyCode: Code[20];
    begin
        PropertyCode := 'BOUWJAAR';
        LibraryProperty.CreateProperty(Database::"Object CBLC", PropertyCode, 'Bouwjaar', Enum::"Property Type BBLC"::Integer, true);

        PropertyCode := 'PLAATSINGSDATUM';
        LibraryProperty.CreateProperty(Database::"Object CBLC", PropertyCode, 'Plaatsingsdatum', Enum::"Property Type BBLC"::Date, true);

        PropertyCode := 'VERMOGEN';
        if not LibraryProperty.PropertyExist(Database::"Object CBLC", PropertyCode) then begin
            LibraryProperty.CreateProperty(Database::"Object CBLC", PropertyCode, 'Vermogen', Enum::"Property Type BBLC"::Text, false);
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, '<50');
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, '>50');
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, '<150');
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, '>150');
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, '>=666');
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, '>=1000');
        end;

        PropertyCode := 'KLEUR';
        if not LibraryProperty.PropertyExist(Database::"Object CBLC", PropertyCode) then begin
            LibraryProperty.CreateProperty(Database::"Object CBLC", PropertyCode, 'Kleur', Enum::"Property Type BBLC"::Text, false);
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, 'Zwart');
            LibraryProperty.CreatePropertyValue(Database::"Object CBLC", PropertyCode, 'Wit');
        end;

        PropertyCode := 'VOLTAGE';
        LibraryProperty.CreateProperty(Database::"Object CBLC", PropertyCode, 'Voltage', Enum::"Property Type BBLC"::Integer, true);
    end;

    procedure CreatePropertyMappings()
    begin
        if not LibraryProperty.HasPropertyMapping(Database::"Object Template CBLC", Database::"Object CBLC") then
            LibraryProperty.CreatePropertyMapping(Database::"Object Template CBLC", Database::"Object CBLC");
    end;

    // ObjectImportLineCBLC."Property 1" := Format(LibraryRandom.RandIntInRange(2010, 2021)); //BOUWJAAR
    //     ObjectImportLineCBLC."Property 2" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 2 Code");
    //     ObjectImportLineCBLC."Property 3" := Format(LibraryRandom.RandDateFromInRange(20200101D, 1, 100)); //PLAATSINGSDATUM
    //     ObjectImportLineCBLC."Property 4" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 4 Code");
    //     ObjectImportLineCBLC."Property 5" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 5 Code"); //VERMOGEN
    //     O
}
