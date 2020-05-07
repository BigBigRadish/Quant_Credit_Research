function [in_c, in_ds, IdxAna, IdxFin, IdxAggLvl3, IdxFaceVal] = ...
            get_demo_data(control)

load('All_H0A0AnaFinDataDateNum');
load('All_H0A0_AnaAggData','All_lvl3_H0A0AnaAggF')
load('All_H0A0_FaceValue_Stats');
load('EndOfMonthDates');

start_dt = control.start_dt;
end_dt = control.end_dt;

s_dt = datenum(start_dt);
e_dt = datenum(end_dt);

in_ds = inputs_ds((e_dt> datenum(cellstr(inputs_ds.beg_dt))) &...
                      (s_dt< datenum(cellstr(inputs_ds.beg_dt))),2);
in_ds = sortrows(in_ds,'beg_dt','ascend');

in_c = inputs((e_dt> datenum(inputs(:,2))) &...
                      (s_dt< datenum(inputs(:,2))),2);      
in_c = in_c(end:-1:1,:);

IdxAna = All_H0A0Ana((e_dt> All_H0A0Ana.beg_dt) &...
                      (s_dt< All_H0A0Ana.beg_dt),:);
IdxFin = All_H0A0Fin_combined((e_dt> All_H0A0Fin_combined.beg_dt) &...
                      (s_dt< All_H0A0Fin_combined.beg_dt),:);
                  

% check rows of analytics and financial datasets correspond to each other
% in terms of cusip and date.
[IdxAna, IdxFin]=...
        sortCompare(IdxAna,IdxFin,...
        [2,4],[1,2]);                  

IdxAggLvl3 = ...
    All_lvl3_H0A0AnaAggF((e_dt> datenum(cellstr(All_lvl3_H0A0AnaAggF.beg_dt))) &...
                      (s_dt< datenum(cellstr(All_lvl3_H0A0AnaAggF.beg_dt))),:);

IdxFaceVal = statarray((e_dt> datenum(cellstr(statarray.beg_dt))) &...
                      (s_dt< datenum(cellstr(statarray.beg_dt))),:);



end
