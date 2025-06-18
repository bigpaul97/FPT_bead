function [] = bead_diffusion_in_potential(tra)
% This code simulates a bead 3D diffusion in a quadratic potential
% It is equivalent to the Rouse model of one bead connected to a wall at the origin
% Initial condition is set to be at a distance of r_0
% We add a sink at radius L, the contact distance
% Once the bead touches L, restart the simulation with the initial condition.

rng(tra)

%% Hyperparameters
init_sep = 50e-9; % r_0
contact_sep = 10e-9; % L
dt = 1e-6; % simulation time step
total_contactN = 1e3; % number of contact events need to be recorded

%% Physical parameter initialization

% control parameters
zeta = 2.02e-6; % friction coefficient
k = 1.01e-6; % spring constant (trap stiffness)

% kbT
kb=1.38e-23;
Temp=300;

% time evolution factors
exp_decay = exp(-k/zeta*dt);
noise = sqrt(kb*Temp/k*(1-exp(-2*k/zeta*dt)));

%% Main loop

contact_times = [];
contact_count = 0;

while contact_count < total_contactN

    % w.l.o.g. set the initial radial coordinate at (0, r_0, 0)
    x_prev = 0;
    y_prev = init_sep;
    z_prev = 0;

    counter = 0;
    while 1
        counter = counter + 1;

        x_pres = x_prev*exp_decay + randn(1)*noise;
        y_pres = y_prev*exp_decay + randn(1)*noise;
        z_pres = z_prev*exp_decay + randn(1)*noise;

        if x_pres^2+y_pres^2+z_pres^2 < contact_sep^2
            contact_times = [contact_times; counter * dt];
            contact_count = contact_count + 1;
            break
        end

        x_prev = x_pres;
        y_prev = y_pres;
        z_prev = z_pres;
    end

%     if mod(contact_count,10) == 0
%         disp(contact_count)
%     end

end


%% Saving
savepath = 'xxx'; % xxx = path of the saving folder
fname = append('yyy','_',num2str(tra),'.mat'); % yyy name of the file

save([savepath fname]);

end