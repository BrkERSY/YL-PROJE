import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Center(
            child: Text(
          'QR CODE SCANNER & GENERATOR',
          style: TextStyle(
            fontFamily: "Silkscreen",
            fontSize: 18,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background3.png"))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/scan');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: const Size(300, 35),
                ),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text(
                  'Scan QR Code',
                  style: TextStyle(
                    fontFamily: "Silkscreen",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/generate');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: const Size(300, 35),
                ),
                icon: const Icon(Icons.qr_code_2_rounded),
                label: const Text(
                  'Generate QR Code',
                  style: TextStyle(
                    fontFamily: "Silkscreen",
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
