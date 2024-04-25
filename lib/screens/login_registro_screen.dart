import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore
import '../firebase_options.dart';
import 'preguntas_usuario.dart'; // Importa la página de preguntas del usuario

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.pink,
          background: Color.fromRGBO(255, 169, 209, 1.0), // Establece el color de fondo de la aplicación
        ),
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Nuevo controlador para el nombre de usuario

  Future<void> _authenticate(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await _signInWithEmail(context);
      } else {
        await _signUpWithEmail();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              alignment: Alignment.center, // Centra el contenido del SnackBar
              child: Padding(
                padding: EdgeInsets.only(top: 0.0), // Ajusta el margen superior del contenido
                child: Text(
                  'Log in successful!',
                  style: TextStyle(fontSize: 18.0), // Aumenta el tamaño de la letra
                ),
              ),
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating, // Cambia el comportamiento del SnackBar a flotante
            shape: RoundedRectangleBorder( // Cambia la forma del SnackBar
              borderRadius: BorderRadius.circular(100.0),
            ),
            margin: EdgeInsets.only(bottom: 120.0, left: 40.0, right: 40.0), // Ajusta el margen del SnackBar para cambiar su posición
          ),
        );
        // Navegar a la pantalla PreguntasUsuario
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PreguntasUsuario(email: _emailController.text)),
        );
      }
    } on FirebaseAuthException catch (error) {
      _showErrorDialog(error.message ?? 'An error occurred');
    }
  }

  Future<void> _signUpWithEmail() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        // Guardar el nombre de usuario en Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(_emailController.text).set({
          'nombre': _usernameController.text, // Guarda el nombre de usuario en Firestore
          'mail': _emailController.text,
          'puntos': 150, // Agrega 150 puntos al registrarse
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navegar al apartado de login después de un breve retraso
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isLogin = true;
          });
        });
      }
    } on FirebaseAuthException catch (error) {
      _showErrorDialog(error.message ?? 'An error occurred');
    }
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      _showErrorDialog('Failed to send reset password. Please check your email address.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 169, 209, 1.0), // Color de fondo rosa

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Color.fromRGBO(255, 169, 209, 1.0),
                height: 100, // Ajusta según tus necesidades
                width: 200,
                child: Image.asset(
                  'assets/match2.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: 350, // Anchura deseada para la tarjeta
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLogin = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                decoration: BoxDecoration(
                                  color: _isLogin ? Color.fromRGBO(226, 50, 42, 1): Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    bottomLeft: Radius.circular(40),
                                  ),
                                ),
                                child: Text(
                                  'Log in',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLogin = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                decoration: BoxDecoration(
                                  color: _isLogin ? Colors.grey : Color.fromRGBO(226, 50, 42, 1),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25), // Solo altura en la parte inferior
                          child: Text(
                            _isLogin ? 'Welcome to MATCH!' : 'Welcome to MATCH!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), // Texto en negrita
                          ),
                        ),
                        SizedBox(height: 1),
                        // Campo de texto para el nombre de usuario
                        if (!_isLogin)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 20 ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => _authenticate(context),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 18),
                            primary: Color.fromRGBO(226, 50, 42, 1), // Color de fondo
                            minimumSize: Size(double.infinity, 50), // Ancho y alto del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40), // Radio del borde
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(_isLogin ? 'Log in' : 'Sign Up'),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_isLogin)
                          TextButton(
                            onPressed: _resetPassword,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose(); // Dispose del controlador de nombre de usuario
    super.dispose();
  }
}

class UserInfo extends StatelessWidget {
  final String email;

  UserInfo({required this.email});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('usuarios')
          .doc(email) // Asumiendo que el documento tiene el mismo ID que el correo electrónico
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("El usuario no existe");
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return ListTile(
          title: Text('${userData['nombre']} ${userData['Apellido']}'),
          subtitle: Text(userData['mail']),
        );
      },
    );
  }
}
