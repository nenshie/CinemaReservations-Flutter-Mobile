import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/dto/login_request_dto.dart';
import '../models/dto/login_response_dto.dart';
import '../models/user.dart';
import '../utils/api_handler.dart';

class AuthService {
  Future<LoginResponseDto?> login(String email, String password) async {
    final url = Uri.parse('${BaseAPI.base}/api/auth/login');
    final response = await http.post(
      url,
      headers: BaseAPI.defaultHeaders,
      body: jsonEncode(LoginRequestDto(email: email, password: password).toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponseDto.fromJson(jsonDecode(response.body));
    } else {
      print('Neuspešna prijava: ${response.body}');
      return null;
    }
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  String getUserRole(String jwtToken) {
    final decoded = JwtDecoder.decode(jwtToken);
    return decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
        ?? (throw Exception('Role not found in token'));
  }

  Future<User?> getUserFromJwt(String jwtToken) async {
    final decoded = JwtDecoder.decode(jwtToken);
    if (decoded.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress') &&
        decoded.containsKey('http://schemas.microsoft.com/ws/2008/06/identity/claims/role') &&
        decoded.containsKey('http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata')) {
      return User(
        name: '',
        surname: '',
        MobileNumber: '',
        email: decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
        jmbg: decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
        role: decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'],
      );
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserData(String jmbg, String jwtToken, String role) async {
    final url = Uri.parse('${BaseAPI.base}/api/user/$jmbg');

    final response = await http.get(
      url,
      headers: {
        ...BaseAPI.defaultHeaders,
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Greška pri dohvaćanju podataka: ${response.body}');
      return null;
    }
  }

  Future<bool> signUp(User user) async {
    final url = Uri.parse('${BaseAPI.base}/api/auth/register');

    final response = await http.post(
      url,
      headers: BaseAPI.defaultHeaders,
      body: jsonEncode({
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'surname': user.surname,
        'MobileNumber' : user.MobileNumber,
        'jmbg': user.jmbg,
        'roles': [user.role.isNotEmpty ? user.role : 'Client'],
      }),
    );

    if (response.statusCode == 200) return true;

    print('Registracija nije uspela: ${response.body}');
    return false;
  }



}
