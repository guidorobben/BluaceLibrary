codeunit 83967 "Library - Priority LIB"
{
    Permissions =
        tabledata "Priority TPZS" = rid;

    procedure CreatePriority(NewCode: Code[20]; Description: Text[100])
    var
        PriorityTPZS: Record "Priority TPZS";
    begin
        CreatePriority(PriorityTPZS, NewCode, Description);
    end;

    procedure DeleteAllPriorities(UseTrigger: Boolean)
    var
        PriorityTPZS: Record "Priority TPZS";
    begin
        PriorityTPZS.DeleteAll(UseTrigger);
    end;

    procedure CreatePriority(var PriorityTPZS: Record "Priority TPZS"; NewCode: Code[20]; Description: Text[100])
    begin
        CreatePriority(PriorityTPZS, NewCode, Description, 0, true, false);
    end;

    procedure CreatePriority(NewCode: Code[20]; Description: Text[100]; Duration: Integer; WorkTimeOnly: Boolean; IgnoreObjectAvailability: Boolean)
    var
        PriorityTPZS: Record "Priority TPZS";
    begin
        CreatePriority(PriorityTPZS, NewCode, Description, Duration, WorkTimeOnly, IgnoreObjectAvailability);
    end;

    procedure CreatePriority(var PriorityTPZS: Record "Priority TPZS"; NewCode: Code[20]; Description: Text[100]; Duration: Integer; WorkTimeOnly: Boolean; IgnoreObjectAvailability: Boolean)
    begin
        PriorityTPZS.Init();
        PriorityTPZS.Validate(Code, NewCode);
        PriorityTPZS.Validate(Description, Description);
        PriorityTPZS.Validate(Duration, Duration);
        PriorityTPZS.Validate("Work Time Only", WorkTimeOnly);
        PriorityTPZS.Validate("Ignore Object Availability", IgnoreObjectAvailability);
        PriorityTPZS.Insert(true);
    end;
}