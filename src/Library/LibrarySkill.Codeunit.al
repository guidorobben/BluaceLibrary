codeunit 83982 "Library - Skill LIB"
{
    Permissions =
        tabledata "Contr. Template Header CBLC" = R,
        tabledata "Contract Header CBLC" = R,
        tabledata Item = R,
        tabledata "Job Planning Line" = R,
        tabledata "Object Template CBLC" = R,
        tabledata "Object CBLC" = R,
        tabledata Resource = R,
        tabledata "Resource Skill" = RID,
        tabledata "Sales Line" = R,
        tabledata "Skill Code" = RID,
        tabledata "Skill Item Line CBLC" = RD,
        tabledata "Skill Line CBLC" = RD;

    var
        Assert: Codeunit Assert;

    procedure CreateSkill(NewCode: Code[10]; Description: Text[100]; SkillTypeCBLC: Enum "Skill Type CBLC")
    begin
        CreateSkill(NewCode, Description, SkillTypeCBLC, 0);
    end;

    procedure CreateSkill(NewCode: Code[10]; Description: Text[100]; SkillTypeCBLC: Enum "Skill Type CBLC"; Score: Integer)
    var
        SkillCode: Record "Skill Code";
    begin
        if SkillCode.Get(NewCode) then
            exit;

        SkillCode.Init();
        SkillCode.Validate(Code, NewCode);
        SkillCode.Validate(Description, Description);
        SkillCode.Validate("Skill Type CBLC", SkillTypeCBLC);
        SkillCode.Validate("Score CBLC", Score);
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

    procedure AddSkillToObject(ObjectCBLC: Record "Object CBLC"; SkillCode: Code[10])
    begin
        AddSkillToObject(ObjectCBLC, '', SkillCode);
    end;

    procedure AddSkillToObject(ObjectCBLC: Record "Object CBLC"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if SkillCode = '' then
            exit;

        ObjectCBLC.TestField("No.");
        SkillItemLineCBLC.AddSkillItemLine(Database::"Object CBLC", ObjectCBLC.SystemId, ItemNo, SkillCode, false);
    end;

    procedure AddSkillToObjectTemplate(ObjectTemplateCBLC: Record "Object Template CBLC"; SkillCode: Code[10])
    begin
        AddSkillToObjectTemplate(ObjectTemplateCBLC, '', SkillCode);
    end;

    procedure AddSkillToObjectTemplate(ObjectTemplateCBLC: Record "Object Template CBLC"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if SkillCode = '' then
            exit;

        ObjectTemplateCBLC.TestField("No.");
        SkillItemLineCBLC.AddSkillItemLine(Database::"Object Template CBLC", ObjectTemplateCBLC.SystemId, ItemNo, SkillCode, false);
    end;

    procedure AddSkillToContractTemplate(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; SkillCode: Code[10])
    begin
        AddSkillToContractTemplate(ContrTemplateHeaderCBLC, '', SkillCode);
    end;

    procedure AddSkillToContractTemplate(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if SkillCode = '' then
            exit;

        ContrTemplateHeaderCBLC.TestField("No.");
        SkillItemLineCBLC.AddSkillItemLine(Database::"Contr. Template Header CBLC", ContrTemplateHeaderCBLC.SystemId, ItemNo, SkillCode, false);
    end;

    procedure AddSkillToContract(ContractHeaderCBLC: Record "Contract Header CBLC"; ItemNo: Code[20]; SkillCode: Code[10])
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if SkillCode = '' then
            exit;

        ContractHeaderCBLC.TestField("No.");
        SkillItemLineCBLC.AddSkillItemLine(ContractHeaderCBLC.RecordId().TableNo(), ContractHeaderCBLC.SystemId, ItemNo, SkillCode, false);
    end;

    // procedure AddSkillLine(TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10])
    // var
    //     SkillLineCBLC: Record "Skill Line CBLC";
    //     EmptyGuid: Guid;
    // begin
    //     if TableId = 0 then
    //         exit;

    //     if SourceSystemId = EmptyGuid then
    //         exit;

    //     SkillLineCBLC.Init();
    //     SkillLineCBLC.Validate("Table Id", TableId);
    //     SkillLineCBLC.Validate("Source System Id", SourceSystemId);
    //     SkillLineCBLC.Validate("Skill Code", SkillCode);
    //     SkillLineCBLC.Insert(true);
    // end;

    procedure AddSkillToSalesLine(SalesLine: Record "Sales Line"; SkillCode: Code[10])
    begin
        AddSkillToSalesLine(SalesLine, SkillCode, 0);
    end;

    procedure AddSkillToSalesLine(SalesLine: Record "Sales Line"; SkillCode: Code[10]; NewScore: Integer)
    var
        // SkillLineHelperCBLC: Codeunit "Skill Line Helper CBLC";
        SkillLineCBLC: Record "Skill Line CBLC";
    begin
        if SkillCode = '' then
            exit;

        SkillLineCBLC.AddSkillLine(SalesLine.RecordId(), Database::"Sales Line", SalesLine.SystemId, SkillCode, NewScore, false); //FIXME SkillScore
    end;

    // procedure AddSkillToJobPlanningLine(JobPlanningLine: Record "Job Planning Line"; SkillCode: Code[10])
    // begin
    //     AddSkillToJobPlanningLine(JobPlanningLine, SkillCode);
    // end;

    procedure AddSkillToJobPlanningLine(JobPlanningLine: Record "Job Planning Line"; SkillCode: Code[10])
    var
        SkillLineCBLC: Record "Skill Line CBLC";
    begin
        if SkillCode = '' then
            exit;

        SkillLineCBLC.AddSkillLine(JobPlanningLine.RecordId(), Database::"Job Planning Line", JobPlanningLine.SystemId, SkillCode, 0, false); //FIXME SkillScore
    end;

    procedure SkillLineExist(TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10]): Boolean
    var
        SkillLineHelperCBLC: Codeunit "Skill Line Helper CBLC";
    begin
        exit(SkillLineHelperCBLC.SkillLineExist(TableId, SourceSystemId, SkillCode));
    end;

    procedure GetSkillLine(var SkillLineCBLC: Record "Skill Line CBLC"; TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10]): Boolean
    var
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineCBLC.SetRange("Table Id", TableId);
        SkillLineCBLC.SetRange("Source System Id", SourceSystemId);
        SkillLineCBLC.SetRange("Skill Code", SkillCode);
        if SkillLineCBLC.FindFirst() then
            exit(true);
    end;

    // procedure SkillLineSkillCodeExist(TableId: Integer; SourceSystemId: Guid; SkillType: Enum "Skill Type CBLC") SkillCode: Code[10]
    // var
    //     SkillLineHelper: Codeunit "Skill Line Helper CBLC";
    // begin
    //     exit(SkillLineExist(TableId, SourceSystemId, SkillType));
    // end;

    procedure SkillLineSkillTypeExist(TableId: Integer; SourceSystemId: Guid; SkillType: Enum "Skill Type CBLC") SkillCode: Code[10]
    var
        SkillLineCBLC: Record "Skill Line CBLC";
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineCBLC.SetRange("Table Id", TableId);
        SkillLineCBLC.SetRange("Source System Id", SourceSystemId);
        SkillLineCBLC.SetRange("Skill Type", SkillType);
        if SkillLineCBLC.FindFirst() then
            exit(SkillLineCBLC."Skill Code");
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

    procedure DeleteResourceSkills(Type: Enum "Resource Skill Type"; SourceNo: Code[20]; SkillTypeCBLC: Enum "Skill Type CBLC")
    var
        ResourceSkill: Record "Resource Skill";
    begin
        if SourceNo = '' then
            exit;

        ResourceSkill.SetRange(Type, Type);
        ResourceSkill.SetRange("No.", SourceNo);
        ResourceSkill.SetRange("Skill Type CBLC", SkillTypeCBLC);
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

    // procedure GetSkillsFromObjectTemplate(var TempResourceSkill: Record "Resource Skill" temporary; ObjectTemplateCBLC: Record "Object Template CBLC")
    // var
    //     ObjectTemplateCBLC: Record "Object Template CBLC";

    // begin
    //     ObjectTemplateCBLC.get
    //     if ObjectTemplateNo = '' then
    //         exit;

    //     SkillItemLine.SetRange("Link-to Table Id", Database::"Object Template CBLC");
    //     SkillItemLine.SetRange("Link-to System Id", ObjectTemplate.SystemId);
    //     if SkillItemLine.FindSet() then
    //         repeat
    //             if not SkillItemLineExist(Database::"Object CBLC", ObjectCBLC.SystemId, SkillItemLine."Item No. (Service)", SkillItemLine."Skill Code") then begin
    //                 ObjectSkillItemLine.Init();
    //                 ObjectSkillItemLine.Validate("Link-to Table Id", Database::"Object CBLC");
    //                 ObjectSkillItemLine.Validate("Link-to System Id", ObjectCBLC.SystemId);
    //                 ObjectSkillItemLine.Validate("Line No.", ObjectSkillItemLine.GetNextLineNo());
    //                 ObjectSkillItemLine.Validate("Skill Code", SkillItemLine."Skill Code");
    //                 ObjectSkillItemLine.Validate("Skill Type", SkillItemLine."Skill Type");
    //                 ObjectSkillItemLine.Insert(true);
    //             end;
    //         until SkillItemLine.Next() = 0;

    // end;

    procedure ResourceSkillExist(Type: Enum "Resource Skill Type"; SourceNo: Code[20]; SkillCode: Code[10]): Boolean
    var
        ResourceSkillHelperCBLC: Codeunit "Resource Skill Helper CBLC";
    begin
        exit(ResourceSkillHelperCBLC.ResourceSkillExist(Type, SourceNo, SkillCode));
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
        SkillLineCBLC: Record "Skill Line CBLC";
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineCBLC.SetRange("Table Id", TableId);
        SkillLineCBLC.SetRange("Source System Id", SourceSystemId);
        if not SkillLineCBLC.IsEmpty() then
            exit(true);
    end;

    procedure SkillLineCount(TableId: Integer; SourceSystemId: Guid): Integer
    var
        SkillLineCBLC: Record "Skill Line CBLC";
        EmptyGuid: Guid;
    begin
        if TableId = 0 then
            exit;

        if SourceSystemId = EmptyGuid then
            exit;

        SkillLineCBLC.SetRange("Table Id", TableId);
        SkillLineCBLC.SetRange("Source System Id", SourceSystemId);
        exit(SkillLineCBLC.Count());
    end;

    procedure DeleteJobPlanningLineSkills(JobPlanningLine: Record "Job Planning Line")
    var
        SkillLineCBLC: Record "Skill Line CBLC";
        EmptyGuid: Guid;
    begin

        if JobPlanningLine.SystemId = EmptyGuid then
            exit;

        SkillLineCBLC.SetRange("Table Id", Database::"Job Planning Line");
        SkillLineCBLC.SetRange("Source System Id", JobPlanningLine.SystemId);
        SkillLineCBLC.DeleteAll(true);
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

    procedure GetObjectTemplateSkillItems(var ObjectTemplateCBLC: Record "Object Template CBLC"; var TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary)
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        SkillItemLineCBLC.GetSkillItems(TempSkillItemLineCBLC, ObjectTemplateCBLC.RecordId().TableNo(), ObjectTemplateCBLC.SystemId, '');
    end;

    procedure GetContractTemplateSkillItems(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; var TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary)
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        SkillItemLineCBLC.GetSkillItems(TempSkillItemLineCBLC, ContrTemplateHeaderCBLC.RecordId().TableNo(), ContrTemplateHeaderCBLC.SystemId, '');
    end;

    procedure DeleteObjectSkills(ObjectCBLC: Record "Object CBLC")
    begin
        if ObjectCBLC."No." = '' then
            exit;

        ObjectCBLC.DeleteSkills();
    end;

    procedure DeleteObjectTemplateSkillItems(ObjectTemplateCBLC: Record "Object Template CBLC")
    begin
        if ObjectTemplateCBLC."No." = '' then
            exit;

        ObjectTemplateCBLC.DeleteSkills();
    end;

    procedure DeleteContractTemplateSkillItems(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC")
    begin
        if ContrTemplateHeaderCBLC."No." = '' then
            exit;

        ContrTemplateHeaderCBLC.DeleteSkills();
    end;


    procedure DeleteSalesLineSkills(SalesLine: Record "Sales Line")
    var
        SkillLineCBLC: Record "Skill Line CBLC";
        EmptyGuid: Guid;
    begin

        if SalesLine.SystemId = EmptyGuid then
            exit;

        SkillLineCBLC.SetRange("Table Id", Database::"Sales Line");
        SkillLineCBLC.SetRange("Source System Id", SalesLine.SystemId);
        SkillLineCBLC.DeleteAll(true);
    end;

    procedure GetSkillsFromSalesLine(var TempSkillLineCBLC: Record "Skill Line CBLC" temporary; SalesLine: Record "Sales Line")
    var
        SkillLineCBLC: Record "Skill Line CBLC";
    begin
        SalesLine.TestField(SystemId);

        SkillLineCBLC.SetRange("Table Id", Database::"Sales Line");
        SkillLineCBLC.SetRange("Source System Id", SalesLine.SystemId);
        if SkillLineCBLC.FindSet() then
            repeat
                TempSkillLineCBLC.Init();
                TempSkillLineCBLC.Copy(SkillLineCBLC);
                TempSkillLineCBLC.Insert(false)
            until SkillLineCBLC.Next() = 0;
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
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if TableId = 0 then
            exit;

        if IsNullGuid(SourceSystemId) then
            exit;

        SkillItemLineCBLC.SetRange("Table Id", TableId);
        SkillItemLineCBLC.SetRange("Source System Id", SourceSystemId);
        SkillItemLineCBLC.DeleteAll(false);
    end;

    procedure HasSkillItemLines(TableId: Integer; SourceSystemId: Guid): Boolean
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if TableId = 0 then
            exit;

        if IsNullGuid(SourceSystemId) then
            exit;

        SkillItemLineCBLC.SetRange("Table Id", TableId);
        SkillItemLineCBLC.SetRange("Source System Id", SourceSystemId);
        exit(not SkillItemLineCBLC.IsEmpty());
    end;

    procedure ContractTemplateSkillCodeExist(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; SkillCode: Code[10]): Boolean
    begin
        exit(ContractTemplateSkillCodeExist(ContrTemplateHeaderCBLC, '', SkillCode));
    end;

    procedure ContractTemplateSkillCodeExist(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(ContrTemplateHeaderCBLC.RecordId().TableNo(), ContrTemplateHeaderCBLC.SystemId, ItemNo, SkillCode));
    end;

    procedure ContractSkillCodeExist(var ContractHeaderCBLC: Record "Contract Header CBLC"; SkillCode: Code[10]): Boolean
    begin
        exit(ContractSkillCodeExist(ContractHeaderCBLC, '', SkillCode));
    end;

    procedure ContractSkillCodeExist(var ContractHeaderCBLC: Record "Contract Header CBLC"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(ContractHeaderCBLC.RecordId().TableNo(), ContractHeaderCBLC.SystemId, ItemNo, SkillCode));
    end;

    procedure ObjectTemplateSkillCodeExist(var ObjectTemplateCBLC: Record "Object Template CBLC"; SkillCode: Code[10]): Boolean
    begin
        exit(ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, '', SkillCode));
    end;

    procedure ObjectTemplateSkillCodeExist(var ObjectTemplateCBLC: Record "Object Template CBLC"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(ObjectTemplateCBLC.RecordId().TableNo(), ObjectTemplateCBLC.SystemId, ItemNo, SkillCode));
    end;

    procedure ObjectSkillCodeExist(var ObjectCBLC: Record "Object CBLC"; SkillCode: Code[10]): Boolean
    begin
        exit(ObjectSkillCodeExist(ObjectCBLC, '', SkillCode));
    end;

    procedure ObjectSkillCodeExist(var ObjectCBLC: Record "Object CBLC"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(Database::"Object CBLC", ObjectCBLC.SystemId, ItemNo, SkillCode));
    end;

    // procedure SkillItemLineSkillCodeExist(SkillItemLineCBLC: Record "Skill Item Line CBLC"; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    // begin
    //     exit(SkillItemLineExist(SkillItemLineCBLC."Link-to Table Id", SkillItemLineCBLC."Link-to System Id", ItemNo, SkillCode));
    // end;

    procedure SkillItemLineExist(TableId: Integer; SourceSystemId: Guid; SkillCode: Code[10]): Boolean
    begin
        exit(SkillItemLineExist(TableId, SourceSystemId, '', SkillCode));
    end;

    procedure SkillItemLineExist(TableId: Integer; SourceSystemId: Guid; ItemNo: Code[20]; SkillCode: Code[10]): Boolean
    var
        SkillItemLineHelperCBLC: Codeunit "Skill Item Line Helper CBLC";
    begin
        if TableId in [Database::Object] then
            Assert.Fail('You used the wrong table.');

        exit(SkillItemLineHelperCBLC.SkillItemLineExist(TableId, SourceSystemId, ItemNo, SkillCode));
    end;

    procedure AlreadyHasSkillType(ObjectTemplateCBLC: Record "Object Template CBLC"; SkillTypeCBLC: Enum "Skill Type CBLC"): Boolean
    var
        EmptyGuid: Guid;
    begin
        exit(AlreadyHasSkillType(Database::"Object Template CBLC", ObjectTemplateCBLC.SystemId, SkillTypeCBLC, false, EmptyGuid));
    end;

    procedure AlreadyHasSkillType(ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC"; SkillTypeCBLC: Enum "Skill Type CBLC"): Boolean
    var
        EmptyGuid: Guid;
    begin
        exit(AlreadyHasSkillType(Database::"Contr. Template Header CBLC", ContrTemplateHeaderCBLC.SystemId, SkillTypeCBLC, false, EmptyGuid));
    end;

    local procedure AlreadyHasSkillType(TableId: Integer; SourceSystemId: Guid; SkillType: Enum "Skill Type CBLC"; ShowError: Boolean; CurrentSystemId: Guid) SkillExist: Boolean
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
        SkillTypeAlreadyExistErr: Label 'A skill type of type %1 ''%2'' is already selected. Only one skill of the type %1 is allowed.', Comment = '%1=Skill Type, %2=Skill Code';
    begin
        if SkillType = SkillType::" " then
            exit;

        if TableId = 0 then
            exit;

        SkillItemLineCBLC.SetFilter(SystemId, '<>%1', CurrentSystemId);
        SkillItemLineCBLC.SetRange("Table Id", TableId);
        SkillItemLineCBLC.SetRange("Source System Id", SourceSystemId);
        SkillItemLineCBLC.SetRange("Skill Type", SkillType);
        if SkillItemLineCBLC.FindFirst() then begin
            SkillExist := true;
            if ShowError then
                Error(SkillTypeAlreadyExistErr, Format(SkillType), SkillItemLineCBLC."Skill Code");
        end;
    end;

    procedure SkillItemLineCount(TableId: Integer; SourceSystemId: Guid): Integer
    var
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
    begin
        if TableId in [0, Database::Object] then
            Assert.Fail('You used the wrong table.');

        SkillItemLineCBLC.SetRange("Table Id", TableId);
        SkillItemLineCBLC.SetRange("Source System Id", SourceSystemId);
        exit(SkillItemLineCBLC.Count());
    end;

    procedure DeleteResourceSkills(Type: Enum "Resource Skill Type"; SourceNo: Code[20]; SkillTypeCBLC: Enum "Skill Type CBLC"; DoNotUpdateSource: Boolean)
    var
        ResourceSkillHelperCBLC: Codeunit "Resource Skill Helper CBLC";
    begin
        ResourceSkillHelperCBLC.DeleteResourceSkills(Type, SourceNo, SkillTypeCBLC, DoNotUpdateSource);
    end;
}
