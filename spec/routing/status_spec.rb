require 'rails_helper'

RSpec.describe 'external dependencies routes', type: :routing do
  describe 'root' do
    specify { expect(get: '/').to route_to(controller: 'home', action: 'index') }

    context 'localized in english' do
      specify { expect(get: '/en').to route_to(controller: 'home', action: 'index', locale: 'en') }
    end

    context 'localized in welsh' do
      specify { expect(get: '/cy').to route_to(controller: 'home', action: 'index', locale: 'cy') }
    end
  end



  describe 'status' do
    specify do
      expect(get: '/status.json').to route_to(
                                       controller: 'tax_tribs/status',
                                       action: 'index',
                                       format: 'json'
                                     )
    end
  end
end
