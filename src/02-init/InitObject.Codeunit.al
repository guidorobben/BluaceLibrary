codeunit 83951 "Init. Object LIB"
{
    Permissions =
        tabledata "Object Setup CBLC" = RIM,
        tabledata "Object Status CBLC" = R;

    var
        LibraryGeneral: Codeunit "Library - General LIB";
        // LibraryMaintenance: Codeunit "Library - Maintenance LIB";
        LibraryObject: Codeunit "Library - Object LIB";
        LibraryUtility: Codeunit "Library - Utility LIB";

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
        InitializeObjectStatus();
        InitializeObjectSetup();
        InitializeObjectContactRole();
        InitializeMaintTemplateNorm();

        OnInitialize();
    end;

    procedure InitializeObjectSetup()
    var
        ObjectSetupCBLC: Record "Object Setup CBLC";
        ObjectStatusCBLC: Record "Object Status CBLC";
        NoSeriesCode: Code[20];
    begin
        if not ObjectSetupCBLC.Get() then begin
            ObjectSetupCBLC.Init();
            ObjectSetupCBLC.Insert(true);
        end;

        if ObjectSetupCBLC."Object Nos." = '' then begin
            LibraryUtility.CreateNoSeries('OBJECTS', true, false, false);
            LibraryUtility.CreateNoSeriesLine('OBJECTS', 'OBJ00001', 'OBJ99999');
            ObjectSetupCBLC."Object Nos." := 'OBJECTS';
            ObjectSetupCBLC.Modify(true);
        end;

        if ObjectSetupCBLC."Object Template Nos." = '' then begin
            LibraryUtility.CreateNoSeries('OBJTEMPLATE', true, true, false);
            LibraryUtility.CreateNoSeriesLine('OBJTEMPLATE', 'OBJS00001', 'OBJS99999');
            ObjectSetupCBLC."Object Template Nos." := 'OBJTEMPLATE';
            ObjectSetupCBLC.Modify(true);
        end;

        if ObjectSetupCBLC."Sales Quote Nos. (Service)" = '' then begin
            NoSeriesCode := 'V-OFF-SERVICE';
            if not LibraryGeneral.NoSeriesExists(NoSeriesCode) then begin
                LibraryUtility.CreateNoSeries(NoSeriesCode, true, false, false);
                LibraryUtility.CreateNoSeriesLine(NoSeriesCode, 'VOFS000001', 'VOFS999999');
                ObjectSetupCBLC."Sales Quote Nos. (Service)" := NoSeriesCode;
                ObjectSetupCBLC.Modify(true);
            end;
        end;

        if ObjectSetupCBLC."Sales Order Nos. (Service)" = '' then begin
            NoSeriesCode := 'V-ORD-SERVICE';
            if not LibraryGeneral.NoSeriesExists(NoSeriesCode) then begin
                LibraryUtility.CreateNoSeries(NoSeriesCode, true, false, false);
                LibraryUtility.CreateNoSeriesLine(NoSeriesCode, 'VORS000001', 'VORSS999999');
                ObjectSetupCBLC."Sales Order Nos. (Service)" := NoSeriesCode;
                ObjectSetupCBLC.Modify(true);
            end;
        end;

        if ObjectSetupCBLC."Maint. Sched. Template Nos." = '' then begin
            NoSeriesCode := 'MAINT';
            if not LibraryGeneral.NoSeriesExists(NoSeriesCode) then begin
                LibraryUtility.CreateNoSeries(NoSeriesCode, true, false, false);
                LibraryUtility.CreateNoSeriesLine(NoSeriesCode, 'M0000001', 'M999999');
                ObjectSetupCBLC."Maint. Sched. Template Nos." := NoSeriesCode;
                ObjectSetupCBLC.Modify(true);
            end;
        end;

        if ObjectSetupCBLC."Replacement Object Status" = '' then begin
            ObjectSetupCBLC.Validate("Replacement Object Status", 'BEEINDIGD');
            ObjectSetupCBLC.Modify(true);
        end;

        if ObjectSetupCBLC."Replacement Object Status" = '' then begin
            ObjectStatusCBLC.SetRange(Blocked, true);
            ObjectStatusCBLC.SetRange("End Object Contact/Contract", true);
            ObjectStatusCBLC.SetLoadFields(Code);
            if ObjectStatusCBLC.FindFirst() then; //Its there

            ObjectSetupCBLC.Validate("Replacement Object Status", ObjectStatusCBLC.Code);
            ObjectSetupCBLC.Modify(true);
        end;

        InitUTCDateTimes();
    end;

    procedure InitializeObjectStatus()
    begin
        LibraryObject.CreateObjectStatus('NIEUW', 'Nieuw', true, false, false);
        LibraryObject.CreateObjectStatus('BEEINDIGD', 'Beindigd', false, false, true);
        LibraryObject.CreateObjectStatus('GEBLOKKEERD', 'Geblokkeerd', false, true, false);
        LibraryObject.CreateObjectStatus('GESLOOPT', 'Gesloopt', false, true, true);
        LibraryObject.CreateObjectStatus('VERVANGEN', 'Vervangen', false, true, true);
    end;

    procedure InitializeObjectContactRole()
    begin
        LibraryObject.CreateObjectContactRole('COMMINICAT', 'Communicatie', false, true, false, false, false);
        LibraryObject.CreateObjectContactRole('KLANT', 'Klant', false, false, true, false, false);
        LibraryObject.CreateObjectContactRole('FACTUREREN', 'Factureren', true, false, false, false, true);
        LibraryObject.CreateObjectContactRole('LOCATIE', 'Locatie', false, false, false, true, false);
        LibraryObject.CreateObjectContactRole('PARTNER', 'Partner', false, false, false, false, false);
    end;

    procedure InitializeMaintTemplateNorm()
    var
    // ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
    // RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
    begin
        //TODO Fix
        exit;
        // LibraryMaintenance.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', '');
        // LibraryMaintenance.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"All Contracts", '', '');
    end;

    procedure InitUTCDateTimes()
    var
        ObjectSetupCBLC: Record "Object Setup CBLC";
        NewDateFormula: DateFormula;
    begin
        if not ObjectSetupCBLC.Get() then begin
            ObjectSetupCBLC.Init();
            ObjectSetupCBLC.Insert(true);
        end;

        if ObjectSetupCBLC."UTC to Std. Time (ms)" <> 0 then
            exit;

        Evaluate(NewDateFormula, '<+3M-WD7>');
        ObjectSetupCBLC.Validate("Starting Date Formula DST", NewDateFormula);
        ObjectSetupCBLC.Validate("Starting Time DST (UTC)", 010000T);
        Evaluate(NewDateFormula, '<+10M-WD7>');
        ObjectSetupCBLC.Validate("Ending Date Formula DST", NewDateFormula);
        ObjectSetupCBLC.Validate("Ending Time DST (UTC)", 010000T);
        ObjectSetupCBLC.Validate("UTC to Std. Time (ms)", 3600000);
        ObjectSetupCBLC.Validate("UTC to DST (ms)", 7200000);
        ObjectSetupCBLC.Modify(true);
    end;

    [InternalEvent(false)]
    local procedure OnInitialize()
    begin
    end;
}
