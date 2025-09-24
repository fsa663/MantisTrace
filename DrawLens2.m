function [] = DrawLens2(Q, dnp, ~)
    Q1 = Q(:,:,1);
    Q2 = Q(:,:,2);
    Q3 = Q(:,:,3);

    clrz = 'gymcb'; % Color options
    ic = round(rand(1,1) * 4 + 1); % Random color index

    % Generate indices for corner points
    [x,y] = meshgrid(1:size(Q1, 2), 1:size(Q1, 1));

    % Check if all corner points are non-occluded
    cnd = ~dnp & ~dnp(:, [2:end end]) & ~dnp([2:end end], :) & ~dnp([2:end end], [2:end end]);
    cnd(1,:)=0;cnd(end,:)=0;cnd(:,1)=0;cnd(:,end)=0; % delete edges

    % Extract corner points for non-occluded elements
    corners_x1 = Q1(sub2ind(size(Q1), y(cnd), x(cnd)));
    corners_x2 = Q1(sub2ind(size(Q1), y(cnd), x(cnd)+1));
    corners_x3 = Q1(sub2ind(size(Q1), y(cnd)+1, x(cnd)));
    corners_x4 = Q1(sub2ind(size(Q1), y(cnd)+1, x(cnd)+1));

    corners_y1 = Q2(sub2ind(size(Q2), y(cnd), x(cnd)));
    corners_y2 = Q2(sub2ind(size(Q2), y(cnd), x(cnd)+1));
    corners_y3 = Q2(sub2ind(size(Q2), y(cnd)+1, x(cnd)));
    corners_y4 = Q2(sub2ind(size(Q2), y(cnd)+1, x(cnd)+1));

    corners_z1 = Q3(sub2ind(size(Q3), y(cnd), x(cnd)));
    corners_z2 = Q3(sub2ind(size(Q3), y(cnd), x(cnd)+1));
    corners_z3 = Q3(sub2ind(size(Q3), y(cnd)+1, x(cnd)));
    corners_z4 = Q3(sub2ind(size(Q3), y(cnd)+1, x(cnd)+1));


    % Reshape corner points for patch creation
    corners_x = [corners_x1, corners_x2,corners_x4,corners_x3];
    corners_y = [corners_y1, corners_y2,corners_y4,corners_y3];
    corners_z = [corners_z1, corners_z2,corners_z4,corners_z3];

    % Draw patches
    patch(corners_x', corners_y', corners_z', clrz(ic));

end

