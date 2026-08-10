codeunit 83958 "Library - Purchase LIB"
{
    Permissions =
        tabledata Item = r,
        tabledata "Purchase Header" = r,
        tabledata "Purchase Line" = rm;

    var
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryPurchase: Codeunit "Library - Purchase";
        LibraryRandom: Codeunit "Library - Random";

    procedure CreatePurchaseQuoteForVendorNo(var PurchaseHeader: Record "Purchase Header"; VendorNo: Code[20])
    var
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Quote, VendorNo);
        // LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo, LibraryRandom.RandInt(100));
        // PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        // PurchaseLine.Modify(true);
    end;

    procedure CreatePurchaseQuoteWithLineForVendorNo(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; VendorNo: Code[20])
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Quote, VendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo(), LibraryRandom.RandInt(100));
        PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        PurchaseLine.Modify(true);
    end;

    // procedure CreatePurchaseQuote(var PurchaseHeader: Record "Purchase Header")
    // var
    //     PurchaseLine: Record "Purchase Line";
    //     LibraryInventory: Codeunit "Library - Inventory";
    //     LibraryRandom: Codeunit "Library - Random";
    // begin
    //     CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Quote, CreateVendorNo);
    //     CreatePurchaseLine(
    //       PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo, LibraryRandom.RandInt(100));
    //     PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 99, 2));
    //     PurchaseLine.Modify(true);
    // end;


    procedure CreatePurchaseOrderForVendorNo(var PurchaseHeader: Record "Purchase Header"; VendorNo: Code[20])
    var
    // PurchaseLine: Record "Purchase Line";
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Order, VendorNo);
        // LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo, LibraryRandom.RandInt(100));
        // PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        // PurchaseLine.Modify(true);
    end;

    procedure CreatePurchaseOrderWithLineForVendorNo(var PurchaseHeader: Record "Purchase Header"; VendorNo: Code[20])
    var
        PurchaseLine: Record "Purchase Line";
    begin
        CreatePurchaseOrderWithLineForVendorNo(PurchaseHeader, PurchaseLine, VendorNo);
    end;

    procedure CreatePurchaseOrderWithLineForVendorNo(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; VendorNo: Code[20])
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Order, VendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo(), LibraryRandom.RandInt(100));
        PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        PurchaseLine.Modify(true);
    end;

    procedure CreatePurchaseOrderWithLine(var PurchaseHeader: Record "Purchase Header")
    var
        Item: Record Item;
        PurchaseLine: Record "Purchase Line";
        PurchaseLineType: Enum "Purchase Line Type";
    begin
        LibraryPurchase.CreatePurchaseOrder(PurchaseHeader);
        Item.FindFirst();
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLineType::Item, Item."No.", 5);
    end;

    procedure CreatePurchaseOrderWithLine(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        Item: Record Item;
        PurchaseLineType: Enum "Purchase Line Type";
    begin
        LibraryPurchase.CreatePurchaseOrder(PurchaseHeader);
        Item.FindFirst();
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLineType::Item, Item."No.", 5);
    end;

    procedure CreatePurchaseInvoiceWithLineForVendorNo(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; VendorNo: Code[20])
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Invoice, VendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo(), LibraryRandom.RandInt(100));
        PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        PurchaseLine.Modify(true);
    end;

    procedure CreatePurchaseCreditMemoWithLineForVendorNo(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; VendorNo: Code[20])
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::"Credit Memo", VendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo(), LibraryRandom.RandInt(100));
        PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        PurchaseLine.Modify(true);
    end;

    procedure CreatePurchaseReturnOrderWithLineForVendorNo(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; VendorNo: Code[20])
    begin
        if VendorNo = '' then
            VendorNo := LibraryPurchase.CreateVendorNo();

        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::"Return Order", VendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo(), LibraryRandom.RandInt(100));
        PurchaseLine.Validate("Direct Unit Cost", LibraryRandom.RandDecInRange(1, 100, 2));
        PurchaseLine.Modify(true);
    end;

    procedure CreatePurchaseLine(var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header"; ItemNo: Code[20])
    var
        PurchaseLineType: Enum "Purchase Line Type";
    begin
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLineType::Item, ItemNo, 1);
    end;

    procedure FindFirstPurchaseLine(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.FindFirst();
    end;
}