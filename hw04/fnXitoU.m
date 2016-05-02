function [ mat_return ] = fnXitoU( mat_X, mat_U )
%fnXitoU find X in terms of Basis U
%   Given coordinates 'mat_X' in standard basis find in terms of basis
%   'mat_U' such that 'mat_X = mat_U * mat_return'

%     mat_return = inv(mat_U' * mat_U) * mat_U' * mat_X;
    mat_return = (mat_U' * mat_U)\ mat_U' * mat_X;

end

