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
        CreateItemDiscountGroups();
    end;

    procedure CreateObjectNorms()
    begin
        LibraryObject.CreateObjectNormCode('ONORM1', 'Object Norm 1', true);
        LibraryObject.CreateObjectNormCode('ONORM2', 'Object Norm 2', true);
        LibraryObject.CreateObjectNormCode('ONORM3', 'Object Norm 3', true);
    end;

    procedure CreateContractNorms()
    begin
        LibraryContract.CreateContractNorm('CNORM1', 'Contract Norm 1');
        LibraryContract.CreateContractNorm('CNORM2', 'Contract Norm 2');
        LibraryContract.CreateContractNorm('CNORM3', 'Contract Norm 3');
        LibraryContract.CreateContractNorm('VERHUUR', 'Verhuur');
    end;

    procedure CreateItemDiscountGroups()
    begin
        LibraryItem.CreateItemDiscountGroup('CONTRACTS', 'Contracts');
        LibraryItem.CreateItemDiscountGroup('OBJECTS', 'Objects');
        LibraryItem.CreateItemDiscountGroup('CUSTOMERS', 'Customers');
        LibraryItem.CreateItemDiscountGroup('VENDORS', 'Vendors');
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
