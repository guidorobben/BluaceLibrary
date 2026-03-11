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
        CreateVolvoItemDiscountGroups();
    end;

    procedure CreateObjectNorms()
    begin
        LibraryObject.CreateObjectNormCode('ONORM1', 'Object Norm 1');
        LibraryObject.CreateObjectNormCode('ONORM2', 'Object Norm 2');
        LibraryObject.CreateObjectNormCode('ONORM3', 'Object Norm 3');
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

    procedure CreateVolvoItemDiscountGroups()
    begin
        LibraryItem.CreateItemDiscountGroup('11', 'Filters, anodes, AQ bellows, OH');
        LibraryItem.CreateItemDiscountGroup('12', 'Motor rep.delen');
        LibraryItem.CreateItemDiscountGroup('13', 'Olie, verf, vetten, dure delen');
        LibraryItem.CreateItemDiscountGroup('14', 'Dure VP acc, QL boeg - hekschr.');
        LibraryItem.CreateItemDiscountGroup('15', 'Rep.delen motoren, drives, serv.');
        LibraryItem.CreateItemDiscountGroup('16', 'Schroeven, SP, vaste VP schr.');
        LibraryItem.CreateItemDiscountGroup('17', 'alle DP en RVS schroeven');
        LibraryItem.CreateItemDiscountGroup('18', 'Dure rep.delen, motorblokken etc.');
        LibraryItem.CreateItemDiscountGroup('19', 'Alle ruildelen excl.onderstaa');
        LibraryItem.CreateItemDiscountGroup('20', 'Gedeelde en compl.ruildrives');
        LibraryItem.CreateItemDiscountGroup('21', 'Gereedschappen + ruilmotoren');
        LibraryItem.CreateItemDiscountGroup('22', 'Core');
        LibraryItem.CreateItemDiscountGroup('31', 'Replaced parts');
        LibraryItem.CreateItemDiscountGroup('35', 'Right choice VP delen');
        LibraryItem.CreateItemDiscountGroup('36', 'Volvo Alternatief A');
        LibraryItem.CreateItemDiscountGroup('37', 'Volvo Reco R');
        LibraryItem.CreateItemDiscountGroup('38', 'Volvo Gebruikt G');
        LibraryItem.CreateItemDiscountGroup('39', 'Nieuw / komt van nieuwe motor N');
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
