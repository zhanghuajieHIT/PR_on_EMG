function data = importfile(filename, startRow, endRow)
%IMPORTFILE 将文本文件中的数值数据作为矩阵导入。
%   SCY2017032314 = IMPORTFILE(FILENAME) 读取文本文件 FILENAME 中默认选定范围的数据。
%
%   SCY2017032314 = IMPORTFILE(FILENAME, STARTROW, ENDROW) 读取文本文件 FILENAME
%   的 STARTROW 行到 ENDROW 行中的数据。
%
% Example:
%   scy2017032314 = importfile('scy20170323_14多核.txt', 1, 240);
%
%    另请参阅 TEXTSCAN。

% 由 MATLAB 自动生成于 2017/04/06 13:48:44

%% 初始化变量。
delimiter = ' ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% 将数据列作为字符串读取:
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%s%s%s%s%s%s%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式字符串读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 关闭文本文件。
fclose(fileID);

%% 将包含数值字符串的列内容转换为数值。
% 将非数值字符串替换为 NaN。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6]
    % 将输入元胞数组中的字符串转换为数值。已将非数值字符串替换为 NaN。
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % 创建正则表达式以检测并删除非数值前缀和后缀。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % 在非千位位置中检测到逗号。
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 将数值字符串转换为数值。
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% 将非数值元胞替换为 NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
raw(R) = {NaN}; % 替换非数值元胞

%% 创建输出变量
data = cell2mat(raw);
