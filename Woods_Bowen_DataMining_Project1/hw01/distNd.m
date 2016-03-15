function [mat_adj] = distNd(v_points)
% takes an n-length vector of 1-d points and returns an nxn adjaceny matrices of square distances

% 	v_points = [1 2 4 7 11; 3 5 8 12 17];

% 	v_points = permute(v_points, [2, 1]);
	mat_adj = repmat(v_points, [1, 1, size(v_points,1)]);
	mat_adj = permute(mat_adj, [1, 3, 2]);
    
    % Get Distance along each dimension
    mat_adj = mat_adj - permute(mat_adj, [2, 1, 3]);
    mat_adj = mat_adj.^2;
    % Find Square Distance along All dimensions
    mat_adj = sum(mat_adj,3);
%	v_points = permute(v_points, [2, 3, 1]);
%	mat_adj = repmat(v_points,[1, size(v_points,1), 1]);
%	mat_adj = v_points;
%	mat_adj = mat_adj - permute(mat_adj, [2, 1, 3]);
%	mat_adj = mat_adj.^2;
end
