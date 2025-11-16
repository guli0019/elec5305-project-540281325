function [features, labels] = extractFeatures(datasetPath, mfccDim, usePitch)
% Extract the feature vectors and labels for all audio files in the dataset

    % List all .wav audio files within the dataset directory
    audioFiles = dir(fullfile(datasetPath, '**', '*.wav'));
    numFiles = length(audioFiles);
    
    % Determine the feature length based on whether it is included in the pitch.
    if usePitch
        if mfccDim == 39
            featureLength = 39 + 1;  
        else
            featureLength = mfccDim + 1; 
        end
    else
        featureLength = mfccDim;
    end
    
    features = zeros(numFiles, featureLength);
    labels   = cell(numFiles, 1);
    
    for i = 1:numFiles
        filePath = fullfile(audioFiles(i).folder, audioFiles(i).name);
        fileName = audioFiles(i).name;   
        
        % Tag by the first letter of the filename
        firstChar = lower(fileName(1));
        if firstChar == 'm'
            labels{i} = 'male';
        elseif firstChar == 'f'
            labels{i} = 'female';
        else
            labels{i} = 'unknown'; 
        end
        
        % Load audio
        [audioData, fs] = audioread(filePath);
        if size(audioData, 2) > 1
            audioData = mean(audioData, 2);  
        end
        
        % Extract MFCC features
        if mfccDim == 39
            [coeffs, delta, deltaDelta] = mfcc(audioData, fs, ...
                                               'NumCoeffs', 12, ...
                                               'LogEnergy', 'append');
            mfcc_mean        = mean(coeffs, 1);
            delta_mean       = mean(delta, 1);
            deltaDelta_mean  = mean(deltaDelta, 1);
            mfcc_features    = [mfcc_mean, delta_mean, deltaDelta_mean]; % 1x39
        else
            if mfccDim == 13
                coeffs = mfcc(audioData, fs, 'NumCoeffs', 12, 'LogEnergy', 'append');
            else
                coeffs = mfcc(audioData, fs, 'NumCoeffs', 8, 'LogEnergy', 'Ignore');
            end
            mfcc_features = mean(coeffs, 1);   
        end
        
        % Add Pitch Feature
        if usePitch
            f0 = pitch(audioData, fs);
            f0 = f0(~isnan(f0) & f0 > 0);
            if isempty(f0)
                avgPitch = 0;
            else
                avgPitch = mean(f0);
            end
            fileFeatures = [mfcc_features, avgPitch];
        else
            fileFeatures = mfcc_features;
        end
        
        features(i, :) = fileFeatures;
    end
    
    labels = categorical(labels);
end
