(function() {
  if (document.getElementById('blog-comments')) {
    var options = {
      container  : '#blog-comments',
      site_key   : '6k20s879i3f0uat78fxm6lgg8hzm2q6',
      topic_key  : location.pathname.match(/(\/[^\/]*)\/?$/)[1],
      topic_url  : location.href,
      topic_title  : document.title || location.href,
      include_base : !window.Juvia,
      include_css  : false,
      comment_order: 'latest-first'
    };

    function makeQueryString(options) {
      var key, params = [];
      for (key in options) {
        params.push(
          encodeURIComponent(key) +
          '=' +
          encodeURIComponent(options[key]));
      }
      return params.join('&');
    }

    function makeApiUrl(options) {
      // Makes sure that each call generates a unique URL, otherwise
      // the browser may not actually perform the request.
      if (!('_juviaRequestCounter' in window)) {
        window._juviaRequestCounter = 0;
      }

      var result =
        '//comment-osasteam.rhcloud.com/api/show_topic.js' +
        '?_c=' + window._juviaRequestCounter +
        '&' + makeQueryString(options);
      window._juviaRequestCounter++;

      return result;
    }

    var s     = document.createElement('script');
    s.async   = true;
    s.type    = 'text/javascript';
    s.className = 'juvia';
    s.src     = makeApiUrl(options);
    (document.getElementsByTagName('head')[0] ||
      document.getElementsByTagName('body')[0]).appendChild(s);
  }
}) ();
