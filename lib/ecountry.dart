import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

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
  double gdp = 0.0;
  double unemployRate = 0.0;
  String capital = "";
  String id = "";
  var flagImg = Image.asset('assets/images/nothing.png', scale: 5);
  String desc = " ";
  String selectCountry = "Malaysia";
  List<String> countryList = ["Malaysia", "Thailand", "Singapore"];
  var mapObj = <String, dynamic>{};

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
          }).toList(),
        ),
        ElevatedButton(
            onPressed: _loadCountry, child: const Text("Load Country")),
        const SizedBox(height: 10),
        Expanded(child: flagImg),
        Text(desc,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Future<void> _loadCountry() async {
    mapObj = {"Malaysia": "MY", "Thailand": "TL", "Singapore": "SG"};
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
        gdp = parsedJson[0]['gdp'];
        unemployRate = parsedJson[0]["unemployment"];
        capital = parsedJson[0]["capital"];
        id = mapObj[selectCountry];
        flagImg = Image.network("https://flagsapi.com/$id/flat/64.png");

        desc =
            "The current GDP of $selectCountry is $gdp. The unemployment rate is $unemployRate percent, and the capital city of $selectCountry is $capital";
      });
    } else {
      setState(() {
        desc = selectCountry;
      });
    }
  }
}
