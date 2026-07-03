codeunit 83987 "Library - Property LIB"
{
    Permissions =
        tabledata "Object Template CBLC" = R,
        tabledata "Object CBLC" = R,
        tabledata "Property Line BBLC" = RID,
        tabledata "Property Mapping BBLC" = RI,
        tabledata "Property BBLC" = RI,
        tabledata "Property Value BBLC" = RI;

    procedure PropertyExist(TableId: Integer; PropertyCode: Code[20]): Boolean
    var
        PropertyLineHelperBBLC: Codeunit "Property Line Helper BBLC";
    begin
        exit(PropertyLineHelperBBLC.PropertyExist(TableId, PropertyCode));
    end;

    procedure CreateProperty(TableId: Integer; PropertyCode: Code[20]; Description: Text[100]; PropertyType: Enum "Property Type BBLC"; AllowFreeValues: Boolean)
    var
        PropertyBBLC: Record "Property BBLC";
    begin
        PropertyBBLC.Init();
        PropertyBBLC.Validate("Table ID", TableId);
        PropertyBBLC.Validate(Code, PropertyCode);
        PropertyBBLC.Validate(Description, Description);
        PropertyBBLC.Validate(Type, PropertyType);
        PropertyBBLC.Validate("Allow Free Values", AllowFreeValues);

        PropertyBBLC.TestField("Table ID");
        PropertyBBLC.TestField(Code);

        if PropertyBBLC.Insert(true) then; //Easy
    end;

    procedure CreatePropertyValue(TableId: Integer; PropertyCode: Code[20]; PropertyValue: Text[2048])
    var
        PropertyValueBBLC: Record "Property Value BBLC";
        NewLineNo: Integer;
    begin
        PropertyValueBBLC.SetRange("Table ID", TableId);
        PropertyValueBBLC.SetRange("Property Code", PropertyCode);
        if PropertyValueBBLC.FindLast() then
            NewLineNo := PropertyValueBBLC."Line No.";
        NewLineNo += 10000;

        PropertyValueBBLC.Init();
        PropertyValueBBLC.Validate("Table ID", TableId);
        PropertyValueBBLC.Validate("Property Code", PropertyCode);
        PropertyValueBBLC.Validate("Line No.", NewLineNo);
        PropertyValueBBLC.StoreValue(PropertyValue);
        PropertyValueBBLC.Insert(true);
    end;

    procedure HasPropertyValue(TableId: Integer; PropertyCode: Code[20]; PropertyValue: Text[2048]): Boolean
    var
        PropertyValueBBLC: Record "Property Value BBLC";
    begin
        PropertyValueBBLC.SetRange("Table ID", TableId);
        PropertyValueBBLC.SetRange("Property Code", PropertyCode);
        PropertyValueBBLC.SetRange("Text Value", PropertyValue); //TODO niet voor alles nu
        exit(not PropertyValueBBLC.IsEmpty());
    end;

    procedure CreatePropertyMapping(TableID: Integer; PropertyTableID: Integer)
    var
        PropertyMappingBBLC: Record "Property Mapping BBLC";
    begin
        PropertyMappingBBLC.Init();
        PropertyMappingBBLC.Validate("Table ID", TableID);
        PropertyMappingBBLC.Validate("Property Table ID", PropertyTableID);
        PropertyMappingBBLC.Insert(true);
    end;

    procedure HasPropertyMapping(TableID: Integer; PropertyTableID: Integer): Boolean
    var
        PropertyMappingBBLC: Record "Property Mapping BBLC";
    begin
        PropertyMappingBBLC.SetRange("Table ID", TableID);
        PropertyMappingBBLC.SetRange("Property Table ID", PropertyTableID);
        exit(not PropertyMappingBBLC.IsEmpty());
    end;

    //TODO MOgen weg
    procedure AddObjectPropertyValue(ObjectCBLC: Record "Object CBLC"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
    // PropertyLineBBLC: Record "Property Line BBLC";
    begin
        if PropertyCode = '' then
            exit;

        AddPropertyValue(ObjectCBLC.SystemId, ObjectCBLC.RecordId().TableNo(), PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    //TODO MOgen weg
    procedure AddObjectTemplatePropertyValue(ObjectTemplateCBLC: Record "Object Template CBLC"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
    // PropertyLineBBLC: Record "Property Line BBLC";
    begin
        if PropertyCode = '' then
            exit;

        AddPropertyValue(ObjectTemplateCBLC.SystemId, ObjectTemplateCBLC.RecordId().TableNo(), PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    procedure AddPropertyValue(SourceSystemID: Guid; TableID: Integer; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
        PropertyLineBBLC: Record "Property Line BBLC";
    begin
        if PropertyCode = '' then
            exit;

        PropertyLineBBLC.Init();
        PropertyLineBBLC.Validate("Table ID", TableID);
        PropertyLineBBLC.Validate("Source System ID", SourceSystemID);
        PropertyLineBBLC.Validate("Property Code", PropertyCode);
        PropertyLineBBLC.Validate("Starting Date", PropertyStartingDate);
        PropertyLineBBLC.Validate("Ending Date", PropertyEndingDate);
        PropertyLineBBLC.ValidatePropertyValue(PropertyValue);
        PropertyLineBBLC.Insert(true)
    end;

    procedure PropertyLineExist(SourceVariant: Variant; PropertyCode: Code[20]): Boolean
    var
        PropertyLineBBLC: Record "Property Line BBLC";
    begin
        exit(PropertyLineExist(PropertyLineBBLC, SourceVariant, PropertyCode));
    end;

    procedure PropertyLineExist(var PropertyLineBBLC: Record "Property Line BBLC"; SourceVariant: Variant; PropertyCode: Code[20]): Boolean
    begin
        exit(PropertyLineExist(PropertyLineBBLC, SourceVariant, PropertyCode, Today()));
    end;

    procedure PropertyLineExist(var PropertyLineBBLC: Record "Property Line BBLC"; SourceVariant: Variant; PropertyCode: Code[20]; ValidOnDate: Date): Boolean
    begin
        PropertyLineBBLC.FilterPropertyLine(SourceVariant, true, ValidOnDate);
        PropertyLineBBLC.SetRange("Property Code", PropertyCode);
        if PropertyLineBBLC.FindFirst() then
            exit(true);
    end;

    procedure DeletePropertyLines(SourceVariant: Variant; PropertyCode: Code[20]): Boolean
    var
        PropertyLineBBLC: Record "Property Line BBLC";
    begin
        PropertyLineBBLC.FilterPropertyLine(SourceVariant, true, 0D);
        if PropertyCode <> '' then
            PropertyLineBBLC.SetRange("Property Code", PropertyCode);
        PropertyLineBBLC.DeleteAll(true);
    end;
}