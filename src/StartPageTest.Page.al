page 83980 "Start Page Test LIB"
{
    ApplicationArea = All;
    Caption = 'Bluace Desktop';
    Editable = false;
    PageType = List;
    UsageCategory = Tasks;

    actions
    {
        area(Processing)
        {
            group(InitGroup)
            {
                Caption = 'Init';
                Image = Start;

                action(InitAll)
                {
                    Caption = 'Init All';
                    Image = Start;
                    RunObject = codeunit "Init. All LIB";
                    ToolTip = 'Run all Inits.';
                }
                action(InitGeneral)
                {
                    Caption = 'Init General';
                    Image = Start;
                    RunObject = codeunit "Init. General LIB";
                    ToolTip = 'Init general data.';
                }
                action(InitProperty)
                {
                    Caption = 'Init Property';
                    Image = Start;
                    RunObject = codeunit "Init. Property LIB";
                    ToolTip = 'Init property data.';
                }
                action(InitSkills)
                {
                    Caption = 'Init Skills';
                    Image = Start;
                    RunObject = codeunit "Init. Skills LIB";
                    ToolTip = 'Init skills data.';
                }
                action(InitObject)
                {
                    Caption = 'Init Object';
                    Image = Start;
                    RunObject = codeunit "Init. Object LIB";
                    ToolTip = 'Init Object data.';
                }
                action(InitContract)
                {
                    Caption = 'Init Contract';
                    Image = Start;
                    RunObject = codeunit "Init. Contract LIB";
                    ToolTip = 'Init Contract.';
                }
                action(InitResource)
                {
                    Caption = 'Init Resource';
                    Image = Start;
                    RunObject = codeunit "Init. Resoure LIB";
                    ToolTip = 'Init resource data.';
                }
                action(InitItem)
                {
                    Caption = 'Init Item';
                    Image = Start;
                    RunObject = codeunit "Init. Item LIB";
                    ToolTip = 'Init item data.';
                }
                action(InitJob)
                {
                    Caption = 'Init Job';
                    Image = Start;
                    RunObject = codeunit "Init. Job LIB";
                    ToolTip = 'Init Job data.';
                }
                action(InitSales)
                {
                    Caption = 'Init Sales';
                    Image = Start;
                    RunObject = codeunit "Init. Sales LIB";
                    ToolTip = 'Init Sales Data.';
                }
            }
            group(AdministrationGroup)
            {
                Caption = 'Administration';

                action(Consumables)
                {
                    Caption = 'Consumables';
                    Image = Entry;
                    RunObject = page "Consumables LIB";
                    ToolTip = 'Show consumables.';
                }
                // action(Dates)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Dates';
                //     Image = DateRange;
                //     RunObject = page "Date List LIB";
                //     ToolTip = 'Show all the dates.';
                // }
            }
            group(Session)
            {
                Caption = 'Session';

                action(SessionSetToDutch)
                {
                    Caption = 'Set to Dutch';
                    Image = Language;

                    trigger OnAction()
                    var
                        Session: SessionSettings;
                    begin
                        Session.Init();
                        Session.LanguageId := 1043;
                        Session.LocaleId := 1043;
                        Session.RequestSessionUpdate(true);
                    end;
                }
                action(SessionSetToEnglish)
                {
                    Caption = 'Set to English';
                    Image = Language;

                    trigger OnAction()
                    var
                        Session: SessionSettings;
                    begin
                        Session.Init();
                        Session.LanguageId := 1033;
                        Session.LocaleId := 1043;
                        Session.RequestSessionUpdate(true);
                    end;
                }
                action(SessionSetAllToEnglish)
                {
                    Caption = 'Set all to English';
                    Image = Language;

                    trigger OnAction()
                    var
                        Session: SessionSettings;
                    begin
                        Session.Init();
                        Session.LanguageId := 1033;
                        Session.LocaleId := 1033;
                        Session.RequestSessionUpdate(true);
                    end;
                }
                action(SetWorkDateToToday)
                {
                    Caption = 'WorkDate to Today';
                    Image = DueDate;

                    trigger OnAction()
                    begin
                        WorkDate(Today);
                    end;
                }
                action(SetWorkDateTo0110)
                {
                    Caption = 'WorkDate to 01-10';
                    Image = DueDate;

                    trigger OnAction()
                    var
                        WDate: Date;
                    begin
                        WDate := DMY2Date(1, 10, Date2DMY(Today(), 3));
                        WorkDate(WDate);
                    end;
                }
            }
        }

        #region Promoted
        area(Promoted)
        {

            group(InitPromoted)
            {
                Caption = 'Init';
                Image = Start;

                actionref(InitAll_Promoted; InitAll) { }
                actionref(InitGeneral_Promoted; InitGeneral) { }
                actionref(InitProperty_Promoted; InitProperty) { }
                actionref(InitSkills_Promoted; InitSkills) { }
                actionref(InitObject_Promoted; InitObject) { }
                actionref(InitContract_Promoted; InitContract) { }
                actionref(InitResource_Promoted; InitResource) { }
                actionref(InitItem_Promoted; InitItem) { }
                actionref(InitJob_Promoted; InitJob) { }
                actionref(InitSales_Promoted; InitSales) { }
            }
            group(Administration_Promoted)
            {
                Caption = 'Administration';
                Image = Administration;

                actionref(Consumables_Promoted; Consumables) { }
                // actionref(DatesPromoted; Dates) { }
            }
            group(Session_Promoted)
            {
                Caption = 'Session';
                Image = Language;

                actionref(SetWorkDateToToday_Promoted; SetWorkDateToToday) { }
                actionref(SetWorkDateTo0110_Promoted; SetWorkDateTo0110) { }
                actionref(SessionSetToDutch_Promoted; SessionSetToDutch) { }
                actionref(SessionSetToEnglish_Promoted; SessionSetToEnglish) { }
                actionref(SessionSetAllToEnglish_Promoted; SessionSetAllToEnglish) { }
            }
        }
        #endregion Promoted
    }
}