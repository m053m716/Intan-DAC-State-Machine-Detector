function features = getSpikeFeatures(spikes)
%% GETSPIKEFEATURES  Get first-3 PCA features from spikes

[~,score,~] = pca(spikes);
score = score./max(abs(score),[],1);
features = score(:,1:3);

end