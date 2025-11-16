% Train the final gender recognition model using the entire dataset and save the model for use by the demonstration function

clear; clc;
rng(0);

% Data set path
datasetPath = 'E:\Matlab Project\ELEC5305 Final Project\Dataset';

mfccDim = 13;
usePitch = true;

% Extract features and labels for the entire dataset
[X_all, Y_all] = extractFeatures(datasetPath, mfccDim, usePitch);

% Train the final model using all the data
finalModel = fitcsvm(X_all, Y_all, 'KernelFunction', 'linear');

% Save the model
save('GenderSVMModel.mat', 'finalModel');
fprintf('Final model trained and saved to GenderSVMModel.mat\n');

audioFiles = dir(fullfile(datasetPath, '**', '*.wav'));
if ~isempty(audioFiles)
    sampleLabels = cell(length(audioFiles),1);
    for i = 1:length(audioFiles)
        fileName = audioFiles(i).name;
        firstChar = lower(fileName(1));
        if firstChar == 'm'
            sampleLabels{i} = 'male';
        elseif firstChar == 'f'
            sampleLabels{i} = 'female';
        else
            sampleLabels{i} = 'unknown';
        end
    end
    
    femaleIdx = find(strcmp(sampleLabels, 'female'), 1);
    maleIdx   = find(strcmp(sampleLabels, 'male'), 1);
    demoIndices = [femaleIdx, maleIdx];
    
    for idx = demoIndices
        if isempty(idx), continue; end  
        filePath = fullfile(audioFiles(idx).folder, audioFiles(idx).name);
        fprintf('\nDemo - test file: %s\n', audioFiles(idx).name);
        result = genderPredictDemo(filePath);
        fprintf('Predicted gender: %s\n', result);
    end
end

