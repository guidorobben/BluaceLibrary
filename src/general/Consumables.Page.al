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
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
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
