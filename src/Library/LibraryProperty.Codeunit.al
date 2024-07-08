codeunit 83987 "Library - Property LIB"
{
    procedure PropertyExist(TableId: Integer; PropertyCode: Code[20]): Boolean
    var
        PropertyLineHelperRBLC: Codeunit "Property Line Helper RBLC";
    begin
        exit(PropertyLineHelperRBLC.PropertyExist(TableId, PropertyCode));
    end;

    procedure CreateProperty(TableId: Integer; PropertyCode: Code[20]; Description: Text[100]; PropertyType: Enum "Property Type RBLC"; AllowFreeValues: Boolean)
    var
        PropertyRBLC: Record "Property RBLC";
    begin
        PropertyRBLC.Init();
        PropertyRBLC.Validate("Table ID", TableId);
        PropertyRBLC.Validate(Code, PropertyCode);
        PropertyRBLC.Validate(Description, Description);
        PropertyRBLC.Validate(Type, PropertyType);
        PropertyRBLC.Validate("Allow Free Values", AllowFreeValues);

        PropertyRBLC.TestField("Table ID");
        PropertyRBLC.TestField(Code);

        if PropertyRBLC.Insert(true) then;
    end;

    procedure CreatePropertyValue(TableId: Integer; PropertyCode: Code[20]; PropertyValue: Text[2048])
    var
        PropertyValueRBLC: Record "Property Value RBLC";
        NewLineNo: Integer;
    begin
        PropertyValueRBLC.SetLoadFields("Line No.");
        PropertyValueRBLC.SetRange("Table ID", TableId);
        PropertyValueRBLC.SetRange("Property Code", PropertyCode);
        if PropertyValueRBLC.FindLast() then
            NewLineNo := PropertyValueRBLC."Line No.";
        NewLineNo += 10000;

        PropertyValueRBLC.Init();
        PropertyValueRBLC.Validate("Table ID", TableId);
        PropertyValueRBLC.Validate("Property Code", PropertyCode);
        PropertyValueRBLC.Validate("Line No.", NewLineNo);
        PropertyValueRBLC.StoreValue(PropertyValue);
        PropertyValueRBLC.Insert(true);
    end;

    procedure HasPropertyValue(TableId: Integer; PropertyCode: Code[20]; PropertyValue: Text[2048]): Boolean
    var
        PropertyValueRBLC: Record "Property Value RBLC";
    begin
        PropertyValueRBLC.SetRange("Table ID", TableId);
        PropertyValueRBLC.SetRange("Property Code", PropertyCode);
        PropertyValueRBLC.SetRange("Text Value", PropertyValue); //TODO niet voor alles nu
        exit(not PropertyValueRBLC.IsEmpty());
    end;

    procedure CreatePropertyMapping(TableID: Integer; PropertyTableID: Integer)
    var
        PropertyMappingRBLC: Record "Property Mapping RBLC";
    begin
        PropertyMappingRBLC.Init();
        PropertyMappingRBLC.Validate("Table ID", TableID);
        PropertyMappingRBLC.Validate("Property Table ID", PropertyTableID);
        PropertyMappingRBLC.Insert(true);
    end;

    procedure HasPropertyMapping(TableID: Integer; PropertyTableID: Integer): Boolean
    var
        PropertyMappingRBLC: Record "Property Mapping RBLC";
    begin
        PropertyMappingRBLC.SetRange("Table ID", TableID);
        PropertyMappingRBLC.SetRange("Property Table ID", PropertyTableID);
        exit(not PropertyMappingRBLC.IsEmpty);
    end;

    //TODO MOgen weg
    procedure AddObjectPropertyValue(ObjectTPZS: Record "Object TPZS"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
    // PropertyLineRBLC: Record "Property Line RBLC";
    begin
        if PropertyCode = '' then
            exit;

        AddPropertyValue(ObjectTPZS.SystemId, ObjectTPZS.RecordId.TableNo, PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    //TODO MOgen weg
    procedure AddObjectTemplatePropertyValue(ObjectTemplateTPZS: Record "Object Template TPZS"; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
    // PropertyLineRBLC: Record "Property Line RBLC";
    begin
        if PropertyCode = '' then
            exit;

        AddPropertyValue(ObjectTemplateTPZS.SystemId, ObjectTemplateTPZS.RecordId.TableNo, PropertyCode, PropertyStartingDate, PropertyEndingDate, PropertyValue);
    end;

    procedure AddPropertyValue(SourceSystemID: Guid; TableID: Integer; PropertyCode: Code[20]; PropertyStartingDate: Date; PropertyEndingDate: Date; PropertyValue: Text[2048])
    var
        PropertyLineRBLC: Record "Property Line RBLC";
    begin
        if PropertyCode = '' then
            exit;

        PropertyLineRBLC.Init();
        PropertyLineRBLC.Validate("Table ID", TableID);
        PropertyLineRBLC.Validate("Source System ID", SourceSystemID);
        PropertyLineRBLC.Validate("Property Code", PropertyCode);
        PropertyLineRBLC.Validate("Starting Date", PropertyStartingDate);
        PropertyLineRBLC.Validate("Ending Date", PropertyEndingDate);
        PropertyLineRBLC.ValidatePropertyValue(PropertyValue);
        PropertyLineRBLC.Insert(true)
    end;

    procedure PropertyLineExist(SourceVariant: Variant; PropertyCode: Code[20]): Boolean
    var
        PropertyLineRBLC: Record "Property Line RBLC";
    begin
        exit(PropertyLineExist(PropertyLineRBLC, SourceVariant, PropertyCode));
    end;

    procedure PropertyLineExist(var PropertyLineRBLC: Record "Property Line RBLC"; SourceVariant: Variant; PropertyCode: Code[20]): Boolean
    begin
        exit(PropertyLineExist(PropertyLineRBLC, SourceVariant, PropertyCode, Today()));
    end;

    procedure PropertyLineExist(var PropertyLineRBLC: Record "Property Line RBLC"; SourceVariant: Variant; PropertyCode: Code[20]; ValidOnDate: Date): Boolean
    begin
        PropertyLineRBLC.FilterPropertyLine(SourceVariant, true, ValidOnDate);
        PropertyLineRBLC.SetRange("Property Code", PropertyCode);
        if PropertyLineRBLC.FindFirst() then
            exit(true);
    end;

    procedure DeletePropertyLines(SourceVariant: Variant; PropertyCode: Code[20]): Boolean
    var
        PropertyLineRBLC: Record "Property Line RBLC";
    begin
        PropertyLineRBLC.FilterPropertyLine(SourceVariant, true, 0D);
        if PropertyCode <> '' then
            PropertyLineRBLC.SetRange("Property Code", PropertyCode);
        PropertyLineRBLC.DeleteAll(true);
    end;
}