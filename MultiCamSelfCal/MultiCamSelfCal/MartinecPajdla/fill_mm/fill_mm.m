%fill_mm Proj. reconstruction from MM.
%
%  [P,X, u1,u2, info] = fill_mm(M, opt)
%
%         M (Ws.(:, inliers.idx))
%    The concept of the central image strength and of the sequence is used.
%
%  Parameters:
%    M .. measurement matrix (MM) with homogeneous image points with NaNs
%         standing for the unknown elements in all three coordinates
%         size(M) = [3m, n]
%    opt .. options with default values in ():
%           .strategy(-1) ..   -1  choose the best of the following: 
%                               0  sequence
%                              -2  all strategies with the central image
%                            1..m  the central image of the corresponding No.
%           .create_nullspace.trial_coef(1)
%           .create_nullspace.threshold(.01)
%           .tol(1e-6) .. tolerance on rows of well computed basis of MM,
%                         see approximate
%           .no_factorization(0) .. if 1, no factorization performed
%           .metric(1) .. the metric used for reproj. error
%                    1 .. square root of sum of squares of x- and y-coordinates
%                    2 .. std of x- and y-coordinates
%           .verbose(1) .. whether display info
%
%  Return parameters:
%    P, X .. estimated projective structure (X) and motion (P)
%    u1, u2 .. unrecovered images (u1) and points (u2)
%              size(P) = [3*(m-length(u1)),4], size(X) = [4,n-length(u2)]
%    info.omega .. info, e.g. predictor functions, about the used strategy

function [P,X, u1,u2, info] = fill_mm(M, opt)
% the strategy method based on the passing parameters opt
if ~isfield(opt, 'strategy'), opt.strategy = -2; end
if ~isfield(opt, 'create_nullspace') | ...
      ~isfield(opt.create_nullspace, 'trial_coef')
  opt.create_nullspace.trial_coef = 1; end % 10
if ~isfield(opt.create_nullspace, 'threshold')
  opt.create_nullspace.threshold  = .0001; end
if ~isfield(opt, 'tol'), opt.tol = 1e-6; end
if ~isfield(opt, 'no_factorization'),
  opt.no_factorization = 0; end
if ~isfield(opt, 'metric'),
  opt.metric = 1; end
if ~isfield(opt, 'verbose'),
  opt.verbose = 1; end
if ~isfield(opt.create_nullspace, 'verbose')
  opt.create_nullspace.verbose  = opt.verbose; end

if ~opt.verbose, fprintf('Repr. error in proj. space (no fact.');
  if ~opt.no_factorization, fprintf('/fact.'); end
  if ~opt.no_BA, fprintf('/BA'); end; fprintf(') is ... '); end
  
nbeg = size(M,2);  %number of column
ptbeg = find(sum(~isnan(M(1:3:end,:))) >= 2); u2beg = setdiff(1:nbeg,ptbeg);
%ptbeg: number of non NaN value on each column, keep the column that at
%least has 2 knowndata

%u2beg: setdiff(A, B) value in A and not in B
%u2beg: record the indext that has only 1 or zero known data
M = M(:,ptbeg);  
%effective columns (more than 2 known value)
if ~isempty(u2beg), 
  fprintf('Removed correspondences in < 2 images (%d):%s\n', length(u2beg),...
          sprintf(' %d', u2beg(1:min(20, length(u2beg))))); end
% remove the frame that has only 1 or zero points

[m n] = size(M); m = m/3; M0 = M;
cols = []; recoverable = inf; Omega = [];

% names of strategies
switch opt.strategy
 case -1    % use all strategies
  Omega{end+1}.name = 'seq';   % set the first strategy to sequence
  for i = 1:m, Omega{end+1}.name = 'cent'; Omega{end}.ind = i;end
 case 0     % sequence
  Omega{end+1}.name = 'seq';
 case -2    % use all strategies with the central image
  for i = 1:m, Omega{end+1}.name = 'cent'; Omega{end}.ind = i; end
 otherwise  % the central image of corresponding No.
  Omega{end+1}.name = 'cent'; Omega{end}.ind = opt.strategy;
