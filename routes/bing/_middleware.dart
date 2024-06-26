import 'package:dart_frog/dart_frog.dart';
import 'package:dream/middlewares/cors_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(corsHeaders());
}
