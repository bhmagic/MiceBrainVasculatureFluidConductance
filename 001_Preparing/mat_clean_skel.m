function mat_clean_skel(dir_root)


data_name = regexp(dir_root, '[\\/]', 'split');

while isempty(data_name{end}) & ~isempty(data_name)
    data_name(end) = [];
end
if    isempty(data_name)
    error('bad dir name')
end


dir_tif = [dir_root '/binarized'];
dir_clean_skel = [dir_root '/clean_skel'];

DirTif = dir([dir_tif '/*.tif']);

FileTif=[DirTif(1).folder '/' DirTif(1).name];
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
lImage = length(InfoImage);
numberFiles = length(DirTif);

CropRange = [1, nImage; 1, mImage; 1, lImage.*numberFiles];
CropSize = CropRange(:,2);



fileIndicator = [dir_clean_skel '/clean_skel.bin' ];
fileID = fopen(fileIndicator);
S_skel = fread(fileID,'uint64');
fclose(fileID);

fileIndicator = [dir_clean_skel '/clean_radii.bin' ];
fileID = fopen(fileIndicator);
S_radii = fread(fileID,'double');
fclose(fileID);

save([ data_name{end}, '.mat'],'S_skel','S_radii', 'CropSize', '-v7.3');
