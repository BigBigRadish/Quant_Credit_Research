function [control] = create_control_structure(demo_type)


% Start and End date
% ~isempty(strfind(demo_type ,'attrib'))
if ~isempty(strfind(demo_type ,'attrib')) % strcmp(demo_type,'attrib')
    control.start_dt = '2009-12-15';
    control.end_dt = '2013-01-15';
else
    control.start_dt = '2008-01-15';
    control.end_dt = '2008-05-15';
end

edge_highcount(1).edge = [-inf 0 2 4 6 8 10 12 16 20 inf]; % yld
edge_highcount(2).edge = [-inf -5 0 2 4 6 8 10 15 20 inf]; % dur
edge_highcount(3).edge = [-inf 0 100 200 300 500 750 1000 1500 2000 inf]; % spd
edge_highcount(4).edge = [-inf 0 10 20 40 60 80 100 120 140 inf]; % prc


edge_lowcount(1).edge = [-inf 0 1 3 5 7 10 inf]; % yld
edge_lowcount(2).edge = [-inf 0 1 3 5 7 10 inf]; % dur
edge_lowcount(3).edge = [-inf 0 100 300 500 700 1000 1500 inf]; % spd
edge_lowcount(4).edge = [-inf 0 25 50 75 100 125 inf]; % prc


edge_verylowcount(1).edge = [-inf 3 7 inf]; % yld
edge_verylowcount(2).edge = [-inf 1 5 inf]; % dur
edge_verylowcount(3).edge = [-inf 300 700 inf]; % spd
edge_verylowcount(4).edge = [-inf 50 100 inf]; % prc


%% GENERAL CONDITIONS
% if "edge_match.type_vec" is not empty, the lenght of "met_match" and
% "edge_match.type_vec" should be equal

%% MATCH CONTROLS
% "match_type" can be set to: 'metrics_only', 'categories_only',
% 'cat_met_both', and 'cat_met_either'
control.catNoOrder_match = {'dm_em','country'};
control.catOrder_match = {'lvl_3','lvl_4'};
control.met_match = {'ytw','mod_dtw','stw'};
control.edge_match.type_vec = [];
control.edge_match.vec = edge_lowcount;
control.edge_match.equal_mass_weights = [20 40 60 80];
control.match_type = 'cat_met_both';


%% COMPARE CONTROLS
control.cat_comp = {'dm_em','lvl_3'};
control.met_comp = {'ytw','mod_dtw','stw'};
if strcmp(demo_type ,'tilt')

    control.edge_comp.type_vec = [];
    control.edge_comp.vec = edge_lowcount;
    control.edge_comp.equal_mass_weights = [33 66];
    
elseif strcmp(demo_type ,'match')

    control.edge_comp.type_vec = [1,2,3];
    control.edge_comp.vec = edge_lowcount;
    control.edge_comp.equal_mass_weights = [20 40 60 80];    

    
end



%% ATTRIBUTION CONTROLS
% "edge_eval.type_vec" cannot be empty. It has to indicate static bucket edges
% will be used to classify securities for each numeric metric, as returns
% and excess returns can potentially be linked through time.
%
% "attrib_vars" fields have to be a subset of the categories and metrics
% fields
control.cat_eval = {'lvl_3'};
control.met_eval = {'ytw','mod_dtw'};
% control.edge_vec_eval = [1,2];
control.edge_eval.type_vec = [1,2];

control.edge_eval.equal_mass_weights = [20 40 60 80];
if strcmp(demo_type,'attrib1')
    control.edge_eval.vec = edge_lowcount;
    control.attrib_cat_vars = [];
    control.attrib_vars = {'bins_ytw','bins_mod_dtw'};
elseif strcmp(demo_type,'attrib2')
    control.edge_eval.vec = edge_verylowcount;
    control.attrib_cat_vars = {'lvl_3'};
    control.attrib_vars = {'bins_mod_dtw'};
    control.edge_eval.equal_mass_weights = [];
else strcmp(demo_type,'attrib3')
    control.edge_eval.vec = edge_verylowcount;
    control.attrib_cat_vars = [];
    control.attrib_vars = [];   
end

%% MODIFICATION CONTROL
control.mod.cat_mod = {'lvl_3'};
control.mod.met_mod = {'ytw','mod_dtw'};
% control.edge_vec_mod = [1,2];
control.mod.edge_mod.type_vec = [];
control.mod.edge_mod.vec = edge_lowcount;
control.mod.edge_mod.equal_mass_weights = [33 66];

%%% 'control.mod.date' is a dataset used to store (date,index) pairs to 
% link a portfolio date with the index of the 'instruct' array in which 
% the tilting instructions for that date are located.

%%% 'control.mod.instruct[]' array:
% Variables used to specify tilts should be included in cat_mod and met_mod
% categories used to classify the securities into bins. 
%%%%%
% Format of the instruction is {Var1,Bins1,Quant1;...;VarM,BinsM,QuantM}
% is a cell array of size Mx3, where each row is a separate instruction.
% - VarX is a cell array of strings of categories found in cat_mod and
% met_mod.
% - BinsX is a scalar or array of scalars. There should be as many Bins
% specified as Variables are specified.
% - QuantX is either a real number or a percentage in string format. The
% number indicates the amount by which the portfolio weight in the bin/s
% specified should change.

if strcmp(demo_type ,'tilt')
    control.mod.date = ...
        cell2dataset({'2008-03-31',1;...
                      '2008-02-29',2},...
                      'VarNames',{'beg_dt','idx'});
    control.mod.instruct(1).instruct = {{'ytw','mod_dtw'},[3,3],'10%';...
                                        {'ytw'},1,'10%'};
    control.mod.instruct(2).instruct = {{'ytw','mod_dtw'},[3,3],'30%';...
                                        {'ytw'},2,'30%'};

elseif strcmp(demo_type ,'match')
    
    control.mod.date = dataset([],[],...
                      'VarNames',{'beg_dt','idx'});
    control.mod.instruct.instruct = [];
    
elseif ~isempty(strfind(demo_type ,'attrib'))

    control.mod.date = dataset([],[],...
                      'VarNames',{'beg_dt','idx'});
    control.mod.instruct.instruct = [];
end


                                

% CLEAR
clear edge_highcount edge_lowcount



