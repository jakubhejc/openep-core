function [Y, iX] = transOpenEP2ImgPos(userdata, openEp3DMesh, openEpUacMesh, img3DMesh, imgUacMesh, varargin)
% TRANSOPENEP2IMGPOS Translates electrode positions from OpenEP space to Imaging space
%
% Usage:
%   [Y, Ix] = transOpenEP2ImgPos(userdata, openEp3DMesh, openEpUacMesh, img3DMesh, imgUacMesh, varargin)
% Where:
%   userdata      - an OpenEP dataset
%   openEp3DMesh  - on OpenEP geometry, presented as a mesh structure,
%                   (see io_readCARPMesh.m) 
%   openEpUacMesh - an OpenEP geometry converted into UACs (universal atrial
%                   co-ordinates), presented as a mesh structure
%   img3DMesh     - an imaging geometry, presented as a mesh structure
%   imgUacMesh    - an imaging geometry converted into UACs, presented as 
%                   a mesh structure
%   Y             - 3D Cartesian co-ordinates of the electrode positions in imaging space
%   iX            - indexes into userdata.electric.X and identifies the
%                   electrodes which were translated:
%                       userdata.electric.X(iX,:) => Y
%
% TRANSOPENEP2IMGPOS accepts the following parameter-value pairs
%   'plot'         {false} | true
%           - specifies whether to draw a figure illustrating the process                   
%   'elecsamples'  {[]} | integer array
%           - integer array identifying the electrodes in
%             userdata.electric.X which will be drawn, if not empty
%
% TRANSOPENEP2IMGPOS Uses the Universal Atrial Co-ordinates to convert 
% electrode positions between OpenEP and Imaging co-ordinate systems. For 
% example; this function can be used to create surface and 3D co-ordinates 
% representing all of the recording electrode positions during a clinical 
% case, relative to an imaging dataset such as MRI or CT.
%
% This translation is performed using the UACs to give the "surface-point-to
% -surface-point" translation between OpenEP and Imaging datasets. In order
% to determine the distance from the surface, i.e. how far internal to the 
% surface the new points should be in the Imaging space, the following 
% algorithm is used. 
%   1. Lines are drawn between every vertex of the OpenEP mesh and the
%      barycentre of the OpenEP mesh.
%   2. For each electrode, the closest line is identified and the position
%      of the electrode is projected perpendicularly onto this line,
%      bisecting the line.
%   3. The ratio of the distance from the surface to the bisection (S1) to the
%      total length of the line (S2) is calculated.
%   4. Every line is uniquely identifiable by its surface vertex
%      attachment. The indices of these vertices is used to convert 3D 
%      locations into 2D locations (openEp3DMesh -> openEpUacMesh)
%   5. Vertex indices in the MRI mesh are then identified by finding the
%      closest vertices in the imaging unfold mesh (openEpUacMesh -> imgUacMesh)
%   6. The barycentre of the imaging mesh is calculated and the lengths of 
%      these lines are calculated (S3). 
%   7. Finally, every electrode is translated the relevant distance along 
%      the relevant surface-to-barycentre line, where this distance is 
%      given by S3 * S1/S2
%
% Author: Steven Williams (2021)
% Modifications -
%
% Info on Code Testing:
% ---------------------------------------------------------------
%  load('/media/stw11/Data/StevenModellingData/Models/Carto_153_NR/Carto/Study_1_07_02_2017_19-42-07_1-Map.mat');
%  mOpenEp3D = io_readCARPMesh('/media/stw11/Data/StevenModellingData/Models/Carto_153_NR/Carto/Labelled');
%  mOpenEpUac = io_readCARPMesh('/media/stw11/Data/StevenModellingData/Models/Carto_153_NR/Carto/Labelled_Coords_2D_Rescaling_v3_C');
%  mImg3D = io_readCARPMesh('/media/stw11/Data/StevenModellingData/Models/Carto_153_NR/Model_16/Labelled');
%  mImgUac = io_readCARPMesh('/media/stw11/Data/StevenModellingData/Models/Carto_153_NR/Model_16/Labelled_Coords_2D_Rescaling_v3_C');
%  [X, surfX] = translateOpenEP2ImagingPositions(userdata, mOpenEp3D, mOpenEpUac, mImg3D, mImgUac)
% ---------------------------------------------------------------
%
% ---------------------------------------------------------------
% code
% ---------------------------------------------------------------

nStandardArgs = 5;
plot = false;
elecsamples = ':';
if nargin > nStandardArgs
    for i = 1:2:nargin-nStandardArgs
        switch varargin{i}
            case 'plot'
                plot = varargin{i+1};
            case 'elecsamples'
                elecsamples = varargin{i+1};
        end
    end
end

