function connector_electrode_naming = getCartoConnectorElectrodeNaming()
% GETCARTOCONNECTORELECTRODENAMING returns naming conventions for Carto.
% Usage:
%   connector_electrode_naming = getCartoConnectorElectrodeNaming()
% Where:
%   connector_electrode_naming -
%     This is a structure array.
%     There is an element for each of the possible connectors ...
%                       'CS_CONNECTOR'
%                       'MAGNETIC_20_POLE_A_CONNECTOR'
%                       'MAGNETIC_20_POLE_B_CONNECTOR'
%                       'NAVISTAR_CONNECTOR'
%                       'MEC'
%                       'MCC_DX_CONNECTOR
%                       'ECG' % this isn't a connector with positions
%                             % but the channel names are created
%     Fieldnames are as follows and illustrated with the CS
%         c(1).connector = 'CS_CONNECTOR';
%         c(1).bipolarNaming = 'CS';
%         c(1).unipolarNaming = 'CS';
%         c(1).electrodeNumbers = (1:10)';
%         c(1).electrodeNames = {'CS1','CS2','CS3','CS4','CS5','CS6','CS7','CS8','CS9','CS10'}';
%         c(1).bipoleNames = {'CS1-CS2','CS2-CS3','CS3-CS4','CS4-CS5','CS5-CS6','CS6-CS7','CS7-CS8','CS8-CS9','CS9-CS10'}';
%         c(1).bipoleElectrodeOneName = {'CS1','CS2','CS3','CS4','CS5','CS6','CS7','CS8','CS9'}';
%         c(1).bipoleElectrodeTwoName = {'CS2','CS3','CS4','CS5','CS6','CS7','CS8','CS9','CS10'}';
%   NOTE CAREFULLY!!!
%   The MCC_DX_CONNECTOR position download file is erratic. Sometimes,
%   there are electrode positions
%           1,2,3 , 1,2,3,4,5,6 , 1,2,3,4,5,6 ...
%   and sometimes there are electrode positions
%           1,2 , 1,2,3,4,5,6 , 1,2,3,4,5,6 ...
%   For this reason, for MCC_DX_CONNECTOR, there is also a fieldname called .optionalElectrode = [3]
%
% Author: Nick Linton (2023) (Copyright)
% SPDX-License-Identifier: Apache-2.0
%
% Modifications - 


% ---------------------------------------------------------------
% code
% ---------------------------------------------------------------


% connector = { 'CS_CONNECTOR'; ...
%               'MAGNETIC_20_POLE_A_CONNECTOR'; ...
%               'MAGNETIC_20_POLE_B_CONNECTOR'; ...
%               'NAVISTAR_CONNECTOR'; ...
%               'MEC'; ...
%               'MCC_DX_CONNECTOR' ...
%               };
% bipolarNaming = {     'CS' ...
%                     , '20A_' ...
%                     , '20B_' ...
%                     , 'M' ...
%                     , 'MC Bipolar ' ...
%                     , 'MCC_Dx_BiPolar_'
%                     };
% unipolarNaming = {    'CS' ...
%                     , '20A_' ...
%                     , '20B_' ...
%                     , 'M' ...
%                     , 'M' ...
%                     , 'MCC_Dx_UniPolar_'
%                     };
% surfaceEcgNaming = {'V1','V2','V3','V4','V5','V6','I','II','III','aVL','aVR','avF'};
    
    connector_electrode_naming(1) = local_cs_names();
    connector_electrode_naming(2) = local_twentypoleA_names();
    connector_electrode_naming(3) = local_twentypoleB_names();
    connector_electrode_naming(4) = local_navistar_names();
    connector_electrode_naming(5) = local_mec_names();
    connector_electrode_naming(6) = local_mcc_dx_names();
    connector_electrode_naming(7) = local_ecg_names(); %not actually a connector but useful to have
end

