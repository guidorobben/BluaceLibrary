codeunit 83966 "Init. Skills NL LIB"
{
    Permissions =
        tabledata "Geo. Skill Code NBLC" = R,
        tabledata "Geo. Skill Post Code NBLC" = RD;

    var
        LibrarySkillNL: Codeunit "Library - Skill NL LIB";

    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        DeleteSkillPostCodes();
        AddAllGeographicSkills();
        CreateSkillPostCodes();
    end;

    procedure AddAllGeographicSkills()
    var
        GeoSkillCodeNBLC: Record "Geo. Skill Code NBLC";
    begin
        GeoSkillCodeNBLC.AddAllGeographicSkills();
    end;

    procedure DeleteSkillPostCodes()
    var
        GeoSkillPostCode: Record "Geo. Skill Post Code NBLC";
    begin
        GeoSkillPostCode.DeleteAll(false);
    end;

    procedure CreateSkillPostCodes()
    begin
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('DR', '1000AA', '1099ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('DR', '1100AA', '1199ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('FL', '1200AA', '1299ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('FL', '1300AA', '1399ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('FR', '1400AA', '1499ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('FR', '1500AA', '1599ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('GR', '1600AA', '1699ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('GR', '1700AA', '1799ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('LB', '1800AA', '1899ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('LB', '1900AA', '1999ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('NB', '2000AA', '2099ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('NB', '2100AA', '2199ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('NH', '3000AA', '3099ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('NH', '3100AA', '3199ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('OV', '2200AA', '2299ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('OV', '2300AA', '2399ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('UT', '2400AA', '2499ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('UT', '2500AA', '2599ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('ZH', '2600AA', '2699ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('ZH', '2700AA', '2799ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('ZL', '2800AA', '2899ZZ');
        LibrarySkillNL.AddPostCodeRangeToGeographicSkill('ZL', '2900AA', '2999ZZ');
    end;
}