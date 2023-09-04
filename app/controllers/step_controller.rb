class StepController < ApplicationController
  before_action :check_tribunal_case_presence
  before_action :check_tribunal_case_status, except: [:show]
  before_action :store_step_path_in_session, only: [:edit, :update]
  before_action :update_navigation_stack

  def previous_step_path
    # Second to last element in the array, will be nil for arrays of size 0 or 1
    current_tribunal_case&.navigation_stack&.slice(-2) || root_path
  end
  helper_method :previous_step_path

  private

  def address_lookup_access_token
    Rails.cache.fetch('address_lookup', expires_in: 290) do
      uri = URI(Rails.configuration.x.address_lookup.endpoint)

      req = Net::HTTP::Post.new('/oauth2/token/v1')
      req.basic_auth(
        Rails.configuration.x.address_lookup.api_key,
        Rails.configuration.x.address_lookup.api_secret
      )
      req.set_form_data('grant_type' => 'client_credentials')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.instance_of? URI::HTTPS
      begin
        res = http.request(req)
        if res.is_a?(Net::HTTPSuccess)
          JSON.parse(res.body).fetch('access_token', nil).tap do |token|
            Rails.logger.info("[Address Lookup] :: os cred #{res.body} -- token: #{token}")
          end
        end
      rescue StandardError => e
        Rails.logger.error("Address Lookup Fetch Access Token error: #{e}")
        nil
      end
    end
  end

  def update_and_advance(form_class, opts={})
    hash = permitted_params(form_class).to_h

    @next_step   = params[:next_step].presence
    @form_object = form_class.new(
      **hash.merge(tribunal_case: current_tribunal_case).symbolize_keys
    )

    if @form_object.save

      decision = decision_tree_class.new(
        tribunal_case: current_tribunal_case,
        step_params:   hash,
        # Used when the step name in the decision tree is not the same as the first
        # (and usually only) attribute in the form.
        as:            opts[:as],
        next_step:     @next_step
      )
      destination = decision.destination
      next_step_in_session(decision)

      redirect_to destination
    else
      render opts.fetch(:render, :edit)
    end
  end

  def permitted_params(form_class)
    params
      .fetch(form_class.model_name.singular, {})
      .permit(form_class.new.attributes.keys)
  end

  def store_step_path_in_session
    session[:current_step_path] = request.fullpath
  end

  def update_navigation_stack
    return unless current_tribunal_case

    stack_until_current_page = current_tribunal_case.navigation_stack.take_while do |path|
      path != request.fullpath
    end

    current_tribunal_case.navigation_stack = stack_until_current_page + [request.fullpath]
    current_tribunal_case.save!
  end

  def next_step_in_session(decision)
    if decision.next_step != { controller: '/steps/save_and_return', action: :edit }
      session[:next_step] = url_for(decision.next_step)
    end
  end
end
