codeunit 83965 "Library - Maintenance LIB"
{
    Permissions =
        tabledata "Contr. Template Header CBLC" = R,
        tabledata "Contract Norm CBLC" = R,
        tabledata "Maint. Sched. Templ. Hdr. CBLC" = RIM,
        tabledata "Maint. Sched. Templ. Line CBLC" = RI,
        tabledata "Maint. Template Norm CBLC" = RIMD,
        tabledata "Object Maint. Schedule CBLC" = R,
        tabledata "Object Norm CBLC" = R,
        tabledata "Object Template CBLC" = R,
        tabledata "Object CBLC" = RM;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";

    procedure CreateMaintenanceTemplate(var MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC"; ScheduleCalcTypeCBLC: Enum "Schedule Calc. Type CBLC")
    begin
        MaintSchedTemplHdrCBLC.Init();
        MaintSchedTemplHdrCBLC."No." := '';
        MaintSchedTemplHdrCBLC.Insert(true);
        MaintSchedTemplHdrCBLC.TestField("No.");
        MaintSchedTemplHdrCBLC.Validate("Schedule Calc. Type", ScheduleCalcTypeCBLC);
        MaintSchedTemplHdrCBLC.Validate(Description, Format(ScheduleCalcTypeCBLC));
        MaintSchedTemplHdrCBLC.Modify(true);
    end;

    procedure CreateMaintenanceTemplateWithLines(var MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC"; ScheduleCalcTypeCBLC: Enum "Schedule Calc. Type CBLC")
    begin
        CreateMaintenanceTemplateWithLines(MaintSchedTemplHdrCBLC, ScheduleCalcTypeCBLC, '', 0);
    end;

    procedure CreateMaintenanceTemplateWithLines(var MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC"; ScheduleCalcTypeCBLC: Enum "Schedule Calc. Type CBLC"; ItemNo: Code[20]; LinesToCreate: Integer)
    var
        MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC";
        DevMax: DateFormula;
        DevMin: DateFormula;
        Periodicity: DateFormula;
        I: Integer;
        DevMaxTok: Label '<+1M>', Locked = true;
        DevMinTok: Label '<-1M>', Locked = true;
        YearTok: Label '<+%1Y>', Comment = '%1=Year', Locked = true;
    begin
        CreateMaintenanceTemplate(MaintSchedTemplHdrCBLC, ScheduleCalcTypeCBLC);

        if LinesToCreate = 0 then
            LinesToCreate := LibraryRandom.RandIntInRange(4, 10);

        for I := 1 to LinesToCreate do begin
            Evaluate(Periodicity, StrSubstNo(YearTok, I));
            Evaluate(DevMin, DevMinTok);
            Evaluate(DevMax, DevMaxTok);
            CreateMaintenanceTemplateLine(MaintSchedTemplHdrCBLC, MaintSchedTemplLineCBLC, ItemNo, Periodicity, DevMin, DevMax);
        end;
    end;

    procedure CreateMaintenanceTemplateLine(var MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC"; var MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC")
    var
        EmptyDF: DateFormula;
    begin
        CreateMaintenanceTemplateLine(MaintSchedTemplHdrCBLC, MaintSchedTemplLineCBLC, '', EmptyDF, EmptyDF, EmptyDF);
    end;

    procedure CreateMaintenanceTemplateLine(var MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC"; var MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC"; ItemNo: Code[20]; Periodicity: DateFormula; DevMinDate: DateFormula; DevMaxDate: DateFormula)
    begin
        MaintSchedTemplHdrCBLC.TestField("No.");

        MaintSchedTemplLineCBLC.Init();
        MaintSchedTemplLineCBLC.Validate("Maint. Template No.", MaintSchedTemplHdrCBLC."No.");
        MaintSchedTemplLineCBLC.Validate("Line No.", CreateNewMaintenanceTemplateLineNo(MaintSchedTemplHdrCBLC));

        if ItemNo = '' then
            ItemNo := LibraryRandomLIB.FindItemServiceRandom();

        Assert.IsTrue(ItemNo <> '', 'Item No. cannot be empty.');

        MaintSchedTemplLineCBLC.Validate("Item No. (Service)", ItemNo);
        MaintSchedTemplLineCBLC.Validate(Periodicity, Periodicity);
        MaintSchedTemplLineCBLC.Validate("Deviation Min. Date", DevMinDate);
        MaintSchedTemplLineCBLC.Validate("Deviation Max. Date", DevMaxDate);
        MaintSchedTemplLineCBLC.Insert(true);
    end;

    local procedure CreateNewMaintenanceTemplateLineNo(MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC") NewLineNo: Integer
    var
        MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC";
    begin
        MaintSchedTemplLineCBLC.SetRange("Maint. Template No.", MaintSchedTemplHdrCBLC."No.");
        if MaintSchedTemplLineCBLC.FindLast() then
            NewLineNo := MaintSchedTemplLineCBLC."Line No.";
        NewLineNo += 10000;
    end;

    procedure DeleteAllMaintenanceNorms()
    var
        MaintTemplateNormCBLC: Record "Maint. Template Norm CBLC";
    begin
        MaintTemplateNormCBLC.DeleteAll(false);
    end;

    procedure CreateMaintenanceNorm(ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormNo: Code[20]; RelatedNormTypeCBLC: Enum "Related Norm Type CBLC"; RelatedNormNo: Code[20]; MaintScheduldeTemplateNo: Code[20])
    var
        MaintTemplateNormCBLC: Record "Maint. Template Norm CBLC";
    begin
        MaintTemplateNormCBLC.SetRange("Object Norm Type", ObjectNormTypeCBLC);
        MaintTemplateNormCBLC.SetRange("Object Norm No.", ObjectNormNo);
        MaintTemplateNormCBLC.SetRange("Related Norm Type", RelatedNormTypeCBLC);
        MaintTemplateNormCBLC.SetRange("Related Norm No.", RelatedNormNo);
        if MaintTemplateNormCBLC.FindFirst() then begin
            if MaintScheduldeTemplateNo <> '' then begin
                MaintTemplateNormCBLC.Validate("Maint. Schedule Templ. No.", MaintScheduldeTemplateNo);
                // MaintTemplateNormCBLC.TestField("Maint. Schedule Templ. No.");
                MaintTemplateNormCBLC.Modify(true);
            end;
            exit;
        end;

        MaintTemplateNormCBLC.Init();
        MaintTemplateNormCBLC.Validate("Object Norm Type", ObjectNormTypeCBLC);
        MaintTemplateNormCBLC.Validate("Object Norm No.", ObjectNormNo);
        MaintTemplateNormCBLC.Validate("Related Norm Type", RelatedNormTypeCBLC);
        MaintTemplateNormCBLC.Validate("Related Norm No.", RelatedNormNo);
        if MaintScheduldeTemplateNo <> '' then
            MaintTemplateNormCBLC.Validate("Maint. Schedule Templ. No.", MaintScheduldeTemplateNo);
        // MaintTemplateNormCBLC.TestField("Maint. Schedule Templ. No.");
        MaintTemplateNormCBLC.Insert(true);
        MaintTemplateNormCBLC.TestField("Entry No.");
    end;

    procedure CreateObjectMaintenanceSchedule(var ObjectCBLC: Record "Object CBLC")
    var
        CreateObjectMaintMethCBLC: Codeunit "Create Object Maint. Meth CBLC";
        MaintScheduleCreated, MaintScheduleUpdated : Boolean;
        ValidOnDate: Date;
    begin
        //Bypass InternalsVisible
        ValidOnDate := Today();
        CreateObjectMaintMethCBLC.CreateObjectMaintenanceSchedule(ObjectCBLC, MaintScheduleCreated, MaintScheduleUpdated, ValidOnDate, not GuiAllowed());
        ObjectCBLC.Validate("Maint. Schedule Updated", true);
        ObjectCBLC.Modify(true);
    end;

    procedure HasMaintTemplateNorms(SourceVariant: Variant): Boolean
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractNormCBLC: Record "Contract Norm CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        MaintTemplateNormCBLC: Record "Maint. Template Norm CBLC";
        ObjectNormCBLC: Record "Object Norm CBLC";
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SourceRecordRef: RecordRef;
    begin
        if not SourceVariant.IsRecord() then
            exit;

        SourceRecordRef.GetTable(SourceVariant);
        case SourceRecordRef.Number() of
            Database::"Maint. Sched. Templ. Hdr. CBLC":
                begin
                    SourceRecordRef.SetTable(MaintSchedTemplHdrCBLC);
                    MaintSchedTemplHdrCBLC.TestField("No.");
                    MaintTemplateNormCBLC.SetRange("Maint. Schedule Templ. No.", MaintSchedTemplHdrCBLC."No.");
                    exit(not MaintTemplateNormCBLC.IsEmpty());
                end;
            Database::"Object Template CBLC":
                begin
                    SourceRecordRef.SetTable(ObjectTemplateCBLC);
                    ObjectTemplateCBLC.TestField("No.");
                    MaintTemplateNormCBLC.SetRange("Object Norm Type", MaintTemplateNormCBLC."Object Norm Type"::"Object Template");
                    MaintTemplateNormCBLC.SetRange("Object Norm No.", ObjectTemplateCBLC."No.");
                    exit(not MaintTemplateNormCBLC.IsEmpty());
                end;
            Database::"Object Norm CBLC":
                begin
                    SourceRecordRef.SetTable(ObjectNormCBLC);
                    ObjectNormCBLC.TestField(Code);
                    MaintTemplateNormCBLC.SetRange("Object Norm Type", MaintTemplateNormCBLC."Object Norm Type"::"Object Norm");
                    MaintTemplateNormCBLC.SetRange("Object Norm No.", ObjectNormCBLC.Code);
                    exit(not MaintTemplateNormCBLC.IsEmpty());
                end;
            Database::"Contract Norm CBLC":
                begin
                    SourceRecordRef.SetTable(ContractNormCBLC);
                    ContractNormCBLC.TestField(Code);
                    MaintTemplateNormCBLC.SetRange("Related Norm Type", MaintTemplateNormCBLC."Related Norm Type"::"Contract Norm");
                    MaintTemplateNormCBLC.SetRange("Related Norm No.", ContractNormCBLC.Code);
                    exit(not MaintTemplateNormCBLC.IsEmpty());
                end;
            Database::"Contr. Template Header CBLC":
                begin
                    SourceRecordRef.SetTable(ContrTemplateHeaderCBLC);
                    ContrTemplateHeaderCBLC.TestField("No.");
                    MaintTemplateNormCBLC.SetRange("Related Norm Type", MaintTemplateNormCBLC."Related Norm Type"::"Contract Template");
                    MaintTemplateNormCBLC.SetRange("Related Norm No.", ContrTemplateHeaderCBLC."No.");
                    exit(not MaintTemplateNormCBLC.IsEmpty());
                end;
        end;
    end;

    procedure HasObjectMaintenance(ObjectCBLC: Record "Object CBLC"): Boolean
    var
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
    begin
        ObjectCBLC.TestField("No.");

        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        exit(not ObjectMaintScheduleCBLC.IsEmpty());
    end;

    procedure UpdateObjectMaintSchedules(var ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC")
    var
    begin
        ObjectMaintScheduleCBLC.UpdateObjectMaintSchedules();
    end;
}
