require 'action_pack'

module Rails
  module Controller
    module Testing
      module Integration
        http_verbs = %w(get post patch put head delete)

        if ActionPack.version < Gem::Version.new('5.1')
          http_verbs.push('xhr', 'xml_http_request', 'get_via_redirect', 'post_via_redirect')
        end

        def locale_params
          { locale: I18n.locale }
        end

        http_verbs.each do |method|
          new_method = "local_#{method}"
          define_method(new_method) do |*args, **kwargs|
            reset_template_assertion
            kwargs[:params] = locale_params.merge(kwargs.fetch(:params, {}))
            send(method.to_sym, *args, **kwargs)
          end
        end
      end
    end
  end
end
