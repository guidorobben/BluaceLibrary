codeunit 83950 "Init. Contract LIB"
{
    Permissions =
        tabledata "Contract Setup TPZS" = RM,
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
        InitializeContractSetup();
        InitializeContractTemplate();
        InitializeCustomerPriceGroups();
        InitializeContractIndexes();
        InitializePriorities();
    end;

    procedure InitializeContractSetup()
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        ItemCategory: Record "Item Category";
        UoMCode: Code[10];
        ItemCategoryCode: Code[20];
        NoSeries: Code[20];
    begin

        if not ContractSetupTPZS.Get() then
            ContractSetupTPZS.InsertIfNotExists();

        ContractSetupTPZS.Validate("Default Invoice Model", ContractSetupTPZS."Default Invoice Model"::"In Advance");

        if ContractSetupTPZS."Unit of Measure Code Month" = '' then begin
            //Create Maand
            UoMCode := 'MAAND';
            CreateUnitOfMeasure(UoMCode, 'Maand');
            ContractSetupTPZS.Validate("Unit of Measure Code Month", UoMCode);
            ContractSetupTPZS.Modify(true);
        end;

        if ContractSetupTPZS."Unit of Measure Code Quarter" = '' then begin
            //Create Quarter
            UoMCode := 'KWARTAAL';
            CreateUnitOfMeasure(UoMCode, 'Kwartaal');
            ContractSetupTPZS.Validate("Unit of Measure Code Quarter", UoMCode);
            ContractSetupTPZS.Modify(true);
        end;

        if ContractSetupTPZS."Unit of Measure Code Year" = '' then begin
            //Create Year
            UoMCode := 'JAAR';
            CreateUnitOfMeasure(UoMCode, 'Jaar');
            ContractSetupTPZS.Validate("Unit of Measure Code Year", UoMCode);
            ContractSetupTPZS.Modify(true);
        end;

        if ContractSetupTPZS."Contract Nos." = '' then begin
            NoSeries := 'CONTRACT';
            LibraryUtilityLIB.CreateNoSeries(NoSeries, true, false, false);
            LibraryUtilityLIB.CreateNoSeriesLine(NoSeries, 'C000001', 'C999999');
            ContractSetupTPZS."Contract Nos." := NoSeries;
            ContractSetupTPZS.Modify(true);
        end;

        if ContractSetupTPZS."Contract Template Nos." = '' then begin
            NoSeries := 'CONTRACTTEMP';
            LibraryUtilityLIB.CreateNoSeries(NoSeries, true, false, false);
            LibraryUtilityLIB.CreateNoSeriesLine(NoSeries, 'CS000001', 'CS999999');
            ContractSetupTPZS."Contract Template Nos." := NoSeries;
            ContractSetupTPZS.Modify(true);
        end;


        if ContractSetupTPZS."Item Category Price" = '' then begin
            ItemCategoryCode := 'PRIJZEN';
            LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Prijzen', '');
            ContractSetupTPZS.Validate("Item Category Price", ItemCategoryCode);
        end;

        if ContractSetupTPZS."Item Category Service" = '' then begin
            ItemCategoryCode := 'DIENSTEN';
            LibraryItemLIB.CreateItemCategory(ItemCategoryCode, 'Diensten', '');
            LibraryItemLIB.CreateItemCategory('ONDERHOUD', 'Onderhoud', ItemCategoryCode);
            LibraryItemLIB.CreateItemCategory('STORING', 'Storing', ItemCategoryCode);
            ContractSetupTPZS.Validate("Item Category Service", ItemCategoryCode);
        end;

        if not ItemCategory.Get('TERMIJNEN') then
            LibraryItemLIB.CreateItemCategory('TERMIJNEN', 'Termijnen', ItemCategoryCode);

        ContractSetupTPZS."Invoice Line Description" := '%1-%2-%3-%4-%5';
        ContractSetupTPZS.Modify(true);
    end;

    procedure InitializeContractTemplate()
    var
        ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS";
        ContractSetupTPZS: Record "Contract Setup TPZS";
    begin
        ContractSetupTPZS.Get();

        Clear(ContrTemplateHeaderTPZS);
        ContractSetupTPZS.TestField("Unit of Measure Code Month");
        LibraryContract.CreateContractTemplateWithUOM(ContrTemplateHeaderTPZS, ContractSetupTPZS."Unit of Measure Code Month", 1);

        Clear(ContrTemplateHeaderTPZS);
        ContractSetupTPZS.TestField("Unit of Measure Code Quarter");
        LibraryContract.CreateContractTemplateWithUOM(ContrTemplateHeaderTPZS, ContractSetupTPZS."Unit of Measure Code Quarter", 1);

        Clear(ContrTemplateHeaderTPZS);
        ContractSetupTPZS.TestField("Unit of Measure Code Quarter");
        LibraryContract.CreateContractTemplateWithUOM(ContrTemplateHeaderTPZS, ContractSetupTPZS."Unit of Measure Code Year", 1);
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
        LibraryContract.CreateIndexCode('FIXED10', Enum::"Contract Index Type TPZS"::"Fixed Value", 10, true);
        LibraryContract.CreateIndexCode('PERCENTAGE10', Enum::"Contract Index Type TPZS"::Percentage, 10, true);
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
}
