import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Bienvenido a la lista pokemon'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<PokemonResponse> _getPokemons() async {
    final respuesta = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
    if(respuesta.statusCode == 200) {
      return PokemonResponse.fromJson(jsonDecode(respuesta.body));
    }else {
      throw Exception('No se pudo cargar los pokemon');
    }
  }

  late Future<PokemonResponse> listaPokemon;

  
  /*List<int> pokemons = List.generate(10, (i) => i);
  ScrollController _scrollController = new ScrollController();
  bool estaHaciendoPeticion = false;*/

  @override
  void initState() {
    super.initState();
    /*_scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        listaPokemon = _getPokemons();
      }
    });*/
    listaPokemon = _getPokemons();
  }

  /*@override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }*/

  /*_obtenerPokemons() async {
    if(!estaHaciendoPeticion) {
      setState(() {
        estaHaciendoPeticion = true;
      });
      List<int> nuevosPokemon = await peticion(pokemons.length, pokemons.length + 10);
    }
  }*/


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: FutureBuilder<PokemonResponse>(
          future: listaPokemon,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.results!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(leading: Icon(Icons.adb), title: snapshot.data!.results!.forEach((element) {element.name}),);
                }

              )
            }else if(snapshot.hasError) {
              return Text('No funciona');
            }

            return const CircularProgressIndicator(backgroundColor: Colors.amber,);
          }
        )
      ),
    );
  }
}


class PokemonResponse {
  int ? count;
  String ? next;
  Null previous;
  List<Pokemon> ? results;

  PokemonResponse({this.count, this.next, this.previous, this.results});

  PokemonResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Pokemon>[];
      json['results'].forEach((v) {
        results!.add(new Pokemon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pokemon {
  String ? name;
  String ? url;

  Pokemon({required this.name, required this.url});

  Pokemon.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}