function temp = local_cs_names()
    temp.connector = 'CS_CONNECTOR';
    temp.bipolarNaming = 'CS';
    temp.unipolarNaming = 'CS';
    temp.electrodeNumbers = (1:10)';
    temp.electrodeNames = {'CS1','CS2','CS3','CS4','CS5','CS6','CS7','CS8','CS9','CS10'}';
    temp.optionalElectrodes = [];
    temp.bipoleNames = {'CS1-CS2','CS2-CS3','CS3-CS4','CS4-CS5','CS5-CS6','CS6-CS7','CS7-CS8','CS8-CS9','CS9-CS10'}';
    temp.bipoleElectrodeOneName = {'CS1','CS2','CS3','CS4','CS5','CS6','CS7','CS8','CS9'}';
    temp.bipoleElectrodeTwoName = {'CS2','CS3','CS4','CS5','CS6','CS7','CS8','CS9','CS10'}';
end

function temp = local_mec_names()
    temp.connector = 'MEC'; % THIS IS NOT SUPPORTED YET BECAUSE WE HAVE NO TEST CASES
    temp.bipolarNaming = 'MC Bipolar ';
    temp.unipolarNaming = 'M'; %this is not unique to the MEC catheter, which is a problem
    temp.electrodeNumbers = (1:4)';
    temp.electrodeNames = {'M1','M2','M3','M4'}';
    temp.optionalElectrodes = [];
    temp.bipoleNames = {'M1-M2','M2-M3','M3-M4'}';
    temp.bipoleElectrodeOneName = {'M1','M2','M3'}';
    temp.bipoleElectrodeTwoName = {'M2','M3','M4'}';
end

function temp = local_ecg_names()
    temp.connector = 'ECG';
    temp.bipolarNaming = '';
    temp.unipolarNaming = '';
    temp.electrodeNumbers = [];
    temp.electrodeNames = {'V1','V2','V3','V4','V5','V6','I','II','III','aVL','aVR','avF'}';
    temp.optionalElectrodes = [];
    temp.bipoleNames = {}';
    temp.bipoleElectrodeOneName = {}';
    temp.bipoleElectrodeTwoName = {}';
end

function temp = local_navistar_names()
    temp.connector = 'NAVISTAR_CONNECTOR';
    temp.bipolarNaming = 'M';
    temp.unipolarNaming = 'M';
    temp.electrodeNumbers = (1:4)';
    temp.electrodeNames = {'M1','M2','M3','M4'}';
    temp.optionalElectrodes = [];
    temp.bipoleNames = {'M1-M2','M2-M3','M3-M4'}'; % NOTE: M2-M3 is not usually returned but is inluded just in case
    temp.bipoleElectrodeOneName = {'M1','M2','M3'}';
    temp.bipoleElectrodeTwoName = {'M2','M3','M4'}';
end

function temp = local_twentypoleA_names()
    temp.connector = 'MAGNETIC_20_POLE_A_CONNECTOR';
    temp.bipolarNaming = '20A_';
    temp.unipolarNaming = '20A_';
    temp.electrodeNumbers = [1:2,repmat(1:4,1,5)]';
    temp.electrodeNames = {...
        'shaft1'; ...
        'shaft2'; ...
        '20A_1'; ...
        '20A_2'; ...
        '20A_3'; ...
        '20A_4'; ...
        '20A_5'; ...
        '20A_6'; ...
        '20A_7'; ...
        '20A_8'; ...
        '20A_9'; ...
        '20A_10'; ...
        '20A_11'; ...
        '20A_12'; ...
        '20A_13'; ...
        '20A_14'; ...
        '20A_15'; ...
        '20A_16'; ...
        '20A_17'; ...
        '20A_18'; ...
        '20A_19'; ...
        '20A_20'};
    temp.optionalElectrodes = [];
    bipoleComposition = {...
        '20A_1-2',   '20A_1',  '20A_2'; ...
        '20A_2-3',   '20A_2',  '20A_3'; ...
        '20A_3-4',   '20A_3',  '20A_4'; ...
        '20A_4-5',   '20A_4',  '20A_5'; ...
        '20A_5-6',   '20A_5',  '20A_6'; ...
        '20A_6-7',   '20A_6',  '20A_7'; ...
        '20A_7-8',   '20A_7',  '20A_8'; ...
        '20A_8-9',   '20A_8',  '20A_9'; ...
        '20A_9-10',  '20A_9',  '20A_10'; ...
        '20A_10-11', '20A_10', '20A_11'; ...
        '20A_11-12', '20A_11', '20A_12'; ...
        '20A_12-13', '20A_12', '20A_13'; ...
        '20A_13-14', '20A_13', '20A_14'; ...
        '20A_14-15', '20A_14', '20A_15'; ...
        '20A_15-16', '20A_15', '20A_16'; ...
        '20A_16-17', '20A_16', '20A_17'; ...
        '20A_17-18', '20A_17', '20A_18'; ...
        '20A_18-19', '20A_18', '20A_19'; ...
        '20A_19-20', '20A_19', '20A_20'};
    temp.bipoleNames = bipoleComposition(:,1);
    temp.bipoleElectrodeOneName = bipoleComposition(:,2);
    temp.bipoleElectrodeTwoName = bipoleComposition(:,3);
