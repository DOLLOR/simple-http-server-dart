import 'dart:io' as io;
import 'dart:convert' as convert;

const port = 9301;
main() async {
  await createServer(io.InternetAddress.anyIPv6, port, onRequest);
}

Future<io.HttpServer> createServer(dynamic address, int port,
    String onRequest(io.HttpRequest request, String postBody)) async {
  final server = await io.HttpServer.bind(io.InternetAddress.anyIPv6, port);
  print('server start http://localhost:${port}');
  server.forEach((request) async {
    final postBody = await convert.utf8.decoder.bind(request).join();
    request.response.headers.add('Server', 'dart/${io.Platform.version}');
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Headers', '*');
    request.response.headers.add('Cache-Control', 'public, max-age=0');
    request.response.headers.add('Content-Type', 'text/plain; charset=UTF-8');
    final res = onRequest(request, postBody);
    request.response.write(res);
    request.response.close();
  });
  return server;
}

String onRequest(io.HttpRequest request, postBody) {
  print(request.method);
  print(request.uri);
  print('post body: ${postBody}');
  request.response.statusCode = 200;
  return 'dart http server ok: ${postBody}';
}
