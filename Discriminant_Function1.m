function [ g ] = Discriminant_Function1( x, m, c)
   g = -0.5*( log( det(c+0.0000001*(eye(size(c)))) ) / log( exp(1) ) ) -0.5*(x-m)*( inv(c+0.0000001*(eye(size(c)))) )*(x-m)';
   %g = -0.5*( log( det(c) ) / log( exp(1) ) ) -0.5*(x-m)*( inv(c) )*(x-m)';
