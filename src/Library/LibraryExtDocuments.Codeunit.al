// codeunit 83961 "Library - Ext. Documents LIB"
// {
//     procedure CreateDetailedDescription(LinkToTableID: Integer; LinkToSystemId: Guid; LanguageCode: Code[10]; Description: Text[100])
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//     begin
//         CreateDetailedDescription(DetailedDescriptionDBLC, LinkToTableID, LinkToSystemId, LanguageCode, Description);
//     end;

//     procedure CreateDetailedDescription(var DetailedDescriptionDBLC: Record "Detailed Description DBLC"; LinkToTableID: Integer; LinkToSystemId: Guid; LanguageCode: Code[10]; Description: Text[100])
//     begin
//         DetailedDescriptionDBLC.Init();
//         DetailedDescriptionDBLC.Validate("Link-to Table ID", LinkToTableID);
//         DetailedDescriptionDBLC.Validate("Link-to Sytem ID", LinkToSystemId);
//         DetailedDescriptionDBLC.Validate("Language Code", LanguageCode);
//         DetailedDescriptionDBLC.Validate(Description, Description);
//         DetailedDescriptionDBLC.Insert(true);
//     end;

//     procedure HasDetailedDescriptions(LinkToTableID: Integer; LinkToSystemId: Guid): Boolean
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//     begin
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", LinkToTableID);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", LinkToSystemId);
//         exit(not (DetailedDescriptionDBLC.IsEmpty()));
//     end;

//     procedure DetailedDescriptionCount(LinkToTableID: Integer; LinkToSystemId: Guid): Integer
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//     begin
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", LinkToTableID);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", LinkToSystemId);
//         exit(DetailedDescriptionDBLC.Count());
//     end;

//     procedure GetContent(var DetailedDescriptionDBLC: Record "Detailed Description DBLC"): Text
//     begin
//         exit(GetContent(DetailedDescriptionDBLC."Link-to Table ID", DetailedDescriptionDBLC."Link-to Sytem ID", DetailedDescriptionDBLC."Language Code"));
//     end;

//     procedure GetContent(LinkedToTableID: Integer; LinkedToSystemId: Guid; LanguageCode: Code[10]): Text
//     // var
//     // DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//     begin
//         //TODO Fix exit(DetailedDescriptionDBLC.GetContent(LinkedToTableID, LinkedToSystemId, LanguageCode));
//     end;

//     procedure GetFullContent(var DetailedDescriptionDBLC: Record "Detailed Description DBLC"): Text
//     begin
//         exit(GetFullContent(DetailedDescriptionDBLC."Link-to Table ID", DetailedDescriptionDBLC."Link-to Sytem ID", DetailedDescriptionDBLC."Language Code"));
//     end;

//     procedure HasLanguageCode(LinkToTableID: Integer; LinkToSystemId: Guid; LanguageCode: Code[10]): Boolean
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//     begin
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", LinkToTableID);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", LinkToSystemId);
//         DetailedDescriptionDBLC.SetRange("Language Code", LanguageCode);
//         exit(not DetailedDescriptionDBLC.IsEmpty());
//     end;

//     procedure GetFullContent(LinkedToTableID: Integer; LinkedToSystemId: Guid; LanguageCode: Code[10]) ContentText: Text
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         ContentBigText: BigText;
//         ContentInstream: InStream;
//     begin
//         DetailedDescriptionDBLC.Get(LinkedToTableID, LinkedToSystemId, LanguageCode);
//         DetailedDescriptionDBLC.CalcFields("Detailed Description");
//         if not DetailedDescriptionDBLC."Detailed Description".HasValue then
//             exit;

//         DetailedDescriptionDBLC."Detailed Description".CreateInStream(ContentInstream);
//         ContentBigText.Read(ContentInstream);
//         ContentText := Format(ContentBigText);
//     end;


//     procedure SetContent(var DetailedDescriptionDBLC: Record "Detailed Description DBLC"; ContentText: Text);
//     var
//         ContentTextOutstream: OutStream;
//     begin
//         DetailedDescriptionDBLC."Detailed Description".CreateOutStream(ContentTextOutstream);
//         ContentTextOutstream.WriteText(ContentText);
//         // TextBigText.Write(ContentTextOutstream);
//         DetailedDescriptionDBLC.Modify();
//     end;

//     procedure HasTheSameContent(var SourceDetailedDescriptionDBLC: Record "Detailed Description DBLC"; var TargetDetailedDescriptionDBLC: Record "Detailed Description DBLC"): Boolean
//     begin
//         exit(GetFullContent(SourceDetailedDescriptionDBLC) = GetFullContent(TargetDetailedDescriptionDBLC));
//     end;

//     procedure CreateExtDocumentText(var ExtDocumentTextDBLC: Record "Ext. Document Text DBLC"; DocumentType: Enum "Ext. Doc. Text Doc. Type DBLC"; TextType: Enum "Ext. Doc. Text Type DBLC"; LanguageCode: Code[10]; Description: Text[100]; StartingDate: Date; EndingDate: Date; ContentText: Text)
//     begin
//         CreateExtDocumentText(ExtDocumentTextDBLC, DocumentType, TextType, LanguageCode, Description, StartingDate, EndingDate);
//         SetExtDocumentContent(ExtDocumentTextDBLC, ContentText);
//     end;

//     procedure CreateExtDocumentText(var ExtDocumentTextDBLC: Record "Ext. Document Text DBLC"; DocumentType: Enum "Ext. Doc. Text Doc. Type DBLC"; TextType: Enum "Ext. Doc. Text Type DBLC"; LanguageCode: Code[10]; Description: Text[100]; StartingDate: Date; EndingDate: Date)
//     begin
//         ExtDocumentTextDBLC.Init();
//         ExtDocumentTextDBLC.Validate("Document Type", DocumentType);
//         ExtDocumentTextDBLC.Validate("Text Type", TextType);
//         ExtDocumentTextDBLC.Validate("Language Code", LanguageCode);
//         ExtDocumentTextDBLC.Validate(Description, Description);
//         ExtDocumentTextDBLC.Validate("Starting Date", StartingDate);
//         ExtDocumentTextDBLC.Validate("Ending Date", EndingDate);
//         ExtDocumentTextDBLC.Insert(true);
//     end;

//     procedure SetExtDocumentContent(var ExtDocumentTextDBLC: Record "Ext. Document Text DBLC"; ContentText: Text);
//     var
//         ContentTextOutstream: OutStream;
//     begin
//         ExtDocumentTextDBLC."Detailed Description".CreateOutStream(ContentTextOutstream);
//         ContentTextOutstream.WriteText(ContentText);
//         ExtDocumentTextDBLC.Modify();
//     end;
// }
