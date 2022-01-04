% Returns the magnetic field at the probe points
% probe is a matrix of coordinates to find the field at
% wire is a matrix of successive coordinates of a current carrying wire
% dI is the current in each section of wire

function Field = WireField(probe, wire, dI)
    mu = 1;
    r = probe - wire;
    Field = mu / (4*pi) * sum(cross(dI, r) ./ sum(r.^2, 2).^(3/2));
end
