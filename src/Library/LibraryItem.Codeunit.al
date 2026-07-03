codeunit 83984 "Library - Item LIB"
{
    Permissions =
        tabledata "Contract Setup CBLC" = R,
        tabledata "General Posting Setup" = R,
        tabledata "Inventory Posting Group" = R,
        tabledata Item = RIM,
        tabledata "Item Category" = RI,
        tabledata "Item Discount Group" = RI,
        tabledata "Item Planning Norm CBLC" = RIMD,
        tabledata "Item Unit of Measure" = RI,
        tabledata "Item Usage Norm CBLC" = RIMD,
        tabledata Location = R,
        tabledata Purchasing = RI,
        tabledata "Resource Group" = R,
        tabledata "Stockkeeping Unit" = RI,
        tabledata "Tax Group" = R,
        tabledata "VAT Posting Setup" = R;

    var
        LibraryERM: Codeunit "Library - ERM";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";

    procedure CreateItemCategory(NewCode: Code[20]; Description: Text[100]; ParentCategory: Code[20])
    var
        ItemCategory: Record "Item Category";
    begin
        if ItemCategory.Get(NewCode) then
            exit;

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
        ContractSetupCBLC: Record "Contract Setup CBLC";
        ItemCategory: Record "Item Category";
    begin
        ContractSetupCBLC.SetLoadFields("Item Category Price");
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Item Category Price");

        ItemCategory.SetLoadFields(Code);
        ItemCategory.Get(ContractSetupCBLC."Item Category Price");

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
        ContractSetupCBLC: Record "Contract Setup CBLC";
    begin
        ContractSetupCBLC.SetLoadFields("Unit of Measure Code Month");
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");
        exit(CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 40, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month"));
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

        if ItemUnitofMeasure.Get(ItemNo, UoMCode) then
            exit;

        ItemUnitofMeasure.Init();
        ItemUnitofMeasure.Validate("Item No.", ItemNo);
        ItemUnitofMeasure.Validate(Code, UoMCode);
        ItemUnitofMeasure.Validate("Qty. per Unit of Measure", QtyPerUoM);
        ItemUnitofMeasure.Insert(true);
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

    procedure CreateItemPlanningNorm(var Item: Record Item; var ItemPlanningNormCBLC: Record "Item Planning Norm CBLC"; ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormNo: Code[20]; RelatedNormTypeCBLC: Enum "Related Norm Type CBLC"; RelatedNormNo: Code[20])
    var
    begin
        Item.TestField("No.");

        ItemPlanningNormCBLC.Init();
        ItemPlanningNormCBLC."Entry No." := 0;
        ItemPlanningNormCBLC.Validate("Item No.", Item."No.");
        ItemPlanningNormCBLC.Validate("Object Norm Type", ObjectNormTypeCBLC);
        ItemPlanningNormCBLC.Validate("Object Norm No.", ObjectNormNo);
        ItemPlanningNormCBLC.Validate("Related Norm Type", RelatedNormTypeCBLC);
        ItemPlanningNormCBLC.Validate("Related Norm No.", RelatedNormNo);
        ItemPlanningNormCBLC.Insert(true);
    end;

    procedure CreateItemPlanningNorm(var Item: Record Item; var ItemPlanningNormCBLC: Record "Item Planning Norm CBLC"; ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormNo: Code[20]; RelatedNormTypeCBLC: Enum "Related Norm Type CBLC"; RelatedNormNo: Code[20]; ResourceGroupNo: Code[20]; UnitOfMeasureCode: Code[10]; Quantity: Decimal)
    begin
        CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC, ObjectNormNo, RelatedNormTypeCBLC, RelatedNormNo);
        ItemPlanningNormCBLC.Validate("Unit of Measure Code", UnitOfMeasureCode);
        ItemPlanningNormCBLC.Modify(true);

        ItemPlanningNormCBLC.Validate("Resource Group No.", ResourceGroupNo);
        ItemPlanningNormCBLC.Validate(Quantity, Quantity);
        ItemPlanningNormCBLC.Modify(true);
    end;

    procedure CreateItemUsageNorm(var Item: Record Item; var ItemUsageNormCBLC: Record "Item Usage Norm CBLC"; ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormNo: Code[20]; RelatedNormTypeCBLC: Enum "Related Norm Type CBLC"; RelatedNormNo: Code[20])
    var
    begin
        Item.TestField("No.");

        ItemUsageNormCBLC.Init();
        ItemUsageNormCBLC.Validate("Item No.", Item."No.");
        ItemUsageNormCBLC.Validate("Object Norm Type", ObjectNormTypeCBLC);
        ItemUsageNormCBLC.Validate("Object Norm No.", ObjectNormNo);
        ItemUsageNormCBLC.Validate("Related Norm Type", RelatedNormTypeCBLC);
        ItemUsageNormCBLC.Validate("Related Norm No.", RelatedNormNo);
        ItemUsageNormCBLC.Insert(true);
    end;

    procedure CreateItemUsageNorm(var Item: Record Item; var ItemUsageNormCBLC: Record "Item Usage Norm CBLC"; ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormNo: Code[20]; RelatedNormTypeCBLC: Enum "Related Norm Type CBLC"; RelatedNormNo: Code[20]; UsageItemNo: Code[20]; Quantity: Decimal)
    begin
        CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC, ObjectNormNo, RelatedNormTypeCBLC, RelatedNormNo);
        ItemUsageNormCBLC.Validate("Usage Item No.", UsageItemNo);
        ItemUsageNormCBLC.Validate(Quantity, Quantity);
        ItemUsageNormCBLC.Modify(true);
    end;

    procedure DeleteAllItemPlanningNorms(ItemNo: Code[20]; UseTrigger: Boolean)
    var
        ItemPlanningNormCBLC: Record "Item Planning Norm CBLC";
    begin
        if ItemNo = '' then
            exit;

        ItemPlanningNormCBLC.SetRange("Item No.", ItemNo);
        ItemPlanningNormCBLC.DeleteAll(UseTrigger);
    end;

    procedure DeleteAllItemUsageNorms(ItemNo: Code[20]; UseTrigger: Boolean)
    var
        ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
    begin
        if ItemNo = '' then
            exit;

        ItemUsageNormCBLC.SetRange("Item No.", ItemNo);
        ItemUsageNormCBLC.DeleteAll(UseTrigger);
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
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        ItemPlanningNormCBLC: Record "Item Planning Norm CBLC";
        ResourceGroup: Record "Resource Group";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        ItemNo: Code[20];
        ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
        I: Integer;
    begin
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Item Category Service");
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        ResourceGroup.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Resource Group"));

        for I := 1 to 10 do begin
            ItemNo := 'TSERVICE' + Format(I);
            Clear(Item);
            if not Item.Get(ItemNo) then
                LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month", ContractSetupCBLC."Item Category Service");
            Item.Validate(Description, 'Service ' + Item."No.");
            Item.Modify(true);

            LibraryItemLIB.DeleteAllItemPlanningNorms(ItemNo, false);
            LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', ResourceGroup."No.", 'UUR', 1);
        end;
    end;

    procedure CreateTestServicePriceItems()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        // ItemPlanningNormCBLC: Record "Item Planning Norm CBLC";
        ResourceGroup: Record "Resource Group";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        ItemNo: Code[20];
        // ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        // RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
        I: Integer;
    begin
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Item Category Price");
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        ResourceGroup.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Resource Group"));

        for I := 1 to 10 do begin
            ItemNo := 'TPRICE' + Format(I);
            Clear(Item);
            if not Item.Get(ItemNo) then
                LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month", ContractSetupCBLC."Item Category Price");

            LibraryItemLIB.DeleteAllItemPlanningNorms(ItemNo, false);
            //LibraryItemLIB.AddPlanningNormToItem(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', ResourceGroup."No.", 'UUR', 1);
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

    procedure CreateItemDiscountGroup(ItemDiscountGroupCode: Code[20]; Description: Text[100])
    var
        ItemDiscountGroup: Record "Item Discount Group";
    begin
        if ItemDiscountGroup.Get(ItemDiscountGroupCode) then
            exit;

        ItemDiscountGroup.Init();
        ItemDiscountGroup.Validate(Code, ItemDiscountGroupCode);
        ItemDiscountGroup.Validate(Description, Description);
        ItemDiscountGroup.Insert(true);
    end;

    procedure CreatePurchasingCode(NewCode: Code[10]; Description: Text[100]; DropShipment: Boolean; SpecialOrder: Boolean)
    var
        Purchasing: Record Purchasing;
    begin
        if Purchasing.Get(NewCode) then
            exit;

        Purchasing.Init();
        Purchasing.Validate(Code, NewCode);
        Purchasing.Validate(Description, Description);
        Purchasing.Validate("Drop Shipment", DropShipment);
        Purchasing.Validate("Special Order", SpecialOrder);
        Purchasing.Insert(true);
    end;
}