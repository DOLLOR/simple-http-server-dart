import './httpServer.dart' as httpServer;
import 'dart:io' as io;

main() async {
  const port = 9301;
  await httpServer.createServer(io.InternetAddress.anyIPv6, port, onRequest);
}

/**
 * onRequest
 * ```js

    // @ts-check
    fetch('http://localhost:9301/path/name?a=b',{
      method:'POST',
      body: JSON.stringify({
        a: 1,
        b: 'a',
      }),
    })
    .then(i=>i.text())
    .then(i=>console.log(i))

 * ```
 */
final httpServer.OnRequest onRequest = (request) async {
  final postBody = await httpServer.getRequestBody(request);
  print(DateTime.now().toString());
  print(request.method);
  print(request.uri);
  print('post body: ${postBody}');
  return 'dart http server ok: ${postBody}';
};
