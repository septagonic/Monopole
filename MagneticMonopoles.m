clear;

for RadInd = 1:70
    R = RadInd / 70;
    I = 1;

    %Circle
    ind = 1;
    for theta = linspace(0, 2*pi, 360)
        circle(ind, 1:3) = R * [sin(theta), cos(theta), 0];
        dI(ind, 1:3) = I * R * 2*pi/360 * [cos(theta), -sin(theta), 0];
        ind = ind + 1;
    end

    NumWires = 100;
    for i = 1:NumWires
        wires{i} = circle;
        wires{i}(:, 3) = -(i - 1) / 20;
    end

    % Plotting the Magnetic Field

    ax = 1;
    ay = 16;
    az = 16;
    [x,y,z] = meshgrid(linspace(-1.5, 1.5,ay), 0, linspace(-1.5,1.5,az));
    Bx = zeros(ax, ay, az);
    By = zeros(ax, ay, az);
    Bz = zeros(ax, ay, az);
    for ind = 1:numel(wires)
        for i = 1:ax
            for j = 1:ay
                for k = 1:az
                    r = norm([x(i, j, k), y(i, j, k), z(i, j, k)]);

                    if ~(z(i, j, k) > -0.1 && z(i, j, k) < 0.1 && r > 0.9 && r < 1.1)
                        Field = WireField([x(i, j, k), y(i, j, k), z(i, j, k)], wires{ind}, dI);
            %             Field = DipoleField([x(i, j, k), y(i, j, k), z(i, j, k)], [0, 0, 0], [0, 0, 1]);
                        Bx(i, j, k) = Bx(i, j, k) + Field(1);
                        By(i, j, k) = By(i, j, k) + Field(2);
                        Bz(i, j, k) = Bz(i, j, k) + Field(3);
                    end
                end
            end
        end
    end

    % Plotting

    B = sqrt(Bx.^2 + By.^2 + Bz.^2);
    Std = std(B);
    Mean = mean(B);

    Bad = abs(B - Mean) > 2 * Std;
    Bx(Bad) = nan;
    By(Bad) = nan;
    Bz(Bad) = nan;

    clf;
    quiver3(x, y, z, Bx, By, Bz, 'LineWidth', 2, 'AlignVertexCenters', 'on');
    view(15, 35);

    hold on;
    LineWidth = 2;
    for ind = 1:numel(wires)
        plot3(wires{ind}(:, 1), wires{ind}(:, 2), wires{ind}(:, 3), 'g', 'LineWidth', LineWidth);
        LineWidth = 1;
    end
    axis equal;
    set(gca, 'Projection','perspective');
    xlim([-1.6, 1.6]);
    ylim([-1.6, 1.6]);
    zlim([-1.6, 1.6]);
    % xticks([]);
    % yticks([]);
    % zticks([]);
    xlabel('x', 'FontSize', 15);
    ylabel('y', 'FontSize', 15);
    zlabel('z', 'FontSize', 15);


    hold off;
    legend('Magnetic Field', 'Current Loop', 'FontSize', 15);
    drawnow;
end
