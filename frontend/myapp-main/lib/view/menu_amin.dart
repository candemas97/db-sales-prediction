import 'package:flutter/material.dart';
import 'package:myapp/data/validuser.dart';
import 'package:myapp/view/login.dart';
import 'package:myapp/view/main_capture.dart';
import 'package:myapp/view/validate_oportunity.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de Administrador'),
      ),
      body: const Center(
        child: Text('Contenido del menú de administrador'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Registrar oportunidad'),
              onTap: () {
                // Navega a la pantalla de registro de oportunidad
                _navigateToMainCapture(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Validar resultado'),
              onTap: () {
                // Navega a la pantalla de validación de resultados
                // Implementa esta navegación según tus necesidades
                _checkOportunity(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                // Implementa aquí la lógica para cerrar sesión
                _signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    // Aquí puedes implementar la lógica para cerrar sesión
    // Esto podría ser un método que limpia las credenciales y navega a la pantalla de inicio de sesión
    // Por ejemplo:
    // Limpia las credenciales
    // Navigate back to login screen
    await ValidUser().signOut();
    Navigator.pop(context); // Cerrar el menú desplegable
    // Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _checkOportunity(BuildContext context) {
    // Navigate to login screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CaptureCheck()),
    );
  }

  //Navegar a main_capture
  void _navigateToMainCapture(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Capture()),
    );
  }
}
