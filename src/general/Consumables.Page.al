page 83950 "Consumables LIB"
{
    ApplicationArea = All;
    Caption = 'Consumables';
    PageType = List;
    SourceTable = "Consumable LIB";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(TypeFilter; ConsumableTypeFilter)
            {
                Caption = 'Type Filter';
                ToolTip = 'Specifies the type filter.';

                trigger OnValidate()
                begin
                    SetConsumableTypeFilter();
                end;
            }
            repeater(General)
            {
                field("Type"; Rec."Type") { }
                field("Value"; Rec."Value") { }
            }
        }
    }

    var
        ConsumableTypeFilter: Enum "Consumable Type LIB";

    local procedure SetConsumableTypeFilter()
    begin
        Rec.SetRange(Type, ConsumableTypeFilter);
        CurrPage.Update();
    end;
}
