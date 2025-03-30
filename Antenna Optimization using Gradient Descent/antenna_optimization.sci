// Antennenoptimierung mittels Gradientenabstieg
// Antenna Optimization using Gradient Descent 

wavelength = 3e8 / 2.4e9;
frequency = 2.4e9;
parameters = [0.5, 0.5, 1.0];
learning_rate = 0.01;
iterations = 100;
tolerance = 1e-6;

function cost = antenna_cost_function(params)
    width = params(1);
    height = params(2);
    length = params(3);
    radiation_pattern_cost = calculate_radiation_pattern(width, height, length);
    impedance_matching_cost = calculate_impedance_matching(width, height);
    power_efficiency_cost = calculate_power_efficiency(width, length, frequency);
    bandwidth_cost = calculate_bandwidth(width, height);
    cost = radiation_pattern_cost + impedance_matching_cost + power_efficiency_cost + bandwidth_cost;
endfunction

function radiation_pattern = calculate_radiation_pattern(width, height, length)
    radiation_pattern = (width * height / length);
endfunction

function impedance = calculate_impedance_matching(width, height)
    impedance = 50 + (width - height) * 5;
endfunction

function power_efficiency = calculate_power_efficiency(width, length, frequency)
    R_r = 73 * (length / wavelength)^2;  // Radiation resistance for dipole (approximation)
    R_l = 0.5;  // Assumed small loss resistance
    power_efficiency = R_r / (R_r + R_l);
    
    if power_efficiency > 1 then
        power_efficiency = 1;
    elseif power_efficiency < 0 then
        power_efficiency = 0;
    end
endfunction

function bandwidth = calculate_bandwidth(width, height)
    bandwidth = abs(0.5 - (width * height / wavelength));
endfunction

function gradient = calculate_gradient(cost_function, params, epsilon)
    gradient = zeros(1, length(params));
    for i = 1:length(params)
        params_up = params;
        params_down = params;
        
        params_up(i) = params_up(i) + epsilon;
        params_down(i) = params_down(i) - epsilon;
        
        gradient(i) = (cost_function(params_up) - cost_function(params_down)) / (2 * epsilon);
    end
endfunction

function optimized_params = gradient_descent(cost_function, params, learning_rate, iterations, tolerance)
    prev_cost = cost_function(params);
    cost_history = [];
    radiation_pattern_history = [];
    impedance_history = [];
    power_efficiency_history = [];
    bandwidth_history = [];
    for iter = 1:iterations
        grad = calculate_gradient(cost_function, params, 1e-5);
        params = params - learning_rate * grad;
        radiation_pattern = calculate_radiation_pattern(params(1), params(2), params(3));
        impedance = calculate_impedance_matching(params(1), params(2));
        power_efficiency = calculate_power_efficiency(params(1), params(3), frequency);
        bandwidth = calculate_bandwidth(params(1), params(2));
        current_cost = cost_function(params);
        cost_history = [cost_history; current_cost];
        radiation_pattern_history = [radiation_pattern_history; radiation_pattern];
        impedance_history = [impedance_history; impedance];
        power_efficiency_history = [power_efficiency_history; power_efficiency];
        bandwidth_history = [bandwidth_history; bandwidth];
        disp("Iteration: " + string(iter));
        disp("Parameters: Width = " + string(params(1)) + ", Height = " + string(params(2)) + ", Length = " + string(params(3)));
        disp("Radiation Pattern: " + string(radiation_pattern));
        disp("Impedance: " + string(impedance));
        disp("Power Efficiency: " + string(power_efficiency));
        disp("Bandwidth: " + string(bandwidth));
        disp("Current Cost: " + string(current_cost));
        disp("----------------------------------------------------");
        if abs(prev_cost - current_cost) < tolerance
            break;
        end
        prev_cost = current_cost;
    end
    scf(1);
    plot(1:length(cost_history), cost_history, '-o');
    xlabel('Iteration');
    ylabel('Cost Function');
    title('Cost Function Evolution');
    scf(2);
    plot(1:length(radiation_pattern_history), radiation_pattern_history, '-o');
    xlabel('Iteration');
    ylabel('Radiation Pattern');
    title('Radiation Pattern Evolution');
    scf(3);
    plot(1:length(impedance_history), impedance_history, '-o');
    xlabel('Iteration');
    ylabel('Impedance (Ohms)');
    title('Impedance Evolution');
    scf(4);
    plot(1:length(power_efficiency_history), power_efficiency_history, '-o');
    xlabel('Iteration');
    ylabel('Power Efficiency');
    title('Power Efficiency Evolution');
    scf(5);
    plot(1:length(bandwidth_history), bandwidth_history, '-o');
    xlabel('Iteration');
    ylabel('Bandwidth (MHz)');
    title('Bandwidth Evolution');
    optimized_params = params;
endfunction

optimized_parameters = gradient_descent(antenna_cost_function, parameters, learning_rate, iterations, tolerance);
radiation_pattern = calculate_radiation_pattern(optimized_parameters(1), optimized_parameters(2), optimized_parameters(3));
impedance = calculate_impedance_matching(optimized_parameters(1), optimized_parameters(2));
power_efficiency = calculate_power_efficiency(optimized_parameters(1), optimized_parameters(3), frequency);
bandwidth = calculate_bandwidth(optimized_parameters(1), optimized_parameters(2));

disp("Optimized Antenna Parameters:");
disp("Width = " + string(optimized_parameters(1)) + " meters");
disp("Height = " + string(optimized_parameters(2)) + " meters");
disp("Length = " + string(optimized_parameters(3)) + " meters");
disp("Estimated Radiation Pattern = " + string(radiation_pattern));
disp("Estimated Impedance = " + string(impedance) + " Ohms");
disp("Estimated Power Efficiency = " + string(power_efficiency));
disp("Estimated Bandwidth = " + string(bandwidth) + " MHz");
