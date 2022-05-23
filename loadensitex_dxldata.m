function [info, points, egms, dataHeaderRowLine] = loadensitex_dxldata(filename)
% LOADPRECISION_DXLDATA loads the map stored in an EnSiteX DxL file.
% Usage:
%   [info, points, egms] = loadprecision_dxldata(filename)
% Where:
%   filename is the filename
%   info - contains header information about the file
%       info.dataElement
%       info.study
%       info.studySegment
%       info.startTime
%       info.endTime
%       info.header
%       *info.numPoints
%       *info.fileIndices
%       *info.mapId
%       *info.segmentDataLength
%       *info.exportedSeconds
%       info.sampleFreq
%       *info.CFE_PP_Sensitivity
%       *info.CFE_Width
%       *info.CFE_Refractory
%       info.userComments
%   points - contains map data
%   egms - contains electrogram data
%
% LOADENSITE_DXLDATA Columns in egms correspond to indices in points
%
% Author: Steven Williams (2022)
% Modifications -

% Info on Code Testing:
% ---------------------------------------------------------------
% test code
% ---------------------------------------------------------------

% ---------------------------------------------------------------
% code
% ---------------------------------------------------------------

info = [];
points = [];
egms = [];

[~, ~, ext] = fileparts(filename);
if ~strcmpi(ext, '.csv')
    warning('LoadPrecision:InvalidFile',...
        'LOADENSITEX_DXLDATA: .csv file expected');
    return
end

fileID = fopen(filename, 'r');
if fileID == (-1)
    error('LOADENSITEX_DXLDATA: Could not open file.')
end
cleanupFile = onCleanup(@()fclose(fileID));


% We are going to read the data in chunks from the file and then
% process it. Assume that the first chunk has enough data in it to span
% the entire 'header' region.

% read the data in manageable chunks
maxBytes = 100000; % enough data to cover the header
fseek(fileID, 0, 'bof'); % move to the beginning of the file
if maxBytes > filebytes2end(fileID)
    maxBytes = filebytes2end(fileID);
end
[fData, fDataSize] = fread(fileID, maxBytes, '*char');
fData = fData(1:fDataSize)';

% do the prechecks and return if bad
if ~loadensitex_prechecks(fData, 'DxL')
    return
end

% READ THE HEADER
% ---------------
% The 'header' finishes at the end of the last line starting with "****,"
[ind1, ~] = regexp(fData, '****','start','end');
if isempty(ind1)
    error('End of header not found. Double check that maxBytes is large enough to cover header.')
end
indEndofHeader = ind1(end);
header = fData(1:indEndofHeader);

% Parse the header
info = parse_header(header, 'dxl');

% READ THE MAP DATA
% -----------------
% The map data starts at the line that starts 'pt number:' and ends before
% the line that starts 'Seg data len:';
ind1 = regexp(fData, 'pt number:', 'start');
ind2 = regexp(fData, 'Seg data len:', 'start');

if isempty(ind1) || isempty(ind2)
    points = [];
else
    % Parse the map data: this section is left over from Precision export
    % formats and may not work for EnSiteX export formats
    mapdatastring = fData(ind1:ind2-2);
    points = local_parsemapdata(mapdatastring, info.numPoints);
end



% READ THE ELECTROGRAMS
% ---------------------

% Read the header line at info.dataStartRow
fseek(fileID, 0, 'bof')
for i = 1:info.dataStartRow-2
    fgetl(fileID);
end
dataHeaderRowLine = fgetl(fileID);
dataHeaders = strsplit(dataHeaderRowLine, ',');
if strcmpi(dataHeaderRowLline(end), ',')
    dataHeaders(end) = [];
end

% If wave data exists; i.e. if sample frequency has been set, we will read
% the wave data separately
if isfield(info, 'sampleFreq')
    headersAsNumbers = str2double(dataHeaders);
    tfNumHeaders = ~isnan(headersAsNumbers);
    iWaveColumns = find(tfNumHeaders);
end



disp('made  it')
return


% Work out the length of data
nSamples = round(info.sampleFreq * info.exportedSeconds); %the number of sampes in the exported segment
columnsToRead = true([1, info.numPoints+1]);
columnsToRead(1) = false;

% The electrorgam data starts at the second line beginning with 'rov trace:'
ind = regexp(fData, 'rov trace', 'start');
dataStartBytes = 1*(ind(2)-1); %1 byte for each character.
fseek(fileID, dataStartBytes, 'bof'); %put the file marker at the start of the relevant data

% Parse the electrogram data
egms = local_parsedata(fileID, columnsToRead, nSamples);

end


function points = local_parsemapdata(mapdatastring, numPoints)
% create cell data arrays of fieldnames and data
C = textscan(mapdatastring, repmat('%s',1,numPoints+1), 'delimiter', ',', 'CollectOutput', true);
C = C{1};
fieldNames = C(:,1);
fieldNames = regexprep(fieldNames,'[^\w'']',''); %remove whitespace and punctuation
rawdata = C(:,2:end);
rawdata([1, 7:23, 25, 27:28],:) = cellfun(@(s) {str2double(s)},rawdata([1, 7:23, 25, 27:28],:)); %convert strings to doubles

% create the points structure
for iPt=1:size(rawdata,2)
    for iFn=1:length(fieldNames)
        points(iPt).(fieldNames{iFn}) = rawdata{iFn,iPt};
    end
end
end

