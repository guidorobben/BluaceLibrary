codeunit 83982 "Library - Skill LIB"
{
    Permissions =
        tabledata "Contr. Template Header TPZS" = r,
        tabledata "Contract Header TPZS" = r,
        tabledata Item = r,
        tabledata "Job Planning Line" = r,
        tabledata "Object Template TPZS" = r,
        tabledata "Object TPZS" = r,
        tabledata Resource = r,
        tabledata "Resource Skill" = rid,
        tabledata "Sales Line" = r,
        tabledata "Skill Code" = rid,
        tabledata "Skill Item Line TPZS" = rd,
        tabledata "Skill Line TPZS" = rd;

    var
        Assert: Codeunit Assert;

    procedure CreateSkill(NewCode: Code[10]; Description: Text[100]; SkillTypeTPZS: Enum "Skill Type TPZS")
    begin
        CreateSkill(NewCode, Description, SkillTypeTPZS, 0);
    end;

    procedure CreateSkill(NewCode: Code[10]; Description: Text[100]; SkillTypeTPZS: Enum "Skill Type TPZS"; Score: Integer)
    var
        SkillCode: Record "Skill Code";
    begin
        if SkillCode.Get(NewCode) then
            exit;

        SkillCode.Init();
        SkillCode.Validate(Code, NewCode);
        SkillCode.Validate(Description, Description);
        SkillCode.Validate("Skill Type TPZS", SkillTypeTPZS);
        SkillCode.Validate("Score TPZS", Score);
        SkillCode.Insert(true);
    end;

    procedure DeleteSkill(Code: Code[10]; UseTrigger: Boolean)
    var
        SkillCode: Record "Skill Code";
    begin
        if SkillCode.Get(Code) then
            if UseTrigger then
                SkillCode.Delete(true)
            else
                SkillCode.Delete(false);
    end;

    procedure AddSkillToResource(Resource: Record Resource; SkillCode: Code[10])
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if SkillCode = '' then
            exit;

        Resource.TestField("No.");
        AddResourceSkill(Resource."No.", ResourceSkill.Type::Resource, SkillCode);
    end;

    procedure AddResourceSkill(No: Code[20]; SkillType: Enum "Resource Skill Type"; SkillCode: Code[10])
    var
        ResourceSkill: Record "Resource Skill";
    begin
        ResourceSkill.Init();
        ResourceSkill.Type := SkillType;
        ResourceSkill.Validate("No.", No);
        ResourceSkill.Validate("Skill Code", SkillCode);
        ResourceSkill.Insert(true);
    end;

    procedure AddSkillToItem(Item: Record Item; SkillCode: Code[10])
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if SkillCode = '' then
            exit;

        Item.TestField("No.");
        AddResourceSkill(Item."No.", ResourceSkill.Type::Item, SkillCode);
    end;

    procedure AddSkillToObject(ObjectTPZS: Record "Object TPZS"; SkillCode: Code[10])
    begin
        AddSkillToObject(ObjectTPZS, '', SkillCode);
    end;

    procedure AddSkillToObject(ObjectTPZS: Record "Object TPZS"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if SkillCode = '' then
            exit;

        ObjectTPZS.TestField("No.");
        SkillItemLineTPZS.AddSkillItemLine(Database::"Object TPZS", ObjectTPZS.SystemId, ItemNo, SkillCode, false);
    end;

    procedure AddSkillToObjectTemplate(ObjectTemplateTPZS: Record "Object Template TPZS"; SkillCode: Code[10])
    begin
        AddSkillToObjectTemplate(ObjectTemplateTPZS, '', SkillCode);
    end;

    procedure AddSkillToObjectTemplate(ObjectTemplateTPZS: Record "Object Template TPZS"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if SkillCode = '' then
            exit;

        ObjectTemplateTPZS.TestField("No.");
        SkillItemLineTPZS.AddSkillItemLine(Database::"Object Template TPZS", ObjectTemplateTPZS.SystemId, ItemNo, SkillCode, false);
    end;

    procedure AddSkillToContractTemplate(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; SkillCode: Code[10])
    begin
        AddSkillToContractTemplate(ContrTemplateHeaderTPZS, '', SkillCode);
    end;

    procedure AddSkillToContractTemplate(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if SkillCode = '' then
            exit;

        ContrTemplateHeaderTPZS.TestField("No.");
        SkillItemLineTPZS.AddSkillItemLine(Database::"Contr. Template Header TPZS", ContrTemplateHeaderTPZS.SystemId, ItemNo, SkillCode, false);
    end;

    procedure AddSkillToContract(ContractHeaderTPZS: Record "Contract Header TPZS"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if SkillCode = '' then
            exit;

        ContractHeaderTPZS.TestField("No.");
        SkillItemLineTPZS.AddSkillItemLine(ContractHeaderTPZS.RecordId().TableNo(), ContractHeaderTPZS.SystemId, ItemNo, SkillCode, false);
    end;

    // procedure AddSkillLine(TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10])
    // var
    //     SkillLineTPZS: Record "Skill Line TPZS";
    //     EmptyGuid: Guid;
    // begin
    //     if TableId = 0 then
    //         exit;

    //     if SourceSystemId = EmptyGuid then
    //         exit;

    //     SkillLineTPZS.Init();
    //     SkillLineTPZS.Validate("Table Id", TableId);
    //     SkillLineTPZS.Validate("Source System Id", SourceSystemId);
    //     SkillLineTPZS.Validate("Skill Code", SkillCode);
    //     SkillLineTPZS.Insert(true);
    // end;

    procedure AddSkillToSalesLine(SalesLine: Record "Sales Line"; SkillCode: Code[10])
    begin
        AddSkillToSalesLine(SalesLine, SkillCode, 0);
    end;

    procedure AddSkillToSalesLine(SalesLine: Record "Sales Line"; SkillCode: Code[10]; NewScore: Integer)
    var
        // SkillLineHelperTPZS: Codeunit "Skill Line Helper TPZS";
        SkillLineTPZS: Record "Skill Line TPZS";
    begin
        if SkillCode = '' then
            exit;

        SkillLineTPZS.AddSkillLine(SalesLine.RecordId(), Database::"Sales Line", SalesLine.SystemId, SkillCode, NewScore, false); //FIXME SkillScore
    end;

    // procedure AddSkillToJobPlanningLine(JobPlanningLine: Record "Job Planning Line"; SkillCode: Code[10])
    // begin
    //     AddSkillToJobPlanningLine(JobPlanningLine, SkillCode);
    // end;

    procedure AddSkillToJobPlanningLine(JobPlanningLine: Record "Job Planning Line"; SkillCode: Code[10])
    var
        SkillLineTPZS: Record "Skill Line TPZS";
    begin
        if SkillCode = '' then
            exit;

        SkillLineTPZS.AddSkillLine(JobPlanningLine.RecordId(), Database::"Job Planning Line", JobPlanningLine.SystemId, SkillCode, 0, false); //FIXME SkillScore
    end;

    procedure SkillLineExist(TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10]): Boolean
    var
        SkillLineHelperTPZS: Codeunit "Skill Line Helper TPZS";
    begin
        exit(SkillLineHelperTPZS.SkillLineExist(TableId, SourceSystemId, SkillCode));
    end;

    procedure GetSkillLine(var SkillLineTPZS: Record "Skill Line TPZS"; TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10]): Boolean
    var
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineTPZS.SetRange("Table Id", TableId);
        SkillLineTPZS.SetRange("Source System Id", SourceSystemId);
        SkillLineTPZS.SetRange("Skill Code", SkillCode);
        if SkillLineTPZS.FindFirst() then
            exit(true);
    end;

    // procedure SkillLineSkillCodeExist(TableId: Integer; SourceSystemId: Guid; SkillType: Enum "Skill Type TPZS") SkillCode: Code[10]
    // var
    //     SkillLineHelper: Codeunit "Skill Line Helper TPZS";
    // begin
    //     exit(SkillLineExist(TableId, SourceSystemId, SkillType));
    // end;

    procedure SkillLineSkillTypeExist(TableId: Integer; SourceSystemId: Guid; SkillType: Enum "Skill Type TPZS") SkillCode: Code[10]
    var
        SkillLineTPZS: Record "Skill Line TPZS";
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineTPZS.SetRange("Table Id", TableId);
        SkillLineTPZS.SetRange("Source System Id", SourceSystemId);
        SkillLineTPZS.SetRange("Skill Type", SkillType);
        if SkillLineTPZS.FindFirst() then
            exit(SkillLineTPZS."Skill Code");
    end;

    procedure DeleteResourceSkills(Type: Enum "Resource Skill Type"; SourceNo: Code[20])
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if SourceNo = '' then
            exit;

        ResourceSkill.SetRange(Type, Type);
        ResourceSkill.SetRange("No.", SourceNo);
        ResourceSkill.DeleteAll(true);
    end;

    procedure DeleteResourceSkills(Type: Enum "Resource Skill Type"; SourceNo: Code[20];
                                             SkillTypeTPZS: Enum "Skill Type TPZS")
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if SourceNo = '' then
            exit;

        ResourceSkill.SetRange(Type, Type);
        ResourceSkill.SetRange("No.", SourceNo);
        ResourceSkill.SetRange("Skill Type TPZS", SkillTypeTPZS);
        ResourceSkill.DeleteAll(true);
    end;

    procedure GetSkillsFromItem(var TempResourceSkill: Record "Resource Skill" temporary; ItemNo: Code[20])
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if ItemNo = '' then
            exit;

        ResourceSkill.SetRange(Type, ResourceSkill.Type::Item);
        ResourceSkill.SetRange("No.", ItemNo);
        if ResourceSkill.FindSet() then
            repeat
                TempResourceSkill.Init();
                TempResourceSkill.Copy(ResourceSkill);
                TempResourceSkill.Insert(false)
            until ResourceSkill.Next() = 0;
    end;

    // procedure GetSkillsFromObject(var TempResourceSkill: Record "Resource Skill" temporary; ObjectNo: Code[20])
    // var
    //     ResourceSkill: Record "Resource Skill";
    // begin
    //     if ObjectNo = '' then
    //         exit;

    //     ResourceSkill.SetRange(Type, ResourceSkill.Type::Object);
    //     ResourceSkill.SetRange("No.", ObjectNo);
    //     if ResourceSkill.FindSet() then
    //         repeat
    //             TempResourceSkill.Init();
    //             TempResourceSkill.Copy(ResourceSkill);
    //             TempResourceSkill.Insert(false)
    //         until ResourceSkill.Next() = 0;
    // end;

    // procedure GetSkillsFromObjectTemplate(var TempResourceSkill: Record "Resource Skill" temporary; ObjectTemplateTPZS: Record "Object Template TPZS")
    // var
    //     ObjectTemplateTPZS: Record "Object Template TPZS";

    // begin
    //     ObjectTemplateTPZS.get
    //     if ObjectTemplateNo = '' then
    //         exit;

    //     SkillItemLine.SetRange("Link-to Table Id", Database::"Object Template TPZS");
    //     SkillItemLine.SetRange("Link-to System Id", ObjectTemplate.SystemId);
    //     if SkillItemLine.FindSet() then
    //         repeat
    //             if not SkillItemLineExist(Database::"Object TPZS", ObjectTPZS.SystemId, SkillItemLine."Item No. (Service)", SkillItemLine."Skill Code") then begin
    //                 ObjectSkillItemLine.Init();
    //                 ObjectSkillItemLine.Validate("Link-to Table Id", Database::"Object TPZS");
    //                 ObjectSkillItemLine.Validate("Link-to System Id", ObjectTPZS.SystemId);
    //                 ObjectSkillItemLine.Validate("Line No.", ObjectSkillItemLine.GetNextLineNo());
    //                 ObjectSkillItemLine.Validate("Skill Code", SkillItemLine."Skill Code");
    //                 ObjectSkillItemLine.Validate("Skill Type", SkillItemLine."Skill Type");
    //                 ObjectSkillItemLine.Insert(true);
    //             end;
    //         until SkillItemLine.Next() = 0;

    // end;

    procedure ResourceSkillExist(Type: Enum "Resource Skill Type"; SourceNo: Code[20];
                                           SkillCode: Code[10]): Boolean
    var
        ResourceSkillHelperTPZS: Codeunit "Resource Skill Helper TPZS";
    begin
        exit(ResourceSkillHelperTPZS.ResourceSkillExist(Type, SourceNo, SkillCode));
    end;

    procedure HasResourceSkills(Type: Enum "Resource Skill Type"; SourceNo: Code[20]): Boolean
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if SourceNo = '' then
            exit;

        ResourceSkill.SetRange(Type, Type);
        ResourceSkill.SetRange("No.", SourceNo);
        exit(not ResourceSkill.IsEmpty());
    end;

    procedure HasSkillLines(TableId: Integer; SourceSystemId: Guid): Boolean
    var
        SkillLineTPZS: Record "Skill Line TPZS";
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineTPZS.SetRange("Table Id", TableId);
        SkillLineTPZS.SetRange("Source System Id", SourceSystemId);
        if not SkillLineTPZS.IsEmpty() then
            exit(true);
    end;

    procedure SkillLineCount(TableId: Integer; SourceSystemId: Guid): Integer
    var
        SkillLineTPZS: Record "Skill Line TPZS";
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineTPZS.SetRange("Table Id", TableId);
        SkillLineTPZS.SetRange("Source System Id", SourceSystemId);
        exit(SkillLineTPZS.Count());
    end;

    procedure DeleteJobPlanningLineSkills(JobPlanningLine: Record "Job Planning Line")
    var
        SkillLineTPZS: Record "Skill Line TPZS";
        EmptyGuid: Guid;
    begin

        if JobPlanningLine.SystemId = EmptyGuid then
            exit;

        SkillLineTPZS.SetRange("Table Id", Database::"Job Planning Line");
        SkillLineTPZS.SetRange("Source System Id", JobPlanningLine.SystemId);
        SkillLineTPZS.DeleteAll(true);
    end;

    procedure DeleteResourceSkills(Resource: Record Resource)
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if Resource."No." = '' then
            exit;

        DeleteResourceSkills(ResourceSkill.Type::Resource, Resource."No.");
    end;

    procedure DeleteItemSkills(Item: Record Item)
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if Item."No." = '' then
            exit;

        DeleteResourceSkills(ResourceSkill.Type::Item, Item."No.");
    end;

    procedure GetObjectTemplateSkillItems(var ObjectTemplateTPZS: Record "Object Template TPZS"; var TempSkillItemLineTPZS: Record "Skill Item Line TPZS" temporary)
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        SkillItemLineTPZS.GetSkillItems(TempSkillItemLineTPZS, ObjectTemplateTPZS.RecordId().TableNo(), ObjectTemplateTPZS.SystemId, '');
    end;

    procedure GetContractTemplateSkillItems(var ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; var TempSkillItemLineTPZS: Record "Skill Item Line TPZS" temporary)
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        SkillItemLineTPZS.GetSkillItems(TempSkillItemLineTPZS, ContrTemplateHeaderTPZS.RecordId().TableNo(), ContrTemplateHeaderTPZS.SystemId, '');
    end;

    procedure DeleteObjectSkills(ObjectTPZS: Record "Object TPZS")
    begin
        if ObjectTPZS."No." = '' then
            exit;

        ObjectTPZS.DeleteSkills();
    end;

    procedure DeleteObjectTemplateSkillItems(ObjectTemplateTPZS: Record "Object Template TPZS")
    begin
        if ObjectTemplateTPZS."No." = '' then
            exit;

        ObjectTemplateTPZS.DeleteSkills();
    end;

    procedure DeleteContractTemplateSkillItems(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS")
    begin
        if ContrTemplateHeaderTPZS."No." = '' then
            exit;

        ContrTemplateHeaderTPZS.DeleteSkills();
    end;


    procedure DeleteSalesLineSkills(SalesLine: Record "Sales Line")
    var
        SkillLineTPZS: Record "Skill Line TPZS";
        EmptyGuid: Guid;
    begin

        if SalesLine.SystemId = EmptyGuid then
            exit;

        SkillLineTPZS.SetRange("Table Id", Database::"Sales Line");
        SkillLineTPZS.SetRange("Source System Id", SalesLine.SystemId);
        SkillLineTPZS.DeleteAll(true);
    end;

    procedure GetSkillsFromSalesLine(var TempSkillLineTPZS: Record "Skill Line TPZS" temporary; SalesLine: Record "Sales Line")
    var
        SkillLineTPZS: Record "Skill Line TPZS";
    begin
        SalesLine.TestField(SystemId);

        SkillLineTPZS.SetRange("Table Id", Database::"Sales Line");
        SkillLineTPZS.SetRange("Source System Id", SalesLine.SystemId);
        if SkillLineTPZS.FindSet() then
            repeat
                TempSkillLineTPZS.Init();
                TempSkillLineTPZS.Copy(SkillLineTPZS);
                TempSkillLineTPZS.Insert(false)
            until SkillLineTPZS.Next() = 0;
    end;

    procedure ResourceSkillCount(FilterResourceSkillType: Enum "Resource Skill Type"; SourceNo: Code[20]): Integer
    var
        ResourceSkill: Record "Resource Skill";
    begin
        ResourceSkill.SetRange(Type, FilterResourceSkillType);
        ResourceSkill.SetRange("No.", SourceNo);
        exit(ResourceSkill.Count());
    end;

    procedure DeleteSkillItems(TableId: Integer; SourceSystemId: Guid)
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if TableId = 0 then
            exit;

        if IsNullGuid(SourceSystemId) then
            exit;

        SkillItemLineTPZS.SetRange("Table Id", TableId);
        SkillItemLineTPZS.SetRange("Source System Id", SourceSystemId);
        SkillItemLineTPZS.DeleteAll(false);
    end;

    procedure HasSkillItemLines(TableId: Integer; SourceSystemId: Guid): Boolean
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if TableId = 0 then
            exit;

        if IsNullGuid(SourceSystemId) then
            exit;

        SkillItemLineTPZS.SetRange("Table Id", TableId);
        SkillItemLineTPZS.SetRange("Source System Id", SourceSystemId);
        exit(not SkillItemLineTPZS.IsEmpty());
    end;

    procedure ContractTemplateSkillCodeExist(var ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; SkillCode: Code[10]): Boolean
    begin
        exit(ContractTemplateSkillCodeExist(ContrTemplateHeaderTPZS, '', SkillCode));
    end;

    procedure ContractTemplateSkillCodeExist(var ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(ContrTemplateHeaderTPZS.RecordId().TableNo(), ContrTemplateHeaderTPZS.SystemId, ItemNo, SkillCode));
    end;

    procedure ContractSkillCodeExist(var ContractHeaderTPZS: Record "Contract Header TPZS"; SkillCode: Code[10]): Boolean
    begin
        exit(ContractSkillCodeExist(ContractHeaderTPZS, '', SkillCode));
    end;

    procedure ContractSkillCodeExist(var ContractHeaderTPZS: Record "Contract Header TPZS"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(ContractHeaderTPZS.RecordId().TableNo(), ContractHeaderTPZS.SystemId, ItemNo, SkillCode));
    end;

    procedure ObjectTemplateSkillCodeExist(var ObjectTemplateTPZS: Record "Object Template TPZS"; SkillCode: Code[10]): Boolean
    begin
        exit(ObjectTemplateSkillCodeExist(ObjectTemplateTPZS, '', SkillCode));
    end;

    procedure ObjectTemplateSkillCodeExist(var ObjectTemplateTPZS: Record "Object Template TPZS"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(ObjectTemplateTPZS.RecordId().TableNo(), ObjectTemplateTPZS.SystemId, ItemNo, SkillCode));
    end;

    procedure ObjectSkillCodeExist(var ObjectTPZS: Record "Object TPZS"; SkillCode: Code[10]): Boolean
    begin
        exit(ObjectSkillCodeExist(ObjectTPZS, '', SkillCode));
    end;

    procedure ObjectSkillCodeExist(var ObjectTPZS: Record "Object TPZS"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(Database::"Object TPZS", ObjectTPZS.SystemId, ItemNo, SkillCode));
    end;

    // procedure SkillItemLineSkillCodeExist(SkillItemLineTPZS: Record "Skill Item Line TPZS"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    // begin
    //     exit(SkillItemLineExist(SkillItemLineTPZS."Link-to Table Id", SkillItemLineTPZS."Link-to System Id", ItemNo, SkillCode));
    // end;

    procedure SkillItemLineExist(TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(TableId, SourceSystemId, '', SkillCode));
    end;

    procedure SkillItemLineExist(TableId: Integer; SourceSystemId: Guid; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    var
        SkillItemLineHelperTPZS: Codeunit "Skill Item Line Helper TPZS";
    begin
        if TableId in [Database::Object] then
            Assert.Fail('You used the wrong table.');

        exit(SkillItemLineHelperTPZS.SkillItemLineExist(TableId, SourceSystemId, ItemNo, SkillCode));
    end;

    procedure AlreadyHasSkillType(ObjectTemplateTPZS: Record "Object Template TPZS"; SkillTypeTPZS: Enum "Skill Type TPZS"): Boolean
    var
        EmptyGuid: Guid;
    begin
        exit(AlreadyHasSkillType(Database::"Object Template TPZS", ObjectTemplateTPZS.SystemId, SkillTypeTPZS, false, EmptyGuid));
    end;

    procedure AlreadyHasSkillType(ContrTemplateHeaderTPZS: Record "Contr. Template Header TPZS"; SkillTypeTPZS: Enum "Skill Type TPZS"): Boolean
    var
        EmptyGuid: Guid;
    begin
        exit(AlreadyHasSkillType(Database::"Contr. Template Header TPZS", ContrTemplateHeaderTPZS.SystemId, SkillTypeTPZS, false, EmptyGuid));
    end;

    local procedure AlreadyHasSkillType(TableId: Integer; SourceSystemId: Guid; SkillType: Enum "Skill Type TPZS"; ShowError: Boolean;
                                                                                               CurrentSystemId: Guid) SkillExist: Boolean
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
        SkillTypeAlreadyExistErr: Label 'A skill type of type %1 ''%2'' is already selected. Only one skill of the type %1 is allowed.', Comment = '%1=Skill Type, %2=Skill Code';
    begin
        if SkillType = SkillType::" " then
            exit;

        if TableId = 0 then
            exit;

        SkillItemLineTPZS.SetFilter(SystemId, '<>%1', CurrentSystemId);
        SkillItemLineTPZS.SetRange("Table Id", TableId);
        SkillItemLineTPZS.SetRange("Source System Id", SourceSystemId);
        SkillItemLineTPZS.SetRange("Skill Type", SkillType);
        if SkillItemLineTPZS.FindFirst() then begin
            SkillExist := true;
            if ShowError then
                Error(SkillTypeAlreadyExistErr, Format(SkillType), SkillItemLineTPZS."Skill Code");
        end;
    end;

    procedure SkillItemLineCount(TableId: Integer; SourceSystemId: Guid): Integer
    var
        SkillItemLineTPZS: Record "Skill Item Line TPZS";
    begin
        if TableId in [0, Database::Object] then
            Assert.Fail('You used the wrong table.');

        SkillItemLineTPZS.SetRange("Table Id", TableId);
        SkillItemLineTPZS.SetRange("Source System Id", SourceSystemId);
        exit(SkillItemLineTPZS.Count());
    end;

    procedure DeleteResourceSkills(Type: Enum "Resource Skill Type"; SourceNo: Code[20];
                                             SkillTypeTPZS: Enum "Skill Type TPZS";
                                             DoNotUpdateSource: Boolean)
    var
        ResourceSkillHelperTPZS: Codeunit "Resource Skill Helper TPZS";
    begin
        ResourceSkillHelperTPZS.DeleteResourceSkills(Type, SourceNo, SkillTypeTPZS, DoNotUpdateSource);
    end;
}
