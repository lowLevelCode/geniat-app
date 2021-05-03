import 'package:flutter/material.dart';
import 'package:geniant_app/Screens/Request/components/car.dart';
import 'package:geniant_app/Screens/Request/components/marca.dart';
import 'package:geniant_app/Util/response.server.dart';
import 'package:geniant_app/services/global.service.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int page = 1;
  int idMarca = 0;
  ScrollController _scrollController;

  List<Car> _autos = [];
  List<Marca> _marcas = <Marca>[];
  Marca _selectedMarca;
  bool isLoadingScrollData = false;

  @override
  void initState() {
    super.initState();
    _init();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scrollMoreData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _getData(int page, int idMarca) {
    return GlobalService.consultar(page, idMarca);
  }

  _init() async {
    setState(() {
      this.page = 1;
      this.idMarca = 0;
    });
    ResponseServer server = await _getData(this.page, this.idMarca);
    var data = server.data["resultados"];
    var marcas = server.data["marcas"];
    _updateDateState(data);
    _loadMarcas(marcas);
  }

  void _loadMarcas(marcas) {
    for (var marca in marcas) {
      setState(() {
        Marca newMarca = new Marca(marca["idMarca"], marca["nombre"]);
        _marcas.add(newMarca);
      });
    }
  }

  void _updateDateState(var data) {
    for (var car in data) {
      setState(() {
        Car newCar =
            new Car(car["idMarca"], car["nombreModelo"], car["nombreMarca"]);
        _autos.add(newCar);
      });
    }
  }

  void _scrollMoreData() async {
    setState(() {
      this.page++;
    });
    ResponseServer server = await _getData(this.page, 0);
    var data = server.data["resultados"];
    _updateDateState(data);
  }

  void _onChangeMarca(int idMarca) async {
    setState(() {
      this.idMarca = idMarca;
      _autos.clear();
    });

    ResponseServer server = await _getData(this.page, this.idMarca);
    var data = server.data["resultados"];
    _updateDateState(data);
  }

  Future _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _autos.clear();
      _marcas.clear();
      _selectedMarca = null;
    });
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          DropdownButton<Marca>(
            hint: Text(
              "Filtra por marca",
              style: TextStyle(color: Colors.white),
            ),
            value: _selectedMarca,
            onChanged: (Marca marca) {
              setState(() {
                _selectedMarca = marca;
              });

              _onChangeMarca(marca.idMarca);
            },
            items: _marcas.map((Marca marca) {
              return DropdownMenuItem<Marca>(
                value: marca,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      marca.nombre,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, int index) {
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 12.0, 12.0, 6.0),
                            child: Text(
                              _autos[index].nombreMarca,
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 6.0, 12.0, 12.0),
                            child: Text(
                              _autos[index].nombreModelo,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.car_rental,
                                size: 35.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2.0,
                    color: Colors.grey,
                  )
                ],
              );
            },
            itemCount: _autos.length),
      ),
    );
  }
}
