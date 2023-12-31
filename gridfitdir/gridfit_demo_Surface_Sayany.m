%% Return stator losses, stator core area and stator voltage     
%
fid =  fopen([pwd '\populations.Sayany.750\G45.Sayany.750p.txt'],'r');  
datacell = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'Delimiter', '\t');
%datacell = gen45;
data = [];
for i=1:16
    datacell{i} = gen45{i}(5000:end);
    data = [data cell2mat(datacell(i))];
end    

degMLoss = 1;
degMega = 10^6;
% The rated values
xnom = 1.068922;
ynom = 1/15676;
znom = (1008360+46113+17089)*(15750*ynom)^2; % = 1071562

data(data(:, 14) < .7*xnom, :) = [];
data(data(:, 14) > 1.2*xnom, :) = [];
data(data(:, 15) > 1.2*znom, :) = [];
data(data(:, 16) > 1.2*ynom, :) = [];
data(data(:, 16) < .85*ynom, :) = [];

for i=1:16
    datacell{i} = data(:,i);
end  

x = datacell{14}./xnom; % stator core area 
y = datacell{16}./ynom; % stator voltage
z = datacell{15}./znom; % stator losses 
%% Turn the scanned point data into a surface
k = 16;
gx = .50 : k*1e-3 : 2.50;
gy = .72 : k*2.5e-4 : 1.22;

gx = .6 : k*1e-3 : 1.6;
gy = .8 : k*2.5e-4 : 1.3;


g=gridfit(x,y,z,gx,gy);
figure
surf(gx, gy, g)
shading interp
material dull 
grid on
grid minor
c = lines(16);
colormap(c);
colorbar
c = colorbar;
%w = c.LineWidth;
c.Position  =  [0.05 0.12 0.02 0.75];


%% Turn mesh
kg = .5;
kx = 50*kg; ky = 25*kg;
[mg, ng] = size(g);
kgx = gx(1:kx:ng); kgy = gy(1:ky:mg);
kxg = g(:, 1:kx:ng);
kyg = g(1:ky:mg, :);
hold on
surf(kgx, gy, kxg, 'EdgeColor', 'k','FaceColor','none', 'MeshStyle', 'column')
surf(gx, kgy, kyg, 'EdgeColor', 'k','FaceColor','none', 'MeshStyle', 'row')
hold off
box

%% Plot settings
%line(x, y, z, 'marker', '.', 'markersize', 10, 'linestyle', 'none', 'Color','r');
line([0.5 1], [1 1], [1 1], 'Color', 'w', 'LineWidth', 3, 'LineStyle', '-');
line([1 1], [.5 1], [1 1], 'Color', 'w', 'LineWidth', 3, 'LineStyle', '-');
line([1 1], [1 1], [.5 1], 'Color', 'w', 'LineWidth', 3, 'LineStyle', '-');
set(gca,'CameraPosition',[1.8  0.9 1.8])
set(gca, 'outerposition',[0.025 0 1 1])
% 2.2
%xlabel('Stator core volume, p.u.', 'Position', [.1 1 -2.3]);
%ylabel('Rotor current, p.u.','Position', [2 1 -.5]);
%zlabel('Iron loss, p.u', 'Position',[-.4 1 .4]);

xlabel({'����� ����������';'�������, �.�.'}, 'Position', [1.7 .82 0]);
ylabel('��� ������, �.�.','Position', [2.1 .95 0]);
zlabel({'������'; '� �����, �.�.'}, 'Position',[.5 .88 2.3]);
set(get(gca,'zlabel'), 'rotation', 0)
set(gcf,'position',[300,300,660,600])
set(gcf,'position',[100,100,660,600])


%title 'The Pareto surface in multicriteria hydro-generator parameters optimization. Generation 14'
set(get(gca,'XLabel'), 'FontSize', 12)
set(get(gca,'YLabel'), 'FontSize', 12)
set(get(gca,'ZLabel'), 'FontSize', 12)
set(get(gca, 'Title'), 'FontSize', 12)
caxis([(0.7)^degMLoss (1.5)^degMLoss])
axis([0.5, 2.0, 0.85, 1.15, (0.0)^degMLoss, (2.0)^degMLoss]);
axis([0.6, 1.4, 0.95, 1.05, (0.0)^degMLoss, (2.0)^degMLoss]);

set(gca,'fontsize',12)
hold on
scatter3(1, 1, 1, 20, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w', 'LineWidth', 1);
l = light('Position',[1.2  1.3 30]);