end


function temp = local_twentypoleB_names()
    temp.connector = 'MAGNETIC_20_POLE_B_CONNECTOR';
    temp.bipolarNaming = '20B_';
    temp.unipolarNaming = '20B_';
    temp.electrodeNumbers = [1:2,repmat(1:4,1,5)]';
    temp.electrodeNames = {...
        'shaft1'; ...
        'shaft2'; ...
        '20B_1'; ...
        '20B_2'; ...
        '20B_3'; ...
        '20B_4'; ...
        '20B_5'; ...
        '20B_6'; ...
        '20B_7'; ...
        '20B_8'; ...
        '20B_9'; ...
        '20B_10'; ...
        '20B_11'; ...
        '20B_12'; ...
        '20B_13'; ...
        '20B_14'; ...
        '20B_15'; ...
        '20B_16'; ...
        '20B_17'; ...
        '20B_18'; ...
        '20B_19'; ...
        '20B_20'};
    temp.optionalElectrodes = [];
    bipoleComposition = {...
        '20B_1-2',   '20B_1',  '20B_2'; ...
        '20B_2-3',   '20B_2',  '20B_3'; ...
        '20B_3-4',   '20B_3',  '20B_4'; ...
        '20B_4-5',   '20B_4',  '20B_5'; ...
        '20B_5-6',   '20B_5',  '20B_6'; ...
        '20B_6-7',   '20B_6',  '20B_7'; ...
        '20B_9-8',   '20B_7',  '20B_8'; ... %NOTE THE MISTAKE ON THIS LINE - ERROR IN CARTO3
        '20B_8-9',   '20B_8',  '20B_9'; ...
        '20B_9-10',  '20B_9',  '20B_10'; ...
        '20B_10-11', '20B_10', '20B_11'; ...
        '20B_11-12', '20B_11', '20B_12'; ...
        '20B_12-13', '20B_12', '20B_13'; ...
        '20B_13-14', '20B_13', '20B_14'; ...
        '20B_14-15', '20B_14', '20B_15'; ...
        '20B_15-16', '20B_15', '20B_16'; ...
        '20B_16-17', '20B_16', '20B_17'; ...
        '20B_17-18', '20B_17', '20B_18'; ...
        '20B_18-19', '20B_18', '20B_19'; ...
        '20B_19-20', '20B_19', '20B_20'};
    temp.bipoleNames = bipoleComposition(:,1);
    temp.bipoleElectrodeOneName = bipoleComposition(:,2);
    temp.bipoleElectrodeTwoName = bipoleComposition(:,3);
end


