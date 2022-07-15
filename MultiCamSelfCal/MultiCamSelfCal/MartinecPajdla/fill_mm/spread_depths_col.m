% Mdepthcol is column of JIM with depths which is spread by this
% function to a submatrix with some zeros
% passing the index matrix of the depth
function submatrix = spread_depths_col(Mdepthcol,depthsIcol)

m = size(depthsIcol,1);  %row
n = 1;                   %col 

known_depths      = find(depthsIcol ~= 0);
% find the matrix that the depths are known

if ~isempty(known_depths)    
  rows              = k2i(known_depths);
  submatrix(rows,n) = Mdepthcol(rows); 
  n=n+1;
end

for i=setdiff(1:m, known_depths)
  %for row that are in 1:m and not in known_depth
  %find this row
  rows              = k2i(i);
  submatrix(rows,n) = Mdepthcol(rows); 
  % append it to the submatrix
  n=n+1;
end

