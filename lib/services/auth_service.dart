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

  Future<bool> getClientById(String jmbg) async {
    final url = Uri.parse('${BaseAPI.base}/api/clients/$jmbg');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.isNotEmpty;
    } else {
      print('Greška pri proveri klijenta: ${response.body}');
      return false;
    }
  }

  Future<List<User>> fetchClients() async {
    final url = Uri.parse('${BaseAPI.base}/api/clients');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User(
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        jmbg: json['jmbg'],
        MobileNumber: json['MobileNumber'] ?? json['MobileNumber'] ?? '',
        role: 'Client',
      )).toList();
    } else {
      print('Greška pri dohvatanju klijenata: ${response.body}');
      return [];
    }
  }

  Future<List<User>> fetchAdmins() async {
    final url = Uri.parse('${BaseAPI.base}/api/admins');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User(
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        jmbg: json['jmbg'],
        MobileNumber: json['MobileNumber'] ?? json['mobileNumber'] ?? '',
        role: 'Admin',
      )).toList();
    } else {
      print('Greška pri dohvatanju admina: ${response.body}');
      return [];
    }
  }

  Future<List<User>> searchClients(String searchTerm) async {
    final url = Uri.parse('${BaseAPI.base}/api/clients/search?searchTerm=$searchTerm');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User(
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        jmbg: json['jmbg'],
        MobileNumber: json['MobileNumber'] ?? json['mobileNumber'] ?? '',
        role: 'Client',
      )).toList();
    } else {
      print('Greška pri pretrazi klijenata: ${response.body}');
      return [];
    }
  }

  Future<void> updateUser(User user, String role) async {
    final url = Uri.parse('${BaseAPI.base}/api/${role.toLowerCase()}s/${user.jmbg}');
    final response = await http.put(
      url,
      headers: BaseAPI.defaultHeaders,
      body: jsonEncode({
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'MobileNumber': user.MobileNumber,
      }),
    );

    if (response.statusCode == 200) {
      print('Uspešna izmena korisnika.');
    } else {
      print('Greška pri izmeni korisnika: ${response.body}');
    }
  }
}
