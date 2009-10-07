module AutoSessionTimeoutHelper
  def auto_session_timeout_js(options={})
    frequency = options[:frequency] || 10
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
                  multiplier : 1,
                  type : 'text'
                },
                function(data)
                {
                  if (data == 'expired')
                    window.location.href = '/timeout';
                  if (data == 'warning')
                   jQuery.facebox('<b>Your Session Is About To Expire</b>');
                });
               })

JS
    javascript_tag(code)
  end
end

ActionView::Base.send :include, AutoSessionTimeoutHelper
