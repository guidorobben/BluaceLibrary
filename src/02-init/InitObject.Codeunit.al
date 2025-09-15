codeunit 83951 "Init. Object LIB"
{
    Permissions =
        tabledata "Object Setup TPZS" = RIM,
        tabledata "Object Status TPZS" = R;

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
        ObjectSetupTPZS: Record "Object Setup TPZS";
        ObjectStatusTPZS: Record "Object Status TPZS";
        NoSeriesCode: Code[20];
    begin
        if not ObjectSetupTPZS.Get() then begin
            ObjectSetupTPZS.Init();
            ObjectSetupTPZS.Insert(true);
        end;

        if ObjectSetupTPZS."Object Nos." = '' then begin
            LibraryUtility.CreateNoSeries('OBJECTS', true, false, false);
            LibraryUtility.CreateNoSeriesLine('OBJECTS', 'OBJ00001', 'OBJ99999');
            ObjectSetupTPZS."Object Nos." := 'OBJECTS';
            ObjectSetupTPZS.Modify(true);
        end;

        if ObjectSetupTPZS."Object Template Nos." = '' then begin
            LibraryUtility.CreateNoSeries('OBJTEMPLATE', true, true, false);
            LibraryUtility.CreateNoSeriesLine('OBJTEMPLATE', 'OBJS00001', 'OBJS99999');
            ObjectSetupTPZS."Object Template Nos." := 'OBJTEMPLATE';
            ObjectSetupTPZS.Modify(true);
        end;

        if ObjectSetupTPZS."Sales Quote Nos. (Service)" = '' then begin
            NoSeriesCode := 'V-OFF-SERVICE';
            if not LibraryGeneral.NoSeriesExists(NoSeriesCode) then begin
                LibraryUtility.CreateNoSeries(NoSeriesCode, true, false, false);
                LibraryUtility.CreateNoSeriesLine(NoSeriesCode, 'VOFS000001', 'VOFS999999');
                ObjectSetupTPZS."Sales Quote Nos. (Service)" := NoSeriesCode;
                ObjectSetupTPZS.Modify(true);
            end;
        end;

        if ObjectSetupTPZS."Sales Order Nos. (Service)" = '' then begin
            NoSeriesCode := 'V-ORD-SERVICE';
            if not LibraryGeneral.NoSeriesExists(NoSeriesCode) then begin
                LibraryUtility.CreateNoSeries(NoSeriesCode, true, false, false);
                LibraryUtility.CreateNoSeriesLine(NoSeriesCode, 'VORS000001', 'VORSS999999');
                ObjectSetupTPZS."Sales Order Nos. (Service)" := NoSeriesCode;
                ObjectSetupTPZS.Modify(true);
            end;
        end;

        if ObjectSetupTPZS."Maint. Sched. Template Nos." = '' then begin
            NoSeriesCode := 'MAINT';
            if not LibraryGeneral.NoSeriesExists(NoSeriesCode) then begin
                LibraryUtility.CreateNoSeries(NoSeriesCode, true, false, false);
                LibraryUtility.CreateNoSeriesLine(NoSeriesCode, 'M0000001', 'M999999');
                ObjectSetupTPZS."Maint. Sched. Template Nos." := NoSeriesCode;
                ObjectSetupTPZS.Modify(true);
            end;
        end;

        if ObjectSetupTPZS."Replacement Object Status" = '' then begin
            ObjectSetupTPZS.Validate("Replacement Object Status", 'BEEINDIGD');
            ObjectSetupTPZS.Modify(true);
        end;

        if ObjectSetupTPZS."Replacement Object Status" = '' then begin
            ObjectStatusTPZS.SetRange(Blocked, true);
            ObjectStatusTPZS.SetRange("End Object Contact/Contract", true);
            if ObjectStatusTPZS.FindFirst() then; //Its there
            ObjectSetupTPZS.Validate("Replacement Object Status", ObjectStatusTPZS.Code);
            ObjectSetupTPZS.Modify(true);
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
    // ObjectNormTypeTPZS: Enum "Object Norm Type TPZS";
    // RelatedNormTypeTPZS: Enum "Related Norm Type TPZS";
    begin
        //TODO Fix
        exit;
        // LibraryMaintenance.CreateMaintenanceNorm(ObjectNormTypeTPZS::All, '', RelatedNormTypeTPZS::All, '', '');
        // LibraryMaintenance.CreateMaintenanceNorm(ObjectNormTypeTPZS::All, '', RelatedNormTypeTPZS::"All Contracts", '', '');
    end;

    procedure InitUTCDateTimes()
    var
        ObjectSetupTPZS: Record "Object Setup TPZS";
        NewDateFormula: DateFormula;
    begin
        if not ObjectSetupTPZS.Get() then begin
            ObjectSetupTPZS.Init();
            ObjectSetupTPZS.Insert(true);
        end;

        if ObjectSetupTPZS."UTC to Std. Time (ms)" <> 0 then
            exit;

        Evaluate(NewDateFormula, '<+3M-WD7>');
        ObjectSetupTPZS.Validate("Starting Date Formula DST", NewDateFormula);
        ObjectSetupTPZS.Validate("Starting Time DST (UTC)", 010000T);
        Evaluate(NewDateFormula, '<+10M-WD7>');
        ObjectSetupTPZS.Validate("Ending Date Formula DST", NewDateFormula);
        ObjectSetupTPZS.Validate("Ending Time DST (UTC)", 010000T);
        ObjectSetupTPZS.Validate("UTC to Std. Time (ms)", 3600000);
        ObjectSetupTPZS.Validate("UTC to DST (ms)", 7200000);
        ObjectSetupTPZS.Modify(true);
    end;

    [InternalEvent(false)]
    local procedure OnInitialize()
    begin
    end;
}
