codeunit 83990 "Library - Sales LIB"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contact Business Relation" = R,
        tabledata Customer = RM,
        tabledata Item = R,
        tabledata Purchasing = RI,
        tabledata "Realization Status CBLC" = RI,
        tabledata "Resource Group" = R,
        tabledata "Return Reason" = RI,
        tabledata "Sales Header" = R,
        tabledata "Sales Line" = R,
        tabledata "Sales Plan. Line CBLC" = R,
        tabledata "Sales Realization CBLC" = RIM,
        tabledata "Sales Rlz. Work Time CBLC" = R,
        tabledata "Transaction Type" = RI;

    var
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryMarketing: Codeunit "Library - Marketing";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";

    procedure CreateSalesOrderForCustomerNo(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, CustomerNo);
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
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Type, No, Quantity);
    end;

    procedure CreatesalesLineItem(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; ItemNo: Code[20])
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, ItemNo, LibraryRandom.RandInt(100));
    end;

    procedure CreatesalesLineItem(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; ItemNo: Code[20]; Quantity: Decimal)
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, ItemNo, Quantity);
    end;

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
        AssignPlanLinkHelperCBLC: Codeunit "Assign Plan. Link Helper CBLC";
    begin
        AssignPlanLinkHelperCBLC.ValidatePlanDocumentLineNo(SalesLine, PlanDocLineNo);
        AssignPlanLinkHelperCBLC.UpdatePlanDocumentLine(SalesLine, PlanDocLineNo);
    end;

    procedure GetSalesPlanLine(var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC"; SalesLine: Record "Sales Line"): Boolean
    begin
        SalesPlanLineCBLC.SetRange("Document Type", SalesLine."Document Type");
        SalesPlanLineCBLC.SetRange("Document No.", SalesLine."Document No.");
        SalesPlanLineCBLC.SetRange("Document Line No.", SalesLine."Line No.");
        if SalesPlanLineCBLC.FindFirst() then
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

    procedure InitSalesRealization(SalesLine: Record "Sales Line"; var SalesRealizationCBLC: Record "Sales Realization CBLC"; ResourceGroup: Record "Resource Group")
    begin
        SalesRealizationCBLC.Init();
        SalesRealizationCBLC.Validate("Document Type", SalesLine."Document Type");
        SalesRealizationCBLC.Validate("Document No.", SalesLine."Document No.");
        SalesRealizationCBLC.Validate("Document Line No.", SalesLine."Line No.");
        SalesRealizationCBLC.Validate("Resource Group No.", ResourceGroup."No.");
    end;

    procedure SalesRealizationUpdateTravelStartingDateTime(var SalesRealizationCBLC: Record "Sales Realization CBLC"; StartDate: Date; StartTime: Time)
    var
        StartingDateTime: DateTime;
    begin
        StartingDateTime := CreateDateTime(StartDate, StartTime);
        SalesRealizationUpdateTravelStartingDateTime(SalesRealizationCBLC, StartingDateTime);
    end;

    procedure SalesRealizationUpdateTravelStartingDateTime(var SalesRealizationCBLC: Record "Sales Realization CBLC"; StartingDateTime: DateTime)
    begin
        SalesRealizationCBLC.Validate("Travel Starting Date Time", StartingDateTime);
    end;

    procedure SalesRealizationUpdateTravelEndingDateTime(var SalesRealizationCBLC: Record "Sales Realization CBLC"; EndingDate: Date; EndingTime: Time)
    var
        EndingDateTime: DateTime;
    begin
        EndingDateTime := CreateDateTime(EndingDate, EndingTime);
        SalesRealizationUpdateTravelEndingDateTime(SalesRealizationCBLC, EndingDateTime);
    end;

    procedure SalesRealizationUpdateTravelEndingDateTime(var SalesRealizationCBLC: Record "Sales Realization CBLC"; EndingDateTime: DateTime)
    begin
        SalesRealizationCBLC.Validate("Travel Ending Date Time", EndingDateTime);
    end;

    procedure SalesRealizationUpdateWorkStartingDateTime(var SalesRealizationCBLC: Record "Sales Realization CBLC"; StartDate: Date; StartTime: Time)
    var
        StartingDateTime: DateTime;
    begin
        StartingDateTime := CreateDateTime(StartDate, StartTime);
        SalesRealizationCBLC.Validate("Work Starting Date Time", StartingDateTime);
    end;

    procedure SalesRealizationUpdateWorkEndingDateTime(var SalesRealizationCBLC: Record "Sales Realization CBLC"; EndingDate: Date; EndingTime: Time)
    var
        EndingDateTime: DateTime;
    begin
        EndingDateTime := CreateDateTime(EndingDate, EndingTime);
        SalesRealizationCBLC.Validate("Work Ending Date Time", EndingDateTime);
    end;

    procedure SetSalesRealizationToProcessed(var SalesRealizationCBLC: Record "Sales Realization CBLC")
    begin
        SalesRealizationCBLC.Validate("Realization Status Code", 'UITGEVOERD'); //TODO is nu hardcoded
        SalesRealizationCBLC.Modify(true);
    end;

    procedure CreateRealizationStatus(Code: Code[10]; Description: Text[100])
    begin
        CreateRealizationStatus(Code, Description, false, 0, false);
    end;

    procedure CreateRealizationStatus(Code: Code[10]; Description: Text[100]; CreateFollowUpDocumentLine: Boolean; FollowUpDocumentType: Option " ",Quote,Order; NewFollowUpDocumentHeader: Boolean)
    var
        RealizationStatusCBLC: Record "Realization Status CBLC";
    begin
        if RealizationStatusCBLC.Get(Code) then
            exit;

        RealizationStatusCBLC.Init();
        RealizationStatusCBLC.Validate(Code, Code);
        RealizationStatusCBLC.Validate(Description, Description);
        RealizationStatusCBLC.Validate("Create Follow-up Document Line", CreateFollowUpDocumentLine);
        RealizationStatusCBLC.Validate("Follow-Up Document Type", FollowUpDocumentType);
        RealizationStatusCBLC.Validate("New Follow-up Document Header", NewFollowUpDocumentHeader);
        RealizationStatusCBLC.Insert(true);
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
        LibraryItem: Codeunit "Library - Item LIB";
    begin
        LibraryItem.CreatePurchasingCode(NewCode, Description, DropShipment, SpecialOrder);
    end;

    procedure CreateSalesRealization(var SalesRealizationCBLC: Record "Sales Realization CBLC"; SalesLine: Record "Sales Line"; WorkStartingDateTime: DateTime; WorkEndingDateTime: DateTime; TravelStartingDateTime: DateTime; TravelEndingDateTime: DateTime; TravelDistance: Decimal)
    var
        ResourceGroup: Record "Resource Group";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        ResourceGroupNo: Code[20];
    begin
        GetSalesPlanLine(SalesPlanLineCBLC, SalesLine);
        ResourceGroupNo := SalesPlanLineCBLC."Resource Group No.";
        ResourceGroup.Get(ResourceGroupNo);

        InitSalesRealization(SalesLine, SalesRealizationCBLC, ResourceGroup);
        SalesRealizationCBLC.Insert(true);

        // Work
        SalesRealizationCBLC.Validate("Work Starting Date Time", WorkStartingDateTime);
        SalesRealizationCBLC.Validate("Work Ending Date Time", WorkEndingDateTime);

        // Travel
        SalesRealizationCBLC.Validate("Travel Starting Date Time", TravelStartingDateTime);
        SalesRealizationCBLC.Validate("Travel Ending Date Time", TravelEndingDateTime);

        //Distance
        if TravelDistance = -1 then
            SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0))
        else
            SalesRealizationCBLC.Validate("Travel Distance (km)", TravelDistance);

        SalesRealizationCBLC.Modify(true);
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
        if SalesHeader.FindLast() then; //Focus
        PageManagement.PageRun(SalesHeader);
    end;

    procedure GetSalesRlzWorkTime(SalesRealizationCBLC: Record "Sales Realization CBLC"; var SalesRlzWorkTimeCBLC: Record "Sales Rlz. Work Time CBLC"): Boolean
    begin
        SalesRlzWorkTimeCBLC.Reset();
        SalesRlzWorkTimeCBLC.SetRange("Document Type", SalesRealizationCBLC."Document Type");
        SalesRlzWorkTimeCBLC.SetRange("Document No.", SalesRealizationCBLC."Document No.");
        SalesRlzWorkTimeCBLC.SetRange("Document Line No.", SalesRealizationCBLC."Document Line No.");
        SalesRlzWorkTimeCBLC.SetRange("Resource Group No.", SalesRealizationCBLC."Resource Group No.");
        if SalesRlzWorkTimeCBLC.FindFirst() then
            exit(true);
    end;

    procedure GetSalesPlanLine(SalesRealizationCBLC: Record "Sales Realization CBLC"; var SalesPlanLineCBLC: Record "Sales Plan. Line CBLC"): Boolean
    begin
        if SalesPlanLineCBLC.Get(SalesRealizationCBLC."Document Type", SalesRealizationCBLC."Document No.", SalesRealizationCBLC."Document Line No.", SalesRealizationCBLC."Resource Group No.") then
            exit(true);
    end;

    procedure CreateCustomer(var Customer: Record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;

    procedure CreateTransactionType(Code: Code[10]; Description: Text[80])
    var
        TransactionType: Record "Transaction Type";
    begin
        if Code = '' then
            exit;

        if TransactionType.Get(Code) then
            exit;

        TransactionType.Init();
        TransactionType.Validate(Code, Code);
        TransactionType.Validate(Description, Description);
        TransactionType.Insert(true);
    end;
}