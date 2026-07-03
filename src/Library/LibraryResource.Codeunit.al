codeunit 83988 "Library - Resource LIB"
{
    Permissions =
        tabledata "General Posting Setup" = R,
        tabledata "Human Resource Unit of Measure" = RI,
        tabledata Resource = RIM,
        tabledata "Resource Group" = RI,
        tabledata "Resources Setup" = R,
        tabledata "Resource Unit of Measure" = RIM,
        tabledata "Unit of Measure" = R,
        tabledata "VAT Posting Setup" = R,
        tabledata "Work Time Work Type CBLC" = RI,
        tabledata "Work Type" = RI;

    var
        LibraryERM: Codeunit "Library - ERM";
        LibraryRandom: Codeunit "Library - Random";
    // LibraryResource: Codeunit "Library - Resource";

    procedure CreateResource(var Resource: Record Resource)
    begin
        CreateResource(Resource, '', '', 'UUR'); //TODO uit setup halen misschien
    end;

    procedure CreateResource(var Resource: Record Resource; ResourceNo: Code[20]; ResourceName: Text[100])
    begin
        CreateResource(Resource, ResourceNo, ResourceName, 'UUR'); //TODO uit setup halen misschien
    end;

    procedure CreateResource(var Resource: Record Resource; ResourceNo: Code[20]; ResourceName: Text[100]; UoMCode: Code[10])
    var
        GeneralPostingSetup: Record "General Posting Setup";
        UnitOfMeasure: Record "Unit of Measure";
        VATPostingSetup: Record "VAT Posting Setup";
        // LibraryInventory: Codeunit "Library - Inventory";
        UnitCost: Decimal;
    begin
        // ResNoSeriesSetup;
        UnitOfMeasure.Get(UoMCode);
        // LibraryInventory.FindUnitOfMeasure(UnitOfMeasure);
        LibraryERM.FindGeneralPostingSetupInvtFull(GeneralPostingSetup);
        LibraryERM.FindVATPostingSetupInvt(VATPostingSetup);

        Clear(Resource);
        Resource.Init();
        if ResourceNo <> '' then
            Resource.Validate("No.", ResourceNo);
        Resource.Insert(true);
        if ResourceName <> '' then
            Resource.Validate(Name, ResourceName)
        else
            Resource.Validate(Name, Resource."No.");  // Validate Name as No. because value is not important.
        Resource.Validate("Base Unit of Measure", UnitOfMeasure.Code);
        UnitCost := LibraryRandom.RandInt(100);
        Resource.Validate("Direct Unit Cost", UnitCost);  // Required field - value is not important.
        Resource.Validate("Unit Price", UnitCost + 10);  // Required field - value is not important.
        Resource.Validate("Gen. Prod. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");
        Resource.Validate("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");
        Resource.Modify(true);
    end;

    procedure CreateResourceUnitOfMeasureTravelKm(Resource: Record Resource)
    var
        ResourcesSetup: Record "Resources Setup";
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        WorkType: Record "Work Type";
    begin
        ResourcesSetup.Get();
        ResourcesSetup.TestField("Work Type Travel (km) CBLC");

        WorkType.Get(ResourcesSetup."Work Type Travel (km) CBLC");
        WorkType.TestField("Unit of Measure Code");

        CreateResourceUnitOfMeasure(ResourceUnitOfMeasure, Resource."No.", WorkType."Unit of Measure Code", 1);
        ResourceUnitOfMeasure.Validate("Related to Base Unit of Meas.", false);
        ResourceUnitOfMeasure.Modify(true);
    end;

    procedure CreateResourceUnitOfMeasure(var ResourceUnitOfMeasure: Record "Resource Unit of Measure"; ResourceNo: Code[20]; UnitOfMeasureCode: Code[10]; QtyPerUoM: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            exit;

        if ResourceUnitOfMeasure.Get(ResourceNo, UnitOfMeasureCode) then
            exit;

        ResourceUnitOfMeasure.Init();
        ResourceUnitOfMeasure.Validate("Resource No.", ResourceNo);
        ResourceUnitOfMeasure.Validate(Code, UnitOfMeasureCode);
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;
        ResourceUnitOfMeasure.Validate("Qty. per Unit of Measure", QtyPerUoM);
        if ResourceUnitOfMeasure.Insert(true) then; //Easy
    end;

    procedure AddWorkTimeWorkTypeSpecific(Date: Date; WorkTypeCode: Code[10])
    begin
        AddWorkTimeWorkType("Work Time Work Type Days CBLC"::"Specific Day", Date, 000000T, 000000T, WorkTypeCode);
    end;

    procedure AddWorkTimeWorkType(Day: Enum "Work Time Work Type Days CBLC"; Date: Date; StartingTime: Time; EndingTime: Time; WorkTypeCode: Code[10])
    var
        WorkTimeWorkTypeCBLC: Record "Work Time Work Type CBLC";
    begin
        WorkTimeWorkTypeCBLC.Init();
        WorkTimeWorkTypeCBLC.Validate(Day, Day);
        if WorkTimeWorkTypeCBLC.Day = WorkTimeWorkTypeCBLC.Day::"Specific Day" then
            WorkTimeWorkTypeCBLC.Validate(Date, Date)
        else begin
            WorkTimeWorkTypeCBLC.Validate("Starting Time", StartingTime);
            WorkTimeWorkTypeCBLC.Validate("Ending Time", EndingTime);
        end;
        WorkTimeWorkTypeCBLC.Validate("Work Type Code", WorkTypeCode);
        WorkTimeWorkTypeCBLC.Insert(true);
    end;

    procedure CreateWorkType(WorkTypeCode: Code[10]; Description: Text[100]; UnitOfMeasureCode: Code[10])
    begin
        CreateWorkType(WorkTypeCode, Description, UnitOfMeasureCode, '');
    end;

    procedure CreateWorkType(WorkTypeCode: Code[10]; Description: Text[100]; UnitOfMeasureCode: Code[10]; GenProdPostingGroup: Code[10])
    var
        WorkType: Record "Work Type";
    begin
        if WorkType.Get(WorkTypeCode) then
            exit;

        WorkType.Init();
        WorkType.Validate(Code, WorkTypeCode);
        WorkType.Validate(Description, Description);
        WorkType.Validate("Unit of Measure Code", UnitOfMeasureCode);
        WorkType.Validate("Gen. Prod. Posting Group CBLC", GenProdPostingGroup);
        WorkType.Insert(true);
    end;

    procedure CreateHumanResourceUnitofMeasure(NewCode: Code[10]; QtyPerUoM: Decimal)
    var
        HumanResourceUnitofMeasure: Record "Human Resource Unit of Measure";
    begin
        if not HumanResourceUnitofMeasure.Get(NewCode) then begin
            HumanResourceUnitofMeasure.Init();
            HumanResourceUnitofMeasure.Validate(Code, NewCode);
            HumanResourceUnitofMeasure.Validate("Qty. per Unit of Measure", QtyPerUoM);
            HumanResourceUnitofMeasure.Insert(true);
        end;
    end;

    procedure CreateDefaultResourceGroups()
    var
        ResourceGroup: Record "Resource Group";
        InspectiesTok: Label 'Inspecties', Locked = true;
        InstallatieTok: Label 'Installatie', Locked = true;
        MonteursTok: Label 'Monteurs', Locked = true;
    begin
        if not ResourceGroup.Get(InspectiesTok) then
            CreateResourceGroupNo(InspectiesTok, InspectiesTok, true);

        if not ResourceGroup.Get(MonteursTok) then
            CreateResourceGroupNo(MonteursTok, MonteursTok, true);

        if not ResourceGroup.Get(InstallatieTok) then
            CreateResourceGroupNo(InstallatieTok, InstallatieTok, true);
    end;

    procedure CreateResourceGroupNo(No: Code[20]; Name: Text[50]; Primary: Boolean): Code[20]
    var
        ResourceGroup: Record "Resource Group";
    begin
        CreateResourceGroup(ResourceGroup, No, Name, Primary);
        exit(ResourceGroup."No.");
    end;

    procedure CreateResourceGroup(var ResourceGroup: Record "Resource Group"; No: Code[20]; Name: Text[50]; Primary: Boolean)
    begin
        ResourceGroup.Init();
        ResourceGroup.Validate("No.", No);
        ResourceGroup.Validate(Name, Name);
        ResourceGroup.Validate("Primary CBLC", Primary);
        ResourceGroup.Insert(true);
    end;
}