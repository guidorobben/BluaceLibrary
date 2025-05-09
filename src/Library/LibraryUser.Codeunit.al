codeunit 83963 "Library - User LIB"
{
    Permissions =
        tabledata "User Setup" = RIM;

    procedure AddUserSetup(UserName: Code[50])
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserName) then
            exit;

        UserSetup.Init();
        UserSetup.Validate("User ID", UserName);
        UserSetup.Insert(true);
    end;

    procedure SetUserAsTimeSheetAdmin(UserName: Code[50])
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserName);
        UserSetup.Validate("Time Sheet Admin.", true);
        UserSetup.Modify(true);
    end;
}
