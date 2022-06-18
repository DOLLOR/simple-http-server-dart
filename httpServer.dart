import 'dart:io' as io;
import 'dart:convert' as convert;

typedef Future<String> OnRequest(io.HttpRequest request);

/**
 * create an http server
 */
Future<io.HttpServer> createServer(
    dynamic address, int port, OnRequest onRequest) async {
  final server = await io.HttpServer.bind(address, port);
  print('server start http://localhost:${port}');
  // handle request
  server.forEach((request) async {
    final res = await onRequest(request);
    request.response.statusCode = 200;
    request.response.headers.add('Server', 'dart/${io.Platform.version}');
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Headers', '*');
    request.response.headers.add('Cache-Control', 'public, max-age=0');
    request.response.headers.add('Content-Type', 'text/plain; charset=UTF-8');
    request.response.write(res);
    request.response.close();
  });
  return server;
}

Future<String> getRequestBody(io.HttpRequest request) {
  return convert.utf8.decoder.bind(request).join();
}
