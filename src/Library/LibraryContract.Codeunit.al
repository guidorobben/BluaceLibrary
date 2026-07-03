codeunit 83980 "Library - Contract LIB"
{
    Permissions =
        tabledata "Contr. Archive Header CBLC" = R,
        tabledata "Contr. Template Header CBLC" = RIM,
        tabledata "Contr. Template Service CBLC" = RI,
        tabledata "Contr. Template UOM CBLC" = RI,
        tabledata "Contract Header CBLC" = RIM,
        tabledata "Contract Index CBLC" = RIMD,
        tabledata "Contract Line CBLC" = RI,
        tabledata "Contract Norm CBLC" = RI,
        tabledata "Contract Service CBLC" = RI,
        tabledata "Contract Setup CBLC" = R,
        tabledata "Contract Templ. Coverage CBLC" = RI,
        tabledata "Contract UOM CBLC" = RI,
        tabledata "Customer Price Group" = RI,
        tabledata "Sales & Receivables Setup" = R;

    procedure CreateContractTemplate(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; UnitOfMeasure: Code[10])
    begin
        CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, UnitOfMeasure, 0);
    end;

    procedure CreateContractTemplate(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; UnitOfMeasure: Code[10]; QtyPerUoM: Decimal)
    begin
        CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, UnitOfMeasure, QtyPerUoM);
    end;

    procedure CreateContractTemplateWithUOM(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; UnitOfMeasure: Code[10]; QtyPerUoM: Decimal)
    begin
        ContrTemplateHeaderCBLC.Init();
        ContrTemplateHeaderCBLC.Insert(true);
        ContrTemplateHeaderCBLC.TestField("No.");

        ContrTemplateHeaderCBLC.Description := ContrTemplateHeaderCBLC."No.";
        CreateContractTemplateUnitofMeasure(ContrTemplateHeaderCBLC, UnitOfMeasure, QtyPerUoM);
        ContrTemplateHeaderCBLC.Validate("Contract Unit of Measure", UnitOfMeasure);
        ContrTemplateHeaderCBLC.Modify(true);
    end;

    procedure CreateContractTemplateUnitofMeasure(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; UnitOfMeasure: Code[10]; QtyPerUoM: Decimal)
    var
        ContrTemplateUOMCBLC: Record "Contr. Template UOM CBLC";
    begin
        ContrTemplateUOMCBLC.Init();
        ContrTemplateUOMCBLC.Validate("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateUOMCBLC.Validate(Code, UnitOfMeasure);
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;
        ContrTemplateUOMCBLC.Validate("Qty. per Unit of Measure", QtyPerUoM);
        ContrTemplateUOMCBLC.Insert(true);
    end;

    procedure CreateContract(var ContractHeaderCBLC: Record "Contract Header CBLC"; SellToCustomerNo: Code[20]; UoMCode: Code[10])
    begin
        ContractHeaderCBLC.Init();
        ContractHeaderCBLC.Insert(true);
        ContractHeaderCBLC.TestField("No.");

        CreateContractUnitOfMeasure(ContractHeaderCBLC, UoMCode);
        ContractHeaderCBLC.Validate("Contract Unit of Measure", UoMCode);
        ContractHeaderCBLC.Validate("Sell-to Customer No.", SellToCustomerNo);
        ContractHeaderCBLC.Modify(true);
    end;

    procedure CreateIndexCode(IndexCode: Code[20]; Type: Enum "Contract Index Type CBLC"; Value: Decimal; SkipWhenExist: Boolean)
    var
        ContractIndexCBLC: Record "Contract Index CBLC";
    begin
        if SkipWhenExist then
            if ContractIndexCBLC.Get(IndexCode) then
                exit;

        CreateIndexCode(IndexCode, Type, Value);
    end;

    procedure CreateIndexCode(IndexCode: Code[20]; Type: Enum "Contract Index Type CBLC"; Value: Decimal)
    var
        ContractIndexCBLC: Record "Contract Index CBLC";
    begin
        ContractIndexCBLC.Init();
        ContractIndexCBLC.Validate(Code, IndexCode);
        ContractIndexCBLC.Validate("Manual Indexing Type", Type);
        ContractIndexCBLC.Validate(Value, Value);
        ContractIndexCBLC.Insert(true);
    end;

    procedure UpdateIndexCode(Code: Code[20]; NewType: Enum "Contract Index Type CBLC"; NewValue: Decimal)
    var
        ContractIndexCBLC: Record "Contract Index CBLC";
    begin
        if not ContractIndexCBLC.Get(Code) then
            exit;

        ContractIndexCBLC.Validate("Manual Indexing Type", NewType);
        ContractIndexCBLC.Validate(Value, NewValue);
        ContractIndexCBLC.Modify(true);
    end;

    procedure DeleteIndexCode(Code: Code[20]; UseTrigger: Boolean)
    var
        ContractIndexCBLC: Record "Contract Index CBLC";
    begin
        ContractIndexCBLC.SetRange(Code, Code);
        if UseTrigger then
            ContractIndexCBLC.DeleteAll(true)
        else
            ContractIndexCBLC.DeleteAll(false)
    end;

    procedure AddContractService(ContractHeaderCBLC: Record "Contract Header CBLC"; ItemCategoryCode: Code[20])
    var
        ContractServiceCBLC: Record "Contract Service CBLC";
    begin
        if ContractHeaderCBLC."No." = '' then
            exit;

        if ItemCategoryCode = '' then
            exit;

        ContractServiceCBLC.Init();
        ContractServiceCBLC.Validate("Contract No.", ContractHeaderCBLC."No.");
        ContractServiceCBLC.Validate("Item Category Code", ItemCategoryCode);
        ContractServiceCBLC.Insert(true);
    end;

    procedure CreateContractNorm(Code: Code[20]; Description: Text[100])
    var
        ContractNormCBLC: Record "Contract Norm CBLC";
    begin
        if ContractNormCBLC.Get(Code) then
            exit;

        ContractNormCBLC.Reset();
        ContractNormCBLC.Init();
        ContractNormCBLC.Validate(Code, Code);
        ContractNormCBLC.Validate(Description, Description);
        ContractNormCBLC.Insert(true);
    end;

    procedure CreateCustomerPriceGroup(Code: Code[10]; Description: Text[100]; AllowInvoiceDiscount: Boolean; AllowLineDiscount: Boolean)
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        CustomerPriceGroup.Init();
        CustomerPriceGroup.Validate(Code, Code);
        CustomerPriceGroup.Validate(Description, Description);
        CustomerPriceGroup.Validate("Allow Invoice Disc.", AllowInvoiceDiscount);
        CustomerPriceGroup.Validate("Allow Line Disc.", AllowLineDiscount);
        CustomerPriceGroup.Insert(true);
    end;

    procedure CreateContractUnitOfMeasure(ContractHeaderCBLC: Record "Contract Header CBLC"; UOMCode: Code[10])
    var
        ContractUOMCBLC: Record "Contract UOM CBLC";
    begin
        ContractUOMCBLC.Init();
        ContractUOMCBLC.Validate("Contract No.", ContractHeaderCBLC."No.");
        ContractUOMCBLC.Validate(Code, UOMCode);
        ContractUOMCBLC.Validate("Qty. per Unit of Measure", 1);
        ContractUOMCBLC.Insert(true);
    end;

    procedure CreateContractLine(ContractHeaderCBLC: Record "Contract Header CBLC"; var ContractLineCBLC: Record "Contract Line CBLC"; ObjectNo: Code[20]; ItemNo: Code[20]; Quantity: Integer; ManuallyChanged: Boolean; UnitPrice: Decimal; StartingDate: Date; EndingDate: Date)
    var
        LineNoContractLineCBLC: Record "Contract Line CBLC";
        LineNo: Integer;
    begin
        LineNoContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        if LineNoContractLineCBLC.FindLast() then
            LineNo := LineNoContractLineCBLC."Line No.";
        LineNo += 10000;

        ContractLineCBLC.Init();
        ContractLineCBLC.Validate("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.Validate("Line No.", LineNo);
        //ContractLineCBLC.Validate(Description, 'Contract Line: ' + Format(LineNo));

        if ObjectNo <> '' then begin
            ContractLineCBLC.Validate("Object No.", ObjectNo);
            ContractLineCBLC.TestField("Price Item No.");
        end else
            ContractLineCBLC.Validate("Price Item No.", ItemNo);

        if ContractLineCBLC."Object No." = '' then
            ContractLineCBLC.Validate(Quantity, Quantity);

        if ManuallyChanged then begin
            ContractLineCBLC.Validate("Unit Price", UnitPrice);
            ContractLineCBLC.Validate("Price Manually Changed", true);
        end;

        ContractLineCBLC.Validate("Starting Date", StartingDate);
        ContractLineCBLC.Validate("Ending Date", EndingDate);
        ContractLineCBLC.Insert(true);
    end;

    // procedure Send(var ContractHeaderCBLC: Record "Contract Header CBLC")
    // var
    //     ContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
    //     TempSalesHeader: Record "Sales Header" temporary;
    //     ShipContractsHelperCBLC: Codeunit "Ship Contracts Helper CBLC";
    //     PostingDate: Date;
    // begin
    //     PostingDate := 20220401D;

    //     //ShipContractsHelperCBLC.InitProgressWindow();

    //     ContrArchiveHeaderCBLC.Get(ContractHeaderCBLC."No.", ContractHeaderCBLC.GetLastVersionNo());
    //     ShipContractsHelperCBLC.CreateContractSalesLines(ContrArchiveHeaderCBLC, PostingDate, TempSalesHeader);
    //     ShipContractsHelperCBLC.ShipSalesOrders(TempSalesHeader);

    //     //ShipContractsHelperCBLC.CloseProgressWindow();
    // end;

    procedure ReindexContract(ContractHeaderCBLC: Record "Contract Header CBLC"; IndexDate: Date)
    var
        ContractIndexingMethCBLC: Codeunit "Contract Indexing Meth CBLC";
    begin
        ContractIndexingMethCBLC.IndexContract(ContractHeaderCBLC, IndexDate);
        ContractHeaderCBLC."Last Index Date" := IndexDate;
        ContractHeaderCBLC.Modify(false);
    end;

    procedure AddContractTemplateService(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; ItemCategoryCode: Code[20])
    var
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
    begin
        AddContractTemplateService(ContrTemplateServiceCBLC, ContrTemplateHeaderCBLC, ItemCategoryCode);
    end;

    procedure AddContractTemplateService(var ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC"; ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; ItemCategoryCode: Code[20])
    begin
        ContrTemplateServiceCBLC.Init();
        ContrTemplateServiceCBLC.Validate("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.Validate("Item Category Code", ItemCategoryCode);
        ContrTemplateServiceCBLC.Insert(true);
    end;

    procedure AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; ItemCategoryCode: Code[20])
    var
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
    begin
        AddContractTemplateService(ContrTemplateServiceCBLC, ContrTemplateHeaderCBLC, ItemCategoryCode);
        AddContractTemplateCoverage(ContrTemplateServiceCBLC, Enum::"Contract Coverage Type CBLC"::AllItems, '', 10);
    end;

    procedure CreateContractTemplateServiceWithCoverageItem(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; ItemCategoryCode: Code[20]; ItemNo: Code[20]; Discount: Decimal)
    var
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
    begin
        AddContractTemplateService(ContrTemplateServiceCBLC, ContrTemplateHeaderCBLC, ItemCategoryCode);
        AddContractTemplateCoverage(ContrTemplateServiceCBLC, Enum::"Contract Coverage Type CBLC"::Item, ItemNo, Discount);
    end;

    procedure AddContractTemplateCoverageItem(ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC"; ItemNo: Code[20]; Discount: Decimal)
    begin
        AddContractTemplateCoverage(ContrTemplateServiceCBLC, Enum::"Contract Coverage Type CBLC"::Item, ItemNo, Discount);
    end;

    procedure CreateContractTemplateCoverageAllItems(ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC"; Discount: Decimal)
    begin
        AddContractTemplateCoverage(ContrTemplateServiceCBLC, Enum::"Contract Coverage Type CBLC"::AllItems, '', Discount);
    end;

    procedure CreateContractTemplateCoverageResource(ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC"; ResourceNo: Code[20]; Discount: Decimal)
    begin
        AddContractTemplateCoverage(ContrTemplateServiceCBLC, Enum::"Contract Coverage Type CBLC"::Resource, ResourceNo, Discount);
    end;

    procedure AddContractTemplateCoverage(ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC"; CoverageType: Enum "Contract Coverage Type CBLC"; CoverageNo: Code[20]; Discount: Decimal)
    var
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        ContractTemplCoverageCBLC.Init();
        ContractTemplCoverageCBLC.Validate("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.Validate("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        ContractTemplCoverageCBLC.Validate(Type, CoverageType);
        ContractTemplCoverageCBLC.Validate("No.", CoverageNo);
        ContractTemplCoverageCBLC.Validate("Discount %", Discount);
        ContractTemplCoverageCBLC.Insert(true);
    end;

    procedure ApplyContractTemplateOnExistingContract(var ContractHeaderCBLC: Record "Contract Header CBLC"; ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC")
    var
        ContractHeaderHelperCBLC: Codeunit "Contract Header Helper CBLC";
    begin
        ContractHeaderHelperCBLC.ApplyContractTemplate(ContractHeaderCBLC, ContrTemplateHeaderCBLC);
    end;

    procedure CreateContractFromTemplate(var ContractHeaderCBLC: Record "Contract Header CBLC"; ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC")
    begin
        ContrTemplateHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.CreateContractFromTemplate(ContrTemplateHeaderCBLC."No.");
    end;

    procedure SendContract(var ContractHeaderCBLC: Record "Contract Header CBLC"; PostingDate: Date; SkipCheckShipmentOnPostingDate: Boolean)
    var
        ContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
        LastContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempSalesHeader: Record "Sales Header" temporary;
        ShipContractsHelperCBLC: Codeunit "Ship Contracts Helper CBLC";
    begin
        SalesReceivablesSetup.Get();
        ContractSetupCBLC.Get();

        ShipContractsHelperCBLC.InitProgressWindow();
        ContrArchiveHeaderCBLC.Get(ContractHeaderCBLC."No.", ContractHeaderCBLC.GetLastVersionNo());
        ShipContractsHelperCBLC.CreateContractSalesLines(ContrArchiveHeaderCBLC, LastContrArchiveHeaderCBLC, PostingDate, PostingDate, SkipCheckShipmentOnPostingDate, SalesReceivablesSetup, ContractSetupCBLC, TempSalesHeader, not GuiAllowed());
        ShipContractsHelperCBLC.ShipSalesOrders(TempSalesHeader, not GuiAllowed());
        ShipContractsHelperCBLC.CloseProgressWindow();
    end;

    procedure RemoveContractLines(ContractNo: Code[20])
    var
        ContractLineCBLC: Record "Contract Line CBLC";
        RemoveContrLinesMethCBLC: Codeunit "Remove Contr. Lines Meth CBLC";
    begin
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractNo);
        if ContractLineCBLC.FindSet() then
            repeat
                RemoveContrLinesMethCBLC.RemoveContractLines(ContractLineCBLC);
            until ContractLineCBLC.Next() = 0;
        RemoveContrLinesMethCBLC.ReleaseContracts();
    end;
}