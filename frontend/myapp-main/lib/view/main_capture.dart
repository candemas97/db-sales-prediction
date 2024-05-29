import 'package:flutter/material.dart';
import 'package:myapp/data/savedata.dart';
import 'package:myapp/model/commercial_opportunity.dart';
import 'package:myapp/view/dropdowncustom.dart';
import 'package:myapp/view/estilotitulo.dart';

class Capture extends StatefulWidget {
  const Capture({super.key});

  @override
  State<Capture> createState() => _CaptureState();
}

class _CaptureState extends State<Capture> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _clientCodeController = TextEditingController();
  final _acvController = TextEditingController();
  final _yearsController = TextEditingController();
  final _tcvController = TextEditingController();
  final _marginController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getLastOpportunityNumber();
    _dateController.text = "${_selectedDate.toLocal()}".split(' ')[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2034),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${_selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Dropdowns
  String? _businessUnit;
  String? _type;
  String? _region;
  String? _territory;
  String? _industry;
  String? _idsealer;
  String? _leadSource;

  String _lastOpportunityNumber = '';

  // Function to save Commercial Opportunity
  Future<void> saveCommercialOpportunity() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get the form data
      String clientCode = _clientCodeController.text;
      String acv = _acvController.text;
      String years = _yearsController.text;
      String tcv = _tcvController.text;
      String margin = _marginController.text;
      int lastOpportunityNumberInt = await _getLastOpportunityNumber();
      String lastOpportunityNumber = "OP-${lastOpportunityNumberInt + 1}";
      DateTime now = DateTime.now();
      String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      int differenceInDays = DateTime.parse(_dateController.text).difference(now).inDays;
      double edadOferta = differenceInDays.toDouble();

      CommercialOpportunity opportunity = CommercialOpportunity(
        numeroOperacion: lastOpportunityNumber,
        cliente: clientCode,
        unidadNegocio: _businessUnit!,
        etapa: "S1",
        tipo: _type!,
        acv: double.parse(acv),
        tcv: double.parse(tcv),
        margenGanancia: double.parse(margin),
        region: _region!,
        territorio: _territory!,
        industria: _industry!,
        fechaCreacion: formattedDate,
        fechaCierre: _dateController.text,
        edadOferta: edadOferta,
        fuentePrincipal: _leadSource!,
        numeroVendedor: _idsealer!,
      );

      final dataSave = DataSave();
      bool result = await dataSave.saveInfo(opportunity);

      setState(() {
        _isLoading = false;
      });

      if (result) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: Text('La oportunidad comercial $lastOpportunityNumber se guardó correctamente'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
        clearAllControllers();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar los datos'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<int> _getLastOpportunityNumber() async {
    final dataSave = DataSave();
    final data = await dataSave.getLastOpportunity();
    _lastOpportunityNumber = data;
    return int.parse(_lastOpportunityNumber.substring(3));
  }

  List<String> opcionesUnidadNegocio=[
    'BU-01',
    'BU-02',
    'BU-03',
    'BU-04',
    'BU-05',
    'BU-06',
    'BU-07',
    'BU-08',
    'BU-09',
    'BU-10',
  ];
  
  List<String> tipos=[
    'TY-00',
    'TY-01',
    'TY-02',
    'TY-03',
    'TY-04',
    'TY-05',    
  ];

  List<String> regiones=[
    'RE-00',
    'RE-01',
    'RE-02',
    'RE-03',    
  ];

  List<String> territorios=[
    'TE-00',
    'TE-01',
    'TE-02',
    'TE-03',    
    'TE-04',
    'TE-05',
    'TE-06',
    'TE-07',
    'TE-08',    
  ];

  List<String> industrias=[
    'IN-00',
    'IN-01',
    'IN-02',
    'IN-03',    
    'IN-04',
    'IN-05',
    'IN-06',
    'IN-07',
    'IN-08',    
    'IN-09',
    'IN-10',
  ];

  List<String> vendedores=[
    'NV-0',
    'NV-1',
    'NV-2',
    'NV-3',    
    'NV-4',    
  ];

  List<String> fuentePrincipal=[
    'LS-00',
    'LS-01',
    'LS-02',
    'LS-03',    
    'LS-04',
    'LS-05',
    'LS-06',
    'LS-07',
    'LS-08',    
    'LS-09',
    'LS-10',
  ];


  void clearAllControllers() {
    _clientCodeController.clear();
    _acvController.clear();
    _yearsController.clear();
    _tcvController.clear();
    _marginController.clear();
    _dateController.clear();
    _businessUnit = null;
    _type = null;
    _region = null;
    _territory = null;
    _industry = null;
    _idsealer = null;
    _leadSource = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TABD'),
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
                    const SizedBox(height: 20),
                    const EstiloTitulo(textoTitulo: 'Ingrese los datos'),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _clientCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Código de cliente',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un código';
                        }
                        return null;
                      },
                    ),
                    DropDownCustom(
                      listaDeOpciones: opcionesUnidadNegocio,
                      nombreColeccion: 'Unidad de negocio',
                      onSelectedValue: (value) {
                        _businessUnit = value;
                        setState(() {});
                      },
                      selectElement: _businessUnit,
                    ),
                    DropDownCustom(
                      listaDeOpciones: tipos,
                      nombreColeccion: 'Tipo',
                      onSelectedValue: (value) {
                        _type = value;
                        setState(() {});
                      },
                      selectElement: _type,
                    ),
                    DropDownCustom(
                      listaDeOpciones: regiones,
                      nombreColeccion: 'Región',
                      onSelectedValue: (value) {
                        _region = value;
                        setState(() {});
                      },
                      selectElement: _region,
                    ),
                    DropDownCustom(
                      listaDeOpciones: territorios,
                      nombreColeccion: 'Territorio',
                      onSelectedValue: (value) {
                        _territory = value;
                        setState(() {});
                      },
                      selectElement: _territory,
                    ),
                    DropDownCustom(
                      listaDeOpciones: industrias,
                      nombreColeccion: 'Industria',
                      onSelectedValue: (value) {
                        _industry = value;
                        setState(() {});
                      },
                      selectElement: _industry,
                    ),
                    DropDownCustom(
                      listaDeOpciones: vendedores,
                      nombreColeccion: 'Vendedor',
                      onSelectedValue: (value) {
                        _idsealer = value;
                        setState(() {});
                      },
                      selectElement: _idsealer,
                    ),
                    TextFormField(
                      controller: _acvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ACV',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an ACV';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Fecha cierre: ${_dateController.text}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _tcvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'TCV',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a TCV';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _marginController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Margen',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a margin';
                        }
                        return null;
                      },
                    ),
                    DropDownCustom(
                      listaDeOpciones: fuentePrincipal,
                      nombreColeccion: 'Lead Source',
                      onSelectedValue: (value) {
                        _leadSource = value;
                        setState(() {});
                      },
                      selectElement: _leadSource,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveCommercialOpportunity,
                      child: const Text('Guardar Datos'),
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
