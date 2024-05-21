codeunit 83967 "Library - Priority LIB"
{

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
        CreatePriority(NewCode, Description, 0, true, false);
    end;

    procedure CreatePriority(NewCode: Code[20]; Description: Text[100]; Duration: Integer; WorkTimeOnly: Boolean; IgnoreObjectAvailability: Boolean)
    var
        PriorityTPZS: Record "Priority TPZS";
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
