codeunit 83984 "Library - Item LIB"
{
    var
        LibraryERM: Codeunit "Library - ERM";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";

    procedure CreateItemCategory(NewCode: Code[20]; Description: Text[100]; ParentCategory: Code[20])
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.Init();
        ItemCategory.Validate(Code, NewCode);
        ItemCategory.Validate(Description, Description);
        ItemCategory.Validate("Parent Category", ParentCategory);
        ItemCategory.Insert(true);
    end;

    procedure CreatePriceItem(var Item: Record Item; UnitCost: Decimal; UnitPrice: Decimal; BaseUnitOM: Code[10])
    begin
        CreatePriceItem(Item, '', UnitCost, UnitPrice, BaseUnitOM);
    end;

    procedure CreatePriceItem(var Item: Record Item; ItemNo: Code[20]; UnitCost: Decimal; UnitPrice: Decimal; BaseUnitOM: Code[10]; ItemCategoryCode: Code[20])
    begin
        CreatePriceItem(Item, ItemNo, UnitCost, UnitPrice, BaseUnitOM);

        Item.TestField("No.");
        Item.Validate("Item Category Code", ItemCategoryCode);
        Item.Modify(true);
    end;

    procedure CreatePriceItem(var Item: Record Item; ItemNo: Code[20]; UnitCost: Decimal; UnitPrice: Decimal; BaseUnitOM: Code[10])
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        ItemCategory: Record "Item Category";
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Item Category Price");
        ItemCategory.Get(ContractSetupTPZS."Item Category Price");

        CreateServiceItem(Item, ItemNo);
        Item.TestField("No.");

        Item.Validate("Item Category Code", ItemCategory.Code);
        Item.Validate("Unit Cost", UnitCost);
        Item.Validate("Unit Price", UnitPrice);
        if BaseUnitOM <> '' then
            Item.Validate("Base Unit of Measure", BaseUnitOM);
        Item.Modify(true);
    end;

    procedure CreatePriceItemNo(): Code[20]
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Unit of Measure Code Month");
        exit(CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 40, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupTPZS."Unit of Measure Code Month"));
    end;

    procedure CreatePriceItemNo(UnitCost: Decimal; UnitPrice: Decimal; BaseUnitOM: Code[10]): Code[20]
    var
        Item: Record Item;
    begin
        CreatePriceItem(Item, UnitCost, UnitPrice, BaseUnitOM);
        exit(Item."No.");
    end;

    procedure CreateItemUnitOfMeasure(ItemNo: Code[20]; UoMCode: Code[10]; QtyPerUoM: Decimal)
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        if ItemNo = '' then
            exit;

        ItemUnitofMeasure.Init();
        ItemUnitofMeasure.Validate("Item No.", ItemNo);
        ItemUnitofMeasure.Validate(Code, UoMCode);
        ItemUnitofMeasure.Validate("Qty. per Unit of Measure", QtyPerUoM);
        if ItemUnitofMeasure.Insert(true) then;
    end;


    procedure CreateServiceItem(var Item: Record Item)
    begin
        CreateItem(Item, '');
        Item.Validate(Description, Item."No.");
        Item.Validate(Type, Item.Type::Service);
    end;

    procedure CreateServiceItem(var Item: Record Item; ItemNo: Code[20])
    begin
        CreateItem(Item, ItemNo);
        Item.Validate(Description, Item."No.");
        Item.Validate(Type, Item.Type::Service);
    end;

    procedure CreateItem(var Item: Record Item; ItemNo: Code[20]): Code[20]
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        CreateItemWithoutVAT(Item, ItemNo, '');

        LibraryERM.FindVATPostingSetupInvt(VATPostingSetup);
        Item.Validate("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");

        Item.Modify(true);
        exit(Item."No.");
    end;

    procedure CreateItemWithoutVAT(var Item: Record Item; ItemNo: Code[20]; UoMCode: Code[10])
    var
        GeneralPostingSetup: Record "General Posting Setup";
        InventoryPostingGroup: Record "Inventory Posting Group";
        // InventorySetup: Record "Inventory Setup";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        TaxGroup: Record "Tax Group";

    begin
        // LibraryInventory.ItemNoSeriesSetup(InventorySetup);        
        Clear(Item);
        Item.Init();
        if ItemNo <> '' then
            Item.Validate("No.", ItemNo);
        Item.Insert(true);

        if UoMCode = '' then
            UoMCode := 'STUKS';
        LibraryInventory.CreateItemUnitOfMeasure(ItemUnitOfMeasure, Item."No.", UoMCode, 1);
        LibraryERM.FindGeneralPostingSetupInvtFull(GeneralPostingSetup);

        if not InventoryPostingGroup.FindFirst() then
            LibraryInventory.CreateInventoryPostingGroup(InventoryPostingGroup);

        Item.Validate(Description, Item."No.");  // Validation Description as No. because value is not important.
        Item.Validate("Base Unit of Measure", ItemUnitOfMeasure.Code);
        Item.Validate("Gen. Prod. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", InventoryPostingGroup.Code);

        if TaxGroup.FindFirst() then
            Item.Validate("Tax Group Code", TaxGroup.Code);

        Item.Modify(true);
    end;

    procedure CreateItemPlanningNorm(var Item: Record Item; var ItemPlanningNormTPZS: Record "Item Planning Norm TPZS"; ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormNo: Code[20]; RelatedNormTypeTPZS: Enum "Related Norm Type TPZS"; RelatedNormNo: Code[20])
    var
    begin
        Item.TestField("No.");

        ItemPlanningNormTPZS.Init();
        ItemPlanningNormTPZS."Entry No." := 0;
        ItemPlanningNormTPZS.Validate("Item No.", Item."No.");
        ItemPlanningNormTPZS.Validate("Object Norm Type", ObjectNormTypeTPZS);
        ItemPlanningNormTPZS.Validate("Object Norm No.", ObjectNormNo);
        ItemPlanningNormTPZS.Validate("Related Norm Type", RelatedNormTypeTPZS);
        ItemPlanningNormTPZS.Validate("Related Norm No.", RelatedNormNo);
        ItemPlanningNormTPZS.Insert(true);
    end;

    procedure CreateItemPlanningNorm(var Item: Record Item; var ItemPlanningNormTPZS: Record "Item Planning Norm TPZS"; ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormNo: Code[20]; RelatedNormTypeTPZS: Enum "Related Norm Type TPZS"; RelatedNormNo: Code[20]; ResourceGroupNo: Code[20]; UnitOfMeasureCode: Code[10]; Quantity: Decimal)
    begin
        CreateItemPlanningNorm(Item, ItemPlanningNormTPZS, ObjectNormTypeTPZS, ObjectNormNo, RelatedNormTypeTPZS, RelatedNormNo);
        ItemPlanningNormTPZS.Validate("Unit of Measure Code", UnitOfMeasureCode);
        ItemPlanningNormTPZS.Modify(true);

        ItemPlanningNormTPZS.Validate("Resource Group No.", ResourceGroupNo);
        ItemPlanningNormTPZS.Validate(Quantity, Quantity);
        ItemPlanningNormTPZS.Modify(true);
    end;

    procedure CreateItemUsageNorm(var Item: Record Item; var ItemUsageNormTPZS: Record "Item Usage Norm TPZS"; ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormNo: Code[20]; RelatedNormTypeTPZS: Enum "Related Norm Type TPZS"; RelatedNormNo: Code[20])
    var
    begin
        Item.TestField("No.");

        ItemUsageNormTPZS.Init();
        ItemUsageNormTPZS.Validate("Item No.", Item."No.");
        ItemUsageNormTPZS.Validate("Object Norm Type", ObjectNormTypeTPZS);
        ItemUsageNormTPZS.Validate("Object Norm No.", ObjectNormNo);
        ItemUsageNormTPZS.Validate("Related Norm Type", RelatedNormTypeTPZS);
        ItemUsageNormTPZS.Validate("Related Norm No.", RelatedNormNo);
        ItemUsageNormTPZS.Insert(true);
    end;

    procedure CreateItemUsageNorm(var Item: Record Item; var ItemUsageNormTPZS: Record "Item Usage Norm TPZS"; ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormNo: Code[20]; RelatedNormTypeTPZS: Enum "Related Norm Type TPZS"; RelatedNormNo: Code[20]; UsageItemNo: Code[20]; Quantity: Decimal)
    begin
        CreateItemUsageNorm(Item, ItemUsageNormTPZS, ObjectNormTypeTPZS, ObjectNormNo, RelatedNormTypeTPZS, RelatedNormNo);
        ItemUsageNormTPZS.Validate("Usage Item No.", UsageItemNo);
        ItemUsageNormTPZS.Validate(Quantity, Quantity);
        ItemUsageNormTPZS.Modify(true);
    end;

    procedure DeleteAllItemPlanningNorms(ItemNo: Code[20]; UseTrigger: Boolean)
    var
        ItemPlanningNormTPZS: Record "Item Planning Norm TPZS";
    begin
        if ItemNo = '' then
            exit;

        ItemPlanningNormTPZS.SetRange("Item No.", ItemNo);
        ItemPlanningNormTPZS.DeleteAll(UseTrigger);
    end;

    procedure DeleteAllItemUsageNorms(ItemNo: Code[20]; UseTrigger: Boolean)
    var
        ItemUsageNormTPZS: Record "Item Usage Norm TPZS";
    begin
        if ItemNo = '' then
            exit;

        ItemUsageNormTPZS.SetRange("Item No.", ItemNo);
        ItemUsageNormTPZS.DeleteAll(UseTrigger);
    end;

    procedure UpdateItemUnitPriceWithFixedValue(ItemNo: Code[20]; FixedValue: Decimal)
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        Item.Validate("Unit Price", Round(Item."Unit Price" + FixedValue));
        Item.Modify(true);
    end;

    procedure UpdateItemUnitPriceWithPercentage(ItemNo: Code[20]; Percentage: Decimal)
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        Item.Validate("Unit Price", Round(Item."Unit Price" * (1 + (Percentage / 100))));
        Item.Modify(true);
    end;

    procedure UpdateItemUnitPrice(ItemNo: Code[20]; NewUnitPrice: Decimal)
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        Item.Validate("Unit Price", NewUnitPrice);
        Item.Modify(true);
    end;

    procedure CreateTestServiceItems()
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        Item: Record Item;
        ItemPlanningNormTPZS: Record "Item Planning Norm TPZS";
        ResourceGroup: Record "Resource Group";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        ItemNo: Code[20];
        ObjectNormTypeTPZS: Enum "Object Norm Type TPZS";
        RelatedNormTypeTPZS: Enum "Related Norm Type TPZS";
        I: Integer;
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Item Category Service");
        ContractSetupTPZS.TestField("Unit of Measure Code Month");

        ResourceGroup.Get(LibraryRandomLIB.GetRandomValueByTable(Database::"Resource Group"));

        for I := 1 to 10 do begin
            ItemNo := 'TSERVICE' + Format(I);
            Clear(Item);
            if not Item.Get(ItemNo) then
                LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupTPZS."Unit of Measure Code Month", ContractSetupTPZS."Item Category Service");
            Item.Validate(Description, 'Service ' + Item."No.");
            Item.Modify(true);

            LibraryItemLIB.DeleteAllItemPlanningNorms(ItemNo, false);
            LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormTPZS, ObjectNormTypeTPZS::All, '', RelatedNormTypeTPZS::All, '', ResourceGroup."No.", 'UUR', 1);
        end;
    end;

    procedure CreateTestServicePriceItems()
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        Item: Record Item;
        // ItemPlanningNormTPZS: Record "Item Planning Norm TPZS";
        ResourceGroup: Record "Resource Group";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        ItemNo: Code[20];
        // ObjectNormTypeTPZS: Enum "Object Norm Type TPZS";
        // RelatedNormTypeTPZS: Enum "Related Norm Type TPZS";
        I: Integer;
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Item Category Price");
        ContractSetupTPZS.TestField("Unit of Measure Code Month");

        ResourceGroup.Get(LibraryRandomLIB.GetRandomValueByTable(Database::"Resource Group"));

        for I := 1 to 10 do begin
            ItemNo := 'TPRICE' + Format(I);
            Clear(Item);
            if not Item.Get(ItemNo) then
                LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupTPZS."Unit of Measure Code Month", ContractSetupTPZS."Item Category Price");

            LibraryItemLIB.DeleteAllItemPlanningNorms(ItemNo, false);
            //LibraryItemLIB.AddPlanningNormToItem(Item, ItemPlanningNormTPZS, ObjectNormTypeTPZS::All, '', RelatedNormTypeTPZS::All, '', ResourceGroup."No.", 'UUR', 1);
        end;
    end;

    procedure CreateSKUForAllLocations(Item: Record Item)
    var
        Location: Record Location;
    begin
        if Location.FindSet() then
            repeat
                CreateSKUIfRequired(Item, Location.Code, '');
            until Location.Next() = 0;
    end;

    procedure CreateSKUIfRequired(var Item2: Record Item; LocationCode: Code[10]; VariantCode: Code[10])
    var
        StockkeepingUnit: Record "Stockkeeping Unit";
        SafetyStockQty: Decimal;
    begin
        Item2.CalcFields(Inventory);
        // if (ItemInInventoryOnly and (Item2.Inventory > 0)) or
        //    (not ItemInInventoryOnly)
        // then
        if not StockkeepingUnit.Get(LocationCode, Item2."No.", VariantCode) then begin
            SafetyStockQty := LibraryRandom.RandDecInRange(1, 10, 0);
            CreateSKUForItem(Item2, LocationCode, VariantCode, SafetyStockQty);
        end;
    end;

    procedure CreateSKUForItem(var Item: Record Item; LocationCode: Code[10]; VariantCode: Code[10]; SafetyStockQty: Decimal)
    var
        StockkeepingUnit: Record "Stockkeeping Unit";
    begin
        StockkeepingUnit.Init();
        StockkeepingUnit."Item No." := Item."No.";
        StockkeepingUnit."Location Code" := LocationCode;
        StockkeepingUnit."Variant Code" := VariantCode;
        StockkeepingUnit.CopyFromItem(Item);
        StockkeepingUnit."Last Date Modified" := WorkDate();
        StockkeepingUnit."Special Equipment Code" := Item."Special Equipment Code";
        StockkeepingUnit."Put-away Template Code" := Item."Put-away Template Code";
        StockkeepingUnit.SetHideValidationDialog(true);
        StockkeepingUnit.Validate("Phys Invt Counting Period Code", Item."Phys Invt Counting Period Code");
        StockkeepingUnit.Validate("Reordering Policy", StockkeepingUnit."Reordering Policy"::"Fixed Reorder Qty.");
        StockkeepingUnit.Validate("Safety Stock Quantity", SafetyStockQty);
        StockkeepingUnit."Put-away Unit of Measure Code" := Item."Put-away Unit of Measure Code";
        StockkeepingUnit."Use Cross-Docking" := Item."Use Cross-Docking";
        StockkeepingUnit.Insert(true);
    end;
}