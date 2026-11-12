
%% SoftCodeHandler
% This function can recieve a byte sent from the Bpod while a trial is running. 
% This is primarily to allow for the MATLAB command window to print the session results trial by trial. 

function SoftCodeHandler(Byte)
    global BpodSystem       

    switch (Byte)
        case 4
            % For lick familiarization only: counting number of total licks (used for dry licks)
            BpodSystem.Data.lickCount = BpodSystem.Data.lickCount + 1;
            
            fprintf('%d (-) \n', BpodSystem.Data.lickCount)
        case 5
            % For lick familiarization only: counting rewarded licks
            BpodSystem.Data.rewardedLickCount = BpodSystem.Data.rewardedLickCount + 1;
            BpodSystem.Data.lickCount = BpodSystem.Data.lickCount + 1;
            
            fprintf('%d (+) \n', BpodSystem.Data.lickCount)
    end
end
