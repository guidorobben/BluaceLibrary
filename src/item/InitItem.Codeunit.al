codeunit 83954 "Init. Item LIB"
{

    var
        LibraryContract: Codeunit "Library - Contract LIB";
        LibraryItem: Codeunit "Library - Item LIB";
        LibraryObject: Codeunit "Library - Object LIB";

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
        CreateObjectNorms();
        CreateContractNorms();
        CreateTestServiceItems();
        CreateTestServicePriceItems();
    end;

    procedure CreateObjectNorms()
    begin
        LibraryObject.CreateObjectNorm('ONORM1', 'Object Norm 1', true);
        LibraryObject.CreateObjectNorm('ONORM2', 'Object Norm 2', true);
        LibraryObject.CreateObjectNorm('ONORM3', 'Object Norm 3', true);
    end;

    procedure CreateContractNorms()
    begin
        LibraryContract.CreateContractNorm('CNORM1', 'Contract Norm 1', true);
        LibraryContract.CreateContractNorm('CNORM2', 'Contract Norm 2', true);
        LibraryContract.CreateContractNorm('CNORM3', 'Contract Norm 3', true);
    end;

    procedure CreateTestServiceItems()
    begin
        LibraryItem.CreateTestServiceItems();
    end;

    procedure CreateTestServicePriceItems()
    begin
        LibraryItem.CreateTestServicePriceItems();
    end;
}
