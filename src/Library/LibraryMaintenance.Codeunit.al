codeunit 83965 "Library - Maintenance LIB"
{
    Permissions =
        tabledata "Contr. Template Header TPZS" = R,
        tabledata "Contract Norm TPZS" = R,
        tabledata "Maint. Sched. Templ. Hdr. TPZS" = RIM,
        tabledata "Maint. Sched. Templ. Line TPZS" = RI,
        tabledata "Maint. Template Norm TPZS" = RIMD,
        tabledata "Object Maint. Schedule TPZS" = R,
        tabledata "Object Norm TPZS" = R,
        tabledata "Object Template TPZS" = R,
        tabledata "Object TPZS" = RM;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";

    procedure CreateMaintenanceTemplate(var MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS"; ScheduleCalcTypeTPZS: Enum "Schedule Calc. Type TPZS")
    begin
        MaintSchedTemplHdrTPZS.Init();
        MaintSchedTemplHdrTPZS."No." := '';
        MaintSchedTemplHdrTPZS.Insert(true);
        MaintSchedTemplHdrTPZS.TestField("No.");
        MaintSchedTemplHdrTPZS.Validate("Schedule Calc. Type", ScheduleCalcTypeTPZS);
        MaintSchedTemplHdrTPZS.Validate(Description, Format(ScheduleCalcTypeTPZS));
        MaintSchedTemplHdrTPZS.Modify(true);
    end;

    procedure CreateMaintenanceTemplateWithLines(var MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS"; ScheduleCalcTypeTPZS: Enum "Schedule Calc. Type TPZS")
    begin
        CreateMaintenanceTemplateWithLines(MaintSchedTemplHdrTPZS, ScheduleCalcTypeTPZS, '', 0);
    end;

    procedure CreateMaintenanceTemplateWithLines(var MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS"; ScheduleCalcTypeTPZS: Enum "Schedule Calc. Type TPZS"; ItemNo: Code[20]; LinesToCreate: Integer)
    var
        MaintSchedTemplLineTPZS: Record "Maint. Sched. Templ. Line TPZS";
        DevMax: DateFormula;
        DevMin: DateFormula;
        Periodicity: DateFormula;
        I: Integer;
        DevMaxTok: Label '<+1M>', Locked = true;
        DevMinTok: Label '<-1M>', Locked = true;
        YearTok: Label '<+%1Y>', Comment = '%1=Year', Locked = true;
    begin
        CreateMaintenanceTemplate(MaintSchedTemplHdrTPZS, ScheduleCalcTypeTPZS);

        if LinesToCreate = 0 then
            LinesToCreate := LibraryRandom.RandIntInRange(4, 10);

        for I := 1 to LinesToCreate do begin
            Evaluate(Periodicity, StrSubstNo(YearTok, I));
            Evaluate(DevMin, DevMinTok);
            Evaluate(DevMax, DevMaxTok);
            CreateMaintenanceTemplateLine(MaintSchedTemplHdrTPZS, MaintSchedTemplLineTPZS, ItemNo, Periodicity, DevMin, DevMax);
        end;
    end;

    procedure CreateMaintenanceTemplateLine(var MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS"; var MaintSchedTemplLineTPZS: Record "Maint. Sched. Templ. Line TPZS")
    var
        EmptyDF: DateFormula;
    begin
        CreateMaintenanceTemplateLine(MaintSchedTemplHdrTPZS, MaintSchedTemplLineTPZS, '', EmptyDF, EmptyDF, EmptyDF);
    end;

    procedure CreateMaintenanceTemplateLine(var MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS"; var MaintSchedTemplLineTPZS: Record "Maint. Sched. Templ. Line TPZS"; ItemNo: Code[20]; Periodicity: DateFormula; DevMinDate: DateFormula; DevMaxDate: DateFormula)
    begin
        MaintSchedTemplHdrTPZS.TestField("No.");

        MaintSchedTemplLineTPZS.Init();
        MaintSchedTemplLineTPZS.Validate("Maint. Template No.", MaintSchedTemplHdrTPZS."No.");
        MaintSchedTemplLineTPZS.Validate("Line No.", CreateNewMaintenanceTemplateLineNo(MaintSchedTemplHdrTPZS));

        if ItemNo = '' then
            ItemNo := LibraryRandomLIB.FindItemServiceRandom();

        Assert.IsTrue(ItemNo <> '', 'Item No. cannot be empty.');

        MaintSchedTemplLineTPZS.Validate("Item No. (Service)", ItemNo);
        MaintSchedTemplLineTPZS.Validate(Periodicity, Periodicity);
        MaintSchedTemplLineTPZS.Validate("Deviation Min. Date", DevMinDate);
        MaintSchedTemplLineTPZS.Validate("Deviation Max. Date", DevMaxDate);
        MaintSchedTemplLineTPZS.Insert(true);
    end;

    local procedure CreateNewMaintenanceTemplateLineNo(MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS") NewLineNo: Integer
    var
        MaintSchedTemplLineTPZS: Record "Maint. Sched. Templ. Line TPZS";
    begin
        MaintSchedTemplLineTPZS.SetRange("Maint. Template No.", MaintSchedTemplHdrTPZS."No.");
        if MaintSchedTemplLineTPZS.FindLast() then
            NewLineNo := MaintSchedTemplLineTPZS."Line No.";
        NewLineNo += 10000;
    end;

    procedure DeleteAllMaintenanceNorms()
    var
        MaintTemplateNormTPZS: Record "Maint. Template Norm TPZS";
    begin
        MaintTemplateNormTPZS.DeleteAll(false);
    end;

    procedure CreateMaintenanceNorm(ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormNo: Code[20]; RelatedNormTypeTPZS: Enum "Related Norm Type TPZS"; RelatedNormNo: Code[20]; MaintScheduldeTemplateNo: Code[20])
    var
        MaintTemplateNormTPZS: Record "Maint. Template Norm TPZS";
    begin
        MaintTemplateNormTPZS.SetRange("Object Norm Type", ObjectNormTypeTPZS);
        MaintTemplateNormTPZS.SetRange("Object Norm No.", ObjectNormNo);
        MaintTemplateNormTPZS.SetRange("Related Norm Type", RelatedNormTypeTPZS);
        MaintTemplateNormTPZS.SetRange("Related Norm No.", RelatedNormNo);
        if MaintTemplateNormTPZS.FindFirst() then begin
            if MaintScheduldeTemplateNo <> '' then begin
                MaintTemplateNormTPZS.Validate("Maint. Schedule Templ. No.", MaintScheduldeTemplateNo);
                // MaintTemplateNormTPZS.TestField("Maint. Schedule Templ. No.");
                MaintTemplateNormTPZS.Modify(true);
            end;
            exit;
        end;

        MaintTemplateNormTPZS.Init();
        MaintTemplateNormTPZS.Validate("Object Norm Type", ObjectNormTypeTPZS);
        MaintTemplateNormTPZS.Validate("Object Norm No.", ObjectNormNo);
        MaintTemplateNormTPZS.Validate("Related Norm Type", RelatedNormTypeTPZS);
        MaintTemplateNormTPZS.Validate("Related Norm No.", RelatedNormNo);
        if MaintScheduldeTemplateNo <> '' then
            MaintTemplateNormTPZS.Validate("Maint. Schedule Templ. No.", MaintScheduldeTemplateNo);
        // MaintTemplateNormTPZS.TestField("Maint. Schedule Templ. No.");
        MaintTemplateNormTPZS.Insert(true);
        MaintTemplateNormTPZS.TestField("Entry No.");
    end;

    procedure CreateObjectMaintenanceSchedule(var ObjectTPZS: Record "Object TPZS")
    var
        CreateObjectMaintMethTPZS: Codeunit "Create Object Maint. Meth TPZS";
        MaintScheduleCreated, MaintScheduleUpdated : Boolean;
        ValidOnDate: Date;
    begin
        //Bypass InternalsVisible
        ValidOnDate := Today();
        CreateObjectMaintMethTPZS.CreateObjectMaintenanceSchedule(ObjectTPZS, MaintScheduleCreated, MaintScheduleUpdated, ValidOnDate, not GuiAllowed());
        ObjectTPZS.Validate("Maint. Schedule Updated", true);
        ObjectTPZS.Modify(true);
    end;

    procedure HasMaintTemplateNorms(SourceVariant: Variant): Boolean
    var
        ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS";
        ContractNormTPZS: Record "Contract Norm TPZS";
        MaintSchedTemplHdrTPZS: Record "Maint. Sched. Templ. Hdr. TPZS";
        MaintTemplateNormTPZS: Record "Maint. Template Norm TPZS";
        ObjectNormTPZS: Record "Object Norm TPZS";
        ObjectTemplateTPZS: Record "Object Template TPZS";
        SourceRecordRef: RecordRef;
    begin
        if not SourceVariant.IsRecord() then
            exit;

        SourceRecordRef.GetTable(SourceVariant);
        case SourceRecordRef.Number() of
            Database::"Maint. Sched. Templ. Hdr. TPZS":
                begin
                    SourceRecordRef.SetTable(MaintSchedTemplHdrTPZS);
                    MaintSchedTemplHdrTPZS.TestField("No.");
                    MaintTemplateNormTPZS.SetRange("Maint. Schedule Templ. No.", MaintSchedTemplHdrTPZS."No.");
                    exit(not MaintTemplateNormTPZS.IsEmpty());
                end;
            Database::"Object Template TPZS":
                begin
                    SourceRecordRef.SetTable(ObjectTemplateTPZS);
                    ObjectTemplateTPZS.TestField("No.");
                    MaintTemplateNormTPZS.SetRange("Object Norm Type", MaintTemplateNormTPZS."Object Norm Type"::"Object Template");
                    MaintTemplateNormTPZS.SetRange("Object Norm No.", ObjectTemplateTPZS."No.");
                    exit(not MaintTemplateNormTPZS.IsEmpty());
                end;
            Database::"Object Norm TPZS":
                begin
                    SourceRecordRef.SetTable(ObjectNormTPZS);
                    ObjectNormTPZS.TestField(Code);
                    MaintTemplateNormTPZS.SetRange("Object Norm Type", MaintTemplateNormTPZS."Object Norm Type"::"Object Norm");
                    MaintTemplateNormTPZS.SetRange("Object Norm No.", ObjectNormTPZS.Code);
                    exit(not MaintTemplateNormTPZS.IsEmpty());
                end;
            Database::"Contract Norm TPZS":
                begin
                    SourceRecordRef.SetTable(ContractNormTPZS);
                    ContractNormTPZS.TestField(Code);
                    MaintTemplateNormTPZS.SetRange("Related Norm Type", MaintTemplateNormTPZS."Related Norm Type"::"Contract Norm");
                    MaintTemplateNormTPZS.SetRange("Related Norm No.", ContractNormTPZS.Code);
                    exit(not MaintTemplateNormTPZS.IsEmpty());
                end;
            Database::"Contr. Template Header TPZS":
                begin
                    SourceRecordRef.SetTable(ContrTemplateHeaderTPZS);
                    ContrTemplateHeaderTPZS.TestField("No.");
                    MaintTemplateNormTPZS.SetRange("Related Norm Type", MaintTemplateNormTPZS."Related Norm Type"::"Contract Template");
                    MaintTemplateNormTPZS.SetRange("Related Norm No.", ContrTemplateHeaderTPZS."No.");
                    exit(not MaintTemplateNormTPZS.IsEmpty());
                end;
        end;
    end;

    procedure HasObjectMaintenance(ObjectTPZS: Record "Object TPZS"): Boolean
    var
        ObjectMaintScheduleTPZS: Record "Object Maint. Schedule TPZS";
    begin
        ObjectTPZS.TestField("No.");

        ObjectMaintScheduleTPZS.SetRange("Object No.", ObjectTPZS."No.");
        exit(not ObjectMaintScheduleTPZS.IsEmpty());
    end;

    procedure UpdateObjectMaintSchedules(var ObjectMaintScheduleTPZS: Record "Object Maint. Schedule TPZS")
    var
        UpdateObjMaintSched: Codeunit "Update Obj. Maint Sched. TPZS";
    begin
        UpdateObjMaintSched.UpdateObjectMaintSchedules(ObjectMaintScheduleTPZS);
    end;
}
