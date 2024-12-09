page 83951 "Feature Setup LIB"
{
    ApplicationArea = All;
    Caption = 'Feature Setup';
    PageType = Card;
    SourceTable = "Feature Setup LIB";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Disable TMNL"; Rec."Disable TMNL") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}