%depths_estimation Determine scale factors (proj. depths) of PRMM.
% what is Ilamb
function [lambda, Ilamb] = depth_estimation(M,F,ep,rows,central)

[m n] = size(M); m = m/3;   

if central
  j  = central; 
  ps = 1:n;
  Ilamb(j,:) = ~isnan(M(3*j,:));
  %j will be central row, and Ilamb will be a index row where 1 represent
  %with entity and 0 represent NaN
else
  j = 1;
  b = subseq_longest(~isnan(M(1:3:end,:)));  % return the longest continuous sub col
  for p = 1:n
    Ilamb(b(p),p) = ~isnan(M(3*b(p),p)); % =1 is sufficient if b(p) is correct
    
    %Ilamb: represent 
  end
end

lambda = ones(m,n); %start with 1 for all lambda


for i = setdiff(1:m, j)
  if ~central
    j = i-1;
    ps = find(b <= j);
  end
  G  = reshape(F(rows(i),rows(j),1:3,1:3),3,3);
  epip = reshape(ep(rows(i),rows(j),1:3),3,1);
  for p = ps
    Ilamb(i,p) = Ilamb(j,p) & ~isnan(M(3*i,p)); 
    
    if Ilamb(i,p)
      u           = cross(epip,M(3*i-2:3*i,p));    	%q(i,p)
      v           = G*M(3*j-2:3*j,p);			%q(j,p)
      lambda(i,p) = u'*v/norm(u)^2*lambda(j,p);   % method mentioned in D.M & T.P
    else
      lambda(i,p) = 1; %so that it's possible to recover scene at the end
    end
  end
end
