codeunit 83972 "Library - Matching LIB"
{
    procedure CalculateMatchingScore(SearchValue: Text; FieldValue: Text; qGram: Integer) MatchScore: Decimal
    var
        MatchingMethCBLC: Codeunit "Matching Meth. CBLC";
        Similarity: Decimal;
    begin
        MatchingMethCBLC.GetSimilarity(SearchValue, FieldValue, qGram, Similarity);
        MatchScore := Round(Similarity * 100);
    end;
}