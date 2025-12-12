codeunit 83970 "Init. Sales LIB"
{
    var
        LibrarySales: Codeunit "Library - Sales LIB";

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

        InitializePurchasingCodes();
        InitializeTransactionTypes();
    end;

    procedure InitializePurchasingCodes()
    begin
        LibrarySales.CreatePurchasingCode('MPG', 'Wijziging prioriteit', false, true);
        LibrarySales.CreatePurchasingCode('MVR', 'Materiaal via reservering', false, true);
        LibrarySales.CreatePurchasingCode('SPOED', 'Spoedlevering', false, true);
    end;

    procedure InitializeTransactionTypes()
    begin
        LibrarySales.CreateTransactionType('1', 'Normale inkoop/verkoop (eigendomsoverdracht met financiele tegenprestatie)');
        LibrarySales.CreateTransactionType('6', 'Tijdelijke in-en uitvoer / Retour in- en uitvoer');
    end;
}