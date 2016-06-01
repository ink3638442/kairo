module ApplicationHelper
    def is_active_controller(controller_name)
        params[:controller] == controller_name ? "active" : nil
    end

    def is_active_action(action_name)
        params[:action] == action_name ? "active" : nil
    end
    
    def is_active_nav(nav_info)
        params[:nav_info] == nav_info ? "active" : nil
    end
    
    #paramsにuser_idがなければcurrent_userにする
    #paramsにuser_idがあればそのユーザーIDにする
    def params_user_id_set
        if params[:user_id].nil?
            @user = current_user
        else
            @user = User.find(params[:user_id])
        end
    end
    
    def randam_video
        video = ["top_a.mp4", "top_b.mp4", "top_c.mp4", "top_d.mp4"]
        video.sample
    end
    
    
end