% Load the co-ordinates of the electrode positions and identify electrodes internal to the imaging mesh
X_orig = getElectrogramX(userdata);
tr = getTriangulationFromMeshStruct(openEp3DMesh, 'region', 11, 'scale', 'um', 'type', 'trirep');
iX = getMappingPointsWithinMesh(userdata, 'mask', tr);
X = X_orig(iX,:); % X is now all the points of interest but DOES NOT index into userdata.electric

% 1. Find the barycentre lines
tempUserdata.surface.triRep = tr;
C_ep = getCentreOfMass(tempUserdata);
tr = getOpenEPSubsetFromImgMap(userdata, openEp3DMesh, 11);
vertices = tr.X;

if plot
   figure
   hS = drawMap(userdata, 'type', 'none');
   hold on
   for i = 1:10:size(vertices,1)
      line( [C_ep(1,1) vertices(i,1)], [C_ep(1,2) vertices(i,2)], [C_ep(1,3) vertices(i,3)], 'linewidth', 1.5, 'color', 'k'); 
      vert4points(i,:) = vertices(i,:);
   end
   vert4points(vert4points(:,1)==0,:) = [];
   plot3(vert4points(:,1), vert4points(:,2), vert4points(:,3), '.', 'color', colorBrewer('r'), 'markersize', 15);
   plotsphere(C_ep(1,1), C_ep(1,2), C_ep(1,3),colorBrewer('r'),1,16);
end


% 2 & 3. For every point of interest X; find the barycentre line that it is
%    closest to; and the percentage distance along this line from the
%    OpenEP surface to the barycentre that the point lies
% relevantVertex; distanceRatio
for i = 1:length(X)
    distance = NaN(length(vertices),1);
    for j = 1:length(vertices)
        distance(j) = point_to_line_segment_distance(X(i,:), vertices(j,:), C_ep);
    end
    [~, iVertex4Electrode(i)] = nanmin(distance);
    
%     if plot
%         h(1) = plotTag(userdata, 'coord', X(i,:), 'color', 'g'); % plot the electrode recording position
%         h(2) = plotTag(userdata, 'coord', C_ep, 'size', 2);% plot the barycentre
%         h(3) = plotTag(userdata, 'coord', vertices(iVertex4Electrode(i),:), 'size', 2); % plot the identified surface point
%         % draw a line
%         h(4) = line( [vertices(iVertex4Electrode(i),1), C_ep(1)], [vertices(iVertex4Electrode(i),2), C_ep(2)], [vertices(iVertex4Electrode(i),3), C_ep(3)] ...
%             , 'color', 'k' ...
%             , 'linewidth', 3);
%         pause; delete(h);
%     end
    
    lineSegmentLength(i) = lineLength([vertices(iVertex4Electrode(i),:); C_ep]);
    surf2ElectrodeDistance(i) = lineLength(    [vertices(iVertex4Electrode(i),:); X(i,:)]    );
    
    relevantVertex(i,1:3) = vertices(iVertex4Electrode(i),:);
    distanceRatio(i) = surf2ElectrodeDistance(i) / lineSegmentLength(i);
end

% 4. Convert 3D locations to 2D locations (openEp3DMesh -> openEpUacMesh)
iVertex_openEp3D = findclosestvertex(openEp3DMesh.Pts/1000, relevantVertex);
coord_openEpUac = openEpUacMesh.Pts(iVertex_openEp3D,:);
if plot
    figure
    trOpenEpUacMesh = getTriangulationFromMeshStruct(openEpUacMesh);
    hSurf = trisurf(trOpenEpUacMesh);
    set(hSurf, 'facecolor', [.5 .5 .5], 'edgecolor', 'none');
    hold on
    for i = 1:numel(elecsamples)
        plotsphere(coord_openEpUac(elecsamples(i),1), coord_openEpUac(elecsamples(i),2), coord_openEpUac(elecsamples(i),3),colorBrewer('r'),1/100,16);
    end
end

% 6. Find the index of the closest node to this location in the MRI-UAC
%    mesh; this defines the barycentre line of interest
iVertex_mImgUac = findclosestvertex(imgUacMesh.Pts, coord_openEpUac);

% 7. Calculate the barycentre of the MRI-3D mesh
tempUserdata.surface.triRep = getTriangulationFromMeshStruct(img3DMesh, 'type', 'trirep');
C_img = getCentreOfMass(tempUserdata);

% 8. calcualte vectors from each node toward the barycentre
baryVectors = repmat(C_img, size(img3DMesh.Pts(iVertex_mImgUac))) - img3DMesh.Pts(iVertex_mImgUac,:);

% 9. calculate the length of these vectors
baryVectorLengths = vecnorm(baryVectors,2,2);

% 10. create unit vectors for use in calculation
unitVectors = baryVectors./baryVectorLengths;

% 11 Calculate the line between the node of interest and the barycentre of
%    the MRI-3D mesh.
scaledVectors = unitVectors .* repmat(distanceRatio', 1, 3) .* baryVectorLengths;

Y = img3DMesh.Pts(iVertex_mImgUac,:) + scaledVectors;

X = X * 1000;
    
    
end