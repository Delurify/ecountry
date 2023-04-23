import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'dart:io';

class EcountryPage extends StatefulWidget {
  const EcountryPage({super.key});

  @override
  State<EcountryPage> createState() => _EcountryState();
}

class _EcountryState extends State<EcountryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('E-Country'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(children: [
          Flexible(
              flex: 5, child: Image.asset('assets/images/logo.png', scale: 2)),
          const Flexible(flex: 5, child: ECountryForm())
        ])));
  }
}

class ECountryForm extends StatefulWidget {
  const ECountryForm({Key? key}) : super(key: key);

  @override
  State<ECountryForm> createState() => _ECountryFormState();
}

class _ECountryFormState extends State<ECountryForm> {
  String desc = "No records";
  String selectCountry = "Malaysia";
  List<String> countryList = ["Malaysia", "Thailand", "Singapore"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(children: [
        const Text(
          "Select a country",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButton(
            itemHeight: 60,
            value: selectCountry,
            onChanged: (newValue) {
              setState(() {
                selectCountry = newValue.toString();
              });
            },
            items: countryList.map((selectCountry) {
              return DropdownMenuItem(
                child: Text(
                  selectCountry,
                ),
                value: selectCountry,
              );
            }).toList()),
        ElevatedButton(
            onPressed: _loadCountry, child: const Text("Load Country")),
        Text(desc,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Future<void> _loadCountry() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    progressDialog.dismiss();

    String apiid = "D9dYvmSVchATL1WgPdG2tg==ol8iKfbIRSBgSPsH";
    Uri url =
        Uri.parse('https://api.api-ninjas.com/v1/country?name=$selectCountry');

    var response = await http.get(url, headers: {
      'X-API-Key': apiid,
    });
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      print(parsedJson);
      setState(() {
        desc = "";
      });
    } else {
      setState(() {
        desc = selectCountry;
      });
    }
  }
}
