function params = getFSMParams(name)
%% GETFSMPARAMS   Load parameters for a block or set of blocks
%
%  params = GETFSMPARAMS(name);
%
%  --------
%   INPUTS
%  --------
%    name      :     Cell array of block names or just string of single
%                       block.
%
%  --------
%   OUTPUT
%  --------
%   params     :     Parameters output that is cell array of size of name
%                       or else a single struct that contains DAC threshold
%                       parameters.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% ITERATE ON CELL ARRAY
if iscell(name)
   params = cell(size(name));
   for ii = 1:numel(name)
      params{ii} = getFSMParams(name{ii});
   end
   return;
end

%%
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

in = load(fullfile(in_dir,[name '_Params.mat']),'params');

params = in.params;

end

