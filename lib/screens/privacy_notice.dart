import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warudu_web_app/colors.dart';

class PrivacyNotice extends StatefulWidget {
  @override
  _PrivacyNoticeState createState() => _PrivacyNoticeState();
}

class _PrivacyNoticeState extends State<PrivacyNotice> {
  String privacyNotice = """
Recopilación de Información: Recopilamos la siguiente información personal cuando te registras en nuestra aplicación Warudu: nombre y correo electrónico.

Métodos de Registro: Puedes registrarte e ingresar a la aplicación a través de dos métodos: usando tu cuenta de Google o registrándote directamente en la propia aplicación.

Uso de la Información: Utilizamos la información recopilada para proveer y operar nuestra aplicación, así como para mejorar y personalizar nuestros servicios. También recomendamos platillos basados en tu presupuesto semanal, ingredientes en casa, gustos y alergias. Además, te comunicamos actualizaciones y otras informaciones relevantes, y cumplimos con obligaciones legales y resolvemos cualquier disputa.

Seguridad de la Información: Adoptamos medidas de seguridad razonables para proteger tu información personal contra accesos no autorizados, pérdida o divulgación. Esto incluye la encriptación de datos y el uso de certificados SSL en el servidor del sitio y base de datos.

Pagos: Para los usuarios premium, los pagos se realizan a través de un enlace de PayPal. No manejamos ni almacenamos información bancaria, ya que el proceso y la protección están a cargo de PayPal.

Uso de Cookies y Tecnologías Similares: Nuestra aplicación puede utilizar cookies y tecnologías similares para mejorar la experiencia del usuario. Estas tecnologías permiten recordar tus preferencias y recopilar datos de uso.

Compartir Información: No compartimos tu información personal con terceros, excepto en las siguientes circunstancias: con tu consentimiento, para cumplir con leyes o regulaciones aplicables, o para proteger nuestros derechos y propiedad.

Transferencias Internacionales de Datos: Podemos transferir y procesar tu información fuera de tu país de origen. Tomamos medidas para asegurar que cualquier transferencia de datos cumpla con las leyes aplicables y se realice de manera segura.

Retención de Datos: Retenemos tu información personal solo durante el tiempo necesario para cumplir con los fines descritos en esta política, a menos que se requiera un período de retención más largo o permitido por la ley.

Precios Ingredientes: Los precios de los ingredientes son aproximados y estan sujetos datos establecidos en base a los reportes de costes de PROFECO en zonas de Jalisco México, pueden entonces no ser exactos y variados.

Precios Platillos: Los precios de los platillos se calculan a partir del precio de los ingredientes que lo componen, por lo que es una aproximación y no un valor exacto.

Derechos de los Usuarios: Tienes derecho a acceder, corregir, eliminar o restringir el procesamiento de tu información personal. También puedes ejercer el derecho a la portabilidad de los datos. Para ejercer estos derechos, contáctanos en warudu29@gmail.com.

Cambios a esta Política de Privacidad: Nos reservamos el derecho de actualizar esta política en cualquier momento. Te notificaremos cualquier cambio mediante la publicación de la nueva política en nuestra aplicación, página web y correo electrónico.

Contacto: Si tienes alguna pregunta o inquietud sobre nuestra política de privacidad, no dudes en contactarnos en warudu29@gmail.com.
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Padding(
          padding: MediaQuery.sizeOf(context).width > 600
              ? const EdgeInsets.symmetric(horizontal: 200, vertical: 20.0)
              : const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón para regresar
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: white, size: 30),
                  onPressed: () async {
                    Navigator.pop(context); // Regresar a la pantalla anterior
                    final Uri url = Uri.parse('https://www.warudu.com');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      print("No se pudo abrir la URL");
                    }
                  },
                ),
              ),
              //Titulo
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Politicas de Privacidad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        privacyNotice,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: white,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Image.asset(
                        'assets/images/warudu_logo.png',
                        width: MediaQuery.sizeOf(context).width > 600
                            ? MediaQuery.of(context).size.height * 0.4
                            : 180.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