function temp = local_mcc_dx_names()
    temp.connector = 'MCC_DX_CONNECTOR';
    temp.bipolarNaming = 'MCC_Dx_BiPolar_';
    temp.unipolarNaming = 'MCC_Dx_UniPolar_';
    temp.electrodeNumbers = [1:3,repmat(1:6,1,8)]';
    temp.electrodeNames = {...
        'shaft1'; ...
        'shaft2'; ...
        'shaft3'; ...
        'MCC_Dx_UniPolar_1'; ...
        'MCC_Dx_UniPolar_2'; ...
        'MCC_Dx_UniPolar_3'; ...
        'MCC_Dx_UniPolar_4'; ...
        'MCC_Dx_UniPolar_5'; ...
        'MCC_Dx_UniPolar_6'; ...
        'MCC_Dx_UniPolar_7'; ...
        'MCC_Dx_UniPolar_8'; ...
        'MCC_Dx_UniPolar_9'; ...
        'MCC_Dx_UniPolar_10'; ...
        'MCC_Dx_UniPolar_11'; ...
        'MCC_Dx_UniPolar_12'; ...
        'MCC_Dx_UniPolar_13'; ...
        'MCC_Dx_UniPolar_14'; ...
        'MCC_Dx_UniPolar_15'; ...
        'MCC_Dx_UniPolar_16'; ...
        'MCC_Dx_UniPolar_17'; ...
        'MCC_Dx_UniPolar_18'; ...
        'MCC_Dx_UniPolar_19'; ...
        'MCC_Dx_UniPolar_20'; ...
        'MCC_Dx_UniPolar_21'; ...
        'MCC_Dx_UniPolar_22'; ...
        'MCC_Dx_UniPolar_23'; ...
        'MCC_Dx_UniPolar_24'; ...
        'MCC_Dx_UniPolar_25'; ...
        'MCC_Dx_UniPolar_26'; ...
        'MCC_Dx_UniPolar_27'; ...
        'MCC_Dx_UniPolar_28'; ...
        'MCC_Dx_UniPolar_29'; ...
        'MCC_Dx_UniPolar_30'; ...
        'MCC_Dx_UniPolar_31'; ...
        'MCC_Dx_UniPolar_32'; ...
        'MCC_Dx_UniPolar_33'; ...
        'MCC_Dx_UniPolar_34'; ...
        'MCC_Dx_UniPolar_35'; ...
        'MCC_Dx_UniPolar_36'; ...
        'MCC_Dx_UniPolar_37'; ...
        'MCC_Dx_UniPolar_38'; ...
        'MCC_Dx_UniPolar_39'; ...
        'MCC_Dx_UniPolar_40'; ...
        'MCC_Dx_UniPolar_41'; ...
        'MCC_Dx_UniPolar_42'; ...
        'MCC_Dx_UniPolar_43'; ...
        'MCC_Dx_UniPolar_44'; ...
        'MCC_Dx_UniPolar_45'; ...
        'MCC_Dx_UniPolar_46'; ...
        'MCC_Dx_UniPolar_47'; ...
        'MCC_Dx_UniPolar_48'};
    temp.optionalElectrodes = 3;
    bipoleComposition = {...
    'MCC_Dx_BiPolar_1',   'MCC_Dx_UniPolar_1',  'MCC_Dx_UniPolar_2'; ...
    'MCC_Dx_BiPolar_2',   'MCC_Dx_UniPolar_2',  'MCC_Dx_UniPolar_3'; ...
    'MCC_Dx_BiPolar_3',   'MCC_Dx_UniPolar_3',  'MCC_Dx_UniPolar_4'; ...
    'MCC_Dx_BiPolar_4',   'MCC_Dx_UniPolar_4',  'MCC_Dx_UniPolar_5'; ...
    'MCC_Dx_BiPolar_5',   'MCC_Dx_UniPolar_5',  'MCC_Dx_UniPolar_6'; ...
    ... % no bipole from 6 to 7
    'MCC_Dx_BiPolar_6',   'MCC_Dx_UniPolar_7',  'MCC_Dx_UniPolar_8'; ...
    'MCC_Dx_BiPolar_7',   'MCC_Dx_UniPolar_8',  'MCC_Dx_UniPolar_9'; ...
    'MCC_Dx_BiPolar_8',   'MCC_Dx_UniPolar_9',  'MCC_Dx_UniPolar_10'; ...
    'MCC_Dx_BiPolar_9',   'MCC_Dx_UniPolar_10', 'MCC_Dx_UniPolar_11'; ...
    'MCC_Dx_BiPolar_10',  'MCC_Dx_UniPolar_11', 'MCC_Dx_UniPolar_12'; ...
    ... % no bipole from 12 to 13
    'MCC_Dx_BiPolar_11',  'MCC_Dx_UniPolar_13', 'MCC_Dx_UniPolar_14'; ...
    'MCC_Dx_BiPolar_12',  'MCC_Dx_UniPolar_14', 'MCC_Dx_UniPolar_15'; ...
    'MCC_Dx_BiPolar_13',  'MCC_Dx_UniPolar_15', 'MCC_Dx_UniPolar_16'; ...
    'MCC_Dx_BiPolar_14',  'MCC_Dx_UniPolar_16', 'MCC_Dx_UniPolar_17'; ...
    'MCC_Dx_BiPolar_15',  'MCC_Dx_UniPolar_17', 'MCC_Dx_UniPolar_18'; ...
    ... % no bipole from 18 to 19
    'MCC_Dx_BiPolar_16',  'MCC_Dx_UniPolar_19', 'MCC_Dx_UniPolar_20'; ...
    'MCC_Dx_BiPolar_17',  'MCC_Dx_UniPolar_20', 'MCC_Dx_UniPolar_21'; ...
    'MCC_Dx_BiPolar_18',  'MCC_Dx_UniPolar_21', 'MCC_Dx_UniPolar_22'; ...
    'MCC_Dx_BiPolar_19',  'MCC_Dx_UniPolar_22', 'MCC_Dx_UniPolar_23'; ...
    'MCC_Dx_BiPolar_20',  'MCC_Dx_UniPolar_23', 'MCC_Dx_UniPolar_24'; ...
    ... % no bipole from 19 to 20
    'MCC_Dx_BiPolar_21',  'MCC_Dx_UniPolar_25', 'MCC_Dx_UniPolar_26'; ...
    'MCC_Dx_BiPolar_22',  'MCC_Dx_UniPolar_26', 'MCC_Dx_UniPolar_27'; ...
    'MCC_Dx_BiPolar_23',  'MCC_Dx_UniPolar_27', 'MCC_Dx_UniPolar_28'; ...
    'MCC_Dx_BiPolar_24',  'MCC_Dx_UniPolar_28', 'MCC_Dx_UniPolar_29'; ...
    'MCC_Dx_BiPolar_25',  'MCC_Dx_UniPolar_29', 'MCC_Dx_UniPolar_30'; ...
    ... % no bipole from 19 to 20
    'MCC_Dx_BiPolar_26',  'MCC_Dx_UniPolar_31', 'MCC_Dx_UniPolar_32'; ...
    'MCC_Dx_BiPolar_27',  'MCC_Dx_UniPolar_32', 'MCC_Dx_UniPolar_33'; ...
    'MCC_Dx_BiPolar_28',  'MCC_Dx_UniPolar_33', 'MCC_Dx_UniPolar_34'; ...
    'MCC_Dx_BiPolar_29',  'MCC_Dx_UniPolar_34', 'MCC_Dx_UniPolar_35'; ...
    'MCC_Dx_BiPolar_30',  'MCC_Dx_UniPolar_35', 'MCC_Dx_UniPolar_36'; ...
    ... % no bipole from 19 to 20
    'MCC_Dx_BiPolar_31',  'MCC_Dx_UniPolar_37', 'MCC_Dx_UniPolar_38'; ...
    'MCC_Dx_BiPolar_32',  'MCC_Dx_UniPolar_38', 'MCC_Dx_UniPolar_39'; ...
    'MCC_Dx_BiPolar_33',  'MCC_Dx_UniPolar_39', 'MCC_Dx_UniPolar_40'; ...
    'MCC_Dx_BiPolar_34',  'MCC_Dx_UniPolar_40', 'MCC_Dx_UniPolar_41'; ...
    'MCC_Dx_BiPolar_35',  'MCC_Dx_UniPolar_41', 'MCC_Dx_UniPolar_42'; ...
    ... % no bipole from 19 to 20
    'MCC_Dx_BiPolar_36',  'MCC_Dx_UniPolar_43', 'MCC_Dx_UniPolar_44'; ...
    'MCC_Dx_BiPolar_37',  'MCC_Dx_UniPolar_44', 'MCC_Dx_UniPolar_45'; ...
    'MCC_Dx_BiPolar_38',  'MCC_Dx_UniPolar_45', 'MCC_Dx_UniPolar_46'; ...
    'MCC_Dx_BiPolar_39',  'MCC_Dx_UniPolar_46', 'MCC_Dx_UniPolar_47'; ...
    'MCC_Dx_BiPolar_40',  'MCC_Dx_UniPolar_47', 'MCC_Dx_UniPolar_48'};
    temp.bipoleNames = bipoleComposition(:,1);
    temp.bipoleElectrodeOneName = bipoleComposition(:,2);
    temp.bipoleElectrodeTwoName = bipoleComposition(:,3);
end


