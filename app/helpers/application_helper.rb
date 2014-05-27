module ApplicationHelper
  def role_name
    # Remove the pluralize
    params['controller'][0...-1]
  end

  def role_icon
    if role_name == 'publisher' then return 'fa-rocket' else return 'fa-bullhorn' end
  end

  # Dynamic choose 'default' button: (primary for adv & success for publisher).
  def current_button
    if role_name == 'publisher' then return 'btn-success' else return 'btn-primary' end
  end

  def role_actions
    case role_name
      when 'publisher'
        actions = [
            { :name => t(:publisher_action)[:invite], :path => '#invite', :icon => 'fa fa-paper-plane', :toggle => 'modal' }
        ]
      when 'advertiser'
        actions = [
            { :name => t(:advertiser_action)[:invite], :path => '#recommend', :icon => 'fa fa-paper-plane', :toggle => 'modal' }
        ]
    else
      actions = []
    end

    # Commum actions
    users_actions = [
        { :name => t(:user_action)[:config_acc], :path => 'edit', :icon => 'fa fa-gears' },
        { :name => t(:user_action)[:feedback], :path => '#feedback', :icon => 'fa fa-comments', :toggle => 'modal' }
    ]

    users_actions.each do |action|
      actions.append(action)
    end

    actions
  end
end
