codeunit 83960 "Library - Job LIB"
{
    Permissions =
        tabledata Job = rm,
        tabledata "Job Plan. Line TPZS" = r,
        tabledata "Job Planning Line" = rm,
        tabledata "Job Realization TPZS" = rim,
        // tabledata "Job Resource PZS" = ri,
        tabledata "Job Rlz. Work Time TPZS" = r,
        tabledata "Job Task" = rim,
        tabledata "Job Type RBLC" = ri,
        tabledata Resource = r,
        tabledata "Resource Group" = r;

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
        AsgJobPlLinkHelperTPZS: Codeunit "Asg. Job Pl. Link Helper TPZS";
    begin
        AsgJobPlLinkHelperTPZS.ValidatePlanJobPlanningLineNo(JobPlanningLine, PlanJobPlanningLineNo);
        AsgJobPlLinkHelperTPZS.UpdatePlanJobPlanningLine(JobPlanningLine, PlanJobPlanningLineNo);
    end;

    procedure GetJobPlanLine(var JobPlanLineTPZS: Record "Job Plan. Line TPZS"; JobPlanningLine: Record "Job Planning Line"): Boolean
    begin
        JobPlanLineTPZS.SetRange("Job No.", JobPlanningLine."Job No.");
        JobPlanLineTPZS.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        JobPlanLineTPZS.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
        if JobPlanLineTPZS.FindFirst() then
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

    procedure InitJobRealization(JobPlanningLine: Record "Job Planning Line"; var JobRealizationTPZS: Record "Job Realization TPZS"; ResourceGroup: Record "Resource Group")
    begin
        JobRealizationTPZS.Init();
        JobRealizationTPZS.Validate("Job No.", JobPlanningLine."Job No.");
        JobRealizationTPZS.Validate("Job Task No.", JobPlanningLine."Job Task No.");
        JobRealizationTPZS.Validate("Job Planning Line No.", JobPlanningLine."Line No.");
        JobRealizationTPZS.Validate("Resource Group No.", ResourceGroup."No.");
    end;

    procedure CreateJobRealization(var JobRealizationTPZS: Record "Job Realization TPZS"; JobPlanningLine: Record "Job Planning Line"; WorkStartingDateTime: DateTime; WorkEndingDateTime: DateTime; TravelStartingDateTime: DateTime; TravelEndingDateTime: DateTime; TravelDistance: Decimal)
    var
        JobPlanLineTPZS: Record "Job Plan. Line TPZS";
        ResourceGroup: Record "Resource Group";
        LibraryRandom: Codeunit "Library - Random";
        ResourceGroupNo: Code[20];
    begin
        GetJobPlanLine(JobPlanLineTPZS, JobPlanningLine);
        ResourceGroupNo := JobPlanLineTPZS."Resource Group No.";
        ResourceGroup.Get(ResourceGroupNo);

        InitJobRealization(JobPlanningLine, JobRealizationTPZS, ResourceGroup);
        JobRealizationTPZS.Insert(true);

        // Work
        JobRealizationTPZS.Validate("Work Starting Date Time", WorkStartingDateTime);
        JobRealizationTPZS.Validate("Work Ending Date Time", WorkEndingDateTime);

        // Travel
        JobRealizationTPZS.Validate("Travel Starting Date Time", TravelStartingDateTime);
        JobRealizationTPZS.Validate("Travel Ending Date Time", TravelEndingDateTime);

        // Distance
        if TravelDistance = -1 then
            JobRealizationTPZS.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0))
        else
            JobRealizationTPZS.Validate("Travel Distance (km)", TravelDistance);

        JobRealizationTPZS.Modify(true);
    end;

    procedure GetJobRlzWorkTime(JobRealizationTPZS: Record "Job Realization TPZS"; var JobRlzWorkTimeTPZS: Record "Job Rlz. Work Time TPZS"): Boolean
    begin
        JobRlzWorkTimeTPZS.Reset();
        JobRlzWorkTimeTPZS.SetRange("Job No.", JobRealizationTPZS."Job No.");
        JobRlzWorkTimeTPZS.SetRange("Job Task No.", JobRealizationTPZS."Job Task No.");
        JobRlzWorkTimeTPZS.SetRange("Job Planning Line No.", JobRealizationTPZS."Job Planning Line No.");
        JobRlzWorkTimeTPZS.SetRange("Resource Group No.", JobRealizationTPZS."Resource Group No.");
        if JobRlzWorkTimeTPZS.FindFirst() then
            exit(true);
    end;

    procedure GetJobPlanLine(JobRealizationTPZS: Record "Job Realization TPZS"; var JobPlanLineTPZS: Record "Job Plan. Line TPZS"): Boolean
    begin
        if JobPlanLineTPZS.Get(JobRealizationTPZS."Job No.", JobRealizationTPZS."Job Task No.", JobRealizationTPZS."Job Planning Line No.", JobRealizationTPZS."Resource Group No.") then
            exit(true);
    end;

    procedure CreateJobType(NewCode: Code[20]; Description: Text[100])
    var
        JobTypeRBLC: Record "Job Type RBLC";
    begin
        if JobTypeRBLC.Get(NewCode) then
            exit;

        JobTypeRBLC.Init();
        JobTypeRBLC.Validate(Code, NewCode);
        JobTypeRBLC.Validate(Description, Description);
        JobTypeRBLC.Insert(true);
    end;
}