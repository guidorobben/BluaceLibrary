table 83951 "Feature Setup LIB"
{
    Caption = 'Feature Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
            NotBlank = false;
        }
        field(10; "Disable TMNL"; Boolean)
        {
            Caption = 'Disable TMNL';
            ToolTip = 'Specifies the value of the Disable TMNL field.', Comment = '%';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

}
