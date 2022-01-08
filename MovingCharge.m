clear;

Frame = 1;

for n = 2 .^ (0:7)
    for t = 1:360
        R = 1;

        % Plotting the Magnetic Field

        ax = 1;
        ay = 22;
        az = 22;
        [x,y,z] = meshgrid(linspace(-2, 2, ay), 0, linspace(-2, 2, az));
        Bx = zeros(ax, ay, az);
        By = zeros(ax, ay, az);
        Bz = zeros(ax, ay, az);

        p = zeros(n, 3);
        v = zeros(n, 3);

        for i = 1:n
            theta = 2 * pi * (t / 360 + (i - 1) / n);
            p(i, :) = R * [sin(theta), cos(theta), 0];
            v(i, :) = [cos(theta), -sin(theta), 0];
        end

        for i = 1:ax
            for j = 1:ay
                for k = 1:az
                    Field = WireField([x(i, j, k), y(i, j, k), z(i, j, k)], p, v);
                    Bx(i, j, k) = Bx(i, j, k) + Field(1);
                    By(i, j, k) = By(i, j, k) + Field(2);
                    Bz(i, j, k) = Bz(i, j, k) + Field(3);
                end
            end
        end

        % Plotting

        B = sqrt(Bx.^2 + By.^2 + Bz.^2);
        Std = std(B);
        Mean = mean(B);

    %     Bad = abs(B - Mean) > 2 * Std;
    %     Bx(Bad) = nan;
    %     By(Bad) = nan;
    %     Bz(Bad) = nan;

        clf;
        quiver3(x, y, z, Bx, By, Bz, 'LineWidth', 2, 'AlignVertexCenters', 'on');
        view(15, 35);

        hold on;
        plot3(p(:, 1), p(:, 2), p(:, 3), 'g.', 'MarkerSize', 50);
        axis equal;
        set(gca, 'Projection','perspective');
        xlim([-2.1, 2.1]);
        ylim([-2.1, 2.1]);
        zlim([-2.1, 2.1]);
        xlabel('x', 'FontSize', 15);
        ylabel('y', 'FontSize', 15);
        zlabel('z', 'FontSize', 15);


        hold off;
        legend('Magnetic Field', 'Moving Charges', 'FontSize', 15);
        drawnow;
        saveas(gca, ['./Frames/Frame' num2str(Frame) '.png']);
    end
end
