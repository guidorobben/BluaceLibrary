codeunit 83986 "Library - Time Sheet LIB"
{
    Permissions =
        tabledata Resource = RM,
        tabledata "Resources Setup" = R,
        tabledata "Resource Unit of Measure" = RI,
        tabledata "Time Sheet Header" = R;

    var
        LibraryTimeSheet: Codeunit "Library - Time Sheet";

    procedure CreateTimeSheetForResource(Resource: Record Resource; StartingDate: Date)
    var
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        CreateTimeSheetForResource(TimeSheetHeader, Resource, StartingDate);
    end;

    procedure CreateTimeSheetForResource(var TimeSheetHeader: Record "Time Sheet Header"; Resource: Record Resource; StartingDate: Date)
    var
        ResourcesSetup: Record "Resources Setup";
        CreateTimeSheets: Report "Create Time Sheets";
    begin
        if not Resource."Use Time Sheet" then
            exit;

        ResourcesSetup.Get();
        ResourcesSetup.TestField("Time Sheet Nos.");

        // create time sheet
        CreateTimeSheets.InitParameters(StartingDate, 1, Resource."No.", false, true);
        CreateTimeSheets.UseRequestPage(false);
        CreateTimeSheets.Run();

        // find created time sheet
        TimeSheetHeader.SetRange("Starting Date", StartingDate);
        TimeSheetHeader.SetRange("Resource No.", Resource."No.");
        TimeSheetHeader.FindFirst();
    end;

    procedure UpdateResourceForTimeSheet(var Resource: Record Resource; SaveRecord: Boolean)
    var
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
    begin
        Resource.Validate("Use Time Sheet", true);
        Resource."Time Sheet Owner User ID" := CopyStr(UserId(), 1, MaxStrLen(Resource."Time Sheet Owner User ID"));
        Resource."Time Sheet Approver User ID" := CopyStr(UserId(), 1, MaxStrLen(Resource."Time Sheet Approver User ID"));

        if Resource."Base Unit of Measure" = '' then
            Resource."Base Unit of Measure" := 'UUR';

        if not ResourceUnitOfMeasure.Get(Resource."No.", Resource."Base Unit of Measure") then begin
            ResourceUnitOfMeasure.Init();
            ResourceUnitOfMeasure."Resource No." := Resource."No.";
            ResourceUnitOfMeasure.Code := Resource."Base Unit of Measure";
            ResourceUnitOfMeasure."Qty. per Unit of Measure" := 1;
            ResourceUnitOfMeasure."Related to Base Unit of Meas." := true;
            ResourceUnitOfMeasure.Insert(true);
        end;

        if SaveRecord then
            Resource.Modify(true);
    end;

    procedure CreateTimeSheetLine(TimeSheetHeader: Record "Time Sheet Header"; var TimeSheetLine: Record "Time Sheet Line"; Type: Enum "Time Sheet Line Type"; JobNo: Code[20]; JobTaskNo: Code[20]; ServiceOrderNo: Code[20]; CauseOfAbsenceCode: Code[10])
    begin
        LibraryTimeSheet.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, Type, JobNo, JobTaskNo, ServiceOrderNo, CauseOfAbsenceCode);
    end;

    procedure CreateTimeSheetLine(TimeSheetHeader: Record "Time Sheet Header"; var TimeSheetLine: Record "Time Sheet Line"; Type: Enum "Time Sheet Line Type"; JobNo: Code[20]; JobTaskNo: Code[20])
    begin
        LibraryTimeSheet.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, Type, JobNo, JobTaskNo, '', '');
    end;

    procedure SetTimeSheetLineToSubmitted(var TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetApprovalManagement: Codeunit "Time Sheet Approval Management";
        ActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject;
    begin
        if TimeSheetApprovalManagement.ConfirmAction(ActionType::Submit) then
            Process(TimeSheetLine, ActionType::Submit);
    end;

    local procedure Process(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject)
    var
        // TimeSheetLine: Record "Time Sheet Line";
        TimeSheetApprovalManagement: Codeunit "Time Sheet Approval Management";
    begin
        // FilterAllLines(TimeSheetLine, ActionType);
        // OnProcessOnAfterTimeSheetLinesFiltered(TimeSheetLine, ActionType);

        // if TimeSheetLine.FindSet() then
        // repeat
        TimeSheetApprovalManagement.ProcessAction(TimeSheetLine, ActionType);
        // until TimeSheetLine.Next() = 0;
        // CurrPage.Update(true);

        // OnAfterProcess(Rec, ActionType);
    end;


}
