import 'package:flutter/material.dart';

class DropDownCustom extends StatelessWidget {

  final List<String> listaDeOpciones;
  final String nombreColeccion;
  final Function onSelectedValue;
  final String? selectElement;

  const DropDownCustom({super.key, 
    required this.listaDeOpciones, 
    required this.nombreColeccion, 
    required this.onSelectedValue,
    this.selectElement
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      focusColor: Colors.amber,
      hint: selectElement == null ? Text(nombreColeccion) : null,
      value: selectElement,
      validator: (value) {
        if(value == null || value.isEmpty) {
            return 'Debe seleccionar un item';
        }
        return null;
      },
      padding: const EdgeInsets.symmetric(horizontal: 4.0),  
      items: listaDeOpciones.map((e){
      return DropdownMenuItem(
        // ignore: sort_child_properties_last
        child: SizedBox(
          width: double.infinity,
          child: Text(
            e,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: e,
      );
      }).toList(),
       onChanged: (value) {    
         onSelectedValue(value);
         },
         isDense: true,
         isExpanded: true,
          );
          
   }

}