codeunit 83961 "Init Object TM-NL LIB"
{
    Permissions =
        tabledata "Object Setup CBLC" = RM,
        tabledata "Post Code Serv. Setup YBLC" = RIM;

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
        ObjectSetupCBLC: Record "Object Setup CBLC";
    begin
        ObjectSetupCBLC.Get();
        if ObjectSetupCBLC."Country Code NL YBLC" = '' then
            ObjectSetupCBLC.Validate("Country Code NL YBLC", 'NL');
        ObjectSetupCBLC.Modify(true);
    end;

    procedure InitPostCodeServSetupTMNL()
    var
        PostCodeServSetupYBLC: Record "Post Code Serv. Setup YBLC";
    begin
        if not PostCodeServSetupYBLC.Get() then
            InsertIfNotExists();

        // PostCodeServSetupBluace();
    end;

    // procedure PostCodeServSetupBluace()
    // var
    //     PostCodeServSetupYBLC: Record "Post Code Serv. Setup YBLC";
    // begin
    //     PostCodeServSetupYBLC.Get();
    //     PostCodeServSetupYBLC.Validate(Type, PostCodeServSetupYBLC.Type::Bluace);
    //     PostCodeServSetupYBLC.Validate("API Key", 'M4%f8-oZcoO9/|/i^[NN0XDwRlvLP=');
    //     PostCodeServSetupYBLC.Validate(Endpoint, 'https://bluace-addresscheck-dev.azurewebsites.net/AddressCheck');
    //     PostCodeServSetupYBLC.Modify(true);
    // end;

    procedure PostCodeServSetupPostNL()
    var
        PostCodeServSetupYBLC: Record "Post Code Serv. Setup YBLC";
    begin
        PostCodeServSetupYBLC.Get();
        // PostCodeServSetupYBLC.Validate(Type, PostCodeServSetupYBLC.Type::PostNL);
        PostCodeServSetupYBLC.Validate("API Key", 'D1JIlqt0fim4oDPoiFYvAs7SrAaVogv7');
        PostCodeServSetupYBLC.Validate(Endpoint, 'https://api.postnl.nl/v4/address/netherlands');
        PostCodeServSetupYBLC.Modify(true);
    end;

    local procedure InsertIfNotExists()
    var
        PostCodeServSetupYBLC: Record "Post Code Serv. Setup YBLC";
    begin
        PostCodeServSetupYBLC.Reset();
        if not PostCodeServSetupYBLC.Get() then begin
            PostCodeServSetupYBLC.Init();
            PostCodeServSetupYBLC.Insert(true);
        end;
    end;
}