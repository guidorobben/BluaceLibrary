codeunit 83969 "Init. Job LIB"
{
    var
        LibraryJob: Codeunit "Library - Job LIB";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init. All LIB", OnInitialize, '', false, false)]
    local procedure OnInitializeAll()
    begin
        Initialize();
    end;

    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        InitializeJobType();

        OnInitialize();
    end;

    procedure InitializeJobType()
    begin
        LibraryJob.CreateJobType('INTERN', 'Intern');
        LibraryJob.CreateJobType('EXTERN', 'Extern');
    end;

    [InternalEvent(false)]
    local procedure OnInitialize()
    begin
    end;
}