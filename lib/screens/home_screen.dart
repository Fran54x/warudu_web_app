import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = 80.0;
    final double bottomBarHeight = 50.0;
    final double availableHeight =
        screenHeight - appBarHeight - bottomBarHeight;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 5),
            Image(
              image: AssetImage('assets/images/warudu_logo_crema.png'),
              width: 60,
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Warudu',
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: cream,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: green,
        toolbarHeight: appBarHeight,
        actions: [
          if (MediaQuery.of(context).size.width > 600) ...[
            TextButton(
              onPressed: () {},
              child: Text(
                'Inicio',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: cream,
                ),
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Aplicación',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: cream,
                ),
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Nosotros',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: cream,
                ),
              ),
            ),
            SizedBox(width: 15),
          ] else ...[
            PopupMenuButton<String>(
              icon: Icon(Icons.menu, color: cream),
              onSelected: (value) {
                // Navegar según la opción seleccionada
                switch (value) {
                  case 'Inicio':
                    // Acción para Inicio
                    break;
                  case 'Aplicación':
                    // Acción para Aplicación
                    break;
                  case 'Nosotros':
                    // Acción para Nosotros
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return ['Inicio', 'Aplicación', 'Nosotros']
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primera sección (Portada)
            Container(
              color: green,
              //height: availableHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  FadeInImage.memoryNetwork(
                    fadeInDuration: const Duration(seconds: 2),
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                    image: 'assets/images/pozole.jpg',
                    width: double.infinity,
                    height: availableHeight,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      'Bienvenido a Warudu',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Segunda sección (¿Qué es Warudu?)
            Container(
              padding: EdgeInsets.all(60),
              color: cream,
              child: DottedBorder(
                color: white,
                strokeWidth: 15,
                dashPattern: [35, 30], // Largo y espacio de los segmentos
                borderType: BorderType.RRect,
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.transparent,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // Vista de escritorio
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: -10 *
                                  3.1415927 /
                                  180, // Rotación de 10 grados hacia la izquierda
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white, // Color del borde
                                    width: 10, // Grosor del borde
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      12), // Radio de las esquinas redondeadas
                                ),
                                child: ClipRRect(
                                  // Radio de las esquinas redondeadas
                                  child: FadeInImage.memoryNetwork(
                                    fadeInDuration: const Duration(seconds: 2),
                                    placeholder: kTransparentImage,
                                    fit: BoxFit.cover,
                                    image: 'assets/images/mole.jpg',
                                    width: screenWidth * 0.4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    20), // Espacio entre la imagen y el texto
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Centrar los textos horizontalmente
                                  children: [
                                    Text(
                                      "¿Qué es Warudu?",
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Es un planificador de comida impulsado con inteligencia artificial para recomendar platillos en base a gustos e ingredientes en casa",
                                      style: TextStyle(
                                        fontSize: 32 * 0.8,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign
                                          .center, // Centrar el texto dentro de su contenedor
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Vista de móvil
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: -10 *
                                  3.1415927 /
                                  180, // Rotación de 10 grados hacia la izquierda
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white, // Color del borde
                                    width: 5, // Grosor del borde
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      12), // Radio de las esquinas redondeadas
                                ),
                                child: ClipRRect(
                                  // Radio de las esquinas redondeadas
                                  child: FadeInImage.memoryNetwork(
                                    fadeInDuration: const Duration(seconds: 2),
                                    placeholder: kTransparentImage,
                                    fit: BoxFit.cover,
                                    image: 'assets/images/mole.jpg',
                                    width: screenWidth * 0.4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Centrar los textos horizontalmente
                                children: [
                                  Text(
                                    "¿Qué es Warudu?",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Es un planificador de comida impulsado con inteligencia artificial para recomendar platillos en base a gustos e ingredientes en casa",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Centrar el texto dentro de su contenedor
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),

            // Tercera sección (Aplicación)
            Container(
              height: MediaQuery.of(context).size.width > 600
                  ? availableHeight // Usar availableHeight en pantallas grandes
                  : null, // Ignorar availableHeight en móviles
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    // Vista de escritorio (Row)
                    return Row(
                      children: [
                        // Primera sección: Logo y texto "Warudu"
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 40, bottom: 30),
                            color: green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/warudu_logo.png',
                                  width: constraints.maxWidth * 0.26,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Warudu",
                                  style: GoogleFonts.inter(
                                    fontSize: 60,
                                    color: cream,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Segunda sección: QR Code y botón de Google Play
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 40, bottom: 30),
                            color: coral,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/qr_code.svg',
                                  width: constraints.maxWidth * 0.25,
                                ),
                                SizedBox(height: 20),
                                Image.asset(
                                  'assets/images/google_play_button.jpg',
                                  width: constraints.maxWidth * 0.2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Vista de móvil (Column)
                    return Column(
                      children: [
                        // Primera sección: Logo y texto "Warudu"
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          color: green,
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/warudu_logo.png',
                                height: constraints.maxWidth * 0.3,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Warudu",
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  color: cream,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Segunda sección: QR Code y botón de Google Play
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          color: coral,
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/qr_code.svg',
                                height: constraints.maxWidth * 0.3,
                              ),
                              SizedBox(height: 20),
                              Image.asset(
                                'assets/images/google_play_button.jpg',
                                width: constraints.maxWidth * 0.3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),

            // Cuarta sección (Nosotros)
            Container(
              padding: EdgeInsets.all(60),
              color: cream,
              child: Container(
                height: screenHeight * 0.55,
                decoration: BoxDecoration(
                  color: coral,
                  border: Border.all(
                    color: coral,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      // Vista de escritorio
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Centrando el texto
                              children: [
                                Text(
                                  "Nosotros",
                                  style: GoogleFonts.inter(
                                    fontSize: 48,
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Somos un pequeño grupo que busca expandir la variedad de platillos en tu mesa",
                                  style: GoogleFonts.inter(
                                    fontSize: 32 * 0.8,
                                    color: white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign:
                                      TextAlign.center, // Centrando el texto
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centrando los iconos
                                  children: [
                                    Image(
                                        image: AssetImage(
                                            'assets/images/facebook.png'),
                                        width: 50),
                                    SizedBox(width: 25),
                                    Image(
                                        image: AssetImage(
                                            'assets/images/twitter.png'),
                                        width: 50),
                                    SizedBox(width: 25),
                                    Image(
                                      image: AssetImage(
                                          'assets/images/instagram.png'),
                                      width: 50,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Transform.rotate(
                            angle: 4.18 * 3.1415927 / 180,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 10,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage.memoryNetwork(
                                  fadeInDuration: const Duration(seconds: 2),
                                  placeholder: kTransparentImage,
                                  fit: BoxFit.cover,
                                  image: 'assets/images/enchiladas.jfif',
                                  width: constraints.maxWidth * 0.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Vista de móvil
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Transform.rotate(
                            angle: 4.18 * 3.1415927 / 180,
                            child: Container(
                              decoration: BoxDecoration(
                                color: coral, // Color coral para el contenedor
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage.memoryNetwork(
                                  fadeInDuration: const Duration(seconds: 2),
                                  placeholder: kTransparentImage,
                                  fit: BoxFit.cover,
                                  image: 'assets/images/enchiladas.jfif',
                                  width: constraints.maxWidth * 0.45,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Nosotros",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Somos un pequeño grupo que busca expandir la variedad de platillos en tu mesa",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: white,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/facebook.png'),
                                      width: 30),
                                  SizedBox(width: 10),
                                  Image(
                                      image: AssetImage(
                                          'assets/images/twitter.png'),
                                      width: 30),
                                  SizedBox(width: 10),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/instagram.png'),
                                    width: 30,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            // Quinta sección (Pie de página)
            Container(
              padding: EdgeInsets.all(20),
              color: green,
              child: Column(
                children: [
                  Text(
                    "Pie de Página",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
