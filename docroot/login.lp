<%
-- Enable localization
gettext.textdomain('webui-core')

local triesbeforemsg = 3
local content_helper = require("web.content_helper")

if ngx.var.request_method == "GET" and ngx.req.get_uri_args().action == "getcsrf" then
  ngx.print(ngx.ctx.session:getCSRFtoken())
  ngx.exit(ngx.HTTP_OK)
end

local cui = {
  defaultuser = "uci.web.uiconfig.@uidefault.defaultuser",
  nsplink = "uci.web.uiconfig.@uidefault.nsplink",
}
content_helper.getExactContent(cui)

%>
<!DOCTYPE HTML>
<%= string.format('<html lang="%s">', gettext.language()) %>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <meta name="CSRFtoken" content="<%= ngx.ctx.session:getCSRFtoken() %>">
    <link href="/css/gw.css" rel="stylesheet">
    <link href="/css/responsive.css" rel="stylesheet">
    <!--[if IE 7]><link rel="stylesheet" href="/css/font-awesome-ie7.css"><![endif]-->
    <script src="/js/main-min.js" ></script>
    <!--[if lt IE 9]> <script src="/js/media-min.js"></script> <![endif]-->
    <script src="/js/srp-min.js" ></script>
    <title><%= T"Login" %></title>
</head>
<body>
  <div class="container">
    <div class="logo-technicolor"><a href="<%= cui.nsplink %>" target="_blank"><img src="/img/logo.gif"></a></div>
    <div class="row">
      <div class="offset4 span4">
        <div class="login">
        <form class="form-horizontal">
          <fieldset>
                <h2><%= T"wuseman Login" %></h2>
            <div id="erroruserpass" class="alert alert-error hide">
               <strong><%= T"Nice try idiot, i already said to ya 'telia' was purged? This login try has been logged and will be reported since i didn't request any support from you!"  %></strong>
            </div>
            <div class="control-group">
                <label for="srp_username"><div class="label-icon">
                    <i class="icon-user icon-large"></i>
                </div></label>
                <input class="span3" type="text" placeholder="<%= T"'telia' & 'assist' has been purged" %>" id="srp_username" value="<%= cui.defaultuser %>" autofocus><br><br>
            </div>
            <div class="control-group">
                <label for="srp_password"><div class="label-icon"><i class="icon-lock icon-large"></i></div></label>
                <input class="span3" type="password" placeholder="<%= T"USB Key is required to login" %>" id="srp_password"><br><br>
            </div>
            <!-- HIDE WARNING - NOT NOT USED IN DEFAULT CUSTO
            <div id="defaultpassword" class="alert alert-info hide">
                <%= T"If you haven't changed it, the default password can be found on the sticker under your gateway (it's called <strong>\"access code\"</strong>)" %>
            </div>
            -->
            <div class="pull-right">
                <a href="/" class="btn btn-primary btn-large"><%= T"Cancel" %></a>
                &nbsp;
                <div id="sign-me-in" class="btn btn-primary btn-large"><%= T"wuseman Login" %></div>
            </div>
          </fieldset>
        </form>
      </div>
      </div>
    </div>
	<div class="content span20" style="width: 100%; text-align-last: center; margin-left: 10px;">
        	<p class="subinfos">
			<strong>
				<%="This router belongs to wuseman"%><br>
				<%="Every failed attempt to log in will be logged"%><br>
        
			</strong>
        	</p>
     	</div>	
    <div class="row"><div class="copyright span12"><p>&copy; wuseman</p></div></div>
  </div>
<script>
$(document).ready(
  function() {
    var triesbeforemsg = <%= triesbeforemsg %>;
    var tries = 0;

    // Set the focus on the first input field
    $('form:first *:input[type!=hidden]:first').focus();
    // Handle press of enter. Could be handled by adding a hidden input submit but
    // this requires a lot of css tweaking to get it right since display:none does
    // not work on every browser. So go for the js way
    $('form input').keydown(function(e) {
        if(e.which == 13 || e.which == 10) {
            e.preventDefault();
            $("#sign-me-in").click();
        }
    });

    $("#sign-me-in").on("click", function () {
      $(this).text('<%= T"Verifying" %>');
      var srp = new SRP();
      srp.success = function() {
        // If we showed the login page using an internal redirect (detected
        // by checking if the URL ends with "/login.lp") then we simply
        // have to reload the page to get the actual page content now that
        // we're logged in.
        // Otherwise we explicitly go back to the main page.
        if (window.location.pathname.search(/\/login\.lp$/) == -1){
		  var curl = window.location.href
          window.location.href = curl.substring(0,curl.indexOf("#"));
        }else
          window.location = "/";
      }
      srp.error_message = function(err) {
      if(err == 403){
        $.get("login.lp", {action:"getcsrf"}, function (data){
          $('meta[name=CSRFtoken]').attr('content', data);
          srp.identify("/authenticate", $("#srp_username")[0].value, $("#srp_password")[0].value);
        });
      }else{
        $("#sign-me-in").text('<%= T"wuseman Login" %>');
        $("#erroruserpass").show();
        $(".control-group").addClass("error");
      }
        tries++;
        if(triesbeforemsg > 0 && tries >= triesbeforemsg) {
            $("#defaultpassword").show();
        }
      }
      srp.identify("/authenticate", $("#srp_username")[0].value, $("#srp_password")[0].value);
    });
  })
</script>
</body>
</html>
