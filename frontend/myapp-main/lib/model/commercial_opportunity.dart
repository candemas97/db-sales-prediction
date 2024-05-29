class CommercialOpportunity {
  String numeroOperacion;
  String cliente;
  String unidadNegocio;
  String etapa;
  String tipo;
  double acv;
  double tcv;
  double margenGanancia;
  String region;
  String territorio;
  String industria;
  String fechaCreacion;
  String fechaCierre;
  double edadOferta;
  String fuentePrincipal;
  String numeroVendedor;

  CommercialOpportunity({
    required this.numeroOperacion,
    required this.cliente,
    required this.unidadNegocio,
    required this.etapa,
    required this.tipo,
    required this.acv,
    required this.tcv,
    required this.margenGanancia,
    required this.region,
    required this.territorio,
    required this.industria,
    required this.fechaCreacion,
    required this.fechaCierre,
    required this.edadOferta,
    required this.fuentePrincipal,
    required this.numeroVendedor,
  });

  
Map<String, dynamic> toJson() {
    return {
      'numero_opportunidad': numeroOperacion,
      'cliente': cliente,
      'unidad_negocio': unidadNegocio,
      'etapas': etapa,
      'tipos': tipo,
      'acv': acv,
      'tcv': tcv,
      'margen_ganancia': margenGanancia,
      'regiones': region,
      'territorios': territorio,
      'industrias': industria,
      'fecha_creacion_oportunidad': fechaCreacion,
      'fecha_cierre_oportunidad': fechaCierre,
      'edad_oferta': edadOferta,
      'lead_source': fuentePrincipal,
      'numero_vendedor': numeroVendedor,
    };
  }

  
static CommercialOpportunity fromJson(Map<String, dynamic> result)  {
    return CommercialOpportunity(
      numeroOperacion: result['numero_opportunidad'],
      cliente: result['cliente'],
      unidadNegocio: result['unidad_negocio'],
      etapa: result['etapas'],
      tipo: result['tipos'],
      acv: result['acv'],
      tcv: result['tcv'],
      margenGanancia: result['margen_ganancia'],
      region: result['regiones'],
      territorio: result['territorios'],
      industria: result['industrias'],
      fechaCreacion: result['fecha_creacion_oportunidad'],
      fechaCierre: result['fecha_cierre_oportunidad'],
      edadOferta: result['edad_oferta'],
      fuentePrincipal: result['lead_source'],
      numeroVendedor: result['numero_vendedor'],
    );
  }


  
}