function p = synthesize_groundTruthData(fName_in,fName_out)
%% SYNTHESIZE_GROUNDTRUTHDATA Superimpose spikes on "non-spiking" channel
%
%  SYNTHESIZE_GROUNDTRUTHDATA(fName_in,fName_out);
%  p = SYNTHESIZE_GROUNDTRUTHDATA(__);
%
%  --------
%   INPUTS
%  --------
%  fName_in    :     (Char) Full filename of .rhs or .rhd file
%
%  fName_out   :     (Char) Full filename of output save Matlab file
%
%  --------
%   OUTPUT
%  --------
%  Saves a file with the synthesized amplifier data stream that has
%  superimposed spike waveforms at random sample indices. If an output is
%  requested, returns the parameter struct (p) that was used.


p = struct;
p.PK_OFFSET = 26; % samples (from start of "snip")
p.SNIP_START = 100.605; % seconds (relative to start of sample record)
p.SNIP_STOP  = 100.609; % seconds (relative to start of sample record)
p.N_INSERTED_SPIKES = 1500; % Number of spikes to insert
p.HPF_FC = 300; % High pass filter cutoff

p.SPIKELESS_CHANNEL = 28;
p.SPIKEY_CHANNEL = 18;

if nargin < 1
   fName_in = '..\data\R18-159_2019_02_01_2_190201_143203.rhs';
end
p.FNAME_IN = fName_in;

if nargin < 2
   fName_out = '..\data\R18-159_2019_02_01_2_GeneratedGroundTruthData.mat';
end

[~,~,ext] = fileparts(fName_in);
switch ext
   case {'.rhs','.rhd'}
      [amplifier_data,fs,t] = read_Intan_RHS2000_file(fName_in);
      rawData = HPF(amplifier_data(p.SPIKELESS_CHANNEL,:),fs,p.HPF_FC);
      idx = (t>p.SNIP_START) & (t<p.SNIP_STOP);
      snip = HPF(amplifier_data(p.SPIKEY_CHANNEL,:),fs,p.HPF_FC);
      snip = snip(idx);
      
      % scale voltage - had originally picked a spike that had very large
      % voltage, want to be more conservative to demonstrate that even with
      % a "good" choice of pure threshold that the FSM is more selective
      % (e.g. doesn't make sense to just arbitrarily set the threshold
      %       voltage too low and say the FSM beats it...)
      snip = snip./max(abs(snip));
      snip = snip.*150; 
   case '.mat'
      load(fName_in,'rawData','fs','t','snip');
   otherwise
      error('Unsupported fName_in type: %s.',ext);
end

vec = 1:numel(snip);
vec = vec - p.PK_OFFSET;

% Reuse old peak indices for consistency (if accidentally ran again after
% other analyses, for example)
if exist(fName_out,'file')==0
   iPeak = randi(numel(rawData)-numel(snip)-1,1,p.N_INSERTED_SPIKES)...
            +p.PK_OFFSET;
else
   in = load(fName_out,'iPeak');
   if numel(in.iPeak)==p.N_INSERTED_SPIKES
      iPeak = in.iPeak;
   else
      iPeak = randi(numel(rawData)-numel(snip)-1,1,p.N_INSERTED_SPIKES)...
               +p.PK_OFFSET;
   end
end

data = rawData;
for ii = 1:numel(iPeak)
   data(vec + iPeak(ii)) = rawData(vec + iPeak(ii)) + snip;
end

[pname,fname,ext] = fileparts(fName_out);
if isempty(ext)
   ext = '.mat';
end
if exist(pname,'dir')==0
   mkdir(pname);
   fprintf('\nMade new directory:\n->\t%s\n',pname);
end
fName_out = fullfile(pname,[fname ext]);
p.FNAME_OUT = fName_out;
save(fName_out,...
   'rawData','data','fs','t','iPeak','snip','-v7.3');

close all force;

%% Make spike snippet figure
fig = figure('Name','Spike Snippet',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.4 0.4],...
   'Color','w');

plot(vec,snip,'Color','k','LineWidth',2,'LineStyle','-');
grid on;
box on;
xlim([min(vec) max(vec)]);
xlabel('Sample Index','FontName','Arial','FontSize',14,'Color','k');
ylabel('Amplitude (\muV)','FontName','Arial','FontSize',14,'Color','k');
title('Inserted Spike Snippet','FontName','Arial','FontSize',16,'Color','k');
savefig(fig,sprintf('%s_groundTruthSnippet.fig',fname));
saveas(fig,sprintf('%s_groundTruthSnippet.png',fname));

yl = get(gca,'YLim');
yl = [yl(1)-150, yl(2)+150]; % offset slightly

%% Make "processing" figure
fig2 = figure('Name','Processing Steps',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8],...
   'Color','w');

idx = (t > 100) & (t < 100.25);

subplot(3,1,1);
plot(t(idx),rawData(idx),'Color','k','LineWidth',2);
title('Non-spiking Channel','FontName','Arial','FontSize',16,'Color','k');
xlim([min(t(idx)) max(t(idx))]);
ylim(yl);

subplot(3,1,2);
stem(t(iPeak),ones(size(iPeak)),'Color','b','LineWidth',2,'Marker','none');
xlim([min(t(idx)) max(t(idx))]);
ylim([0 1]);
title('Known Spike Insertion Times','FontName','Arial','FontSize',16,'Color','k');

subplot(3,1,3);
plot(t(idx),rawData(idx),'Color','k','LineWidth',2); hold on;
plot(t(idx),data(idx),'Color','b','LineWidth',1.5,'LineStyle',':');
title('Synthesized Data','FontName','Arial','FontSize',16,'Color','k');
xlim([min(t(idx)) max(t(idx))]);
ylim(yl);

end