function gender = genderPredictDemo(audioFilePath)

    persistent model;
    % If the model has not been loaded, load it from the file.
    if isempty(model)
        try
            data = load('GenderSVMModel.mat', 'finalModel');
            model = data.finalModel;
        catch
            error('Cannot load GenderSVMModel.mat');
        end
    end
    
    % Load audio
    [audioData, fs] = audioread(audioFilePath);
    if size(audioData,2) > 1
        audioData = mean(audioData, 2); 
    end
    
    % Extract features
    % Calculate MFCC
    coeffs = mfcc(audioData, fs, 'NumCoeffs', 12, 'LogEnergy', 'append');
    mfcc_mean = mean(coeffs, 1);
    % Calculate the average fundamental frequency pitch
    f0 = pitch(audioData, fs);
    f0 = f0(~isnan(f0));
    if isempty(f0)
        avgPitch = 0;
    else
        avgPitch = mean(f0);
    end
    featureVector = [mfcc_mean, avgPitch];
    
    predLabel = predict(model, featureVector);
    if strcmpi(char(predLabel), 'male')
        gender = 'male';
    elseif strcmpi(char(predLabel), 'female')
        gender = 'female';
    else
        gender = 'unknown';
    end
end
