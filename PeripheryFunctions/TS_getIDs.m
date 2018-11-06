function [IDs,notIDs] = TS_getIDs(theKeyword,whatData,tsOrOps)
% TS_getIDs   Retrieve IDs of time series (or operations) in an hctsa dataset
%               using keyword matching.
%
%---INPUTS:
% theKeyword, the keyword to match on (string).
% whatData, the source of the hctsa dataset (e.g., a filename, cf. TS_LoadData).
%           (default: 'norm')
% tsOrOps, whether to retrieve IDs for TimeSeries ('ts', default) or
%           Operations ('ops').
%
%---OUTPUTS:
% IDs, a vector of IDs matching the keyword constraint provided.
%
%---EXAMPLE USAGE:
% >> ts_IDs = TS_getIDs('noisy','norm','ts');
% This retrieves the IDs of time series in 'HCTSA_N.mat' (specifying 'norm') that
% contain the keyword 'noisy'.
%
% >> op_IDs = TS_getIDs('entropy','norm','ops');
% This retrieves the IDs of operations in HCTSA_N.mat that have been tagged
% with the keyword 'entropy'.

% ------------------------------------------------------------------------------
% Copyright (C) 2018, Ben D. Fulcher <ben.d.fulcher@gmail.com>,
% <http://www.benfulcher.com>
%
% If you use this code for your research, please cite the following two papers:
%
% (1) B.D. Fulcher and N.S. Jones, "hctsa: A Computational Framework for Automated
% Time-Series Phenotyping Using Massive Feature Extraction, Cell Systems 5: 527 (2017).
% DOI: 10.1016/j.cels.2017.10.001
%
% (2) B.D. Fulcher, M.A. Little, N.S. Jones, "Highly comparative time-series
% analysis: the empirical structure of time series and their methods",
% J. Roy. Soc. Interface 10(83) 20130048 (2013).
% DOI: 10.1098/rsif.2013.0048
%
% This work is licensed under the Creative Commons
% Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of
% this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send
% a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
% California, 94041, USA.
% ------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Check inputs, set defaults:
%-------------------------------------------------------------------------------
if nargin < 2
    whatData = 'norm';
end
if nargin < 3
    tsOrOps = 'ts';
end

%-------------------------------------------------------------------------------
% Load data:
%-------------------------------------------------------------------------------
[~,TimeSeries,Operations,theDataFile] = TS_LoadData(whatData);

%-------------------------------------------------------------------------------
% Match time series/operations on an input keyword:
%-------------------------------------------------------------------------------
switch tsOrOps
case 'ts'
    theDataTable = TimeSeries;
case 'ops'
    theDataTable = Operations;
otherwise
    error('Specify ''ts'' or ''ops''');
end

% The cell of comma-delimited keyword strings:
theKeywordCell = theDataTable.Keywords;

% Split into sub-cells using comma delimiter:
Keywords = SUB_cell2cellcell(theKeywordCell);

% Find objects with a keyword that matchees that given:
matches = cellfun(@(x)any(ismember(theKeyword,x)),Keywords);

% Return the IDs of the matches:
IDs = theDataTable.ID(matches);

% Check for empty:
if isempty(IDs)
    warning('No matches to ''%s'' found in %s',theKeyword,theDataFile)
end

% Also provide IDs not matching the constraint, if required
if nargout > 1
    notIDs = setxor(IDs,theDataTable.ID);
end

end
