import 'package:flutter/material.dart';
import 'user.dart';
import 'user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter User API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pictureController = TextEditingController();
  final UserService _userService = UserService();
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          _buildUserList(),
          _buildAddUserForm(),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.picture!),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: _buildEditAndDeleteButtons(user),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEditAndDeleteButtons(User user) {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _showEditDialog(user),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteUser(user.id!),
        ),
      ],
    );
  }

  void _showEditDialog(User user) {
    _firstnameController.text = user.firstName;
    _lastnameController.text = user.lastName;
    _emailController.text = user.email;
    _pictureController.text = user.picture!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  controller: _firstnameController,
                  decoration: InputDecoration(labelText: 'First Name')),
              TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(labelText: 'Last Name')),
              TextFormField(
                  controller: _pictureController,
                  decoration: InputDecoration(labelText: 'Picture URL')),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Update"),
            onPressed: () {
              _updateUser(user);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _updateUser(User user) {
    Map<String, dynamic> dataToUpdate = {
      'firstName': _firstnameController.text,
      'lastName': _lastnameController.text,
      'picture': _pictureController.text,
    };

    _userService.updateUser(user.id!, dataToUpdate).then((updatedUser) {
      _showSnackbar('User updated successfully!');
      _refreshUserList();
    }).catchError((error) {
      _showSnackbar('Failed to update user: $error');
    });
  }

  void _deleteUser(String id) {
    _userService.deleteUser(id).then((_) {
      _showSnackbar('User deleted successfully!');
      _refreshUserList();
    }).catchError((error) {
      _showSnackbar('Failed to delete user.');
    });
  }

  Widget _buildAddUserForm() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextFormField(
              controller: _firstnameController,
              decoration: InputDecoration(labelText: 'First Name')),
          TextFormField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: 'Last Name')),
          TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email')),
          ElevatedButton(
            onPressed: _addUser,
            child: Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _addUser() {
    if (_firstnameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      _userService
          .createUser(User(
        firstName: _firstnameController.text,
        lastName: _lastnameController.text,
        email: _emailController.text,
        picture: _pictureController.text,
      ))
          .then((newUser) {
        _showSnackbar('User added successfully!');
        _refreshUserList();
        _clearTextControllers();
      }).catchError((error) {
        _showSnackbar('Failed to add user: $error');
      });
    } else {
      _showSnackbar('Please fill in all fields.');
    }
  }

  void _refreshUserList() {
    setState(() {
      _futureUsers = _userService.getUsers();
    });
  }

  void _clearTextControllers() {
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _pictureController.clear();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
