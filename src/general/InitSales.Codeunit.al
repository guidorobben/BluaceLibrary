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

        InitializePurchasingCode();
    end;

    local procedure InitializePurchasingCode()
    begin
        LibrarySales.CreatePurchasingCode('MVR', 'Materiaal via reservering', false, true);
    end;
}
