codeunit 83962 "Session Manager LIB"
{
    procedure SetAllLanguagesToEnglish()
    begin
        SetAllToEnglish(1033, 1033);
    end;

    procedure SetLanguageToEnglish()
    begin
        SetAllToEnglish(1033, 1043);
    end;

    procedure SetAllLanguagesToDutch()
    begin
        SetAllToEnglish(1043, 1043);
    end;

    procedure SetAllToEnglish(LanguageId: Integer; LocaleId: Integer)
    var
        Session: SessionSettings;
    begin
        Session.Init();
        Session.LanguageId(LanguageId);
        Session.LocaleId(LocaleId);
        Session.RequestSessionUpdate(true);
    end;

    procedure CurrentLanguageId(): Integer
    var
        Session: SessionSettings;
    begin
        Session.Init();
        exit(Session.LanguageId());
    end;

    procedure CurrentLocaleId(): Integer
    var
        Session: SessionSettings;
    begin
        Session.Init();
        exit(Session.LocaleId());
    end;
}