end

% the first iteration the Omega(strategy sequence) should be
% seq, cent, cent, cent, cent, cent, cent.......
%
%
added = 1; I = ~isnan(M(1:3:end,:)); info = []; iter = 0;
% I: index matrix that record: 1->the entity is not NaN
%                              0->the entity is NaH
% recoverable =inf 
while recoverable > 0 ... % not all parts of JIM are restored
      &  added            % something was added during the last trial
  if opt.verbose,
      %start with recovered column = empty column []
    disp(sprintf('%d (from %d) recovered columns...', length(cols), n)); end
  
  added = 0; iter = iter + 1; if iter > 5, keyboard; end
  %if there is no added value after 10 iterations, determine the block
  
  
  [S, F, strengths] = compute_predictions(Omega, I); % for all stragegies

  % try the best strategy(s)
  while (~added  &  max(F) > 0)  |  ...
        sum(F==0) == length(F)  % when no data missing, only rescaling needed

    % choose the actually best strategy (sg)
    Omega_F = find(F==max(F));  
    %based on the paper principle 1 that the more points are filled within
    %one step, the smaller the expected error
    if length(Omega_F) == 1, sg = Omega_F; else
      if opt.verbose, disp(sprintf('Omega_F:%s.', sprintf(' %d',Omega_F))); end
      ns = S(Omega_F);
      Omega_S = Omega_F(find(ns==max(ns))); if length(Omega_S) >1 & opt.verbose
        disp(sprintf('Omega_S:%s.', sprintf(' %d', Omega_S)));
        disp(['!!! Maybe some other criteria is needed to choose' ...
              ' the better candidate (now the 1st is taken)! !!!']); end
      sg = Omega_S(1);  % an arbitrary of Omega_S
    end
    
    
    [rows, cols, central, info] = set_rows_cols(Omega, sg, F, S, strengths, ...
                                                       I, info, opt);
    % if seq: the camera0 will start as central image, row and col will be
    % the row and col of the original M matrx
    % if cent: a specific camera will be central camera, and, row and col will be 
    % the good row and good col based on the central camera
    %F(sg) = -1; % "don't try this strategy anymore"    
    if opt.verbose, disp(sprintf('Used images:%s.', sprintf(' %d', rows))); end
    
    [Mn,T] = normM(M); % normalize the image by using transformation matrix F
    
    [Pn,X, lambda, u1,u2, info] = fill_mm_sub(Mn(k2i(rows),:), ...
                                              Mn(k2i(rows),cols), ...
                                             find(central==rows),opt,info);
    % using the transformed matrix and the sub transformed matrix with good
    % col, and central row
    
    
    save('lambdafile.mat','lambda');
    if length(u1)==length(rows) & length(u2)==length(cols)
      if opt.verbose, disp('Nothing recovered.'); end
    else
      if opt.verbose
        if ~isempty(u1), disp(sprintf('u1 = %s', num2str(u1))); end
        if ~isempty(u2) & ~isempty(Pn),disp(sprintf('u2 = %s',num2str(u2)));end
      end
      
      % say (un)recovered in indices of whole M not only M(k2i(rows),cols)
      r1 = rows(setdiff(1:length(rows),u1)); 
      u1 = setdiff(1:m, r1);
      r2 = cols(setdiff(1:length(cols),u2)); 
      u2 = setdiff(1:n, r2);
      P  = normMback(Pn, T(r1,:,:));
      R = P*X;

      % fill holes: use the original data when known as much as possible rather
      %             than the new data
      if isempty(r1) | isempty(r2), fill = []; else,
      fill = find(isnan(M(3*r1, r2)) ... % some depths (lambda) could not
                                     ... % have been computed L2depths
                  | (~isnan(M(3*r1,r2)) & isnan(lambda))); end
      M_ = M(k2i(r1),r2); M_(k2i(fill)) = R(k2i(fill)); M(k2i(r1),r2) = M_;

      added = length(fill); I = ~isnan(M(1:3:end,:));
      recoverable = sum(sum(I(:,find(sum(I) >= 2))==0));
      if opt.verbose, 
        disp(sprintf('%d points added, %d recoverable points remain.', ...
                     added, recoverable)); end

      info.err.no_fact = dist(M0(k2i(r1),r2), R, opt.metric);
      if opt.verbose,
        fprintf('Error (no factorization): %f\n', info.err.no_fact);
      else, fprintf(' %f', info.err.no_fact); end
 
    end
  end
  
  if ~added  &  sum(~I(:)) > 0 % impossible to recover anything
    P=[];X=[]; u1=1:m; u2=1:nbeg; info.opt = opt; return; end
