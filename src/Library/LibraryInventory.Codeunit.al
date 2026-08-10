codeunit 83959 "Library - Inventory LIB"
{
    Permissions =
        tabledata "Base Calendar" = r,
        tabledata "Base Calendar Change" = r,
        tabledata Location = rm;

    var
        LibraryInventory: Codeunit "Library - Inventory";

    procedure CreateTransferOrderWithBaseCalendar(var TransferLine: Record "Transfer Line")
    var
        BaseCalendar: Record "Base Calendar";
        BaseCalendar2: Record "Base Calendar";
        BaseCalendarChange: Record "Base Calendar Change";
        LibraryService: Codeunit "Library - Service";
    begin
        LibraryService.CreateBaseCalendar(BaseCalendar);
        LibraryService.CreateBaseCalendar(BaseCalendar2);
        CreateBaseCalendarChange(BaseCalendarChange, BaseCalendar.Code, BaseCalendarChange.Day::Saturday, BaseCalendarChange.Day::Sunday);
        CreateBaseCalendarChange(BaseCalendarChange, BaseCalendar2.Code, BaseCalendarChange.Day::Sunday, BaseCalendarChange.Day::Monday);
        CreateTransferOrderWithModifiedLocation(TransferLine, BaseCalendar.Code, BaseCalendar2.Code);
    end;

    procedure CreateBaseCalendarChange(var BaseCalendarChange: Record "Base Calendar Change"; BaseCalendarCode: Code[10]; Day: Option; Day2: Option)
    begin
        LibraryInventory.CreateBaseCalendarChange(
          BaseCalendarChange, BaseCalendarCode, BaseCalendarChange."Recurring System"::"Weekly Recurring", 0D, Day);  // '0D' is taken for blank date.
        LibraryInventory.CreateBaseCalendarChange(
          BaseCalendarChange, BaseCalendarCode, BaseCalendarChange."Recurring System"::"Weekly Recurring", 0D, Day2);  // '0D' is taken for blank date.
    end;

    procedure CreateTransferOrderWithModifiedLocation(var TransferLine: Record "Transfer Line"; BaseCalendarCode: Code[10]; BaseCalendarCode2: Code[10])
    var
        Location: Record Location;
        Location2: Record Location;
    begin
        CreateAndModifyLocation(Location, BaseCalendarCode);
        CreateAndModifyLocation(Location2, BaseCalendarCode2);
        CreateTransferOrder(TransferLine, Location.Code, Location2.Code);
    end;

    procedure CreateAndModifyLocation(var Location: Record Location; BaseCalendarCode: Code[10])
    var
        LibraryRandom: Codeunit "Library - Random";
        LibraryWarehouse: Codeunit "Library - Warehouse";
    begin
        LibraryWarehouse.CreateLocation(Location);
        Location.Validate("Base Calendar Code", BaseCalendarCode);
        Evaluate(Location."Inbound Whse. Handling Time", '<' + Format(LibraryRandom.RandInt(5)) + 'D>');  // Random value is taken for Handling Time and 'D' is used for Day.
        Location.Validate("Outbound Whse. Handling Time", Location."Inbound Whse. Handling Time");
        Location.Modify(true);
    end;

    procedure CreateTransferOrder(var TransferLine: Record "Transfer Line"; LocationCode: Code[10]; LocationCode2: Code[10])
    var
        Location: Record Location;
        TransferHeader: Record "Transfer Header";
        LibraryRandom: Codeunit "Library - Random";
        LibraryWarehouse: Codeunit "Library - Warehouse";
    begin
        LibraryWarehouse.CreateInTransitLocation(Location);
        LibraryWarehouse.CreateTransferHeader(TransferHeader, LocationCode, LocationCode2, Location.Code);
        LibraryWarehouse.CreateTransferLine(
          TransferHeader, TransferLine, LibraryInventory.CreateItemNo(), LibraryRandom.RandDec(10, 2));  // Random value taken for Quantity.
    end;
}
