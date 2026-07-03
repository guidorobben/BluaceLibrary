codeunit 83967 "Library - Priority LIB"
{
    Permissions =
        tabledata "Priority CBLC" = RID;

    procedure CreatePriority(NewCode: Code[20]; Description: Text[100])
    var
        PriorityCBLC: Record "Priority CBLC";
    begin
        CreatePriority(PriorityCBLC, NewCode, Description);
    end;

    procedure DeleteAllPriorities(UseTrigger: Boolean)
    var
        PriorityCBLC: Record "Priority CBLC";
    begin
        PriorityCBLC.DeleteAll(UseTrigger);
    end;

    procedure CreatePriority(var PriorityCBLC: Record "Priority CBLC"; NewCode: Code[20]; Description: Text[100])
    begin
        CreatePriority(PriorityCBLC, NewCode, Description, 0, true, false);
    end;

    procedure CreatePriority(NewCode: Code[20]; Description: Text[100]; Duration: Integer; WorkTimeOnly: Boolean; IgnoreObjectAvailability: Boolean)
    var
        PriorityCBLC: Record "Priority CBLC";
    begin
        CreatePriority(PriorityCBLC, NewCode, Description, Duration, WorkTimeOnly, IgnoreObjectAvailability);
    end;

    procedure CreatePriority(var PriorityCBLC: Record "Priority CBLC"; NewCode: Code[20]; Description: Text[100]; Duration: Integer; WorkTimeOnly: Boolean; IgnoreObjectAvailability: Boolean)
    begin
        PriorityCBLC.Init();
        PriorityCBLC.Validate(Code, NewCode);
        PriorityCBLC.Validate(Description, Description);
        PriorityCBLC.Validate(Duration, Duration);
        PriorityCBLC.Validate("Work Time Only", WorkTimeOnly);
        PriorityCBLC.Validate("Ignore Object Availability", IgnoreObjectAvailability);
        PriorityCBLC.Insert(true);
    end;
}