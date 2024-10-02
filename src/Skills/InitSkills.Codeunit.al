codeunit 83952 "Init. Skills LIB"
{
    Permissions = tabledata "Skill Code" = RD;

    var
        LibrarySkill: Codeunit "Library - Skill LIB";
        SkillType: Enum "Skill Type TPZS";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init. All LIB", OnInitialize, '', false, false)]
    local procedure OnInitialize()
    begin
        Initialize();
    end;

    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        DeleteSkills();
        // DeleteSkillPostCodes();

        CreateDefaultSkills();
        // AddAllGeographicSkills();
        // CreateSkillPostCodes();
    end;

    procedure DeleteSkills()
    var
        SkillCode: Record "Skill Code";
    begin
        SkillCode.DeleteAll(false);
    end;

    procedure CreateDefaultSkills()
    begin
        CreateSkillsEmpty();
        CreateSkillsGeoprahpy();
        CreateSkillsManual();
        CreateSkillsOrganization();
    end;

    procedure CreateSkillsOrganization()
    begin
        LibrarySkill.CreateSkill('BC', 'Business Central (ORG)', SkillType::Organization, 100);
        LibrarySkill.CreateSkill('NAV', 'Navision (ORG)', SkillType::Organization, 110);
        LibrarySkill.CreateSkill('DOTNET', 'DotNet (ORG)', SkillType::Organization, 120);
        LibrarySkill.CreateSkill('DELPHI', 'Delphi (ORG)', SkillType::Organization, 130);
        LibrarySkill.CreateSkill('CPLUSPLUS', 'C++ (ORG)', SkillType::Organization, 140);
        LibrarySkill.CreateSkill('JAVA', 'Java (ORG)', SkillType::Organization, 150);
    end;

    procedure CreateSkillsGeoprahpy()
    begin
        LibrarySkill.CreateSkill('DR', 'Drente (GEO)', SkillType::Geography, 200);
        LibrarySkill.CreateSkill('FL', 'Flevoland (GEO)', SkillType::Geography, 210);
        LibrarySkill.CreateSkill('FR', 'Friesland (GEO)', SkillType::Geography, 220);
        LibrarySkill.CreateSkill('GR', 'Groningen (GEO)', SkillType::Geography, 230);
        LibrarySkill.CreateSkill('LB', 'Limburg (GEO)', SkillType::Geography, 240);
        LibrarySkill.CreateSkill('NB', 'Noord-Brabant (GEO)', SkillType::Geography, 250);
        LibrarySkill.CreateSkill('NH', 'Noord Holland (GEO)', SkillType::Geography, 260);
        LibrarySkill.CreateSkill('OV', 'Overijsel (GEO)', SkillType::Geography, 270);
        LibrarySkill.CreateSkill('UT', 'Utrecht (GEO)', SkillType::Geography, 280);
        LibrarySkill.CreateSkill('ZH', 'Zuid Holland (GEO)', SkillType::Geography, 290);
        LibrarySkill.CreateSkill('ZL', 'Zeeland (GEO)', SkillType::Geography, 300);
    end;

    procedure CreateSkillsEmpty()
    begin
        LibrarySkill.CreateSkill('AHA', 'Aha', SkillType::" ");
        LibrarySkill.CreateSkill('ZAGEN', 'Zagen', SkillType::" ");
        LibrarySkill.CreateSkill('BOREN', 'Boren', SkillType::" ");
        LibrarySkill.CreateSkill('HAKKEN', 'Zagen', SkillType::" ");
    end;

    procedure CreateSkillsManual()
    begin
        LibrarySkill.CreateSkill('PARKEREN', 'Parkeren', SkillType::Manual);
        LibrarySkill.CreateSkill('SLEUTEL', 'Sleutel', SkillType::Manual);
        LibrarySkill.CreateSkill('SLAGBOOM', 'Slagboom', SkillType::Manual);
    end;
    // procedure AddAllGeographicSkills()
    // var
    // // GeoSkillCodeNBLC: Record "Geo. Skill Code NBLC";
    // begin
    //     // GeoSkillCodeNBLC.AddAllGeographicSkills();
    // end;

    // procedure DeleteSkillPostCodes()
    // var
    // // GeoSkillPostCode: Record "Geo. Skill Post Code NBLC";
    // begin
    //     // GeoSkillPostCode.DeleteAll(false);
    // end;
}
