<%
-- Enable localization
gettext.textdomain('webui-parental')

local triesbeforemsg = 3
local content_helper = require("web.content_helper")

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
    <title><%= T"Parental Blocked" %></title>
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="header span12">
        <a href="<%= cui.nsplink %>" target="_blank"><img src="/img/logo.gif"></a>
      </div>
    </div>
    <div class="row">
      <div class="offset4 span4">
        <p><strong>Destination is blocked due to parental control.</strong></p>
        <p><a href="http://<%=ngx.var.server_addr%>">Click here to access NG-gateway webinterface.</a></p>
      </div>
    </div>
    <div class="row"><div class="copyright span12"><p>wuseman</p></div></div>
  </div>
</body>
</html>
