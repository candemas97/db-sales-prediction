import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/model/commercial_opportunity.dart';
import 'package:mongo_dart/mongo_dart.dart';


class DataSave {

// ignore: prefer_typing_uninitialized_variables
static var bd;

DataSave() {
  bd = Db.create(dotenv.env['CONNECTION_STRING']!);  
}

  
Future<bool> saveInfo(CommercialOpportunity commercialOpportunity) async {
  try {
    bd = await Db.create(dotenv.env['CONNECTION_STRING']!); 
    await bd.open();
    final collection = bd.collection('opportunities');
    final result = await collection.insertOne(commercialOpportunity.toJson()); 
    await bd.close(); 
    return true;
  } on Exception catch (e) {
    print("Error: $e");
    return false;
  }
}

//Obtener el último registro de la colección opportunities ordenado por numero_opportunidad

Future<String> getLastOpportunity() async {
    print(dotenv.env['CONNECTION_STRING']);
    bd = await Db.create(dotenv.env['CONNECTION_STRING']!);  
    await bd.open();
    final collection = bd.collection('opportunities');
    final result = await collection.findOne(where.sortBy('numero_opportunidad', descending: true));
    CommercialOpportunity opportunity = CommercialOpportunity.fromJson(result);
    await bd.close();
    return opportunity.numeroOperacion;      
}





}
