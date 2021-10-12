function info = loadprecision_modelgroups(filename)
% LOADPRECISION_MODELGROUPS loads a Precision file.
% Usage:
%   info = loadprecision_modelgroups(filename)
% Where:
%   filename is a full path to a file.
%   info.dxgeo is a structure containing the geometry and the labels
%   info.dataElement is 'modelgroups' - used to identify the data in
%                           compatibility with loadprecision_wavefile
%
% LOADPRECISION_MODELGROUPS ..........
% If filename does not contain a file with a valid format, info is left
% empty and a warning generated with msgID = 'LoadPrecision:InvalidFile'.

% Author: Nick Linton (2009)
% Modifications
%   Steven Williams 2017    Convert to Precision
%   Nick Linton 2017        Updated to info.dataElement and info.dxgeo in
%                           order to keep compatibility with other
%                           loadprecision_ code.
%
% Info on Code Testing:
% ---------------------------------------------------------------
%
% ---------------------------------------------------------------
%
% ---------------------------------------------------------------
% code
% ---------------------------------------------------------------

info = [];

[~,~,ext] = fileparts(filename);
if ~strcmpi(ext, '.xml')
    warning('LoadPrecision:InvalidFile','LOADPRECISION_MODELGROUPS: .xml file expected');
    return
end

[tree , treeNames] = xml_read(filename);

% check version
if ~strcmpi(tree.DIFHeader.Version, 'SJM_DIF_5.0')
    warning('LoadPrecision:InvalidFile','LOADPRECISION_MODELGROUPS: unexpected version number.')
    return
end

for i = 1:tree.DIFBody.Volumes.ATTRIBUTE.number
    if isfield(tree.DIFBody.Volumes.Volume(i), 'Vertices')
        dxgeo(i).vertices = str2num(tree.DIFBody.Volumes.Volume(i).Vertices.CONTENT);
    end
    if isfield(tree.DIFBody.Volumes.Volume(i), 'Polygons')
        dxgeo(i).triangles = str2num(tree.DIFBody.Volumes.Volume(i).Polygons.CONTENT);
    end
    if isfield(tree.DIFBody.Volumes.Volume(i), 'Normals')
        dxgeo(i).normals = str2num(tree.DIFBody.Volumes.Volume(i).Normals.CONTENT);
    end
    if isfield(tree.DIFBody.Volumes.Volume(i), 'COMMENT')
        dxgeo(i).comment = tree.DIFBody.Volumes.Volume(i).COMMENT;
    end
    if isfield(tree.DIFBody.Volumes.Volume(i).ATTRIBUTE, 'name')
        dxgeo(i).name = tree.DIFBody.Volumes.Volume(i).ATTRIBUTE.name;
    end
    
    %get the labels
    if isfield(tree.DIFBody.Labels, 'Label')
        for j = 1:tree.DIFBody.Labels.ATTRIBUTE.number
            dxgeo(i).labels(j).xyz = tree.DIFBody.Labels.Label(j).CONTENT;
            dxgeo(i).labels(j).name = tree.DIFBody.Labels.Label(j).ATTRIBUTE;
        end
    end
end

info.dataElement = 'modelgroups';
info.dxgeo = dxgeo;
info.fileLoaded = filename;
end

