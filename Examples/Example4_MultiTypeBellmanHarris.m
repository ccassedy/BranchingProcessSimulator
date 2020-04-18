%% EXAMPLE 4: Multi-type Bellman-Harris with normal life lengths
addpath('../')  % adds the function BranchingProcessSimulator to the path
sim_num=1000;   % number of simulations to perform
T=20;   % the horizon is 20 time units and we simulate the branching process in [0, T].
h=0.1;    % the time step is 1 unit of time
omega=T;
S=[(1-normcdf(0:h:omega, 2, 0.5)')./(1-normcdf(0, 2, 0.5)), ...     % type 1 has normal life length 
    (1-normcdf(0:h:omega, 3, 1)')./(1-normcdf(0, 3, 1))];  % all 3 types of the particles die exactly after 1 unit of time
Z_0=[10,10]';     % the initial population starts with 10 particles of type 1 and 10 of type 2

U=[0.9,0.1; 0.1, 0.9]';         % mutation probabilities matrix
H=[1/3,0,2/3; 3/4,0,1/4]';      % type 1 is supercritical, type 2 - subcritical, type 3 - critical
% there is no immigration and no point process in this example

% we are not interested in the age structure, as it is trivial in this case
[Z, Z_types] = BranchingProcessSimulator(sim_num, T, h, S, H, U, Z_0, 'GetAgeStructure', false);
[Z_mean, Z_lower, Z_upper, Z_median]=confInterval(Z, 0.10);

%% Shows the simulations with confidence intervals
line_wd=2.5;
figure('visible','on', 'Units','pixels','OuterPosition',[0 0 1280 1024]);
set(gca,'FontSize',16)
hold on
plot(0:h:T, Z', 'Color', [0.7, 0, 0,0.05]);
h_mean=plot(0:h:T, Z_mean, 'Color', [0, 0, 0, 0.5], 'LineWidth', line_wd);
h_median=plot(0:h:T, Z_median, '--', 'Color', [0, 0, 0, 0.5], 'LineWidth', line_wd);
h_CI=plot(0:h:T, Z_lower, '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
plot(0:h:T, Z_upper, '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
h_sims=plot(0, Z(1,1),'-', 'Color', [0.7, 0, 0], 'LineWidth', line_wd);
legend([h_sims(1), h_mean, h_median, h_CI], 'Simulations', 'Mean', 'Median', '90% conf. interval', 'Location', 'NorthWest')
ylabel('Total Population Count')
xlabel('Time')
print('./figures/Example4_fig1', '-dpng', '-r0')

%% draw the average number of particles by type
figure('visible','on', 'Units','pixels','OuterPosition',[0 0 1280 1024]);
set(gca,'FontSize',16)
hold on
area(0:h:T, squeeze(mean(Z_types,1))')
colormap([0:(1/(size(Z_types,2)-1)):1; zeros(2, size(Z_types,2))]')
legend(strcat({'Type '}, cellstr(num2str((1:size(Z_types,2))'))), 'Location', 'NorthWest')
ylabel('Population Count by Type')
xlabel('Time')
print('./figures/Example4_fig2', '-dpng', '-r0')

% save
save(strcat('Example4_', num2str(sim_num)))
