import 'dart:io' as io;
import 'dart:convert' as convert;
import 'dart:typed_data' show Uint8List;

typedef Future<ResponseResult> OnRequest(io.HttpRequest request);
// typedef OnRequest = Future<ResponseResult> Function(io.HttpRequest request);

/**
 * create an http server
 */
Future<io.HttpServer> createServer({
  required int port,
  required OnRequest onRequest,
  io.InternetAddress? address,
  Uint8List? certificateChain,
  Uint8List? privateKey,
}) async {
  if (address == null) {
    address = io.InternetAddress.anyIPv6;
  }
  final io.HttpServer server;

  if (certificateChain != null && privateKey != null) {
    final context = io.SecurityContext()
      ..useCertificateChainBytes(certificateChain)
      ..usePrivateKeyBytes(privateKey);

    server = await io.HttpServer.bindSecure(address, port, context);
    print('server start https://localhost:${port}');
  } else {
    server = await io.HttpServer.bind(address, port);
    print('server start http://localhost:${port}');
  }

  // handle request
  server.forEach((request) async {
    final res = await onRequest(request);
    request.response.statusCode = res.statusCode;
    res.headers.forEach((key, value) {
      request.response.headers.add(key, value);
    });
    request.response.add(res.data);
    await request.response.flush();
    request.response.close();
  });
  return server;
}

Future<String> getRequestBody(io.HttpRequest request) {
  return convert.utf8.decoder.bind(request).join();
}

class ResponseResult {
  dynamic data = null;
  Map<String, String> headers = {
    'Server': 'dart/${io.Platform.version}',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': '*',
    'Cache-Control': 'public, max-age=0',
    'Content-Type': 'text/plain; charset=UTF-8',
  };
  int statusCode = 200;
  ResponseResult({
    dynamic data,
    Map<String, String>? headers,
    int? statusCode,
  }) {
    this.data = data;
    if (headers != null) {
      this.headers = headers;
    }
    if (statusCode != null) {
      this.statusCode = statusCode;
    }
  }
}

const strcodec = convert.Utf8Codec();
List<int> stringToU8(String text) {
  return strcodec.encode(text);
}