end

if length(r1)<2, % rank cannot be 4
  P=[];X=[]; u1=1:m; u2=1:nbeg; info.opt = opt; return; end

if ~opt.no_factorization
  if opt.verbose
    fprintf(1,'Factorization into structure and motion...'); tic; end

  % depths estimated from info.Mdepths (which is approximated by R)
  Mdepths_un = normMback(info.Mdepths, T(r1,:,:));
  lambda(length(r1), length(r2)) = NaN;
  for i = find(~isnan(M0(3*r1, r2)))', 
    lambda(i) = M0(k2i(i)) \ Mdepths_un(k2i(i)); end
  for i = 1:length(r1), B(k2i(i),:) = M(k2i(i),:).*([1;1;1]*lambda(i,:)); end
  fill = find(isnan(M0(3*r1, r2))); B(k2i(fill)) = R(k2i(fill));
  [Bn,T] = normM(B);
  opt.info_separately = 0; 
  Bn = balance_triplets(Bn, opt);
  if opt.verbose, fprintf(1,'(running svd...'); tic; end
  [u,s,v] = svd(Bn); 
  s1 = sqrt(s(1:4,1:4)); 
  P = u(:,1:4)*s1;
  X = s1 * v(:,1:4)';

  if opt.verbose, disp([num2str(toc) ' sec)']); end
  P = normMback(P, T);

  info.err.fact = dist(M0(k2i(r1),r2), P*X, opt.metric);
  if opt.verbose, fprintf('Error (after factorization): %f\n', info.err.fact);
  else, fprintf(' %f', info.err.fact); end
end

u2 = union(u2beg, ptbeg(u2));
info.opt = opt;

function [S, F, strengths] = compute_predictions(Omega, I)
% compute predictor functions for all strategies

for sg = 1:length(Omega)
  switch Omega{sg}.name
   case 'seq'
     % if the strategy is 'seq', the get the longest subsequence, with
     % index and length
    [b, len]   = subseq_longest(I);  
    Isub = I; % for now, epipolar geometry is supposed to be computable
              % through the whole sequence. See also lower.
    F(sg)      = sum(Isub(:) == 0); % number of NaN value
    S(sg)      = sum(len);          % total total length of 
   case 'cent'
    i = Omega{sg}.ind;
    % use i as the central camera
    % and then evaluate the strength
    strengths{i} = strength(i, I, 1);
    % F(sg): number of filled point in one iteration
    % S(sg): number of estimated depth for on iteration
    F(sg)      = strengths{i}.strength(1);  % or 2   
    S(sg)      = strengths{i}.num_scaled; 
  end
end  


function result = strength(central, I, general)

