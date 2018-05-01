Apipie.configure do |config|
  config.app_name = 'Backend'
  config.api_base_url = ''
  config.doc_base_url = '/docs'
  config.translate = false
  config.reload_controllers = true
  config.api_controllers_matcher = File.join(Rails.root, 'app', 'controllers', '**', '*.rb')
  config.show_all_examples = true
end
