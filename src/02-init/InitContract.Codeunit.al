codeunit 83950 "Init. Contract LIB"
{
    Permissions =
        tabledata "Contract Setup CBLC" = RM,
        tabledata "Customer Price Group" = RD,
        tabledata "Item Category" = R,
        tabledata "Unit of Measure" = RI;

    var
        LibraryContract: Codeunit "Library - Contract LIB";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        LibraryPriority: Codeunit "Library - Priority LIB";
        LibraryUtilityLIB: Codeunit "Library - Utility LIB";

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
        InitializeContainerItemCategories();
        InitializeContractSetup();
        InitializeContractTemplate();
        InitializeCustomerPriceGroups();
        InitializeContractIndexes();
        InitializePriorities();
        InitializeVolvoItemCategories();
    end;

    procedure InitializeContractSetup()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        ItemCategory: Record "Item Category";
        UoMCode: Code[10];
        ItemCategoryCode: Code[20];
        NoSeries: Code[20];
    begin

        if not ContractSetupCBLC.Get() then
            ContractSetupCBLC.InsertIfNotExists();

        ContractSetupCBLC.Validate("Default Invoice Model", ContractSetupCBLC."Default Invoice Model"::"In Advance");

        if ContractSetupCBLC."Unit of Measure Code Month" = '' then begin
            //Create Maand
            UoMCode := 'MAAND';
            CreateUnitOfMeasure(UoMCode, 'Maand');
            ContractSetupCBLC.Validate("Unit of Measure Code Month", UoMCode);
            ContractSetupCBLC.Modify(true);
        end;

        if ContractSetupCBLC."Unit of Measure Code Quarter" = '' then begin
            //Create Quarter
            UoMCode := 'KWARTAAL';
            CreateUnitOfMeasure(UoMCode, 'Kwartaal');
            ContractSetupCBLC.Validate("Unit of Measure Code Quarter", UoMCode);
            ContractSetupCBLC.Modify(true);
        end;

        if ContractSetupCBLC."Unit of Measure Code Year" = '' then begin
            //Create Year
            UoMCode := 'JAAR';
            CreateUnitOfMeasure(UoMCode, 'Jaar');
            ContractSetupCBLC.Validate("Unit of Measure Code Year", UoMCode);
            ContractSetupCBLC.Modify(true);
        end;

        if ContractSetupCBLC."Contract Nos." = '' then begin
            NoSeries := 'CONTRACT';
            LibraryUtilityLIB.CreateNoSeries(NoSeries, true, false, false);
            LibraryUtilityLIB.CreateNoSeriesLine(NoSeries, 'C000001', 'C999999');
            ContractSetupCBLC."Contract Nos." := NoSeries;
            ContractSetupCBLC.Modify(true);
        end;

        if ContractSetupCBLC."Contract Template Nos." = '' then begin
            NoSeries := 'CONTRACTTEMP';
            LibraryUtilityLIB.CreateNoSeries(NoSeries, true, false, false);
            LibraryUtilityLIB.CreateNoSeriesLine(NoSeries, 'CS000001', 'CS999999');
            ContractSetupCBLC."Contract Template Nos." := NoSeries;
            ContractSetupCBLC.Modify(true);
        end;


        if ContractSetupCBLC."Item Category Price" = '' then begin
            ItemCategoryCode := 'PRIJZEN';
            LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Prijzen', '');
            ContractSetupCBLC.Validate("Item Category Price", ItemCategoryCode);
        end;

        if ContractSetupCBLC."Item Category Service" = '' then begin
            ItemCategoryCode := 'DIENSTEN';
            LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Diensten', '');
            LibraryItemLIB.CreateItemCategory('ONDERHOUD', 'Onderhoud', ItemCategoryCode);
            LibraryItemLIB.CreateItemCategory('STORING', 'Storing', ItemCategoryCode);
            ContractSetupCBLC.Validate("Item Category Service", ItemCategoryCode);
        end;

        if ContractSetupCBLC."Usage Container Item Category" = '' then
            ContractSetupCBLC.Validate("Usage Container Item Category", 'CONTAINER');

        if ContractSetupCBLC."Container Cont. Item Category" = '' then
            ContractSetupCBLC.Validate("Container Cont. Item Category", 'CONTENT');

        if not ItemCategory.Get('TERMIJNEN') then
            LibraryItemLIB.CreateItemCategory('TERMIJNEN', 'Termijnen', ItemCategoryCode);

        ContractSetupCBLC."Invoice Line Description" := '%1-%2-%3-%4-%5';
        ContractSetupCBLC.Modify(true);
    end;

    procedure InitializeContractTemplate()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
    begin
        ContractSetupCBLC.SetLoadFields("Unit of Measure Code Month", "Unit of Measure Code Quarter", "Unit of Measure Code Year");
        ContractSetupCBLC.Get();

        Clear(ContrTemplateHeaderCBLC);
        ContractSetupCBLC.TestField("Unit of Measure Code Month");
        LibraryContract.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);

        Clear(ContrTemplateHeaderCBLC);
        ContractSetupCBLC.TestField("Unit of Measure Code Quarter");
        LibraryContract.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Quarter", 1);

        Clear(ContrTemplateHeaderCBLC);
        ContractSetupCBLC.TestField("Unit of Measure Code Quarter");
        LibraryContract.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Year", 1);
    end;

    procedure CreateUnitOfMeasure(NewCode: Code[10]; Description: Text[50])
    var
        UnitofMeasure: Record "Unit of Measure";
    begin
        if UnitofMeasure.Get(NewCode) then
            exit;

        UnitofMeasure.Init();
        UnitofMeasure.Validate(Code, NewCode);
        UnitofMeasure.Validate(Description, Description);
        UnitofMeasure.Insert(true);
    end;

    procedure InitializeCustomerPriceGroups()
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        CustomerPriceGroup.DeleteAll(false);
        LibraryContract.CreateCustomerPriceGroup('CONTRACTEN', 'Contracten', true, true);
    end;

    procedure InitializeContractIndexes()
    begin
        LibraryContract.CreateIndexCode('FIXED10', Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);
        LibraryContract.CreateIndexCode('PERCENTAGE10', Enum::"Contract Index Type CBLC"::Percentage, 10, true);
    end;

    procedure InitializePriorities()
    begin
        LibraryPriority.DeleteAllPriorities(false);

        LibraryPriority.CreatePriority('PRIORITY1', 'Description 1');
        LibraryPriority.CreatePriority('PRIORITY2', 'Description 2');
        LibraryPriority.CreatePriority('PRIORITY3', 'Description 3');
        LibraryPriority.CreatePriority('PRIORITY4', 'Description 4');
        LibraryPriority.CreatePriority('PRIORITY5', 'Description 5');
        LibraryPriority.CreatePriority('PRIORITY6', 'Description 6');
        LibraryPriority.CreatePriority('PRIORITY7', 'Description 7');
        LibraryPriority.CreatePriority('PRIORITY8', 'Description 8');
        LibraryPriority.CreatePriority('PRIORITY9', 'Description 9');
    end;

    local procedure InitializeContainerItemCategories()
    var
        ItemCategoryCode: Code[20];
    begin
        ItemCategoryCode := 'Container';
        LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Containers', '');
        LibraryItemLIB.CreateItemCategory('KLEIN', 'Klein', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('MIDDEL', 'Middel', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('GROOT', 'Groot', ItemCategoryCode);

        ItemCategoryCode := 'Content';
        LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Content', '');
        LibraryItemLIB.CreateItemCategory('KOEL', 'Koel- en airconditioningsystemen', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('SCHUIM', 'Schuimblusmiddelen', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('SPUIT', 'Spuitblusmiddelen', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('BRAND', 'Brandblusmiddelen', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('INDUSTRIE', 'Industriële processen', ItemCategoryCode);
    end;

    local procedure InitializeVolvoItemCategories()
    var
        ItemCategoryCode: Code[20];
    begin
        ItemCategoryCode := 'TOOLS VP';
        LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Tools / VP', '');

        ItemCategoryCode := 'Volvo';
        LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Volvo', '');
        LibraryItemLIB.CreateItemCategory('11', 'Filters, anodes, AQ bellows, OH', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('12', 'Motor reparatie delen', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('13', 'Olie, verf, vetten, duren delen', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('14', 'Dure VP accesoires, QL boeg-hekschr.', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('15', 'Reparatie delen motoren, drives, serv.', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('16', 'Schroeven, SP, vaste VP schr.', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('17', 'alle DP en RVS schroeven', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('18', 'Dure reparatie delen, motorblokken etc.', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('19', 'Alle ruildelen excl. onderstaa', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('20', 'Gedeelde en compl. ruildrives', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('21', 'Gereedschappen + ruilmotoren', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('22', 'Core', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('31', 'Replaced VP parts', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('35', 'Right choice', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('36', 'Volvo Alternatief (grijs) A', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('37', 'Volvo Reco R', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('38', 'Volvo Gebruikt G', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('39', 'Volvo Nieuw / Afkomstig nieuwe motor N', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('40', '-->ART.CAT.CODE: "TOOLS VP" gebruiken', ItemCategoryCode);
        LibraryItemLIB.CreateItemCategory('MERCH', 'Merchandise Volvo Penta', ItemCategoryCode);
    end;
}