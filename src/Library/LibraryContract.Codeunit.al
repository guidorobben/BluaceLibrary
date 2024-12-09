codeunit 83980 "Library - Contract LIB"
{
    Permissions =
        tabledata "Contr. Archive Header TPZS" = R,
        tabledata "Contr. Template Coverage TPZS" = RI,
        tabledata "Contr. Template Header TPZS" = RIM,
        tabledata "Contr. Template Service TPZS" = RI,
        tabledata "Contr. Template UOM TPZS" = RI,
        tabledata "Contract Header TPZS" = RIM,
        tabledata "Contract Index TPZS" = RIMD,
        tabledata "Contract Line TPZS" = RI,
        tabledata "Contract Norm TPZS" = RI,
        tabledata "Contract Service TPZS" = RI,
        tabledata "Contract Setup TPZS" = R,
        tabledata "Contract UOM TPZS" = RI,
        tabledata "Customer Price Group" = RI,
        tabledata "Sales & Receivables Setup" = R;

    procedure CreateContractTemplate(var ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; UnitOfMeasure: Code[10])
    begin
        CreateContractTemplateWithUOM(ContrTemplateHeaderTPZS, UnitOfMeasure, 0);
    end;

    procedure CreateContractTemplate(var ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; UnitOfMeasure: Code[10]; QtyPerUoM: Decimal)
    begin
        CreateContractTemplateWithUOM(ContrTemplateHeaderTPZS, UnitOfMeasure, QtyPerUoM);
    end;

    procedure CreateContractTemplateWithUOM(var ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; UnitOfMeasure: Code[10]; QtyPerUoM: Decimal)
    begin
        ContrTemplateHeaderTPZS.Init();
        ContrTemplateHeaderTPZS.Insert(true);
        ContrTemplateHeaderTPZS.TestField("No.");

        ContrTemplateHeaderTPZS.Description := ContrTemplateHeaderTPZS."No.";
        CreateContractTemplateUnitofMeasure(ContrTemplateHeaderTPZS, UnitOfMeasure, QtyPerUoM);
        ContrTemplateHeaderTPZS.Validate("Contract Unit of Measure", UnitOfMeasure);
        ContrTemplateHeaderTPZS.Modify(true);
    end;

    procedure CreateContractTemplateUnitofMeasure(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; UnitOfMeasure: Code[10]; QtyPerUoM: Decimal)
    var
        ContrTemplateUOMTPZS: Record "Contr. Template UOM TPZS";
    begin
        ContrTemplateUOMTPZS.Init();
        ContrTemplateUOMTPZS.Validate("Contract Template No.", ContrTemplateHeaderTPZS."No.");
        ContrTemplateUOMTPZS.Validate(Code, UnitOfMeasure);
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;
        ContrTemplateUOMTPZS.Validate("Qty. per Unit of Measure", QtyPerUoM);
        ContrTemplateUOMTPZS.Insert(true);
    end;

    procedure CreateContract(var ContractHeaderTPZS: Record "Contract Header TPZS"; SellToCustomerNo: Code[20]; UoMCode: Code[10])
    begin
        ContractHeaderTPZS.Init();
        ContractHeaderTPZS.Insert(true);
        ContractHeaderTPZS.TestField("No.");

        CreateContractUnitOfMeasure(ContractHeaderTPZS, UoMCode);
        ContractHeaderTPZS.Validate("Contract Unit of Measure", UoMCode);
        ContractHeaderTPZS.Validate("Sell-to Customer No.", SellToCustomerNo);
        ContractHeaderTPZS.Modify(true);
    end;

    procedure CreateIndexCode(IndexCode: Code[20]; Type: Enum "Contract Index Type TPZS"; Value: Decimal; SkipWhenExist: Boolean)
    var
        ContractIndexTPZS: Record "Contract Index TPZS";
    begin
        if SkipWhenExist then
            if ContractIndexTPZS.Get(IndexCode) then
                exit;

        CreateIndexCode(IndexCode, Type, Value);
    end;

    procedure CreateIndexCode(IndexCode: Code[20]; Type: Enum "Contract Index Type TPZS"; Value: Decimal)
    var
        ContractIndexTPZS: Record "Contract Index TPZS";
    begin
        ContractIndexTPZS.Init();
        ContractIndexTPZS.Validate(Code, IndexCode);
        ContractIndexTPZS.Validate("Manual Indexing Type", Type);
        ContractIndexTPZS.Validate(Value, Value);
        ContractIndexTPZS.Insert(true);
    end;

    procedure UpdateIndexCode(Code: Code[20]; NewType: Enum "Contract Index Type TPZS"; NewValue: Decimal)
    var
        ContractIndexTPZS: Record "Contract Index TPZS";
    begin
        if not ContractIndexTPZS.Get(Code) then
            exit;

        ContractIndexTPZS.Validate("Manual Indexing Type", NewType);
        ContractIndexTPZS.Validate(Value, NewValue);
        ContractIndexTPZS.Modify(true);
    end;

    procedure DeleteIndexCode(Code: Code[20]; UseTrigger: Boolean)
    var
        ContractIndexTPZS: Record "Contract Index TPZS";
    begin
        ContractIndexTPZS.SetRange(Code, Code);
        if UseTrigger then
            ContractIndexTPZS.DeleteAll(true)
        else
            ContractIndexTPZS.DeleteAll(false)
    end;

    procedure AddContractService(ContractHeaderTPZS: Record "Contract Header TPZS"; ItemCategoryCode: Code[20])
    var
        ContractServiceTPZS: Record "Contract Service TPZS";
    begin
        if ContractHeaderTPZS."No." = '' then
            exit;

        if ItemCategoryCode = '' then
            exit;

        ContractServiceTPZS.Init();
        ContractServiceTPZS.Validate("Contract No.", ContractHeaderTPZS."No.");
        ContractServiceTPZS.Validate("Item Category Code", ItemCategoryCode);
        ContractServiceTPZS.Insert(true);
    end;

    procedure CreateContractNorm(Code: Code[20]; Description: Text[100])
    var
        ContractNormTPZS: Record "Contract Norm TPZS";
    begin
        if ContractNormTPZS.Get(Code) then
            exit;

        ContractNormTPZS.Reset();
        ContractNormTPZS.Init();
        ContractNormTPZS.Validate(Code, Code);
        ContractNormTPZS.Validate(Description, Description);
        ContractNormTPZS.Insert(true);
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

    procedure CreateContractUnitOfMeasure(ContractHeaderTPZS: Record "Contract Header TPZS"; UOMCode: Code[10])
    var
        ContractUOMTPZS: Record "Contract UOM TPZS";
    begin
        ContractUOMTPZS.Init();
        ContractUOMTPZS.Validate("Contract No.", ContractHeaderTPZS."No.");
        ContractUOMTPZS.Validate(Code, UOMCode);
        ContractUOMTPZS.Validate("Qty. per Unit of Measure", 1);
        ContractUOMTPZS.Insert(true);
    end;

    procedure CreateContractLine(ContractHeaderTPZS: Record "Contract Header TPZS"; var ContractLineTPZS: Record "Contract Line TPZS"; ObjectNo: Code[20]; ItemNo: Code[20]; Quantity: Integer; ManuallyChanged: Boolean; UnitPrice: Decimal; StartingDate: Date; EndingDate: Date)
    var
        LineNoContractLineTPZS: Record "Contract Line TPZS";
        LineNo: Integer;
    begin
        LineNoContractLineTPZS.SetRange("Contract No.", ContractHeaderTPZS."No.");
        if LineNoContractLineTPZS.FindLast() then
            LineNo := LineNoContractLineTPZS."Line No.";
        LineNo += 10000;

        ContractLineTPZS.Init();
        ContractLineTPZS.Validate("Contract No.", ContractHeaderTPZS."No.");
        ContractLineTPZS.Validate("Line No.", LineNo);
        //ContractLineTPZS.Validate(Description, 'Contract Line: ' + Format(LineNo));

        if ObjectNo <> '' then begin
            ContractLineTPZS.Validate("Object No.", ObjectNo);
            ContractLineTPZS.TestField("Price Item No.");
        end else
            ContractLineTPZS.Validate("Price Item No.", ItemNo);

        if ContractLineTPZS."Object No." = '' then
            ContractLineTPZS.Validate(Quantity, Quantity);

        if ManuallyChanged then begin
            ContractLineTPZS.Validate("Unit Price", UnitPrice);
            ContractLineTPZS.Validate("Price Manually Changed", true);
        end;

        ContractLineTPZS.Validate("Starting Date", StartingDate);
        ContractLineTPZS.Validate("Ending Date", EndingDate);
        ContractLineTPZS.Insert(true);
    end;

    // procedure Send(var ContractHeaderTPZS: Record "Contract Header TPZS")
    // var
    //     ContrArchiveHeaderTPZS: Record "Contr. Archive Header TPZS";
    //     TempSalesHeader: Record "Sales Header" temporary;
    //     ShipContractsHelperTPZS: Codeunit "Ship Contracts Helper TPZS";
    //     PostingDate: Date;
    // begin
    //     PostingDate := 20220401D;

    //     //ShipContractsHelperTPZS.InitProgressWindow();

    //     ContrArchiveHeaderTPZS.Get(ContractHeaderTPZS."No.", ContractHeaderTPZS.GetLastVersionNo());
    //     ShipContractsHelperTPZS.CreateContractSalesLines(ContrArchiveHeaderTPZS, PostingDate, TempSalesHeader);
    //     ShipContractsHelperTPZS.ShipSalesOrders(TempSalesHeader);

    //     //ShipContractsHelperTPZS.CloseProgressWindow();
    // end;

    procedure ReindexContract(ContractHeaderTPZS: Record "Contract Header TPZS"; IndexDate: Date)
    var
        ContractIndexingMethTPZS: Codeunit "Contract Indexing Meth TPZS";
    begin
        ContractIndexingMethTPZS.IndexContract(ContractHeaderTPZS, IndexDate);
        ContractHeaderTPZS."Last Index Date" := IndexDate;
        ContractHeaderTPZS.Modify(false);
    end;

    procedure AddContractTemplateService(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; ItemCategoryCode: Code[20])
    var
        ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS";
    begin
        AddContractTemplateService(ContrTemplateServiceTPZS, ContrTemplateHeaderTPZS, ItemCategoryCode);
    end;

    procedure AddContractTemplateService(var ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS"; ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; ItemCategoryCode: Code[20])
    begin
        ContrTemplateServiceTPZS.Init();
        ContrTemplateServiceTPZS.Validate("Contract Template No.", ContrTemplateHeaderTPZS."No.");
        ContrTemplateServiceTPZS.Validate("Item Category Code", ItemCategoryCode);
        ContrTemplateServiceTPZS.Insert(true);
    end;

    procedure AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; ItemCategoryCode: Code[20])
    var
        ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS";
    begin
        AddContractTemplateService(ContrTemplateServiceTPZS, ContrTemplateHeaderTPZS, ItemCategoryCode);
        AddContractTemplateCoverage(ContrTemplateServiceTPZS, Enum::"Contract Coverage Type TPZS"::AllItems, '', 10);
    end;

    procedure CreateContractTemplateServiceWithCoverageItem(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; ItemCategoryCode: Code[20]; ItemNo: Code[20]; Discount: Decimal)
    var
        ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS";
    begin
        AddContractTemplateService(ContrTemplateServiceTPZS, ContrTemplateHeaderTPZS, ItemCategoryCode);
        AddContractTemplateCoverage(ContrTemplateServiceTPZS, Enum::"Contract Coverage Type TPZS"::Item, ItemNo, Discount);
    end;

    procedure AddContractTemplateCoverageItem(ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS"; ItemNo: Code[20]; Discount: Decimal)
    begin
        AddContractTemplateCoverage(ContrTemplateServiceTPZS, Enum::"Contract Coverage Type TPZS"::Item, ItemNo, Discount);
    end;

    procedure CreateContractTemplateCoverageAllItems(ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS"; Discount: Decimal)
    begin
        AddContractTemplateCoverage(ContrTemplateServiceTPZS, Enum::"Contract Coverage Type TPZS"::AllItems, '', Discount);
    end;

    procedure CreateContractTemplateCoverageResource(ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS"; ResourceNo: Code[20]; Discount: Decimal)
    begin
        AddContractTemplateCoverage(ContrTemplateServiceTPZS, Enum::"Contract Coverage Type TPZS"::Resource, ResourceNo, Discount);
    end;

    procedure AddContractTemplateCoverage(ContrTemplateServiceTPZS: Record "Contr. Template Service TPZS"; CoverageType: Enum "Contract Coverage Type TPZS"; CoverageNo: Code[20]; Discount: Decimal)
    var
        ContrTemplateCoverageTPZS: Record "Contr. Template Coverage TPZS";
    begin
        ContrTemplateCoverageTPZS.Init();
        ContrTemplateCoverageTPZS.Validate("Contract Template No.", ContrTemplateServiceTPZS."Contract Template No.");
        ContrTemplateCoverageTPZS.Validate("Item Category Code", ContrTemplateServiceTPZS."Item Category Code");
        ContrTemplateCoverageTPZS.Validate(Type, CoverageType);
        ContrTemplateCoverageTPZS.Validate("No.", CoverageNo);
        ContrTemplateCoverageTPZS.Validate("Discount %", Discount);
        ContrTemplateCoverageTPZS.Insert(true);
    end;

    procedure ApplyContractTemplateOnExistingContract(var ContractHeaderTPZS: Record "Contract Header TPZS"; ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS")
    var
        ContractHeaderHelperTPZS: Codeunit "Contract Header Helper TPZS";
    begin
        ContractHeaderHelperTPZS.ApplyContractTemplate(ContractHeaderTPZS, ContrTemplateHeaderTPZS);
    end;

    procedure CreateContractFromTemplate(var ContractHeaderTPZS: Record "Contract Header TPZS"; ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS")
    begin
        ContrTemplateHeaderTPZS.TestField("No.");
        ContractHeaderTPZS.CreateContractFromTemplate(ContrTemplateHeaderTPZS."No.");
    end;

    procedure SendContract(var ContractHeaderTPZS: Record "Contract Header TPZS"; PostingDate: Date)
    var
        ContrArchiveHeaderTPZS: Record "Contr. Archive Header TPZS";
        LastContrArchiveHeaderTPZS: Record "Contr. Archive Header TPZS";
        ContractSetupTPZS: Record "Contract Setup TPZS";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempSalesHeader: Record "Sales Header" temporary;
        ShipContractsHelperTPZS: Codeunit "Ship Contracts Helper TPZS";
    begin
        SalesReceivablesSetup.Get();
        ContractSetupTPZS.Get();

        ShipContractsHelperTPZS.InitProgressWindow();
        ContrArchiveHeaderTPZS.Get(ContractHeaderTPZS."No.", ContractHeaderTPZS.GetLastVersionNo());
        ShipContractsHelperTPZS.CreateContractSalesLines(ContrArchiveHeaderTPZS, LastContrArchiveHeaderTPZS, PostingDate, SalesReceivablesSetup, ContractSetupTPZS, TempSalesHeader, not GuiAllowed);
        ShipContractsHelperTPZS.ShipSalesOrders(TempSalesHeader, not GuiAllowed);
        ShipContractsHelperTPZS.CloseProgressWindow();
    end;

    procedure RemoveContractLines(ContractNo: Code[20])
    var
        ContractLineTPZS: Record "Contract Line TPZS";
        RemoveContrLinesMethTPZS: Codeunit "Remove Contr. Lines Meth TPZS";
    begin
        ContractLineTPZS.Reset();
        ContractLineTPZS.SetRange("Contract No.", ContractNo);
        if ContractLineTPZS.FindSet() then
            repeat
                RemoveContrLinesMethTPZS.RemoveContractLines(ContractLineTPZS);
            until ContractLineTPZS.Next() = 0;
        RemoveContrLinesMethTPZS.ReleaseContracts();
    end;
}