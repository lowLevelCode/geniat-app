import 'package:geniant_app/Util/response.server.dart';
import 'package:dio/dio.dart';
import 'package:geniant_app/constants.dart';
import 'package:geniant_app/main.dart';

class GlobalService {
  static Future<ResponseServer> login(Map<String, dynamic> login) async {
    var formData = FormData.fromMap(login);
    var response = await Dio().post('$URL_BASE/login', data: formData);

    var data = response.data;
    ResponseServer serverResponse = new ResponseServer();
    serverResponse.response = data['response'];
    serverResponse.message = data['message'];
    serverResponse.data = data['data'];

    if (serverResponse.response) {
      var jwt = serverResponse.data['jwt'];
      print(jwt);
      storage.write(key: JWT_KEY, value: jwt);
    } else {
      storage.delete(key: JWT_KEY);
    }

    return serverResponse;
  }

  static Future<ResponseServer> registrar(Map<String, dynamic> registro) async {
    var formData = FormData.fromMap(registro);
    var response = await Dio().post('$URL_BASE/registro', data: formData);

    var data = response.data;
    ResponseServer serverResponse = new ResponseServer();
    serverResponse.response = data['response'];
    serverResponse.message = data['message'];
    serverResponse.data = data['data'];

    return serverResponse;
  }

  static Future<ResponseServer> consultar(
      int pageInput, int idMarcaInput) async {
    var page = pageInput <= 0 ? 1 : pageInput;
    var idMarca = idMarcaInput <= 0 ? null : idMarcaInput;

    var pageQuery = 'page=$page';

    if (idMarca != null) {
      pageQuery += '&idMarca=$idMarcaInput';
    }

    var jwt = await storage.read(key: JWT_KEY);
    var api = Dio();
    api.options.headers["Authorization"] = 'Bearer $jwt';
    var response = await api.get('$URL_BASE/lista?$pageQuery');

    var data = response.data;
    ResponseServer serverResponse = new ResponseServer();
    serverResponse.response = data['response'];
    serverResponse.message = data['message'];
    serverResponse.data = data['data'];
    return serverResponse;
  }
}