function egmData = local_parsedata(fileID, columnsToRead, nSamples)
    %   nSamples - the number of samples
    %   columnsToRead - logical array indicating which columns will be read
    %   fileID - the file ID
    %
    % CREATE THE FORMAT STRING
    % The first column contains [,], all other columns can be read as %f format.
    
    if columnsToRead(1)
        error('Code not written to read first column of data.')
    end
%     formatFirstCol = uint8(','); % Discards the first column, which is a literal [,]
%     columnRead = uint8('%f,'); % A token that will be read
%     columnLeave = uint8('%*f,'); % A token that will be discarded
    nColToRead = sum(columnsToRead);
%     nColToLeave = numel(columnsToRead) - nColToRead - 1;
        % -1 because we are dealing with first column separately
%     totalLength = numel(formatFirstCol)...
%         + nColToRead*numel(columnRead)...
%         + nColToLeave*numel(columnLeave);
%     format = zeros(1, totalLength, 'uint8');
%     format(1:numel(formatFirstCol)) = formatFirstCol;
%     lastPlace = numel(formatFirstCol);
%     for i = 2:numel(columnsToRead)
%         if columnsToRead(i)
%             format(lastPlace + (1:numel(columnRead))) = columnRead;
%             lastPlace = lastPlace + numel(columnRead);
%         else % Don't read
%             format(lastPlace + (1:numel(columnLeave))) = columnLeave;
%             lastPlace = lastPlace + numel(columnLeave);
%         end
%     end
%     format = char(format); % Finally, we have made the format string
%     format = [format, char(10)];
%     format(end-1) = []; % Remove the trailing comma

    % READ IN THE DATA IN CHUNKS
%     allBytesToRead = filebytes2end(fileID);

    % Go through the file and read the data; if you come across a string use
    % this as the variable name, appended with _egm

    maxBytes = 10 * 1024 * 1024; % read in max 10MBytes at a time
    remainder = [];
    allData = zeros(nColToRead*nSamples, 1, 'single');
    lastDataPosition = 0;


e = [];
egmVarName = [];
while isempty(e)
    % Read chunk of data
    remainingBytes = filebytes2end(fileID);
    bytesToRead = min([maxBytes, remainingBytes+1]); 
        % The +1 ensures we read into the end of the file.
    dataChunk = fread(fileID, bytesToRead, '*char');
    fileText = [  remainder ; dataChunk  ];

    % Determine if we are at the end of the electrograms which stop before
    % the line beginning "FFT spectrum is available ..."
    e = regexp(fileText',... 
        'FFT spectrum is available for FFT maps only',...
        'start');

    % Get the indices of any electrogram titles - we will store these to
    % use as the variable names; and remove them from the text to allow all
    % the data to be read in a single block which will later be divide

    % Matlab regexp
    %[ind1, ind2] = regexp(fileText', '\w*\s*\w*:', 'start', 'end');

    % Don't bother with regexp at all - much faster:
    ind1 = [];
    ind2 = strfind(fileText', ':');
    if ~isempty(ind2)
        ind1=zeros(size(ind2));
        for i=1:numel(ind2)
            counter=ind2(i)-7; %str(index-7) gives 'X' if str='X trace:'
            dcounter=ind2(i);
            if counter==0
                counter=counter+1;
            end
            % Count back to start of word:
            while ~isspace(fileText(counter))
                counter = counter-1;
                if counter == 0
                    break
                end
            end
            dcounter=dcounter-counter-1;
            ind1(i)=ind2(i)-dcounter;
        end
    end

    if ~isempty(e)
        ind2(ind1>e) = [];
        ind1(ind1>e) = []; %#ok<AGROW>
    end
    if ~isempty(ind1)
%         egmVarNameTemp = cell(numel(ind1), 1);
        for iVarName = 1:numel(ind1)
            egmVarNameTemp{iVarName} = fileText(ind1(iVarName):ind2(iVarName))';
        end
        egmVarName = [egmVarName egmVarNameTemp];
        clear egmVarNameTemp;
        iRemove = [];
        for iVarName = 1:numel(ind1)
            endOfLine = ind1(iVarName);
            while fileText(endOfLine) ~= char(10)
                endOfLine = endOfLine + 1;
            end
            iRemove = [iRemove ind1(iVarName):endOfLine];
        end
        fileText(iRemove) = [];
    end

    % Remove the hanging line
    endOfLastLine = numel(fileText);
    while fileText(endOfLastLine) ~= char(10)
        endOfLastLine = endOfLastLine - 1;
    end
    remainder = fileText((endOfLastLine+1):end); %work out hanging line
    fileText = fileText(1:(endOfLastLine-1)); %truncate to last full line

    % Read the data using sscanf
    ft2=strrep(fileText',',',' ');
    [data, count] = sscanf(ft2, '%f');

    if rem(count,nColToRead) ~=0
        error('Unexpected amount of data read.')
    end
    allData(lastDataPosition + (1:count)) = data;
    lastDataPosition = lastDataPosition + count;
    clear data
end

% Check the right amount of data has been read
nSignals = numel(egmVarName);
if lastDataPosition ~= nColToRead*nSamples*nSignals
    beep()
    warning('Not all samples read.')
end

% REARRANGE THE DATA
% Fread and sscanf reads the data into a long column (not row) and we have
% read all the signals into one array
allData = reshape(allData, nColToRead, nSamples*nSignals);
allData = allData';

egmVar = regexprep(egmVarName, '[^\w'']','');
iRow = 1:nSamples;
for iSig = 1:numel(egmVarName)
    egmData.(egmVar{iSig}) = allData(iRow+((iSig-1)*nSamples),:);
end

end