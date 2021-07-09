import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:uas_rendra/helpers/dbhelpers.dart';
import 'package:uas_rendra/models/cashnote.dart';
import 'package:uas_rendra/theme.dart';
import 'package:uas_rendra/ui/home.dart';

enum TransType { earning, expense }

class EditDataWidget extends StatefulWidget {
  EditDataWidget(this.note);

  final Cashnote note;

  @override
  _EditDataWidgetState createState() => _EditDataWidgetState();
}

class _EditDataWidgetState extends State<EditDataWidget> {
  _EditDataWidgetState();

  DbHelpers dbconn = DbHelpers();
  final _addFormKey = GlobalKey<FormState>();
  int _id;
  final _tanggalController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _jumlahController = TextEditingController();
  String transType = '';
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
  void initState() {
    _id = widget.note.id;
    _tanggalController.text = widget.note.tanggalNote;
    _deskripsiController.text = widget.note.deskripsiNote;
    _jumlahController.text = widget.note.jumlahTrx.toString();
    transType = widget.note.tipeNote;
    if (widget.note.tipeNote == 'earning') {
      _transType = TransType.earning;
    } else {
      _transType = TransType.expense;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rubah Transaksi'),
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
                      return 'Please enter transaction name';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
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
                      title: const Text('Earning'),
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
                      title: const Text('Expense'),
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
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                      return 'Please enter amount';
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
                              await dbconn.updateTrans(Cashnote(
                                  id: _id,
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
                          'UBAH',
                          style: whiteText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 250,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: redColor,
                      ),
                      child: TextButton(
                        onPressed: () {
                          final initDB = dbconn.initDB();
                          initDB.then((db) async {
                            await dbconn.deleteTrans(widget.note.id);
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'HAPUS',
                          style: whiteText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Perhatian !!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Yakin ingin menghapus transaksi ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yakin'),
              onPressed: () {
                final initDB = dbconn.initDB();
                initDB.then((db) async {
                  await dbconn.deleteTrans(widget.note.id);
                });

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            FlatButton(
              child: const Text('Kembali'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
