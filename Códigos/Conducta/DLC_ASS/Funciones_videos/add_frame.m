function [senial_new] = add_frame(senial,num_videos,num_frames)

    senial_new = zeros(size(senial,1),size(senial,2)+num_videos);
    
    pos_i = (1:num_frames:length(senial))';
    pos_f = (num_frames:num_frames:length(senial))';
    pos_f(end+1) = length(senial);
   
    
    pi_new = (1:(num_frames+1):length(senial_new))';
    pf_new = ((num_frames+1):(num_frames+1):length(senial_new))';
    pf_new(end+1) = length(senial_new);

    for i = 1:num_videos
        senial_n = senial(:,pos_i(i):pos_f(i));
        senial_n(:,end+1) = senial_n(:,end);
        senial_new(:,pi_new(i):pf_new(i)) = senial_n;
    end


end