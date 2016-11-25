class StepGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :task_name, :type => :string
  argument :step_name, :type => :string

  def copy_controller
    template 'controller.rb', "app/controllers/steps/#{task_name.underscore}/#{step_name.underscore}_controller.rb"
    template 'controller_spec.rb', "spec/controllers/steps/#{task_name.underscore}/#{step_name.underscore}_controller_spec.rb"
  end

  def copy_template
    template 'edit.html.erb', "app/views/steps/#{task_name.underscore}/#{step_name.underscore}/edit.html.erb"
  end

  def copy_form
    template 'form.rb', "app/forms/steps/#{task_name.underscore}/#{step_name.underscore}_form.rb"
    template 'form_spec.rb', "spec/forms/steps/#{task_name.underscore}/#{step_name.underscore}_form_spec.rb"
  end

  def add_to_routes
    insert_into_file 'config/routes.rb', after: /namespace :#{task_name.underscore} do.+?(?=end)/m do
      "  edit_step :#{step_name.underscore}\n    "
    end
  end

  def add_to_decision_tree
    tree_file = "app/services/#{task_name.underscore}_decision_tree.rb"

    insert_into_file tree_file, before: "else\n      raise"do
      "when :#{step_name.underscore}\n      after_#{step_name.underscore}_step\n    "
    end

    insert_into_file tree_file, before: /^end/ do
      "  def after_#{step_name.underscore}_step\n    raise 'TODO: Implement me'\n  end\n"
    end
  end
end
