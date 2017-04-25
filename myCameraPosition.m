function [orient, loc] = myCameraPosition(E, cameraParams1, cameraParams2, inlierPoints1,inlierPoints2)
%MYCAMERAPOSITION Summary of this function goes here
%   Detailed explanation goes here

    intrinsic1 = cameraParams1.IntrinsicMatrix;
    intrinsic2 = cameraParams2.IntrinsicMatrix;
    [U, D, V] = svd(E);
    %make rank 2
    est = (D(1,1) + D(2,2)) / 2;
    D(1,1) = est;
    D(2,2) = est;
    D(3,3) = 0;
    
    %reestimate E
    E = U * D * V';
    %perform svd again
    [U, ~, V] = svd(E);
    
    %define W and Z as in report
    W=[0 -1 0; 
       1 0 0; 
       0 0 1];
    Z = [0 1 0; 
        -1 0 0; 
         0 0 0];
    
    %define two rotation matrices 
    R1 = U * W' * V';
    R2 = U * W * V';
    
    %make valid rotations
    if det(R1) < 0
        R1 = -R1;
    end
    if det(R2) < 0
        R2 = -R2;
    end
    %define translation as third col
    t = U(:,3)';
    
    %find the right solution using triangulation 
    neg = zeros(1, 4);
    ninliers=size(inlierPoints1, 1);
    
    %set the left camera's origin and rotation
    camMat0 = ([eye(3);[0 0 0]]*intrinsic1)';
    M1 = camMat0(1:3, 1:3);
    c1 = - M1 \ camMat0(:,4);
    %{
    Loop through all the solutions
    i=1 -> R=R1', t=-t 
    i=2 -> R=R1', t=t
    i=3 -> R=R2', t=-t
    i=4 -> R=R2', t=t
    %}
    for i = 1:4
        if i>2
            R=R2';
        else
            R=R1';
        end
        t=-t;
        %set parameters of second matrix relative to first
        camMat1 = ([R; t]*intrinsic2)';
        M2 = camMat1(1:3, 1:3);
        c2 = -M2 \ camMat1(:,4);
        
        %loop through all the inliers
        for j = 1:ninliers
            a1 = M1 \ [inlierPoints1(j, :), 1]';
            a2 = M2 \ [inlierPoints2(j, :), 1]';
            A = [a1, -a2];
            alpha = (A' * A) \ A' * (c2 - c1);
            p = (c1 + alpha(1) * a1 + c2 + alpha(2) * a2) / 2;
            m1(j, :) = p';
        end
        m2 = bsxfun(@plus, m1 * R, t);
        neg(i) = sum((m1(:,3) < 0) | (m2(:,3) < 0));
    end
    
    %select the right solution, with minimum inliers on the wrong side
    [~, idx] = min(neg);
    if idx<3
        R=R1';
    end
    if mod(idx,2)==1
        t=-t;
    end
    t = t ./ norm(t);

    orient = R;
    loc = t;
    
    
end

