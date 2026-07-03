// codeunit 83962 "Library - Ext. Time Sheet LIB"
// {
//     Permissions =
//         tabledata "Absence Job PZS" = RID;

//     var
//         Assert: Codeunit Assert;

//     procedure CreateAbsenceJob(JobNo: Code[20]; StartingDate: Date; EndingDate: Date)
//     var
//         AbsenceJobPZS: Record "Absence Job PZS";
//     begin
//         CreateAbsenceJob(AbsenceJobPZS, JobNo, StartingDate, EndingDate);
//     end;

//     procedure CreateAbsenceJob(var AbsenceJobPZS: Record "Absence Job PZS"; JobNo: Code[20]; StartingDate: Date; EndingDate: Date)
//     begin
//         Assert.IsTrue(JobNo <> '', 'Job No. cannot be empty.');

//         AbsenceJobPZS.Init();
//         AbsenceJobPZS.Validate("Job No.", JobNo);
//         AbsenceJobPZS.Validate("Starting Date", StartingDate);
//         AbsenceJobPZS.Validate("Ending Date", EndingDate);
//         AbsenceJobPZS.Insert(true)
//     end;

//     procedure DeleteAllJobAbsence(UseTrigger: Boolean)
//     var
//         AbsenceJobPZS: Record "Absence Job PZS";
//     begin
//         if UseTrigger then
//             AbsenceJobPZS.DeleteAll(true)
//         else
//             AbsenceJobPZS.DeleteAll(false);
//     end;

// procedure CreateJobResource(ResouceNo: Code[20]; JobNo: Code[20])
//     var
//     JobResourcePZS: Record "Job Resource PZS";
//     begin
//         JobResourcePZS.Init();
//         JobResourcePZS.Validate("Resource No.", ResouceNo);
//         JobResourcePZS.Validate("Job No.", JobNo);
//         JobResourcePZS.Insert(true);
//     end;
// }