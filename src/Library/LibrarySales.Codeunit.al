codeunit 83990 "Library - Sales LIB"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contact Business Relation" = R,
        tabledata Customer = RM,
        tabledata Item = R,
        tabledata Purchasing = RI,
        tabledata "Realization Status TPZS" = RI,
        tabledata "Resource Group" = R,
        tabledata "Return Reason" = RI,
        tabledata "Sales Header" = R,
        tabledata "Sales Line" = R,
        tabledata "Sales Plan. Line TPZS" = R,
        tabledata "Sales Realization TPZS" = RIM,
        tabledata "Sales Rlz. Work Time TPZS" = R;

    var
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryMarketing: Codeunit "Library - Marketing";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";

    procedure CreateSalesOrderForCustomerNo(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
    // Item: Record Item;
    // SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, CustomerNo);
        // LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
        //   Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
    end;

    procedure CreateSalesOrderForCustomerNoWithSalesLine(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, CustomerNo);
        LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
          Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibraryRandom.RandInt(100));
    end;

    procedure CreateSalesInvoiceForCustomerNoWithSalesLine(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Invoice, CustomerNo);
        LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
          Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibraryRandom.RandInt(100));
    end;

    procedure CreateSalesCreditMemoForCustomerNoWithSalesLine(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::"Credit Memo", CustomerNo);
        LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
          Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibraryRandom.RandInt(100));
    end;

    procedure CreateSalesReturnOrderForCustomerNoWithSalesLine(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::"Return Order", CustomerNo);
        LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
          Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibraryRandom.RandInt(100));
    end;

    procedure CreateSalesQuoteForCustomerNo(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
    // Item: Record Item;
    // SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Quote, CustomerNo);
        // LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
        //   Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
    end;

    procedure CreateSalesQuoteForCustomerNoWithSalesLine(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Quote, CustomerNo);
        LibraryInventory.CreateItemWithUnitPriceAndUnitCost(
          Item, LibraryRandom.RandDecInRange(1, 100, 2), LibraryRandom.RandDecInRange(1, 100, 2));
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibraryRandom.RandInt(100));
    end;

    procedure CreateSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Type: Enum "Sales Line Type"; No: Code[20]; Quantity: Decimal)
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Type, No, LibraryRandom.RandInt(100));
    end;

    procedure CreatesalesLineItem(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; ItemNo: Code[20])
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, ItemNo, LibraryRandom.RandInt(100));
    end;

    procedure CreatesalesLineItem(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; ItemNo: Code[20]; Quantity: Decimal)
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, ItemNo, Quantity);
    end;

    // procedure FindFirstSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    // begin
    //     SalesLine.SetRange("Document Type", SalesHeader."Document Type");
    //     SalesLine.SetRange("Document No.", SalesHeader."No.");
    //     SalesLine.FindFirst();
    // end;

    procedure GetCustomerFromContact(var Customer: Record Customer; Contact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.SetRange("Contact No.", Contact."No.");
        if ContactBusinessRelation.FindFirst() then
            Customer.Get(ContactBusinessRelation."No.");
    end;

    procedure LinkSalesLines(var SalesLine: Record "Sales Line"; PlanDocLineNo: Integer)
    var
        AssignPlanLinkHelperTPZS: Codeunit "Assign Plan. Link Helper TPZS";
    begin
        AssignPlanLinkHelperTPZS.ValidatePlanDocumentLineNo(SalesLine, PlanDocLineNo);
        AssignPlanLinkHelperTPZS.UpdatePlanDocumentLine(SalesLine, PlanDocLineNo);
    end;

    procedure GetSalesPlanLine(var SalesPlanLineTPZS: Record "Sales Plan. Line TPZS"; SalesLine: Record "Sales Line"): Boolean
    begin
        SalesPlanLineTPZS.SetRange("Document Type", SalesLine."Document Type");
        SalesPlanLineTPZS.SetRange("Document No.", SalesLine."Document No.");
        SalesPlanLineTPZS.SetRange("Document Line No.", SalesLine."Line No.");
        // SalesPlanLineTPZS.SetRange("Plan. Document Type", SalesLine."Document Type");
        // SalesPlanLineTPZS.SetRange("Plan. Document No.", SalesLine."Document No.");
        // SalesPlanLineTPZS.SetRange("Plan. Document Line No.", SalesLine."Line No.");
        if SalesPlanLineTPZS.FindFirst() then
            exit(true);
    end;

    procedure PostSalesDocument(SalesHeader: Record "Sales Header"; NewShipReceive: Boolean; NewInvoice: Boolean): Code[20]
    begin
        exit(LibrarySales.PostSalesDocument(SalesHeader, NewShipReceive, NewInvoice));
    end;

    procedure ReopenSalesDocument(var SalesHeader: Record "Sales Header")
    var
        ReleaseSalesDocument: Codeunit "Release Sales Document";
    begin
        ReleaseSalesDocument.PerformManualReopen(SalesHeader);
    end;

    procedure CreatePersonContactWithCustomer(var Contact: Record Contact)
    var
        Customer: Record Customer;
    begin
        CreatePersonContactWithCustomer(Contact, Customer);
    end;

    procedure CreatePersonContactWithCustomer(var Contact: Record Contact; var Customer: Record Customer)
    // var
    //     LibrarySalesLIB: Codeunit "Library - Sales LIB";
    begin
        LibraryMarketing.CreatePersonContact(Contact);
        Contact.CreateCustomerFromTemplate('');
        GetCustomerFromContact(Customer, Contact);

        Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND'); //TODO Fix
        Customer.Validate("Customer Posting Group", 'BINNENLAND');
        Customer.Modify(true);
    end;

    procedure FindFirstSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        LibrarySales.FindFirstSalesLine(SalesLine, SalesHeader);
    end;

    procedure InitSalesRealization(SalesLine: Record "Sales Line"; var SalesRealizationTPZS: Record "Sales Realization TPZS"; ResourceGroup: Record "Resource Group")
    begin
        SalesRealizationTPZS.Init();
        SalesRealizationTPZS.Validate("Document Type", SalesLine."Document Type");
        SalesRealizationTPZS.Validate("Document No.", SalesLine."Document No.");
        SalesRealizationTPZS.Validate("Document Line No.", SalesLine."Line No.");
        SalesRealizationTPZS.Validate("Resource Group No.", ResourceGroup."No.");
    end;

    procedure SalesRealizationUpdateTravelStartingDateTime(var SalesRealizationTPZS: Record "Sales Realization TPZS"; StartDate: Date; StartTime: Time)
    var
        StartingDateTime: DateTime;
    begin
        StartingDateTime := CreateDateTime(StartDate, StartTime);
        SalesRealizationUpdateTravelStartingDateTime(SalesRealizationTPZS, StartingDateTime);
    end;

    procedure SalesRealizationUpdateTravelStartingDateTime(var SalesRealizationTPZS: Record "Sales Realization TPZS"; StartingDateTime: DateTime)
    begin
        SalesRealizationTPZS.Validate("Travel Starting Date Time", StartingDateTime);
    end;

    procedure SalesRealizationUpdateTravelEndingDateTime(var SalesRealizationTPZS: Record "Sales Realization TPZS"; EndingDate: Date; EndingTime: Time)
    var
        EndingDateTime: DateTime;
    begin
        EndingDateTime := CreateDateTime(EndingDate, EndingTime);
        SalesRealizationUpdateTravelEndingDateTime(SalesRealizationTPZS, EndingDateTime);
    end;

    procedure SalesRealizationUpdateTravelEndingDateTime(var SalesRealizationTPZS: Record "Sales Realization TPZS"; EndingDateTime: DateTime)
    begin
        SalesRealizationTPZS.Validate("Travel Ending Date Time", EndingDateTime);
    end;

    procedure SalesRealizationUpdateWorkStartingDateTime(var SalesRealizationTPZS: Record "Sales Realization TPZS"; StartDate: Date; StartTime: Time)
    var
        StartingDateTime: DateTime;
    begin
        StartingDateTime := CreateDateTime(StartDate, StartTime);
        SalesRealizationTPZS.Validate("Work Starting Date Time", StartingDateTime);
    end;

    procedure SalesRealizationUpdateWorkEndingDateTime(var SalesRealizationTPZS: Record "Sales Realization TPZS"; EndingDate: Date; EndingTime: Time)
    var
        EndingDateTime: DateTime;
    begin
        EndingDateTime := CreateDateTime(EndingDate, EndingTime);
        SalesRealizationTPZS.Validate("Work Ending Date Time", EndingDateTime);
    end;

    procedure SetSalesRealizationToProcessed(var SalesRealizationTPZS: Record "Sales Realization TPZS")
    begin
        SalesRealizationTPZS.Validate("Realization Status Code", 'UITGEVOERD'); //TODO is nu hardcoded
        SalesRealizationTPZS.Modify(true);
    end;

    procedure CreateRealizationStatus(Code: Code[10]; Description: Text[100])
    begin
        CreateRealizationStatus(Code, Description, false, 0, false);
    end;

    procedure CreateRealizationStatus(Code: Code[10]; Description: Text[100]; CreateFollowUpDocumentLine: Boolean; FollowUpDocumentType: Option " ",Quote,Order; NewFollowUpDocumentHeader: Boolean)
    var
        RealizationStatusTPZS: Record "Realization Status TPZS";
    begin
        if RealizationStatusTPZS.Get(Code) then
            exit;

        RealizationStatusTPZS.Init();
        RealizationStatusTPZS.Validate(Code, Code);
        RealizationStatusTPZS.Validate(Description, Description);
        RealizationStatusTPZS.Validate("Create Follow-up Document Line", CreateFollowUpDocumentLine);
        RealizationStatusTPZS.Validate("Follow-Up Document Type", FollowUpDocumentType);
        RealizationStatusTPZS.Validate("New Follow-up Document Header", NewFollowUpDocumentHeader);
        RealizationStatusTPZS.Insert(true);
    end;

    procedure CreateReturnReason(NewCode: Code[10]; Description: Text[100])
    var
        ReturnReason: Record "Return Reason";
    begin
        if ReturnReason.Get(NewCode) then
            exit;

        ReturnReason.Init();
        ReturnReason.Validate(Code, NewCode);
        ReturnReason.Validate(Description, Description);
        ReturnReason.Insert(true);
    end;

    procedure CreatePurchasingCode(NewCode: Code[10]; Description: Text[100]; DropShipment: Boolean; SpecialOrder: Boolean)
    var
        Purchasing: Record Purchasing;
    begin
        Purchasing.Init();
        Purchasing.Validate(Code, NewCode);
        Purchasing.Validate(Description, Description);
        Purchasing.Validate("Drop Shipment", DropShipment);
        Purchasing.Validate("Special Order", SpecialOrder);
        Purchasing.Insert(true);
    end;

    procedure CreateSalesRealization(var SalesRealizationTPZS: Record "Sales Realization TPZS"; SalesLine: Record "Sales Line"; WorkStartingDateTime: DateTime; WorkEndingDateTime: DateTime; TravelStartingDateTime: DateTime; TravelEndingDateTime: DateTime; TravelDistance: Decimal)
    var
        ResourceGroup: Record "Resource Group";
        SalesPlanLineTPZS: Record "Sales Plan. Line TPZS";
        ResourceGroupNo: Code[20];
    begin
        GetSalesPlanLine(SalesPlanLineTPZS, SalesLine);
        ResourceGroupNo := SalesPlanLineTPZS."Resource Group No.";
        ResourceGroup.Get(ResourceGroupNo);

        InitSalesRealization(SalesLine, SalesRealizationTPZS, ResourceGroup);
        SalesRealizationTPZS.Insert(true);

        // Work
        SalesRealizationTPZS.Validate("Work Starting Date Time", WorkStartingDateTime);
        SalesRealizationTPZS.Validate("Work Ending Date Time", WorkEndingDateTime);

        // Travel
        SalesRealizationTPZS.Validate("Travel Starting Date Time", TravelStartingDateTime);
        SalesRealizationTPZS.Validate("Travel Ending Date Time", TravelEndingDateTime);

        //Distance
        if TravelDistance = -1 then
            SalesRealizationTPZS.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0))
        else
            SalesRealizationTPZS.Validate("Travel Distance (km)", TravelDistance);

        SalesRealizationTPZS.Modify(true);
    end;

    procedure OpenLastSalesOrder()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        OpenSalesDocument(SalesHeader);
    end;

    procedure GetLastSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindLast();
    end;

    procedure OpenLastSalesInvoice()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        OpenSalesDocument(SalesHeader);
    end;

    procedure OpenLastSalesCreditMemo()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        OpenSalesDocument(SalesHeader);
    end;

    procedure OpenSalesDocument(var SalesHeader: Record "Sales Header")
    var
        PageManagement: Codeunit "Page Management";
    begin
        if SalesHeader.FindLast() then;
        PageManagement.PageRun(SalesHeader);
    end;

    procedure GetSalesRlzWorkTime(SalesRealizationTPZS: Record "Sales Realization TPZS"; var SalesRlzWorkTimeTPZS: Record "Sales Rlz. Work Time TPZS"): Boolean
    begin
        SalesRlzWorkTimeTPZS.Reset();
        SalesRlzWorkTimeTPZS.SetRange("Document Type", SalesRealizationTPZS."Document Type");
        SalesRlzWorkTimeTPZS.SetRange("Document No.", SalesRealizationTPZS."Document No.");
        SalesRlzWorkTimeTPZS.SetRange("Document Line No.", SalesRealizationTPZS."Document Line No.");
        SalesRlzWorkTimeTPZS.SetRange("Resource Group No.", SalesRealizationTPZS."Resource Group No.");
        if SalesRlzWorkTimeTPZS.FindFirst() then
            exit(true);
    end;

    procedure GetSalesPlanLine(SalesRealizationTPZS: Record "Sales Realization TPZS"; var SalesPlanLineTPZS: Record "Sales Plan. Line TPZS"): Boolean
    begin
        if SalesPlanLineTPZS.Get(SalesRealizationTPZS."Document Type", SalesRealizationTPZS."Document No.", SalesRealizationTPZS."Document Line No.", SalesRealizationTPZS."Resource Group No.") then
            exit(true);
    end;

    procedure CreateCustomer(var Customer: Record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;
}