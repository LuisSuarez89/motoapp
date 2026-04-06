import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              transparentBackground: true,
              useShouldOverrideUrlLoading: true,
            ),
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              // Bypass SSL errors (net_error -202: ERR_CERT_AUTHORITY_INVALID)
              // Useful for specific governmental sites or sites with self-signed/outdated certificates.
              return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;

              if (uri == null) {
                return NavigationActionPolicy.ALLOW;
              }

              if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                // Intercept intent://, geo:, whatsapp: etc. to open in the native app
                String uriString = uri.toString();
                
                // Mapeo especial para los intent:// de Android (Maps, etc.)
                if (uri.scheme == 'intent') {
                  final fallbackMatch = RegExp(r'S\.browser_fallback_url=([^;]+)').firstMatch(uriString);
                  if (fallbackMatch != null) {
                    final fallbackUrl = Uri.decodeComponent(fallbackMatch.group(1)!);
                    controller.loadUrl(urlRequest: URLRequest(url: WebUri(fallbackUrl)));
                    return NavigationActionPolicy.CANCEL;
                  }

                  // Si no hay fallback url explícito, intentamos pasarlo a https
                  final intentBaseMatch = RegExp(r'intent://([^#]+)').firstMatch(uriString);
                  if (intentBaseMatch != null) {
                    final baseUrl = 'https://${intentBaseMatch.group(1)}';
                    controller.loadUrl(urlRequest: URLRequest(url: WebUri(baseUrl)));
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                try {
                  await launchUrl(
                    Uri.parse(uriString),
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  debugPrint('Could not launch $uriString');
                }
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadStart: (controller, url) {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onLoadStop: (controller, url) async {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
