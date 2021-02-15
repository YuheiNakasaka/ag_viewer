import 'dart:convert';
import 'dart:io';

class TwitterApi {
  final _httpClient = HttpClient();

  Future<String> getTweetData() async {
    final uri =
        Uri.https('www.uniqueradio.jp', '/_common/twitter/twitter-inc.html');
    final respHtml = await _getHTMLRequest(uri);
    return '''
<!DOCTYPE html>
<html lang="ja">
	<head>
		<!-- Required meta tags -->
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<title>超!A&G #agqr</title>
    <style>
    body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
        font-size: 1rem;
        font-weight: 400;
        line-height: 1.5;
        color: #212529;
        text-align: left;
        background-color: #fff;
    }
    *, *::before, *::after {
        box-sizing: border-box;
    }
    .container-fluid {
      width: 100%;
      padding-right: 15px;
      padding-left: 15px;
      margin-right: auto;
      margin-left: auto;
    }
    .row {
        display: -ms-flexbox;
        display: flex;
        -ms-flex-wrap: wrap;
        flex-wrap: wrap;
        margin-right: -15px;
        margin-left: -15px;
    }
    .col {
        -ms-flex-preferred-size: 0;
        flex-basis: 0;
        -ms-flex-positive: 1;
        flex-grow: 1;
        max-width: 100%;
    }
    .list-unstyled {
        padding-left: 0;
        list-style: none;
    }
    ol, ul, dl {
        margin-top: 0;
        margin-bottom: 1rem;
    }
    .mt-3, .my-3 {
        margin-top: 1rem !important;
    }
    .border-bottom {
        border-bottom: 1px solid #dee2e6 !important;
    }
    .media {
        display: -ms-flexbox;
        display: flex;
        -ms-flex-align: start;
        align-items: flex-start;
    }
    .mr-3, .mx-3 {
        margin-right: 1rem !important;
    }
    .align-self-center {
        -ms-flex-item-align: center !important;
        align-self: center !important;
    }
    a {
        color: #007bff;
        text-decoration: none;
        background-color: transparent;
        -webkit-text-decoration-skip: objects;
    }
    .media-body {
        -ms-flex: 1;
        flex: 1;
    }
    img {
        vertical-align: middle;
        border-style: none;
    }
    .mt-0, .my-0 {
        margin-top: 0 !important;
    }
    h6, .h6 {
        font-size: 1rem;
    }
    h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
        margin-bottom: 0.5rem;
        font-family: inherit;
        font-weight: 500;
        line-height: 1.2;
        color: inherit;
    }
    p {
        margin-top: 0;
        margin-bottom: 1rem;
    }
    </style>
	</head>
	<body>
    <div id="twitter_wrap">
    $respHtml
    </div>
	</body>
</html>
''';
  }

  Future<String> _getHTMLRequest(Uri uri) async {
    final response =
        await _httpClient.getUrl(uri).then((HttpClientRequest request) {
      request.headers.add('mime-type', 'text/html;charset=UTF-8');
      return request.close();
    });
    return response.transform(utf8.decoder).join();
  }
}
