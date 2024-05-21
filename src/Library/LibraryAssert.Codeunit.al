codeunit 83985 "Library - Assert LIB"
{
    var
        Assert: Codeunit Assert;

    procedure DecimalIsNotNegative(Value: Decimal)
    begin
        Assert.IsTrue(Value < 0, 'Value cannot be negative');
    end;
}