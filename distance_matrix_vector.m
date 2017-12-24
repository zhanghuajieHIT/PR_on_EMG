function distance_value=distance_matrix_vector(matrix_value,vector_value)
% 计算矩阵中各行与某一向量的距离（欧式距离）
% matrix_value是一个矩阵，每行都代表一个向量
% vector_value是一个向量
NUM=size(matrix_value,1);
distance_value=zeros(NUM,1);
for i=1:NUM
    distance_value(i)=pdist([matrix_value(i,:);vector_value]);
    
end

end