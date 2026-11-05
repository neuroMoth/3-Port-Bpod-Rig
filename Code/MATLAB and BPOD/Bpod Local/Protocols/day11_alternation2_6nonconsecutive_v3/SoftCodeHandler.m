
%% SoftCodeHandler
% This function can recieve a byte sent from the Bpod while a trial is running. 
% This is primarily to allow for the MATLAB command window to print the session results trial by trial. 

function SoftCodeHandler(Byte)
    global BpodSystem       

    expV = ExperimentVariables; % Only needed to get the punish duration

    switch (Byte)
        case 1
            % End of session, not currently used (no need to end session partway through a trial)
            BpodSystem.Status.ExitTrialLoop = true; 
            BpodSystem.Status.BeingUsed = 0;
        case 2 
            % trial was not engaged
            BpodSystem.Data.summary.engagedTrials(BpodSystem.Status.trial) = 0; 
            
            fprintf('-> %d skipped. ', sum(BpodSystem.Data.summary.engagedTrials == 0));
            fprintf('Punish. %d sec. ', expV.PUNISHMENT_TIME);
        case 14
            % Report Incorrect
            BpodSystem.Data.summary.correctTrials(BpodSystem.Status.trial) = 0;
            
            % Trial *was* engaged, reset consecutiveRatSkips
            BpodSystem.Data.summary.engagedTrials(BpodSystem.Status.trial) = 1;
            
            fprintf('-> %d incorrect. ', sum(BpodSystem.Data.summary.correctTrials == 0));
            fprintf('Punish. %d sec. ', expV.PUNISHMENT_TIME);
        case 15 
            % Report Correct
            BpodSystem.Data.summary.correctTrials(BpodSystem.Status.trial) = 1;
            
            % Trial *was* engaged, reset consecutiveRatSkips
            BpodSystem.Data.summary.engagedTrials(BpodSystem.Status.trial) = 1;
            
            fprintf('-> %d correct. ', sum(BpodSystem.Data.summary.correctTrials == 1));
            
            % FOR ALTERNATION -> if # correct is a multiple of the # required to switch, then switch sides
            BpodSystem.Status.numberNonconsecutiveCorrect = BpodSystem.Status.numberNonconsecutiveCorrect + 1;
            fprintf('%d nonconsecutive run. ', BpodSystem.Status.numberNonconsecutiveCorrect);
            if (mod(sum(BpodSystem.Data.summary.correctTrials == 1), expV.CORRECT_REQUIRED_TO_SWITCH) == 0)
                BpodSystem.Status.switchStimulusFlag = true; 
            end
    end
end
