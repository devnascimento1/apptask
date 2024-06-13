import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

class UserService {
  final String apiUrl = "https://dummyapi.io/data/v1";
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'app-id': '66339f4c777d45485ff7532b',
  };

  Future<List<User>> getUsers({int? page, String? sortBy, String? created}) async {
    try {
      var response = await http.get(
        Uri.parse('$apiUrl/user').replace(queryParameters: {
          'page': page?.toString(),
          'sortBy': sortBy ?? '',
          'created': created ?? ''
        }),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          List<dynamic> usersJson = jsonResponse['data'];
          List<User> users = usersJson.map((dynamic item) => User.fromJson(item)).toList();
          return users;
        } else {
          throw "Unexpected JSON format: ${response.body}";
        }
      } else {
        throw "Failed to load users with status code: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to load users: $e";
    }
  }

  Future<User> getUserById(String id) async {
    try {
      var response = await http.get(
        Uri.parse('$apiUrl/user/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw "Failed to get user with status code: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to get user: $e";
    }
  }

  Future<User> createUser(User user) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/user/create'),
        headers: headers,
        body: jsonEncode({
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null && data.containsKey('id')) {
          return User.fromJson(data);
        } else {
          throw "User creation was successful but did not return user data.";
        }
      } else {
        throw "Failed to create user with status code: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to create user: $e";
    }
  }

  Future<User> updateUser(String id, Map<String, dynamic> dataToUpdate) async {
    try {
      var response = await http.put(
        Uri.parse('$apiUrl/user/$id'),
        headers: headers,
        body: jsonEncode(dataToUpdate),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw "Failed to update user with status code: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to update user: $e";
    }
  }

  Future<String> deleteUser(String id) async {
    try {
      var response = await http.delete(
        Uri.parse('$apiUrl/user/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return id;
      } else {
        throw "Failed to delete user with status code: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to delete user: $e";
    }
  }
}
