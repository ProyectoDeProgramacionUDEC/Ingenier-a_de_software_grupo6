import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MenuPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 33, 16, 105),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 205, 255, 7),
        title: const Text('Pokédex App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.catching_pokemon),
              label: const Text('Pokédex'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(248, 73, 143, 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListaPokemon()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.group),
              label: const Text('Mi Equipo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(248, 73, 143, 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
