codeunit 83964 "Library - Skill NL LIB"
{
    Permissions =
        tabledata "Geo. Skill Org. Skill YBLC" = RID,
        tabledata "Geo. Skill Post Code YBLC" = RID;

    procedure AddPostCodeRangeToGeographicSkill(SkillCode: Code[10]; PostCodeFrom: Text[6]; PostCodeTo: Text[6])
    var
        GeoSkillPostCodeYBLC: Record "Geo. Skill Post Code YBLC";
    begin
        GeoSkillPostCodeYBLC.Init();
        GeoSkillPostCodeYBLC.Validate("Geographic Skill Code", SkillCode);
        GeoSkillPostCodeYBLC.Validate("Post Code From", PostCodeFrom);
        GeoSkillPostCodeYBLC.Validate("Post Code To", PostCodeTo);
        GeoSkillPostCodeYBLC.Insert(true);
    end;

    procedure DeletePostCodeRangesGeographicSkill(SkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillPostCodeYBLC: Record "Geo. Skill Post Code YBLC";
    begin
        GeoSkillPostCodeYBLC.Reset();
        GeoSkillPostCodeYBLC.SetRange("Geographic Skill Code", SkillCode);
        GeoSkillPostCodeYBLC.DeleteAll(UseTrigger);
    end;

    procedure DeleteAllPostCodeRangesGeographicSkill(UseTrigger: Boolean)
    var
        GeoSkillPostCodeYBLC: Record "Geo. Skill Post Code YBLC";
    begin
        GeoSkillPostCodeYBLC.Reset();
        GeoSkillPostCodeYBLC.DeleteAll(UseTrigger);
    end;

    procedure AddOrganizationSkillToGeographicSkill(GeoSkillCode: Code[10]; OrgSkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillOrgSkillYBLC: Record "Geo. Skill Org. Skill YBLC";
    begin
        GeoSkillOrgSkillYBLC.Init();
        GeoSkillOrgSkillYBLC.Validate("Geographic Skill Code", GeoSkillCode);
        GeoSkillOrgSkillYBLC.Validate("Organization Skill Code", OrgSkillCode);
        GeoSkillOrgSkillYBLC.Insert(UseTrigger);
    end;

    procedure AddOrganizationSkillToGeographicSkill(GeoSkillCode: Code[10]; OrgSkillCode: Code[10])
    begin
        AddOrganizationSkillToGeographicSkill(GeoSkillCode, OrgSkillCode, true);
    end;

    procedure DeleteOrganizationSkillsFromGeographicSkill(SkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillOrgSkillYBLC: Record "Geo. Skill Org. Skill YBLC";
    begin
        GeoSkillOrgSkillYBLC.Reset();
        GeoSkillOrgSkillYBLC.SetRange("Geographic Skill Code", SkillCode);
        GeoSkillOrgSkillYBLC.DeleteAll(UseTrigger);
    end;

    procedure DeleteOrganizationSkillFromGeographicSkill(SkillCode: Code[10]; OrgSkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillOrgSkillYBLC: Record "Geo. Skill Org. Skill YBLC";
    begin
        GeoSkillOrgSkillYBLC.Reset();
        GeoSkillOrgSkillYBLC.SetRange("Geographic Skill Code", SkillCode);
        GeoSkillOrgSkillYBLC.SetRange("Organization Skill Code", OrgSkillCode);
        if GeoSkillOrgSkillYBLC.FindFirst() then
            GeoSkillOrgSkillYBLC.Delete(UseTrigger);
    end;

    procedure DeleteAllGeographicSkillOrganizationSkillS(UseTrigger: Boolean)
    var
        GeoSkillOrgSkillYBLC: Record "Geo. Skill Org. Skill YBLC";
    begin
        GeoSkillOrgSkillYBLC.Reset();
        GeoSkillOrgSkillYBLC.DeleteAll(UseTrigger);
    end;
}
