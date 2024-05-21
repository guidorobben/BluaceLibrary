codeunit 83964 "Library - Skill NL LIB"
{
    procedure AddPostCodeRangeToGeographicSkill(SkillCode: Code[10]; PostCodeFrom: Text[6]; PostCodeTo: Text[6])
    var
        GeoSkillPostCodeNBLC: Record "Geo. Skill Post Code NBLC";
    begin
        GeoSkillPostCodeNBLC.Init();
        GeoSkillPostCodeNBLC.Validate("Geographic Skill Code", SkillCode);
        GeoSkillPostCodeNBLC.Validate("Post Code From", PostCodeFrom);
        GeoSkillPostCodeNBLC.Validate("Post Code To", PostCodeTo);
        GeoSkillPostCodeNBLC.Insert(true);
    end;

    procedure DeletePostCodeRangesGeographicSkill(SkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillPostCodeNBLC: Record "Geo. Skill Post Code NBLC";
    begin
        GeoSkillPostCodeNBLC.Reset();
        GeoSkillPostCodeNBLC.SetRange("Geographic Skill Code", SkillCode);
        GeoSkillPostCodeNBLC.DeleteAll(UseTrigger);
    end;

    procedure DeleteAllPostCodeRangesGeographicSkill(UseTrigger: Boolean)
    var
        GeoSkillPostCodeNBLC: Record "Geo. Skill Post Code NBLC";
    begin
        GeoSkillPostCodeNBLC.Reset();
        GeoSkillPostCodeNBLC.DeleteAll(UseTrigger);
    end;

    procedure AddOrganizationSkillToGeographicSkill(GeoSkillCode: Code[10]; OrgSkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillOrgSkillNBLC: Record "Geo. Skill Org. Skill NBLC";
    begin
        GeoSkillOrgSkillNBLC.Init();
        GeoSkillOrgSkillNBLC.Validate("Geographic Skill Code", GeoSkillCode);
        GeoSkillOrgSkillNBLC.Validate("Organization Skill Code", OrgSkillCode);
        GeoSkillOrgSkillNBLC.Insert(UseTrigger);
    end;

    procedure AddOrganizationSkillToGeographicSkill(GeoSkillCode: Code[10]; OrgSkillCode: Code[10])
    begin
        AddOrganizationSkillToGeographicSkill(GeoSkillCode, OrgSkillCode, true);
    end;

    procedure DeleteOrganizationSkillsFromGeographicSkill(SkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillOrgSkillNBLC: Record "Geo. Skill Org. Skill NBLC";
    begin
        GeoSkillOrgSkillNBLC.Reset();
        GeoSkillOrgSkillNBLC.SetRange("Geographic Skill Code", SkillCode);
        GeoSkillOrgSkillNBLC.DeleteAll(UseTrigger);
    end;

    procedure DeleteOrganizationSkillFromGeographicSkill(SkillCode: Code[10]; OrgSkillCode: Code[10]; UseTrigger: Boolean)
    var
        GeoSkillOrgSkillNBLC: Record "Geo. Skill Org. Skill NBLC";
    begin
        GeoSkillOrgSkillNBLC.Reset();
        GeoSkillOrgSkillNBLC.SetRange("Geographic Skill Code", SkillCode);
        GeoSkillOrgSkillNBLC.SetRange("Organization Skill Code", OrgSkillCode);
        if GeoSkillOrgSkillNBLC.FindFirst() then
            GeoSkillOrgSkillNBLC.Delete(UseTrigger);
    end;

    procedure DeleteAllGeographicSkillOrganizationSkillS(UseTrigger: Boolean)
    var
        GeoSkillOrgSkillNBLC: Record "Geo. Skill Org. Skill NBLC";
    begin
        GeoSkillOrgSkillNBLC.Reset();
        GeoSkillOrgSkillNBLC.DeleteAll(UseTrigger);
    end;
}
