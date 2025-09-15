codeunit 83953 "Init. General LIB"
{
    Permissions =
        tabledata "Feature Setup LIB" = RI,
        tabledata "Report Selections" = RID,
        tabledata "User Setup" = RI;

    var
        LibraryGeneral: Codeunit "Library - General LIB";
        LibrarySales: Codeunit "Library - Sales LIB";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init. All LIB", OnInitialize, '', false, false)]
    local procedure OnInitialize()
    begin
        Initialize();
    end;

    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        InitializeTechnicaManagement();
        InitializeTimeWindows();
        InitializeUnitOfMeasures();
        InitializeRealizationStatus();
        InitializePriority();
        InitializeReportSelections();
        InitializeReturnReasons();
        InitializeApprovalUserSetup();
        InitializeFeatureSetup();
        InitializePaymentMethods();
        InitializeAllowedLanguages();
    end;

    procedure InitializeTechnicaManagement()
    var
        ApplAreaHelperTPZS: Codeunit "Appl. Area Helper TPZS";
    begin
        ApplAreaHelperTPZS.SetAreaEnabled(true);
        ApplAreaHelperTPZS.RefreshExperienceTier();
    end;

    procedure InitializeTimeWindows()
    var
        TimeWindowTypeTPZS: Enum "Time Window Type TPZS";
    begin
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Planning, 'HELE DAG', 080000T, 170000T, true);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Planning, 'MIDDAG', 120000T, 170000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Planning, 'OCHTEND', 080000T, 120000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Planning, 'AVOND', 170000T, 210000T, false);

        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'GESLOTEN', 0T, 0T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'HELE DAG', 080000T, 170000T, true);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'NEGENTOTVIJF', 090000T, 170000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'RETAIL-AVOND', 180000T, 210000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'RETAIL-MAANDAG', 130000T, 180000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'RETAIL-STANDAARD', 093000T, 180000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'SUPER-STANDAARD', 070000T, 220000T, false);
        LibraryGeneral.CreateTimeWindow(TimeWindowTypeTPZS::Object, 'SUPER-ZONDAG', 120000T, 170000T, false);
    end;

    procedure InitializeUnitOfMeasures()
    begin
        LibraryGeneral.CreateUnitOfMeasureCode('MINUUT', 'Minuut', 5, true);
        LibraryGeneral.CreateUnitOfMeasureCode('KM', 'Kilometer', 0, true);
    end;

    procedure InitializeRealizationStatus()
    begin
        LibrarySales.CreateRealizationStatus('NT', 'Niet thuis');
        LibrarySales.CreateRealizationStatus('UITGEVOERD', 'Uitgevoerd');
        LibrarySales.CreateRealizationStatus('OFFERTE', 'Offerte');
        LibrarySales.CreateRealizationStatus('VERVOLG', 'Vervolg', true, 2, true);
        Commit();
    end;

    procedure InitializePriority()
    var
        LibraryPriority: Codeunit "Library - Priority LIB";
    begin
        LibraryPriority.DeleteAllPriorities(false);

        LibraryPriority.CreatePriority('4UUR', '4 uur', 240, true, false);
        LibraryPriority.CreatePriority('8UUR', '8 uur', 480, true, false);
        LibraryPriority.CreatePriority('24UUR', '24 uur', 1140, true, false);
        LibraryPriority.CreatePriority('ASAP', 'Asap', 60, false, true);
        Commit();
    end;

    procedure InitializeReportSelections()
    begin
        InitializeReportSelectionsSales();
        InitializeReportSelectionsReminder();
    end;

    procedure InitializeReportSelectionsSales()
    var
        ReportUsage: Enum "Report Selection Usage";
    begin
        InsertRepSelection(ReportUsage::"S.Invoice", '1', 70573, true);
        InsertRepSelection(ReportUsage::"S.Cr.Memo", '1', 70574, true);
        InsertRepSelection(ReportUsage::"S.Work Order", '1', 80100, true);
        InsertRepSelection(ReportUsage::"Posted Work Order TPZS", '1', 80105, true);
    end;

    procedure InitializeReportSelectionsReminder()
    var
        ReportUsage: Enum "Report Selection Usage";
    begin
        InsertRepSelection(ReportUsage::Reminder, '1', 70575, true);
        InsertRepSelection(ReportUsage::"Rem.Test", '1', 70576, true);
    end;

    local procedure InsertRepSelection(ReportUsage: Enum "Report Selection Usage"; Sequence: Code[10]; ReportID: Integer; DeleteIfExist: Boolean)
    var
        ReportSelections: Record "Report Selections";
    begin
        if DeleteIfExist then
            if ReportSelections.Get(ReportUsage, Sequence) then
                ReportSelections.Delete(true);

        if not ReportSelections.Get(ReportUsage, Sequence) then begin
            ReportSelections.Init();
            ReportSelections.Usage := ReportUsage;
            ReportSelections.Sequence := Sequence;
            ReportSelections."Report ID" := ReportID;
            ReportSelections.Insert(false);
        end;
    end;

    local procedure InitializeFeatureSetup()
    var
        FeatureSetupTPTE: Record "Feature Setup LIB";
    begin
        if not FeatureSetupTPTE.Get() then begin
            FeatureSetupTPTE.Init();
            FeatureSetupTPTE.Insert(true);
        end;
    end;

    local procedure InitializeAllowedLanguages()
    begin
        LibraryGeneral.AddAllowedLanguage(1043);
        LibraryGeneral.AddAllowedLanguage(1033);
    end;

    procedure InitializeReturnReasons()
    begin
        LibrarySales.CreateReturnReason('REVISIE', 'Revisie');
    end;

    procedure InitializeApprovalUserSetup()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then begin
            UserSetup.Init();
            UserSetup.Validate("User ID", UserId());
            UserSetup.Validate("Salespers./Purch. Code", 'GP');
            UserSetup.Validate("Unlimited Purchase Approval", true);
            UserSetup.Validate("Unlimited Sales Approval", true);
            UserSetup.Validate("Approval Administrator", true);
            UserSetup.Insert(true);
        end;

        if not UserSetup.Get('ESSENTIAL') then begin
            UserSetup.Init();
            UserSetup.Validate("User ID", 'ESSENTIAL');
            UserSetup.Validate("Salespers./Purch. Code", 'DV');
            UserSetup.Validate("Unlimited Purchase Approval", true);
            UserSetup.Validate("Unlimited Sales Approval", true);
            UserSetup.Validate("Approver ID", 'ADMIN');
            UserSetup.Insert(true);
        end;

        if not UserSetup.Get('TEAMMEMBER') then begin
            UserSetup.Init();
            UserSetup.Validate("User ID", 'TEAMMEMBER');
            UserSetup.Validate("Salespers./Purch. Code", 'FK');
            UserSetup.Validate("Unlimited Purchase Approval", true);
            UserSetup.Validate("Unlimited Sales Approval", true);
            UserSetup.Validate("Approver ID", 'ADMIN');
            UserSetup.Insert(true);
        end;
    end;

    procedure InitializePaymentMethods()
    begin
        LibraryGeneral.CreatePaymentMethod('CREDIT', 'Credit betalingen', Enum::"Payment Balance Account Type"::"G/L Account", '', false, '');
        LibraryGeneral.CreatePaymentMethod('FACTUUR', 'Betaling via Factuur', Enum::"Payment Balance Account Type"::"G/L Account", '', false, '');
        LibraryGeneral.CreatePaymentMethod('GEEN', 'Geen Betalingswijze', Enum::"Payment Balance Account Type"::"G/L Account", '', false, '');
        LibraryGeneral.CreatePaymentMethod('INCASSO', 'Betaling via Incasso', Enum::"Payment Balance Account Type"::"G/L Account", '', true, '2 DAGEN');
        LibraryGeneral.CreatePaymentMethod('MANUAL', 'Manual payment', Enum::"Payment Balance Account Type"::"G/L Account", '', false, '');
        LibraryGeneral.CreatePaymentMethod('SEPA', 'SEPA payment', Enum::"Payment Balance Account Type"::"G/L Account", '', false, '');
    end;
}