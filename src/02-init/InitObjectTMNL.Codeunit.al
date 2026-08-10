codeunit 83961 "Init Object TM-NL LIB"
{
    Permissions =
        tabledata "Object Setup TPZS" = rm,
        tabledata "Post Code Serv. Setup NBLC" = rim;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init. Object LIB", OnInitialize, '', false, false)]
    local procedure OnInitialize()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        InitializeObjectSetupTMNL();
        InitPostCodeServSetupTMNL();
    end;

    procedure InitializeObjectSetupTMNL()
    var
        ObjectSetupTPZS: Record "Object Setup TPZS";
    begin
        ObjectSetupTPZS.Get();
        if ObjectSetupTPZS."Country Code NL NBLC" = '' then
            ObjectSetupTPZS.Validate("Country Code NL NBLC", 'NL');
        ObjectSetupTPZS.Modify(true);
    end;

    procedure InitPostCodeServSetupTMNL()
    var
        PostCodeServSetupNBLC: Record "Post Code Serv. Setup NBLC";
    begin
        if not PostCodeServSetupNBLC.Get() then
            InsertIfNotExists();

        // PostCodeServSetupBluace();
    end;

    // procedure PostCodeServSetupBluace()
    // var
    //     PostCodeServSetupNBLC: Record "Post Code Serv. Setup NBLC";
    // begin
    //     PostCodeServSetupNBLC.Get();
    //     PostCodeServSetupNBLC.Validate(Type, PostCodeServSetupNBLC.Type::Bluace);
    //     PostCodeServSetupNBLC.Validate("API Key", 'M4%f8-oZcoO9/|/i^[NN0XDwRlvLP=');
    //     PostCodeServSetupNBLC.Validate(Endpoint, 'https://bluace-addresscheck-dev.azurewebsites.net/AddressCheck');
    //     PostCodeServSetupNBLC.Modify(true);
    // end;

    procedure PostCodeServSetupPostNL()
    var
        PostCodeServSetupNBLC: Record "Post Code Serv. Setup NBLC";
    begin
        PostCodeServSetupNBLC.Get();
        // PostCodeServSetupNBLC.Validate(Type, PostCodeServSetupNBLC.Type::PostNL);
        PostCodeServSetupNBLC.Validate("API Key", 'D1JIlqt0fim4oDPoiFYvAs7SrAaVogv7');
        PostCodeServSetupNBLC.Validate(Endpoint, 'https://api.postnl.nl/v4/address/netherlands');
        PostCodeServSetupNBLC.Modify(true);
    end;

    local procedure InsertIfNotExists()
    var
        PostCodeServSetupNBLC: Record "Post Code Serv. Setup NBLC";
    begin
        PostCodeServSetupNBLC.Reset();
        if not PostCodeServSetupNBLC.Get() then begin
            PostCodeServSetupNBLC.Init();
            PostCodeServSetupNBLC.Insert(true);
        end;
    end;
}