codeunit 83983 "Library - Object LIB"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contr. Template Header CBLC" = R,
        tabledata "Contract Header CBLC" = R,
        tabledata "Contract Line CBLC" = R,
        tabledata "Contract Setup CBLC" = R,
        tabledata Customer = RM,
        tabledata "Item Planning Norm CBLC" = RI,
        tabledata "Item Usage Norm CBLC" = RI,
        tabledata "Job Planning Line" = R,
        tabledata "Job Task Object CBLC" = RI,
        tabledata "Object BOM CBLC" = RIM,
        tabledata "Object Contact CBLC" = RI,
        tabledata "Object Norm CBLC" = RID,
        tabledata "Object Status CBLC" = RI,
        tabledata "Object Template CBLC" = RIM,
        tabledata "Object CBLC" = RIM,
        tabledata "Property Line BBLC" = RI,
        tabledata "Role CBLC" = RI;

    var
        LibraryContractLIB: Codeunit "Library - Contract LIB";
        // LibraryInventory: Codeunit "Library - Inventory";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        LibraryMarketing: Codeunit "Library - Marketing";
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";

    procedure CreateObjectStatus(StatusCode: Code[20]; Description: Text[100]; IsDefault: Boolean; IsBlocked: Boolean; IsEnd: Boolean)
    var
        ObjectStatusCBLC: Record "Object Status CBLC";
    begin
        if StatusCode = '' then
            exit;

        ObjectStatusCBLC.Init();
        ObjectStatusCBLC.Validate(Code, StatusCode);
        ObjectStatusCBLC.Validate(Description, Description);
        if IsDefault then
            ObjectStatusCBLC.Validate(Default, true);

        if IsBlocked then
            ObjectStatusCBLC.Validate(Blocked, true);

        if IsEnd then
            ObjectStatusCBLC.Validate("End Object Contact/Contract", true);

        if ObjectStatusCBLC.Insert(true) then; //Easy
    end;

    procedure CreateObject(var ObjectCBLC: Record "Object CBLC")
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
    begin
        if not ContractSetupCBLC.Get() then
            Clear(ContractSetupCBLC);

        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        ObjectCBLC.Init();
        ObjectCBLC."No." := '';
        ObjectCBLC.Insert(true);
    end;

    procedure CreateObject(var ObjectCBLC: Record "Object CBLC"; CreatePriceItem: Boolean; InstallationDate: Date)
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        PriceItemNo: Code[20];
    begin
        ContractSetupCBLC.Get();
        CreateObject(ObjectCBLC);

        if CreatePriceItem then begin
            ContractSetupCBLC.TestField("Unit of Measure Code Month");
            PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 40, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month");
            if ContractSetupCBLC."Unit of Measure Code Quarter" <> '' then
                LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupCBLC."Unit of Measure Code Quarter", 3);
            if ContractSetupCBLC."Unit of Measure Code Year" <> '' then
                LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupCBLC."Unit of Measure Code Year", 12);
            ObjectCBLC.Validate("Price Item No.", PriceItemNo);
        end;

        ObjectCBLC.Validate(Description, ObjectCBLC."No.");
        ObjectCBLC.Validate("Installation Date", InstallationDate);
        ObjectCBLC.Validate("Location Description", LibraryRandomLIB.FindLocationRandom());
        ObjectCBLC.Modify(true);
    end;

    procedure CreatePriceItemNo() PriceItemNo: Code[20]
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
    begin
        ContractSetupCBLC.Get();

        ContractSetupCBLC.TestField("Unit of Measure Code Month");
        PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 40, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month");
        if ContractSetupCBLC."Unit of Measure Code Quarter" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupCBLC."Unit of Measure Code Quarter", 3);
        if ContractSetupCBLC."Unit of Measure Code Year" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupCBLC."Unit of Measure Code Year", 12);
    end;

    procedure CreateObjectWithRandomTemplate(var ObjectCBLC: Record "Object CBLC")
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectTemplateNo: Code[20];
    begin
        //Get Random Template
        ObjectTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(ObjectTemplateCBLC.RecordId().TableNo());
        ObjectTemplateCBLC.Get(ObjectTemplateNo);
        ObjectTemplateCBLC.TestField("No.");

        ObjectCBLC.ApplyObjectTemplate(ObjectTemplateCBLC);
    end;

    procedure CreateObjectWithTemplate(var ObjectCBLC: Record "Object CBLC"; ObjectTemplateCBLC: Record "Object Template CBLC")
    begin
        // if ObjectTemplateCBLC."No." = '' then
        // exit;

        // ObjectCBLC.ApplyObjectTemplate(ObjectTemplateCBLC);
        CreateObjectWithTemplate(ObjectCBLC, ObjectTemplateCBLC, true);
    end;

    procedure CreateObjectWithTemplate(var ObjectCBLC: Record "Object CBLC"; ObjectTemplateCBLC: Record "Object Template CBLC"; CreatePriceItem: Boolean)
    var
        PriceItemNo: Code[20];
    begin
        if ObjectTemplateCBLC."No." = '' then
            exit;

        ObjectCBLC.ApplyObjectTemplate(ObjectTemplateCBLC);

        if CreatePriceItem then begin
            PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
            ObjectCBLC.Validate("Price Item No.", PriceItemNo);
        end;
    end;

    procedure CreatePriceItemNoForObject(var ObjectCBLC: Record "Object CBLC")
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        PriceItemNo: Code[20];
    begin
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");
        PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 50, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month");
        if ContractSetupCBLC."Unit of Measure Code Quarter" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupCBLC."Unit of Measure Code Quarter", 3);
        if ContractSetupCBLC."Unit of Measure Code Year" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupCBLC."Unit of Measure Code Year", 12);
        ObjectCBLC.Validate("Price Item No.", PriceItemNo);
        ObjectCBLC.Modify(true);
    end;

    procedure CreateObjectWithContract(var ObjectCBLC: Record "Object CBLC"; var ObjectTemplateCBLC: Record "Object Template CBLC")
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
    begin
        CreateObjectWithContract(ObjectCBLC, ObjectTemplateCBLC, ContractHeaderCBLC);
    end;

    procedure CreateObjectWithContract(var ObjectCBLC: Record "Object CBLC"; var ObjectTemplateCBLC: Record "Object Template CBLC"; var ContractHeaderCBLC: Record "Contract Header CBLC")
    var
        Contact: Record Contact;
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Customer: Record Customer;
        CreateContractObjMethCBLC: Codeunit "Create Contract Obj. Meth CBLC";
    begin
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Item Category Service");

        if ObjectTemplateCBLC."No." <> '' then
            CreateObjectWithTemplate(ObjectCBLC, ObjectTemplateCBLC)
        else
            CreateObject(ObjectCBLC, true, (Today() + 4));

        ObjectCBLC.Modify(true);

        LibraryMarketing.CreatePersonContact(Contact);
        Contact.CreateCustomerFromTemplate('');
        LibrarySalesLIB.GetCustomerFromContact(Customer, Contact);

        Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND');
        Customer.Validate("Customer Posting Group", 'BINNENLAND');
        Customer.Modify(true);

        CreateObjectContact(ObjectCBLC, 'KLANT', CalcDate('<-CY>', Today()), 0D, Contact."No.");

        //Create Contract
        ContrTemplateHeaderCBLC.FindFirst();
        CreateContractObjMethCBLC.CreateContractFromObject(ObjectCBLC, ContrTemplateHeaderCBLC."No.", CalcDate('<-CY>', Today()), true);

        ContractLineCBLC.SetRange("Object No.", ObjectCBLC."No.");
        if ContractLineCBLC.FindFirst() then
            ContractHeaderCBLC.Get(ContractLineCBLC."Contract No.");

        LibraryContractLIB.AddContractService(ContractHeaderCBLC, ContractSetupCBLC."Item Category Service");
    end;

    procedure AddObjectCustomerContact(ObjectCBLC: Record "Object CBLC"; StartingDate: Date)
    var
        Contact: Record Contact;
        Customer: Record Customer;
        RoleCBLC: Record "Role CBLC";
        LibraryObject: Codeunit "Library - Object LIB";
        LibrarySales: Codeunit "Library - Sales LIB";
    begin
        LibraryMarketing.CreatePersonContact(Contact);
        Contact.CreateCustomerFromTemplate('');
        LibrarySales.GetCustomerFromContact(Customer, Contact);

        Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND');
        Customer.Validate("Customer Posting Group", 'BINNENLAND');
        Customer.Modify(true);

        RoleCBLC.SetRange(Customer, true);
        RoleCBLC.FindFirst();

        LibraryObject.CreateObjectContact(ObjectCBLC, RoleCBLC.Code, StartingDate, 0D, Contact."No.");
    end;

    procedure CreateObjectWithContract(var ObjectCBLC: Record "Object CBLC")
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
    begin
        CreateObjectWithContract(ObjectCBLC, ObjectTemplateCBLC);
    end;

    procedure CreateObjectTemplate(var ObjectTemplateCBLC: Record "Object Template CBLC")
    begin
        //TODO Complete
        ObjectTemplateCBLC.Init();
        ObjectTemplateCBLC.Insert(true);
    end;

    procedure CreateObjectTemplate(var ObjectTemplateCBLC: Record "Object Template CBLC"; Code: Code[20]; Description: Text[100])
    begin
        //TODO Complete
        ObjectTemplateCBLC.Init();
        ObjectTemplateCBLC.Validate("No.", Code);
        ObjectTemplateCBLC.Insert(true);

        ObjectTemplateCBLC.Validate(Description, Description);
        ObjectTemplateCBLC.Modify(true);
    end;

    procedure AddObjectProperty(ObjectCBLC: Record "Object CBLC"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyValue: Text[2048])
    var
        PropertyLineBBLC: Record "Property Line BBLC";
    begin
        if PropertyCode = '' then
            exit;

        PropertyLineBBLC.Init();
        PropertyLineBBLC.Validate("Table ID", ObjectCBLC.RecordId().TableNo());
        PropertyLineBBLC.Validate("Source System ID", ObjectCBLC.SystemId);
        PropertyLineBBLC.Validate("Property Code", PropertyCode);
        PropertyLineBBLC.Validate("Starting Date", PropertyStartingDate);
        PropertyLineBBLC.ValidatePropertyValue(PropertyValue);
        PropertyLineBBLC.Insert(true)
    end;

    procedure CreateObjectContact(ObjectCBLC: Record "Object CBLC"; RolCode: Code[10]; StartingDate: Date; EndingDate: Date; ContactNo: Code[20])
    var
        ObjectContactCBLC: Record "Object Contact CBLC";
    begin
        ObjectCBLC.TestField("No.");

        ObjectContactCBLC.Init();
        ObjectContactCBLC.Validate("Object No.", ObjectCBLC."No.");
        ObjectContactCBLC.Validate("Role Code", RolCode);
        ObjectContactCBLC.Validate("Starting Date", StartingDate);
        ObjectContactCBLC.TestField("Starting Date");
        ObjectContactCBLC.Validate("Ending Date", EndingDate);
        ObjectContactCBLC.Validate("Contact No.", ContactNo);
        ObjectContactCBLC.Insert(true);
    end;

    procedure CreateObjectContactRole(Code: Code[10]; Description: Text[100]; BillToCustomer: Boolean; Communication: Boolean; Customer: Boolean; Location: Boolean; CopyFromMain: Boolean)
    var
        RoleCBLC: Record "Role CBLC";
    begin
        if RoleCBLC.Get(Code) then
            exit;

        RoleCBLC.Reset();
        RoleCBLC.Init();
        RoleCBLC.Validate(Code, Code);
        RoleCBLC.Validate(Description, Description);
        RoleCBLC.TestField(Code);

        RoleCBLC.Validate("Bill-to Customer", BillToCustomer);
        RoleCBLC.Validate(Communication, Communication);
        RoleCBLC.Validate(Customer, Customer);
        RoleCBLC.Validate(Location, Location);
        RoleCBLC.Validate("Copy From Main Object", CopyFromMain);
        RoleCBLC.Insert(true);
    end;

    procedure AddObjectPropertyValue(ObjectCBLC: Record "Object CBLC"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
        // PropertyLineBBLC: Record "Property Line BBLC";
        LibraryProperty: Codeunit "Library - Property LIB";
    begin
        if PropertyCode = '' then
            exit;

        LibraryProperty.AddPropertyValue(ObjectCBLC.SystemId, ObjectCBLC.RecordId().TableNo(), PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    procedure AddObjectTemplatePropertyValue(ObjectTemplateCBLC: Record "Object Template CBLC"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
        // PropertyLineBBLC: Record "Property Line BBLC";
        LibraryProperty: Codeunit "Library - Property LIB";
    begin
        if PropertyCode = '' then
            exit;

        LibraryProperty.AddPropertyValue(ObjectTemplateCBLC.SystemId, ObjectTemplateCBLC.RecordId().TableNo(), PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    // procedure CreateObjectMaintSchedule(var MaintScheduleCBLC: Record "Maint. Schedule CBLC"; ObjectCBLC: Record "Object CBLC")
    // begin
    //     MaintScheduleCBLC.Init();
    //     MaintScheduleCBLC.Validate("Object No.", ObjectCBLC."No.");
    //     MaintScheduleCBLC.Insert(true);
    // end;

    //TODO To NEW STYLE
    // procedure CreateObjectTemplateMaintScheduleTemplateLine(var MaintSchedTemplCBLC: Record "Maint. Sched. Templ. CBLC"; ObjectTemplateCBLC: Record "Object Template CBLC"; LineNo: Integer; ItemNo: Code[20])
    // begin
    //     MaintSchedTemplCBLC.Init();
    //     MaintSchedTemplCBLC.Validate("Object Template No.", ObjectTemplateCBLC."No.");
    //     MaintSchedTemplCBLC.Validate("Line No.", LineNo);
    //     MaintSchedTemplCBLC.Validate("Item No.", ItemNo);
    //     Evaluate(MaintSchedTemplCBLC.Periodicity, '<+1Y>');
    //     Evaluate(MaintSchedTemplCBLC."Deviation Min. Date", '<-1M>');
    //     Evaluate(MaintSchedTemplCBLC."Deviation Max. Date", '<+1M>');
    //     MaintSchedTemplCBLC.Insert(true);
    // end;

    procedure CreateObjectNormCode(Code: Code[20]; Description: Text[100])
    var
        ObjectNormCBLC: Record "Object Norm CBLC";
    begin
        if ObjectNormCBLC.Get(Code) then
            exit;

        ObjectNormCBLC.Reset();
        ObjectNormCBLC.Init();
        ObjectNormCBLC.Validate(Code, Code);
        ObjectNormCBLC.Validate(Description, Description);
        ObjectNormCBLC.Insert(true);
    end;

    procedure CreateItemPlanningNorm(ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormCode: Code[20]; ItemNo: Code[20])
    var
        ItemPlanningNormCBLC: Record "Item Planning Norm CBLC";
    begin
        ItemPlanningNormCBLC.Init();
        ItemPlanningNormCBLC.Validate("Object Norm Type", ObjectNormTypeCBLC);
        ItemPlanningNormCBLC.Validate("Object Norm No.", ObjectNormCode);
        ItemPlanningNormCBLC.Validate("Item No.", ItemNo);
        ItemPlanningNormCBLC.Insert(true);
    end;

    procedure CreateItemUsageNorm(ObjectNormTypeCBLC: Enum "Object Norm Type CBLC"; ObjectNormCode: Code[20]; ItemNo: Code[20])
    var
        ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
    begin
        ItemUsageNormCBLC.Init();
        ItemUsageNormCBLC.Validate("Object Norm Type", ObjectNormTypeCBLC);
        ItemUsageNormCBLC.Validate("Object Norm No.", ObjectNormCode);
        ItemUsageNormCBLC.Validate("Item No.", ItemNo);
        ItemUsageNormCBLC.Insert(true);
    end;

    procedure AddJobTaskObject(JobPlanningLine: Record "Job Planning Line"; ObjectCBLC: Record "Object CBLC")
    begin
        AddJobTaskObject(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", ObjectCBLC);
    end;

    procedure AddJobTaskObject(JobNo: Code[20]; JobTaskNo: Code[20]; ObjectCBLC: Record "Object CBLC")
    var
        JobTaskObjectCBLC: Record "Job Task Object CBLC";
    begin
        ObjectCBLC.TestField("No.");

        if JobTaskObjectCBLC.Get(JobNo, JobTaskNo, ObjectCBLC."No.") then
            exit;

        JobTaskObjectCBLC.Init();
        JobTaskObjectCBLC.Validate("Job No.", JobNo);
        JobTaskObjectCBLC.Validate("Job Task No.", JobTaskNo);
        JobTaskObjectCBLC.Validate("Object No.", ObjectCBLC."No.");
        JobTaskObjectCBLC.Insert(true);
    end;

    procedure ApplyObjectTemplate(var ObjectCBLC: Record "Object CBLC"; ObjectTemplateCBLC: Record "Object Template CBLC")
    var
        ObjectHelperCBLC: Codeunit "Object Helper CBLC";
    begin
        ObjectHelperCBLC.ApplyObjectTemplate(ObjectCBLC, ObjectTemplateCBLC)
    end;

    procedure CopyObjectTemplate(var ObjectTemplateCBLC: Record "Object Template CBLC"; var NewObjectTemplateCBLC: Record "Object Template CBLC")
    var
        CopyObjectTemplateMethCBLC: Codeunit "Copy Object Template Meth CBLC";
    begin
        CopyObjectTemplateMethCBLC.CopyObjectTemplate(ObjectTemplateCBLC, NewObjectTemplateCBLC, '', true);
    end;

    procedure CreateContractFromObject(ObjectCBLC: Record "Object CBLC"; ContractTemplateNo: Code[20]; ProcessingDate: Date; HideDialog: Boolean)
    var
        CreateContractObjMethCBLC: Codeunit "Create Contract Obj. Meth CBLC";
    begin
        CreateContractObjMethCBLC.CreateContractFromObject(ObjectCBLC, ContractTemplateNo, ProcessingDate, HideDialog);
    end;

    procedure CreateObjectMaintenanceSchedule(var ObjectCBLC: Record "Object CBLC")
    var
        CreateObjectMaintMethCBLC: Codeunit "Create Object Maint. Meth CBLC";
        MaintScheduleCreated, MaintScheduleUpdated : Boolean;
        ValidOnDate: Date;
    begin
        ValidOnDate := Today();
        CreateObjectMaintMethCBLC.CreateObjectMaintenanceSchedule(ObjectCBLC, MaintScheduleCreated, MaintScheduleUpdated, ValidOnDate, not GuiAllowed());
    end;

    procedure GetLastObject(var ObjectCBLC: Record "Object CBLC")
    begin
        ObjectCBLC.Reset();
        ObjectCBLC.FindLast();
        ObjectCBLC.TestField("No.");
    end;

    procedure GetLastObjectNo(): Code[20]
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        GetLastObject(ObjectCBLC);
        exit(ObjectCBLC."No.");
    end;

    procedure AddObjectToBOM(ParentObjectCBLC: Record "Object CBLC"; var ChildObjectCBLC: Record "Object CBLC")
    var
        ObjectBOMCBLC: Record "Object BOM CBLC";
    begin
        ParentObjectCBLC.TestField("No.");
        ChildObjectCBLC.TestField("No.");

        if ChildObjectCBLC."Main Object No." <> '' then
            exit;

        ObjectBOMCBLC.Reset();
        ObjectBOMCBLC.Init();
        ObjectBOMCBLC.Validate("Object No.", ParentObjectCBLC."No.");
        ObjectBOMCBLC.Validate("Line No.", GetNextLineNoObjectBOM(ParentObjectCBLC."No."));
        ObjectBOMCBLC.Insert(true);

        ObjectBOMCBLC.Validate(Type, ObjectBOMCBLC.Type::Object);
        ObjectBOMCBLC.Validate("No.", ChildObjectCBLC."No.");
        ObjectBOMCBLC.Modify(true);

        ChildObjectCBLC.Validate("Main Object No.", ObjectBOMCBLC."Object No.");
        ChildObjectCBLC.Modify(true);
    end;

    local procedure GetNextLineNoObjectBOM(ObjectNo: Code[20]) LineNo: Integer
    var
        ObjectBOMCBLC: Record "Object BOM CBLC";
    begin
        ObjectBOMCBLC.Reset();
        ObjectBOMCBLC.SetLoadFields("Line No.");
        ObjectBOMCBLC.SetRange("Object No.", ObjectNo);
        if ObjectBOMCBLC.FindLast() then
            LineNo := ObjectBOMCBLC."Line No.";
        LineNo += 10000;
    end;

    procedure DeleteProperties(ObjectCBLC: Record "Object CBLC")
    begin
        ObjectCBLC.DeleteProperties();
    end;

    procedure CreateFixedAsset(var ObjectCBLC: Record "Object CBLC"; HideDialog: Boolean)
    begin
        ObjectCBLC.CreateFixedAsset(HideDialog);
    end;

    procedure CreateSalesOrderLine(var ObjectCBLC: Record "Object CBLC"; ValidOnDate: Date)
    begin
        ObjectCBLC.CreateSalesOrderLine(ValidOnDate);
    end;

    procedure GetNextObjectMaintenanceSchedule(ObjectCBLC: Record "Object CBLC"; var NextObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC")
    begin
        ObjectCBLC.GetNextObjectMaintenanceSchedule(NextObjectMaintScheduleCBLC);
    end;

    procedure DeleteObjectMaintenanceSchedules(ObjectCBLC: Record "Object CBLC"; StartingDate: Date)
    begin
        ObjectCBLC.DeleteObjectMaintenanceSchedules(StartingDate);
    end;

    procedure GetActiveContractArchiveLine(ObjectCBLC: Record "Object CBLC"; var ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC"; ValidOnDate: Date): Boolean
    begin
        exit(ObjectCBLC.GetActiveContractArchiveLine(ContrArchiveLineCBLC, ValidOnDate));
    end;
}