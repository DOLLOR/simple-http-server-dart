import './httpServer.dart' as httpServer;
import 'dart:io' as io;

main() async {
  const port = 9301;
  await httpServer.createServer(io.InternetAddress.anyIPv6, port, onRequest);
}

final httpServer.OnRequest onRequest = (request) async {
  final postBody = await httpServer.getRequestBody(request);
  print(DateTime.now().toString());
  print(request.method);
  print(request.uri);
  print('post body: ${postBody}');
  return 'dart http server ok: ${postBody}';
};
