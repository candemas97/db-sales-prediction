import 'package:flutter/material.dart';
import 'package:myapp/view/estilotitulo.dart';
import 'package:redis/redis.dart';

class CaptureCheck extends StatefulWidget {
  const CaptureCheck({super.key});

  @override
  State<CaptureCheck> createState() => _CaptureState();
}

class _CaptureState extends State<CaptureCheck> {
  int _isValidOportunity = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for text fields
  final _clientCodeController = TextEditingController();
  
  void changeState (String response) {
    print("entra aca");
    setState(() {
      if (response == "Won") {
        _isValidOportunity = 1;
      } else if (response == "Lost") {
        _isValidOportunity = -1;
      } else {
        _isValidOportunity = 0;
      }
      _isLoading = false;
    });
  }

  final conn = RedisConnection();

  Future<String> connectToRedis(String key) async {
    const redisHost = 'redis-17205.c245.us-east-1-3.ec2.redns.redis-cloud.com';
    const redisPort = 17205;
    const redisPassword = 'sTGiKr1gp3nrYoyXVPdv9zhdFW8H2eOC';
    print('El valor de value es $key');  
    final connection = RedisConnection();
    Command command;

    try {
      // Connect to Redis server
      command = await connection.connect(redisHost, redisPort);

      // Authenticate with the provided password
      await command.send_object(['AUTH', redisPassword]);

      print('Connected to Redis');

      // Obtener el valor de la clave específica
      var value = await command.send_object(['GET', key]);
      print('El valor es $value');    
      if (value == null) {      
        print('La clave "$key" no existe en la base de datos.');
        changeState("No existe");
        return "No existe";
      } else {      
        changeState(value);
        print('Valor de la clave "$key": $value');
        return value;
      }
    } catch (e) {
      print('Error: $e');
      changeState("Error");
      return "Error";
    } finally {
      // Close the connection
      connection.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar oportunidad'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const EstiloTitulo(textoTitulo: 'Ingrese numero de oportunidad'),      
                    const SizedBox(height: 30,),
                    // Client code text field
                    TextFormField(
                      controller: _clientCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Número oportunidad',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un código';
                        }
                        return null;
                      },
                    ),

                    // Submit button
                    ElevatedButton(
                      onPressed: () {
                        final String value = _clientCodeController.text;
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          connectToRedis(value);
                        }
                      },
                      child: const Text('Guardar Datos'),
                    ),
                    // Show the result of the validation
                    if (_isValidOportunity == 1)
                      const Text(
                        'hay probabilidad de ganar la oportunidad',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                      // Show the result of the validation when it is not valid
                    if (_isValidOportunity == -1)
                      const Text(
                        'hay probabilidad de perder la oportunidad',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    if (_isValidOportunity == 0)
                      const Text(
                        'No se encuentra la oportunidad en la base de datos',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                        ),
                      ),  
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