%strength Compute the central image strength of an image.
%
%  result = strength(central, I, general)
%  
%  Parameters:
%    `general' is set to logical true when generalized Jacos' algorithm for
%        unknown projective depths is supposed.
%
%    `result' is a stucture containing following fields
%      `strength'   is computed strength
%      `good_rows'  are the useful rows for the used submatrix
%      `good_cols'        ""       columns        ""
%      `Isub'        is the "good" submatrix where ones are known points
%      `num_scaled' is the number of scaled points

if nargin<3, general=0; end


[m n]     = size(I);  % 1-> there is value
                      % 0-> NaN 
good_rows = [];

%display(central);
% fundamental matrices
 for i = setdiff(1:m, central)
     %for the rest of cameras except the central camera
     % find how many points does the rest camera has in common
     % if the number of points is larger than 8
     % then this row will be able to use for calculating the fundamental
     % matrix between central camera and subordinary cameras. 
   common = find(I(i,:) & I(central,:));
   if length(common) >= 8   %7 for 7-points algorithm
     good_rows = [good_rows i];  %merge this row to the collection of good rows

% only common points
     if ~general
      I(i,setdiff(1:n,common)) = zeros(1,n-length(common)); end
   else
     I(i,:) = zeros(1,n);
   end
 end
% 
good_rows = union(good_rows,central);

% Jacobs' algorithm needs at least 2 points in each column 
% and its generalized form for unknown depths as well
  present       = sum(I);
  % good column requires that the number of points can be seen at least 2
  % cameras. 
  good_cols     = find(present >= 2); 

Isub            = I(good_rows,good_cols);  
% the submatrix that is good for fundamental matrix

result.strength = [ sum(Isub(:)==0) size(Isub,1)*size(Isub,2) ];
% the strength of using the central image is calculated by 
% [number of zero, total entities in submatrix]


% find scaled image points (those in the columns known in the
% central image)
  scaled_cols = find(Isub(find(central==good_rows),:)==1);
  % scaled_cols will find entities that central and good_rows that has data
  % and the depth could be estimated by using fundamental matrix and
  % epipolar geometry
  
  num_scaled  = 0;
  for i=1:length(good_rows),
    %for each rol, find the value common to both array
    scaled     = intersect(find(Isub(i,:)==1), scaled_cols);
    num_scaled = num_scaled + length(scaled); % the number of scaleable 
  end
  
result.good_rows  = good_rows;
result.good_cols  = good_cols;
result.Isub       = Isub;
result.num_scaled = num_scaled;  


function [rows, cols, central, info] = set_rows_cols(Omega, sg, F, S, ...
                                                      strengths, I,info, opt)

[m n] = size(I);    %size of index matrix
switch Omega{sg}.name
 case 'seq'     
  rows    = 1:m; % for now, epipolar geometry is supposed to be computable
                 % through the whole sequence. See also above.
  cols    = 1:n; % ""
  Isub    = I(rows, cols);
  central = 0;
 case 'cent'
  central = Omega{sg}.ind;  % make the current image as central
  rows = strengths{central}.good_rows;  % for this current central camera, setup the good rows
  cols = strengths{central}.good_cols;  % for this current central camera, setup the good cols
  Isub = strengths{central}.Isub;       % for this current central camera, submatrix are using for calculating the 
                                        %depth of image
end

info.omega = Omega{sg}; info.omega.F = F(sg); info.omega.S = S(sg);
sequence = set_sequence(central, S(sg), Isub, I, opt);
if ~isfield(info,'sequence'), info.sequence{1} = sequence;
else,                         info.sequence{end+1} = sequence; end


function sequence = set_sequence(central, num_scaled, Isub, I, opt)

sequence.central = central;
if isempty(Isub)
  sequence.scaled = 0;
  sequence.missing = 0;
  sequence.used_pts = 0;
else
  sequence.scaled = num_scaled / sum(Isub(:)) * 100;
  sz = size(Isub);
  sequence.missing = sum(Isub(:) == 0) / (sz(1)*sz(2)) * 100;
  sequence.used_pts = sum(Isub(:)) / sum(I(:)) * 100;
end
if opt.verbose
  disp(sprintf(['Image %d is the central image, image points: %.2f %%' ...
                ' scaled, %.2f %% missing, %.2f %% used.'], central, ...
               sequence.scaled, sequence.missing, ...
               sequence.used_pts)); end

%normM Normalize the image coordinates by applying transformations normu.
function [Mr, T] = normM(M)


for k = 1:size(M,1)/3

  Tk           = normu(M(k2i(k),find(~isnan(M(3*k,:)))));
  Mr(k2i(k),:) = Tk * M(k2i(k),:); T(k,1:3,1:3) = Tk;
end

%normMback Adapt projective motion, to account for the normalization norm.
function P = normMback(P, T)

for k = 1:size(P,1)/3
  Tk    = reshape(T(k,1:3,1:3),3,3);
  P(3*k-2:3*k,:) = inv(Tk)*P(3*k-2:3*k,:);
end
