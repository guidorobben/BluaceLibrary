codeunit 83972 "Library - Matching LIB"
{
    procedure CalculateMatchingScore(SearchValue: Text; FieldValue: Text; qGram: Integer) MatchScore: Decimal
    var
        MatchingMeth: Codeunit "Matching Meth. TPZS";
        Similarity: Decimal;
    begin
        MatchingMeth.GetSimilarity(SearchValue, FieldValue, qGram, Similarity);
        MatchScore := Round(Similarity * 100);
    end;
}