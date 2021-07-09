import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:uas_rendra/helpers/dbhelpers.dart';
import 'package:uas_rendra/models/cashnote.dart';
import 'package:uas_rendra/theme.dart';

enum TransType { earning, expense }

class AddDataWidget extends StatefulWidget {
  AddDataWidget();

  @override
  _AddDataWidgetState createState() => _AddDataWidgetState();
}

class _AddDataWidgetState extends State<AddDataWidget> {
  _AddDataWidgetState();

  DbHelpers dbconn = DbHelpers();
  final _addFormKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _jumlahController = TextEditingController();
  String transType = 'earning';
  TransType _transType = TransType.earning;
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Form(
        key: _addFormKey,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 24.0, right: 24.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: _deskripsiController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: primaryText,
                    hintText: 'Contoh : Gaji',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: primaryColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: primaryColor)),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Deskripsi Tidak Boleh Kosong Ya !';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: _tanggalController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    labelStyle: primaryText,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: primaryColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: primaryColor)),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Tanggal Transaksinya Masih Kosong Nih !';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101));
                    if (picked != null && picked != selectedDate)
                      setState(() {
                        selectedDate = picked;
                        var date =
                            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
                        _tanggalController.text = date;
                      });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tipe Transaksi',
                      style: primaryText,
                    ),
                    ListTile(
                      title: const Text('Pemasukkan'),
                      leading: Radio(
                        value: TransType.earning,
                        groupValue: _transType,
                        onChanged: (TransType value) {
                          setState(() {
                            _transType = value;
                            transType = 'earning';
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Pengeluaran'),
                      leading: Radio(
                        value: TransType.expense,
                        groupValue: _transType,
                        onChanged: (TransType value) {
                          setState(() {
                            _transType = value;
                            transType = 'expense';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 50.0),
                child: TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jumlah Transaksi',
                    labelStyle: primaryText,
                    hintText: 'Contoh : 500000',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: primaryColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: primaryColor)),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Jumlahnya Masih Kosong Nih !';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_addFormKey.currentState.validate()) {
                            _addFormKey.currentState.save();
                            final initDB = dbconn.initDB();
                            initDB.then((db) async {
                              dbconn.insertTrans(Cashnote(
                                  tanggalNote: _tanggalController.text,
                                  deskripsiNote: _deskripsiController.text,
                                  tipeNote: transType,
                                  jumlahTrx:
                                      int.parse(_jumlahController.text)));
                            });

                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'SIMPAN',
                          style: whiteText,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('BATAL'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
