function [mat_adj] = dist1d(v_points)
% takes an n-length vector of 1-d points and returns an nxn adjaceny matrices of square distances

	v_points = permute(v_points, [2, 1]);
	mat_adj = repmat(v_points,[1, length(v_points)]);

	mat_adj = mat_adj - permute(mat_adj, [2, 1]);
	mat_adj = mat_adj.^2;
end
