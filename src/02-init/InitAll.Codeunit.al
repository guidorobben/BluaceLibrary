codeunit 83968 "Init. All LIB"
{

    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        OnInitialize();
    end;

    [InternalEvent(false)]
    local procedure OnInitialize()
    begin
    end;
}