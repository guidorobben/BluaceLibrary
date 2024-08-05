table 83950 "Consumable LIB"
{
    Caption = 'Consumable';
    DataClassification = CustomerContent;
    DrillDownPageId = "Consumables LIB";
    LookupPageId = "Consumables LIB";

    fields
    {
        field(1; Type; Enum "Consumable Type LIB")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the value of the Type field.';
        }
        field(11; Value; Text[50])
        {
            Caption = 'Value';
            ToolTip = 'Specifies the value of the Value field.';
        }
    }

    keys
    {
        key(PK; Type, Value)
        {
            Clustered = true;
        }
    }
}