codeunit 83983 "Library - Object LIB"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contr. Template Header TPZS" = R,
        tabledata "Contract Header TPZS" = R,
        tabledata "Contract Line TPZS" = R,
        tabledata "Contract Setup TPZS" = R,
        tabledata Customer = RM,
        tabledata "Item Planning Norm TPZS" = RI,
        tabledata "Item Usage Norm TPZS" = RI,
        tabledata "Job Planning Line" = R,
        tabledata "Job Task Object TPZS" = RI,
        tabledata "Object BOM TPZS" = RIM,
        tabledata "Object Contact TPZS" = RI,
        tabledata "Object Norm TPZS" = RID,
        tabledata "Object Status TPZS" = RI,
        tabledata "Object Template TPZS" = RIM,
        tabledata "Object TPZS" = RIM,
        tabledata "Property Line RBLC" = RI,
        tabledata "Role TPZS" = RI;

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
        ObjectStatusTPZS: Record "Object Status TPZS";
    begin
        if StatusCode = '' then
            exit;

        ObjectStatusTPZS.Init();
        ObjectStatusTPZS.Validate(Code, StatusCode);
        ObjectStatusTPZS.Validate(Description, Description);
        if IsDefault then
            ObjectStatusTPZS.Validate(Default, true);

        if IsBlocked then
            ObjectStatusTPZS.Validate(Blocked, true);

        if IsEnd then
            ObjectStatusTPZS.Validate("End Object Contact/Contract", true);

        if ObjectStatusTPZS.Insert(true) then;
    end;

    procedure CreateObject(var ObjectTPZS: Record "Object TPZS")
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
    begin
        if not ContractSetupTPZS.Get() then
            Clear(ContractSetupTPZS);

        ContractSetupTPZS.TestField("Unit of Measure Code Month");

        ObjectTPZS.Init();
        ObjectTPZS."No." := '';
        ObjectTPZS.Insert(true);
    end;

    procedure CreateObject(var ObjectTPZS: Record "Object TPZS"; CreatePriceItem: Boolean; InstallationDate: Date)
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        PriceItemNo: Code[20];
    begin
        ContractSetupTPZS.Get();
        CreateObject(ObjectTPZS);

        if CreatePriceItem then begin
            ContractSetupTPZS.TestField("Unit of Measure Code Month");
            PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 40, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupTPZS."Unit of Measure Code Month");
            if ContractSetupTPZS."Unit of Measure Code Quarter" <> '' then
                LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupTPZS."Unit of Measure Code Quarter", 3);
            if ContractSetupTPZS."Unit of Measure Code Year" <> '' then
                LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupTPZS."Unit of Measure Code Year", 12);
            ObjectTPZS.Validate("Price Item No.", PriceItemNo);
        end;

        ObjectTPZS.Validate(Description, ObjectTPZS."No.");
        ObjectTPZS.Validate("Installation Date", InstallationDate);
        ObjectTPZS.Validate("Location Description", LibraryRandomLIB.FindLocationRandom());
        ObjectTPZS.Modify(true);
    end;

    procedure CreatePriceItemNo() PriceItemNo: Code[20]
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
    begin
        ContractSetupTPZS.Get();

        ContractSetupTPZS.TestField("Unit of Measure Code Month");
        PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 40, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupTPZS."Unit of Measure Code Month");
        if ContractSetupTPZS."Unit of Measure Code Quarter" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupTPZS."Unit of Measure Code Quarter", 3);
        if ContractSetupTPZS."Unit of Measure Code Year" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupTPZS."Unit of Measure Code Year", 12);
    end;

    procedure CreateObjectWithRandomTemplate(var ObjectTPZS: Record "Object TPZS")
    var
        ObjectTemplateTPZS: Record "Object Template TPZS";
        ObjectTemplateNo: Text;
    begin
        //Get Random Template
        ObjectTemplateNo := LibraryRandomLIB.GetRandomValueByTable(ObjectTemplateTPZS.RecordId.TableNo);
        ObjectTemplateTPZS.Get(ObjectTemplateNo);
        ObjectTemplateTPZS.TestField("No.");

        ObjectTPZS.ApplyObjectTemplate(ObjectTemplateTPZS);
    end;

    procedure CreateObjectWithTemplate(var ObjectTPZS: Record "Object TPZS"; ObjectTemplateTPZS: Record "Object Template TPZS")
    begin
        // if ObjectTemplateTPZS."No." = '' then
        // exit;

        // ObjectTPZS.ApplyObjectTemplate(ObjectTemplateTPZS);
        CreateObjectWithTemplate(ObjectTPZS, ObjectTemplateTPZS, true);
    end;

    procedure CreateObjectWithTemplate(var ObjectTPZS: Record "Object TPZS"; ObjectTemplateTPZS: Record "Object Template TPZS"; CreatePriceItem: Boolean)
    var
        PriceItemNo: Code[20];
    begin
        if ObjectTemplateTPZS."No." = '' then
            exit;

        ObjectTPZS.ApplyObjectTemplate(ObjectTemplateTPZS);

        if CreatePriceItem then begin
            PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
            ObjectTPZS.Validate("Price Item No.", PriceItemNo);
        end;
    end;

    procedure CreatePriceItemNoForObject(var ObjectTPZS: Record "Object TPZS")
    var
        ContractSetupTPZS: Record "Contract Setup TPZS";
        PriceItemNo: Code[20];
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Unit of Measure Code Month");
        PriceItemNo := LibraryItemLIB.CreatePriceItemNo(LibraryRandom.RandDecInRange(10, 50, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupTPZS."Unit of Measure Code Month");
        if ContractSetupTPZS."Unit of Measure Code Quarter" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupTPZS."Unit of Measure Code Quarter", 3);
        if ContractSetupTPZS."Unit of Measure Code Year" <> '' then
            LibraryItemLIB.CreateItemUnitOfMeasure(PriceItemNo, ContractSetupTPZS."Unit of Measure Code Year", 12);
        ObjectTPZS.Validate("Price Item No.", PriceItemNo);
        ObjectTPZS.Modify(true);
    end;

    procedure CreateObjectWithContract(var ObjectTPZS: Record "Object TPZS"; var ObjectTemplateTPZS: Record "Object Template TPZS")
    var
        ContractHeaderTPZS: Record "Contract Header TPZS";
    begin
        CreateObjectWithContract(ObjectTPZS, ObjectTemplateTPZS, ContractHeaderTPZS);
    end;

    procedure CreateObjectWithContract(var ObjectTPZS: Record "Object TPZS"; var ObjectTemplateTPZS: Record "Object Template TPZS"; var ContractHeaderTPZS: Record "Contract Header TPZS")
    var
        Contact: Record Contact;
        ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS";
        ContractLineTPZS: Record "Contract Line TPZS";
        ContractSetupTPZS: Record "Contract Setup TPZS";
        Customer: Record Customer;
        CreateContractObjMethTPZS: Codeunit "Create Contract Obj. Meth TPZS";
    begin
        ContractSetupTPZS.Get();
        ContractSetupTPZS.TestField("Item Category Service");

        if ObjectTemplateTPZS."No." <> '' then
            CreateObjectWithTemplate(ObjectTPZS, ObjectTemplateTPZS)
        else
            CreateObject(ObjectTPZS, true, (Today + 4));

        ObjectTPZS.Modify(true);

        LibraryMarketing.CreatePersonContact(Contact);
        Contact.CreateCustomerFromTemplate('');
        LibrarySalesLIB.GetCustomerFromContact(Customer, Contact);

        Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND');
        Customer.Validate("Customer Posting Group", 'BINNENLAND');
        Customer.Modify(true);

        CreateObjectContact(ObjectTPZS, 'KLANT', CalcDate('<-CY>', Today()), 0D, Contact."No.");

        //Create Contract
        ContrTemplateHeaderTPZS.FindFirst();
        CreateContractObjMethTPZS.CreateContractFromObject(ObjectTPZS, ContrTemplateHeaderTPZS."No.", CalcDate('<-CY>', Today()), true);

        ContractLineTPZS.SetRange("Object No.", ObjectTPZS."No.");
        if ContractLineTPZS.FindFirst() then
            ContractHeaderTPZS.Get(ContractLineTPZS."Contract No.");

        LibraryContractLIB.AddContractService(ContractHeaderTPZS, ContractSetupTPZS."Item Category Service");
    end;

    procedure AddObjectCustomerContact(ObjectTPZS: Record "Object TPZS"; StartingDate: Date)
    var
        Contact: Record Contact;
        Customer: Record Customer;
        RoleTPZS: Record "Role TPZS";
        LibraryObject: Codeunit "Library - Object LIB";
        LibrarySales: Codeunit "Library - Sales LIB";
    begin
        LibraryMarketing.CreatePersonContact(Contact);
        Contact.CreateCustomerFromTemplate('');
        LibrarySales.GetCustomerFromContact(Customer, Contact);

        Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND');
        Customer.Validate("Customer Posting Group", 'BINNENLAND');
        Customer.Modify(true);

        RoleTPZS.SetRange(Customer, true);
        RoleTPZS.FindFirst();

        LibraryObject.CreateObjectContact(ObjectTPZS, RoleTPZS.Code, StartingDate, 0D, Contact."No.");
    end;

    procedure CreateObjectWithContract(var ObjectTPZS: Record "Object TPZS")
    var
        ObjectTemplateTPZS: Record "Object Template TPZS";
    begin
        CreateObjectWithContract(ObjectTPZS, ObjectTemplateTPZS);
    end;

    procedure CreateObjectTemplate(var ObjectTemplateTPZS: Record "Object Template TPZS")
    begin
        //TODO Complete
        ObjectTemplateTPZS.Init();
        ObjectTemplateTPZS.Insert(true);
    end;

    procedure CreateObjectTemplate(var ObjectTemplateTPZS: Record "Object Template TPZS"; Code: Code[20]; Description: Text[100])
    begin
        //TODO Complete
        ObjectTemplateTPZS.Init();
        ObjectTemplateTPZS.Validate("No.", Code);
        ObjectTemplateTPZS.Insert(true);

        ObjectTemplateTPZS.Validate(Description, Description);
        ObjectTemplateTPZS.Modify(true);
    end;

    procedure AddObjectProperty(ObjectTPZS: Record "Object TPZS"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyValue: Text[2048])
    var
        PropertyLineRBLC: Record "Property Line RBLC";
    begin
        if PropertyCode = '' then
            exit;

        PropertyLineRBLC.Init();
        PropertyLineRBLC.Validate("Table ID", ObjectTPZS.RecordId.TableNo);
        PropertyLineRBLC.Validate("Source System ID", ObjectTPZS.SystemId);
        PropertyLineRBLC.Validate("Property Code", PropertyCode);
        PropertyLineRBLC.Validate("Starting Date", PropertyStartingDate);
        PropertyLineRBLC.ValidatePropertyValue(PropertyValue);
        PropertyLineRBLC.Insert(true)
    end;

    procedure CreateObjectContact(ObjectTPZS: Record "Object TPZS"; RolCode: Code[20]; StartingDate: Date; EndingDate: Date; ContactNo: Code[20])
    var
        ObjectContactTPZS: Record "Object Contact TPZS";
    begin
        ObjectTPZS.TestField("No.");

        ObjectContactTPZS.Init();
        ObjectContactTPZS.Validate("Object No.", ObjectTPZS."No.");
        ObjectContactTPZS.Validate("Role Code", RolCode);
        ObjectContactTPZS.Validate("Starting Date", StartingDate);
        ObjectContactTPZS.TestField("Starting Date");
        ObjectContactTPZS.Validate("Ending Date", EndingDate);
        ObjectContactTPZS.Validate("Contact No.", ContactNo);
        ObjectContactTPZS.Insert(true);
    end;

    procedure CreateObjectContactRole(Code: Code[10]; BillToCustomer: Boolean; Communication: Boolean; Customer: Boolean; Location: Boolean; CopyFromMain: Boolean)
    var
        RoleTPZS: Record "Role TPZS";
    begin
        RoleTPZS.Init();
        RoleTPZS.Validate(Code, Code);
        RoleTPZS.TestField(Code);

        RoleTPZS.Validate("Bill-to Customer", BillToCustomer);
        RoleTPZS.Validate(Communication, Communication);
        RoleTPZS.Validate(Customer, Customer);
        RoleTPZS.Validate(Location, Location);
        RoleTPZS.Validate("Copy From Main Object", CopyFromMain);
        if RoleTPZS.Insert(true) then;
    end;

    procedure AddObjectPropertyValue(ObjectTPZS: Record "Object TPZS"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
        // PropertyLineRBLC: Record "Property Line RBLC";
        LibraryProperty: Codeunit "Library - Property LIB";
    begin
        if PropertyCode = '' then
            exit;

        LibraryProperty.AddPropertyValue(ObjectTPZS.SystemId, ObjectTPZS.RecordId.TableNo, PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    procedure AddObjectTemplatePropertyValue(ObjectTemplateTPZS: Record "Object Template TPZS"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
        // PropertyLineRBLC: Record "Property Line RBLC";
        LibraryProperty: Codeunit "Library - Property LIB";
    begin
        if PropertyCode = '' then
            exit;

        LibraryProperty.AddPropertyValue(ObjectTemplateTPZS.SystemId, ObjectTemplateTPZS.RecordId.TableNo, PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    // procedure CreateObjectMaintSchedule(var MaintScheduleTPZS: Record "Maint. Schedule TPZS"; ObjectTPZS: Record "Object TPZS")
    // begin
    //     MaintScheduleTPZS.Init();
    //     MaintScheduleTPZS.Validate("Object No.", ObjectTPZS."No.");
    //     MaintScheduleTPZS.Insert(true);
    // end;

    //TODO To NEW STYLE
    // procedure CreateObjectTemplateMaintScheduleTemplateLine(var MaintSchedTemplTPZS: Record "Maint. Sched. Templ. TPZS"; ObjectTemplateTPZS: Record "Object Template TPZS"; LineNo: Integer; ItemNo: Code[20])
    // begin
    //     MaintSchedTemplTPZS.Init();
    //     MaintSchedTemplTPZS.Validate("Object Template No.", ObjectTemplateTPZS."No.");
    //     MaintSchedTemplTPZS.Validate("Line No.", LineNo);
    //     MaintSchedTemplTPZS.Validate("Item No.", ItemNo);
    //     Evaluate(MaintSchedTemplTPZS.Periodicity, '<+1Y>');
    //     Evaluate(MaintSchedTemplTPZS."Deviation Min. Date", '<-1M>');
    //     Evaluate(MaintSchedTemplTPZS."Deviation Max. Date", '<+1M>');
    //     MaintSchedTemplTPZS.Insert(true);
    // end;

    procedure CreateObjectNorm(Code: Code[20]; Description: Text[100]; DeleteFirst: Boolean)
    var
        ObjectNormTPZS: Record "Object Norm TPZS";
    begin
        if DeleteFirst then
            if ObjectNormTPZS.Get(Code) then
                ObjectNormTPZS.Delete(false);

        ObjectNormTPZS.Reset();
        ObjectNormTPZS.Init();
        ObjectNormTPZS.Validate(Code, Code);
        ObjectNormTPZS.Validate(Description, Description);
        ObjectNormTPZS.Insert(true);
    end;

    procedure CreateItemPlanningNorm(ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormCode: Code[20]; ItemNo: Code[20])
    var
        ItemPlanningNormTPZS: Record "Item Planning Norm TPZS";
    begin
        ItemPlanningNormTPZS.Init();
        ItemPlanningNormTPZS.Validate("Object Norm Type", ObjectNormTypeTPZS);
        ItemPlanningNormTPZS.Validate("Object Norm No.", ObjectNormCode);
        ItemPlanningNormTPZS.Validate("Item No.", ItemNo);
        ItemPlanningNormTPZS.Insert(true);
    end;

    procedure CreateItemUsageNorm(ObjectNormTypeTPZS: Enum "Object Norm Type TPZS"; ObjectNormCode: Code[20];
                                                          ItemNo: Code[20])
    var
        ItemUsageNormTPZS: Record "Item Usage Norm TPZS";
    begin
        ItemUsageNormTPZS.Init();
        ItemUsageNormTPZS.Validate("Object Norm Type", ObjectNormTypeTPZS);
        ItemUsageNormTPZS.Validate("Object Norm No.", ObjectNormCode);
        ItemUsageNormTPZS.Validate("Item No.", ItemNo);
        ItemUsageNormTPZS.Insert(true);
    end;

    procedure AddJobTaskObject(JobPlanningLine: Record "Job Planning Line"; ObjectTPZS: Record "Object TPZS")
    begin
        AddJobTaskObject(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", ObjectTPZS);
    end;

    procedure AddJobTaskObject(JobNo: Code[20]; JobTaskNo: Code[20]; ObjectTPZS: Record "Object TPZS")
    var
        JobTaskObjectTPZS: Record "Job Task Object TPZS";
    begin
        ObjectTPZS.TestField("No.");

        if JobTaskObjectTPZS.Get(JobNo, JobTaskNo, ObjectTPZS."No.") then
            exit;

        JobTaskObjectTPZS.Init();
        JobTaskObjectTPZS.Validate("Job No.", JobNo);
        JobTaskObjectTPZS.Validate("Job Task No.", JobTaskNo);
        JobTaskObjectTPZS.Validate("Object No.", ObjectTPZS."No.");
        JobTaskObjectTPZS.Insert(true);
    end;

    procedure ApplyObjectTemplate(var ObjectTPZS: Record "Object TPZS"; ObjectTemplateTPZS: Record "Object Template TPZS")
    var
        ObjectHelperTPZS: Codeunit "Object Helper TPZS";
    begin
        ObjectHelperTPZS.ApplyObjectTemplate(ObjectTPZS, ObjectTemplateTPZS)
    end;

    procedure CopyObjectTemplate(var ObjectTemplateTPZS: Record "Object Template TPZS"; var NewObjectTemplateTPZS: Record "Object Template TPZS")
    var
        CopyObjectTemplateMethTPZS: Codeunit "Copy Object Template Meth TPZS";
    begin
        CopyObjectTemplateMethTPZS.CopyObjectTemplate(ObjectTemplateTPZS, NewObjectTemplateTPZS, '', true);
    end;

    procedure CreateContractFromObject(ObjectTPZS: Record "Object TPZS"; ContractTemplateNo: Code[20]; ProcessingDate: Date; HideDialog: Boolean)
    var
        CreateContractObjMethTPZS: Codeunit "Create Contract Obj. Meth TPZS";
    begin
        CreateContractObjMethTPZS.CreateContractFromObject(ObjectTPZS, ContractTemplateNo, ProcessingDate, HideDialog);
    end;

    procedure CreateObjectMaintenanceSchedule(var ObjectTPZS: Record "Object TPZS")
    var
        CreateObjectMaintMethTPZS: Codeunit "Create Object Maint. Meth TPZS";
        MaintScheduleCreated: Boolean;
    begin
        CreateObjectMaintMethTPZS.CreateObjectMaintenanceSchedule(ObjectTPZS, MaintScheduleCreated, not GuiAllowed);
    end;

    procedure GetLastObject(var ObjectTPZS: Record "Object TPZS")
    begin
        ObjectTPZS.Reset();
        ObjectTPZS.FindLast();
        ObjectTPZS.TestField("No.");
    end;

    procedure GetLastObjectNo(): Code[20]
    var
        ObjectTPZS: Record "Object TPZS";
    begin
        GetLastObject(ObjectTPZS);
        exit(ObjectTPZS."No.");
    end;

    procedure AddObjectToBOM(ParentObject: Record "Object TPZS"; var ChildObject: Record "Object TPZS")
    var
        ObjectBOM: Record "Object BOM TPZS";
    begin
        ParentObject.TestField("No.");
        ChildObject.TestField("No.");

        if ChildObject."Main Object No." <> '' then
            exit;

        ObjectBOM.Reset();
        ObjectBOM.Init();
        ObjectBOM.Validate("Object No.", ParentObject."No.");
        ObjectBOM.Validate("Line No.", GetNextLineNoObjectBOM(ParentObject."No."));
        ObjectBOM.Insert(true);

        ObjectBOM.Validate(Type, ObjectBOM.Type::Object);
        ObjectBOM.Validate("No.", ChildObject."No.");
        ObjectBOM.Modify(true);

        ChildObject.Validate("Main Object No.", ObjectBOM."Object No.");
        ChildObject.Modify(true);
    end;

    local procedure GetNextLineNoObjectBOM(ObjectNo: Code[20]) LineNo: Integer
    var
        ObjectBOM: Record "Object BOM TPZS";
    begin
        ObjectBOM.Reset();
        ObjectBOM.SetLoadFields("Line No.");
        ObjectBOM.SetRange("Object No.", ObjectNo);
        if ObjectBOM.FindLast() then
            LineNo := ObjectBOM."Line No.";
        LineNo += 10000;
    end;
}