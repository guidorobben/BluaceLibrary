codeunit 83955 "Init. Resoure LIB"
{
    Permissions =
        tabledata "Employee Absence" = RD,
        tabledata "Human Resources Setup" = RM,
        tabledata "Human Resource Unit of Measure" = RIM,
        tabledata Location = R,
        tabledata "No. Series Line" = RM,
        tabledata Resource = RM,
        tabledata "Resources Setup" = RIM,
        tabledata "Resource Unit of Measure" = RI,
        tabledata "Work Time Work Type CBLC" = R;

    var
        LibraryResource: Codeunit "Library - Resource LIB";

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
        DeleteEmployeeAbsence();
        InitializeHRSetup();
        CreateDefaultWorkTypes();
        InitializeResourceSetup();
        InitializeResourceGroups();
        InitializeWorkTimeWorkTypes();
        InitializeResources();
        UpdateResourceUnitsOfMeasure();
        UpdateResourcesForTimeSheet();
        UpdateResources();
        UpdateResourceNoSerie();
    end;

    procedure InitializeResourceSetup()
    var
        ResourcesSetup: Record "Resources Setup";
        LibraryTimeSheet: Codeunit "Library - Time Sheet";
    begin
        if not ResourcesSetup.Get() then begin
            ResourcesSetup.Init();
            ResourcesSetup.Insert(false);
        end;

        if ResourcesSetup."Time Sheet Nos." = '' then begin
            ResourcesSetup.Validate("Time Sheet Nos.", LibraryTimeSheet.GetTimeSheetNoSeries());
            ResourcesSetup.Modify(false);
        end;

        ResourcesSetup.Validate("Work Type Work CBLC", 'WERK');
        ResourcesSetup.Validate("Work Type Travel CBLC", 'REIS');
        ResourcesSetup.Validate("Work Type Travel (km) CBLC", 'KM');

        ResourcesSetup.Validate("Realization Time Descr. CBLC", '%5 %6 %7 %8 %9');
        ResourcesSetup.Validate("Realization Dist. Descr. CBLC", '%2: %4 (%11 km)');
        ResourcesSetup.Modify(false);
    end;

    procedure InitializeResourceGroups()
    // var
    //     ResourceGroup: Record "Resource Group";
    begin
        LibraryResource.CreateDefaultResourceGroups();
    end;

    procedure CreateDefaultWorkTypes()
    begin
        LibraryResource.CreateWorkType('KM', 'Afstand', 'KM');
        LibraryResource.CreateWorkType('REIS', 'Reis', 'UUR');
        LibraryResource.CreateWorkType('WERK', 'Werk', 'UUR');
        LibraryResource.CreateWorkType('FEESTDAG', 'Feestdag', 'UUR');
        LibraryResource.CreateWorkType('BUITENWT', 'Buiten werktijd', 'UUR');
        LibraryResource.CreateWorkType('WEEKEND', 'Weekend', 'UUR');
    end;

    procedure InitializeWorkTimeWorkTypes()
    var
        WorkTimeWorkTypeCBLC: Record "Work Time Work Type CBLC";
        // WorkTimeWorkTypeDaysCBLC: Enum "Work Time Work Type Days CBLC";
        WorkTypeCode: Code[10];
        Day: Enum "Work Time Work Type Days CBLC";
    begin

        if not WorkTimeWorkTypeCBLC.IsEmpty() then
            exit;

        //Specific Date
        WorkTypeCode := 'FEESTDAG';
        LibraryResource.AddWorkTimeWorkTypeSpecific(20230427D, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkTypeSpecific(20230505D, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkTypeSpecific(20230518D, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkTypeSpecific(20230528D, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkTypeSpecific(20230529D, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkTypeSpecific(20231225D, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkTypeSpecific(20231226D, WorkTypeCode);

        WorkTypeCode := 'BUITENWT';
        Day := Day::Monday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 080000T, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 163000T, 000000T, WorkTypeCode);

        Day := Day::Tuesday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 080000T, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 163000T, 000000T, WorkTypeCode);

        Day := Day::Wednesday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 080000T, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 163000T, 000000T, WorkTypeCode);

        Day := Day::Thursday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 080000T, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 163000T, 000000T, WorkTypeCode);

        Day := Day::Friday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 080000T, WorkTypeCode);
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 163000T, 000000T, WorkTypeCode);

        WorkTypeCode := 'WEEKEND';
        Day := Day::Saturday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 000000T, WorkTypeCode);

        Day := Day::Sunday;
        LibraryResource.AddWorkTimeWorkType(Day, 0D, 000000T, 000000T, WorkTypeCode);
    end;

    procedure InitializeResources()
    var
        Location: Record Location;
        Resource: Record Resource;
        LibraryRandom: Codeunit "Library - Random LIB";
        SourceRecordRef: RecordRef;
        I: Integer;
    begin
        for I := 1 to 10 do begin
            Clear(Resource);
            LibraryResource.CreateResource(Resource, '', LibraryRandom.FindCompleteNameRandom());
            Resource.Validate("Resource Group No.", LibraryRandom.GetRandomValueByTableCode20(Database::"Resource Group"));

            Location.Reset();
            Location.SetRange("Use As In-Transit", false);
            SourceRecordRef.GetTable(Location);
            //UITGEZET Resource.Validate("Location Code CBLC", LibraryRandom.GetRandomValueByRecordRefCode10(SourceRecordRef, 1));
            Resource.Modify(true);

            LibraryResource.CreateResourceUnitOfMeasureTravelKm(Resource);
        end;
    end;

    procedure InitializeHRSetup()
    var
        HumanResourcesSetup: Record "Human Resources Setup";
        HumanResourceUnitofMeasure: Record "Human Resource Unit of Measure";
        HRCode: Code[10];
    begin
        HumanResourcesSetup.Get();

        HumanResourcesSetup."Base Unit of Measure" := '';
        HumanResourcesSetup.Modify(true);

        HRCode := 'DAG';
        if not HumanResourceUnitofMeasure.Get(HRCode) then begin
            HumanResourceUnitofMeasure.Init();
            HumanResourceUnitofMeasure.Validate(Code, HRCode);
            HumanResourceUnitofMeasure.Insert(true);
        end;
        HumanResourceUnitofMeasure.Validate("Qty. per Unit of Measure", 1440);
        HumanResourceUnitofMeasure.Modify(true);

        HRCode := 'MINUUT';
        if not HumanResourceUnitofMeasure.Get(HRCode) then begin
            HumanResourceUnitofMeasure.Init();
            HumanResourceUnitofMeasure.Validate(Code, HRCode);
            HumanResourceUnitofMeasure.Insert(true);
        end;
        HumanResourceUnitofMeasure.Validate("Qty. per Unit of Measure", 1);
        HumanResourceUnitofMeasure.Modify(true);

        HRCode := 'UUR';
        if not HumanResourceUnitofMeasure.Get(HRCode) then begin
            HumanResourceUnitofMeasure.Init();
            HumanResourceUnitofMeasure.Validate(Code, HRCode);
            HumanResourceUnitofMeasure.Insert(true);
        end;
        HumanResourceUnitofMeasure.Validate("Qty. per Unit of Measure", 60);
        HumanResourceUnitofMeasure.Modify(true);

        HumanResourcesSetup.Validate("Base Unit of Measure", 'MINUUT');
        HumanResourcesSetup.Modify(false);
    end;

    procedure UpdateResourceUnitsOfMeasure()
    var
        Resource: Record Resource;
        ResourceUnitofMeasure: Record "Resource Unit of Measure";
        UoMCode: Code[10];
    begin
        UoMCode := 'KM';
        Resource.SetLoadFields("No.");
        if Resource.FindSet() then
            repeat
                if not ResourceUnitofMeasure.Get(Resource."No.", UoMCode) then begin
                    ResourceUnitofMeasure.Init();
                    ResourceUnitofMeasure.Validate("Resource No.", Resource."No.");
                    ResourceUnitofMeasure.Validate(Code, UoMCode);
                    ResourceUnitofMeasure.Validate("Qty. per Unit of Measure", 1);
                    ResourceUnitofMeasure.Insert(true);
                end;
            until Resource.Next() = 0;
    end;

    procedure UpdateResourcesForTimeSheet()
    var
        Resource: Record Resource;
        LibraryTimeSheetLIB: Codeunit "Library - Time Sheet LIB";
        I: Integer;
    begin
        Resource.SetRange("Use Time Sheet", false);
        if Resource.FindSet() then begin
            I += 1;
            LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource, true);
            if I = 10 then
                exit;
        end;
    end;

    procedure UpdateResources()
    var
        Resource: Record Resource;
        LibraryRandom: Codeunit "Library - Random LIB";
    begin
        if Resource.FindSet() then
            repeat
                if Resource.Name in ['', ' '] then begin
                    Resource.Validate(Name, LibraryRandom.FindCompleteNameRandom());
                    Resource.Modify(true);
                end;
            until Resource.Next() = 0;
    end;

    procedure DeleteEmployeeAbsence()
    var
        EmployeeAbsence: Record "Employee Absence";
    begin
        EmployeeAbsence.DeleteAll(true);
    end;

    procedure UpdateResourceNoSerie()
    var
        NoSeriesLine: Record "No. Series Line";
        ResourcesSetup: Record "Resources Setup";
    begin
        ResourcesSetup.Get();
        if ResourcesSetup."Resource Nos." = '' then
            exit;

        NoSeriesLine.SetRange("Series Code", ResourcesSetup."Resource Nos.");
        NoSeriesLine.FindFirst();
        NoSeriesLine.Validate("Increment-by No.", 1);
        NoSeriesLine.Modify(true);
    end;
}
