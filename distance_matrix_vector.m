function distance_value=distance_matrix_vector(matrix_value,vector_value)
% ��������и�����ĳһ�����ľ��루ŷʽ���룩
% matrix_value��һ������ÿ�ж�����һ������
% vector_value��һ������
NUM=size(matrix_value,1);
distance_value=zeros(NUM,1);
for i=1:NUM
    distance_value(i)=pdist([matrix_value(i,:);vector_value]);
    
end

end