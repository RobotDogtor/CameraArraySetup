addpath ./OutputFunctions
%drawscene(Xe,Ce,Re,3,'cloud','reconstructed points/camera setup');
drawscene(in.Xe,in.Ce,in.Re,4,'cloud','reconstructed points/camera setup only inliers are used',config.cal.cams2use);


% first, use camera_0 as the original point, the find the display between
% original and centre of camera0

translation_to_original = [0,0,0]' - in.Ce(:, 1);
%duplicate the vector to the same number of camera, and same number of
%inlier points

camera_translation = repmat(translation_to_original,1,18);
% the camera translation the is Ce + camera_translation

translated_camera_centre = in.Ce + camera_translation;

%drawscene(in.Xe,translated_camera_centre,in.Re,4,'cloud','translated reconstructed camera setup only inliers are used',config.cal.cams2use);

% then calculate the points translation

points_translation = repmat(translation_to_original, 1, size(in.Xe,2));
Homogeneous_points_translation = [points_translation;repmat(0, 1, size(in.Xe,2))];

translated_points = in.Xe + Homogeneous_points_translation;
x=linspace(0, 1); % Gaussian Process N(0,1)
y=linspace(0, 0); % same ~N(0,1)
z=linspace(0, 0); %  Random Uniform distribution
drawscene(translated_points,translated_camera_centre,in.Re,4,'cloud','translated reconstructed points/camera setup only inliers are used',config.cal.cams2use);
plot3(x, y, z)
x=linspace(0, 0); % Gaussian Process N(0,1)
y=linspace(0, 1); % same ~N(0,1)
z=linspace(0, 0); %  Random Uniform distribution
plot3(x, y, z)

x=linspace(0, 0); % Gaussian Process N(0,1)
y=linspace(0, 0); % same ~N(0,1)
z=linspace(0, -1); %  Random Uniform distribution
plot3(x, y, z)
%drawscene(in.Xe,in.Ce,in.Re,4,'cloud','reconstructed points/camera setup only inliers are used',config.cal.cams2use);

% the use the vector camera0->camera5 as Y axis direction and camera0 ->
% camera4 as X axis direction


vector_5_0 = (in.Ce(:,6) - in.Ce(:,1))
vector_4_0 = (in.Ce(:,5) - in.Ce(:,1))


% assume the ground truth distance between camera_0 to camera_4 is 1m
% assume the ground truth distance between camera_0 to camera_5 is 0.8m
% assume the ground truth distance bwtween camera_0 to camera_1 is 1.4m
% the calculate the scale for for X and Y distance 
% rotate the vector_4_0 to Y axis

sum_vector = translated_camera_centre(:, 6) - translated_camera_centre(:, 1) + ...
             translated_camera_centre(:, 5) - translated_camera_centre(:, 1) + ...
             translated_camera_centre(:, 2) - translated_camera_centre(:, 1)



real_scaled_sum_vector = (translated_camera_centre(:, 6) - translated_camera_centre(:, 1)) * (0.8/norm(translated_camera_centre(:, 6)- translated_camera_centre(:, 1))) + ...
                         (translated_camera_centre(:, 5) - translated_camera_centre(:, 1)) * (1.1/norm(translated_camera_centre(:, 5) - translated_camera_centre(:, 1))) + ...
                         (translated_camera_centre(:, 2) - translated_camera_centre(:, 1)) * (1.4/norm(translated_camera_centre(:, 2) - translated_camera_centre(:, 1)))


% then the scale vector should be

scaled_vector = real_scaled_sum_vector ./ sum_vector

scaled_matrix= repmat(scaled_vector, 1, CAMS);

scaled_camera = translated_camera_centre .* scaled_matrix;

scaled_matrix_point = repmat(scaled_vector, 1, size(in.Xe, 2));

Homogeneous_scaled_matrix_point = [scaled_matrix_point;repmat(1, 1, size(in.Xe,2))];

scaled_points = translated_points .* Homogeneous_scaled_matrix_point; 
drawscene(scaled_points,scaled_camera,in.Re,4,'cloud','translated reconstructed points/camera setup only inliers are used',config.cal.cams2use);



