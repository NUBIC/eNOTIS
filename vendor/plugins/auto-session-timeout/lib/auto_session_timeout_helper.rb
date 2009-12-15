module AutoSessionTimeoutHelper
  def auto_session_timeout_js(options={})
    frequency = options[:frequency] || 60
    frequency *=1000
    code = <<JS

            $(document).ready(
              function()
              {
                $.PeriodicalUpdater(
                {
                  url : '/active',
                  method : 'get',
                  minTimeout: #{frequency},
                  maxTimeout: #{frequency * 2},
                  type : 'text'
                },
                function(data)
                {
                  if (data == 'expired')
                    window.location.href = '/timeout';
                  if (data == 'warning')
                    $("#session-expire").overlay({ expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }, closeOnClick: false, api: true }).load();
                });
               })

JS
    javascript_tag(code)
  end
end

ActionView::Base.send :include, AutoSessionTimeoutHelper
