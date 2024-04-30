function SJF_algorithm()
    disp('Thuật toán SJF (Shortest Job First)');
    disp('-----------------------------------');
    
    % Nhập số lượng tiến trình
    num_processes = input('Nhập số lượng tiến trình: ');
    
    % Kiểm tra tính hợp lệ của đầu vào
    while ~isnumeric(num_processes) || num_processes <= 0
        disp('Vui lòng nhập một số nguyên dương cho số lượng tiến trình.');
        num_processes = input('Nhập số lượng tiến trình: ');
    end
    
    % Khởi tạo ma trận lưu trữ thông tin về tiến trình
    processes = zeros(num_processes, 4); % Cột 1: Thời gian đến, Cột 2: Thời gian thực thi, Cột 3: Số thứ tự tiến trình, Cột 4: Thời gian kết thúc
    
    % Nhập thông tin về thời gian đến và thời gian thực thi của từng tiến trình
    for i = 1:num_processes
        fprintf('Nhập thông tin cho tiến trình %d:\n', i);
        
        % Nhập thời gian đến và kiểm tra tính hợp lệ của đầu vào
        while true
            arrival_time = input('Thời gian đến: ');
            if ~isempty(arrival_time) && isnumeric(arrival_time) && numel(arrival_time) == 1
                processes(i, 1) = arrival_time;
                break;
            else
                disp('Vui lòng nhập một giá trị số cho thời gian đến.');
            end
        end
        
        % Nhập thời gian thực thi và kiểm tra tính hợp lệ của đầu vào
        while true
            execution_time = input('Thời gian thực thi: ');
            if ~isempty(execution_time) && isnumeric(execution_time) && numel(execution_time) == 1 && execution_time > 0
                processes(i, 2) = execution_time;
                break;
            else
                disp('Vui lòng nhập một số nguyên dương cho thời gian thực thi.');
            end
        end
        
        processes(i, 3) = i; % Gán số thứ tự cho tiến trình
    end
    
    % Sắp xếp các tiến trình theo thời gian đến
    processes = sortrows(processes, 1);
    
    % Thời gian bắt đầu của mỗi tiến trình
    start_times = zeros(num_processes, 1);
    % Thời gian hoàn thành của mỗi tiến trình
    completion_times = zeros(num_processes, 1);
    
    % Tính thời gian hoàn thành và thời gian chờ đợi của mỗi tiến trình
    current_time = 0; % Thời gian hiện tại
    total_wait_time = 0; % Tổng thời gian chờ đợi
    running_process_index = 0; % Chỉ số của tiến trình đang chạy
    while true
        remaining_processes = find(processes(:, 1) <= current_time & processes(:, 4) == 0);
        if isempty(remaining_processes)
            break; % Không còn tiến trình nào để thực thi
        end
        
        % Chọn tiến trình có burst time (thời gian thực thi) ngắn nhất từ danh sách các tiến trình sẵn có
        [~, min_index] = min(processes(remaining_processes, 2));
        current_process_index = remaining_processes(min_index);
        
        if running_process_index ~= current_process_index
            start_times(current_process_index) = current_time; % Thời gian bắt đầu của tiến trình
            completion_times(current_process_index) = current_time + processes(current_process_index, 2); % Thời gian hoàn thành của tiến trình
            total_wait_time = total_wait_time + (current_time - processes(current_process_index, 1)); % Tính tổng thời gian chờ đợi
        end
        
        running_process_index = current_process_index;
        current_time = current_time + processes(current_process_index, 2); % Cập nhật thời gian hiện tại
        processes(current_process_index, 4) = completion_times(current_process_index); % Ghi nhận thời gian kết thúc của tiến trình
    end
    
    % Tính thời gian turnaround của mỗi tiến trình
    turnaround_times = completion_times - processes(:, 1);
    
    % In kết quả
    disp('Kết quả của thuật toán SJF:');
    disp('------------------------------------------------------------------------------------------------------------');
    disp('Tiến trình   | Thời gian đến | Thời gian thực thi | Thời gian hoàn thành | Turn around time | Thời gian đợi |');
    disp('------------------------------------------------------------------------------------------------------------');
    for i = 1:num_processes
        fprintf('%12d | %15d | %18d | %20d | %16d | %13d\n', processes(i, 3), processes(i, 1), processes(i, 2), completion_times(i), turnaround_times(i), start_times(i) - processes(i, 1));
    end
    disp('------------------------------------------------------------------------------------------------------------');
    
    % Tính thời gian chờ đợi trung bình và thời gian turnaround trung bình
    average_wait_time = total_wait_time / num_processes;
    average_turnaround_time = mean(turnaround_times);
    
    % In thời gian chờ đợi trung bình và thời gian turnaround trung bình
    disp(['Thời gian chờ đợi trung bình: ' num2str(average_wait_time)]);
    disp(['Thời gian turnaround trung bình: ' num2str(average_turnaround_time)]);
    
    % Vẽ biểu đồ Gantt
    figure;
    hold on;
    for i = 1:num_processes
        rectangle('Position', [start_times(i), 0, processes(i, 2), 1], 'FaceColor', rand(1, 3), 'EdgeColor', 'k');
        text(start_times(i) + processes(i, 2)/2, 0.5, num2str(processes(i, 3)), 'HorizontalAlignment', 'center');
    end
    xlabel('Thời gian');
    ylabel('Tiến trình');
    title('Biểu đồ Gantt cho thuật toán SJF');
    ylim([0 1]);
    xlim([0 max(completion_times)]);
    yticks([]);
    hold off;
end
