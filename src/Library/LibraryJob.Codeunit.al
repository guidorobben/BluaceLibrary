codeunit 83960 "Library - Job LIB"
{
    Permissions =
        tabledata Job = RM,
        tabledata "Job Plan. Line CBLC" = R,
        tabledata "Job Planning Line" = RM,
        tabledata "Job Realization CBLC" = RIM,
        // tabledata "Job Resource PZS" = RI,
        tabledata "Job Rlz. Work Time CBLC" = R,
        tabledata "Job Task" = RIM,
        tabledata "Job Type BBLC" = RI,
        tabledata Resource = R,
        tabledata "Resource Group" = R;

    var
        LibraryJob: Codeunit "Library - Job";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibraryResourceLIB: Codeunit "Library - Resource LIB";

    procedure CreateJob(var Job: Record Job)
    begin
        LibraryJob.CreateJob(Job);
    end;

    procedure CreateJobTask(Job: Record Job; JobTaskNo: Code[20]; JobTaskDescription: Text[100])
    var
        JobTask: Record "Job Task";
    begin
        CreateJobTask(Job, JobTask, JobTaskNo, JobTaskDescription);
    end;

    procedure CreateJobTask(Job: Record Job; var JobTask: Record "Job Task"; JobTaskNo: Code[20]; JobTaskDescription: Text[100])
    begin
        CreateJobTask(Job, JobTask, JobTaskNo);
        if JobTaskNo <> '' then
            JobTask.TestField("Job Task No.", JobTaskNo);
        JobTask.Validate(Description, JobTaskDescription);
        JobTask.Modify(true);
    end;

    procedure CreateJobTask(Job: Record Job; var JobTask: Record "Job Task"; JobTaskNo: Code[20])
    var
        JobTaskLocal: Record "Job Task";
    // JobTaskNo: Code[20];
    begin
        // Create a (posting) task for a job

        if JobTaskNo = '' then begin
            JobTaskNo := 'JT001';

            // Find the last task no. (as an integer)
            JobTaskLocal.SetRange("Job No.", Job."No.");
            if JobTaskLocal.FindLast() then
                JobTaskNo := IncStr(JobTaskLocal."Job Task No.");
        end;

        JobTask.Init();
        JobTask.Validate("Job No.", Job."No.");
        JobTask.Validate("Job Task No.", JobTaskNo);
        JobTask.Insert(true);

        JobTask.Validate("Job Task Type", JobTask."Job Task Type"::Posting);
        JobTask.Modify(true)
    end;

    procedure CreateJobPlanningLine(LineType: Enum "Job Planning Line Line Type"; Type: Enum "Job Planning Line Type"; JobTask: Record "Job Task"; var JobPlanningLine: Record "Job Planning Line")
    begin
        LibraryJob.CreateJobPlanningLine(LineType, Type, JobTask, JobPlanningLine);
    end;

    procedure CreateJobPlanningLine(var JobPlanningLine: Record "Job Planning Line"; JobTask: Record "Job Task"; LineType: Enum "Job Planning Line Line Type"; Type: Enum "Job Planning Line Type"; Number: Code[20]; PlanningDate: Date; Quantity: Decimal)
    begin
        LibraryJob.CreateJobPlanningLine(LineType, Type, JobTask, JobPlanningLine);
        JobPlanningLine.Validate("Planning Date", PlanningDate);
        JobPlanningLine.Validate("No.", Number);
        JobPlanningLine.Validate(Quantity, Quantity);
        JobPlanningLine.Modify(true);
    end;

    procedure CreateJobPlanningLine(var JobPlanningLine: Record "Job Planning Line"; JobTask: Record "Job Task"; LineType: Enum "Job Planning Line Line Type"; Type: Enum "Job Planning Line Type"; Number: Code[20]; LocationCode: Code[10]; Quantity: Decimal)
    begin
        LibraryJob.CreateJobPlanningLine(LineType, Type, JobTask, JobPlanningLine);
        JobPlanningLine.Validate("No.", Number);
        JobPlanningLine.Validate("Location Code", LocationCode);
        JobPlanningLine.Validate(Quantity, Quantity);
        JobPlanningLine.Modify(true);
        // Commit();
    end;

    // procedure CreateJobResource(ResouceNo: Code[20]; JobNo: Code[20])
    // var
    // // JobResourcePZS: Record "Job Resource PZS";
    // begin
    //     // JobResourcePZS.Init();
    //     // JobResourcePZS.Validate("Resource No.", ResouceNo);
    //     // JobResourcePZS.Validate("Job No.", JobNo);
    //     // JobResourcePZS.Insert(true);
    // end;

    procedure CreateResourceAsJobResource(JobNo: Code[20])
    var
        Resource: Record Resource;
    begin
        CreateResourceAsJobResource(Resource, JobNo);
    end;

    procedure CreateResourceAsJobResource(var Resource: Record Resource; JobNo: Code[20])
    var
    begin
        LibraryResourceLIB.CreateResource(Resource, '', LibraryRandomLIB.FindCompleteNameRandom());
        // LibExtTimeSheet.CreateJobResource(Resource."No.", JobNo);
    end;

    procedure LinkJobPlanningLines(var JobPlanningLine: Record "Job Planning Line"; PlanJobPlanningLineNo: Integer)
    var
        AsgJobPlLinkHelperCBLC: Codeunit "Asg. Job Pl. Link Helper CBLC";
    begin
        AsgJobPlLinkHelperCBLC.ValidatePlanJobPlanningLineNo(JobPlanningLine, PlanJobPlanningLineNo);
        AsgJobPlLinkHelperCBLC.UpdatePlanJobPlanningLine(JobPlanningLine, PlanJobPlanningLineNo);
    end;

    procedure GetJobPlanLine(var JobPlanLineCBLC: Record "Job Plan. Line CBLC"; JobPlanningLine: Record "Job Planning Line"): Boolean
    begin
        JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
        JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
        if JobPlanLineCBLC.FindFirst() then
            exit(true);
    end;

    // procedure ReleaseJobForTimeSheets(var Job: Record Job)
    // var
    // // RelJobforTimeSheetsPZS: Codeunit "Rel. Job for Time Sheets PZS";
    // begin
    //     // RelJobforTimeSheetsPZS.ReleaseJobForTimeSheets(Job);        
    // end;

    // procedure SetTimeSheetApproverToUser(var Job: Record Job; UserName: Code[50])
    // begin
    //     // Job.Validate("Time Sheet Appr. User ID PZS", UserName);
    //     // Job.Modify(true);
    // end;

    procedure InitJobRealization(JobPlanningLine: Record "Job Planning Line"; var JobRealizationCBLC: Record "Job Realization CBLC"; ResourceGroup: Record "Resource Group")
    begin
        JobRealizationCBLC.Init();
        JobRealizationCBLC.Validate("Job No.", JobPlanningLine."Job No.");
        JobRealizationCBLC.Validate("Job Task No.", JobPlanningLine."Job Task No.");
        JobRealizationCBLC.Validate("Job Planning Line No.", JobPlanningLine."Line No.");
        JobRealizationCBLC.Validate("Resource Group No.", ResourceGroup."No.");
    end;

    procedure CreateJobRealization(var JobRealizationCBLC: Record "Job Realization CBLC"; JobPlanningLine: Record "Job Planning Line"; WorkStartingDateTime: DateTime; WorkEndingDateTime: DateTime; TravelStartingDateTime: DateTime; TravelEndingDateTime: DateTime; TravelDistance: Decimal)
    var
        JobPlanLineCBLC: Record "Job Plan. Line CBLC";
        ResourceGroup: Record "Resource Group";
        LibraryRandom: Codeunit "Library - Random";
        ResourceGroupNo: Code[20];
    begin
        GetJobPlanLine(JobPlanLineCBLC, JobPlanningLine);
        ResourceGroupNo := JobPlanLineCBLC."Resource Group No.";
        ResourceGroup.Get(ResourceGroupNo);

        InitJobRealization(JobPlanningLine, JobRealizationCBLC, ResourceGroup);
        JobRealizationCBLC.Insert(true);

        // Work
        JobRealizationCBLC.Validate("Work Starting Date Time", WorkStartingDateTime);
        JobRealizationCBLC.Validate("Work Ending Date Time", WorkEndingDateTime);

        // Travel
        JobRealizationCBLC.Validate("Travel Starting Date Time", TravelStartingDateTime);
        JobRealizationCBLC.Validate("Travel Ending Date Time", TravelEndingDateTime);

        // Distance
        if TravelDistance = -1 then
            JobRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0))
        else
            JobRealizationCBLC.Validate("Travel Distance (km)", TravelDistance);

        JobRealizationCBLC.Modify(true);
    end;

    procedure GetJobRlzWorkTime(JobRealizationCBLC: Record "Job Realization CBLC"; var JobRlzWorkTimeCBLC: Record "Job Rlz. Work Time CBLC"): Boolean
    begin
        JobRlzWorkTimeCBLC.Reset();
        JobRlzWorkTimeCBLC.SetRange("Job No.", JobRealizationCBLC."Job No.");
        JobRlzWorkTimeCBLC.SetRange("Job Task No.", JobRealizationCBLC."Job Task No.");
        JobRlzWorkTimeCBLC.SetRange("Job Planning Line No.", JobRealizationCBLC."Job Planning Line No.");
        JobRlzWorkTimeCBLC.SetRange("Resource Group No.", JobRealizationCBLC."Resource Group No.");
        if JobRlzWorkTimeCBLC.FindFirst() then
            exit(true);
    end;

    procedure GetJobPlanLine(JobRealizationCBLC: Record "Job Realization CBLC"; var JobPlanLineCBLC: Record "Job Plan. Line CBLC"): Boolean
    begin
        if JobPlanLineCBLC.Get(JobRealizationCBLC."Job No.", JobRealizationCBLC."Job Task No.", JobRealizationCBLC."Job Planning Line No.", JobRealizationCBLC."Resource Group No.") then
            exit(true);
    end;

    procedure CreateJobType(NewCode: Code[20]; Description: Text[100])
    var
        JobTypeBBLC: Record "Job Type BBLC";
    begin
        if JobTypeBBLC.Get(NewCode) then
            exit;

        JobTypeBBLC.Init();
        JobTypeBBLC.Validate(Code, NewCode);
        JobTypeBBLC.Validate(Description, Description);
        JobTypeBBLC.Insert(true);
    end;
}