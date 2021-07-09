import 'package:flutter/material.dart';
import 'package:uas_rendra/helpers/dbhelpers.dart';
import 'package:uas_rendra/models/cashnote.dart';
import 'package:uas_rendra/theme.dart';
import 'package:uas_rendra/ui/add_pages.dart';
import 'package:uas_rendra/ui/card_list.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  // const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelpers dbconn = DbHelpers();
  List<Cashnote> noteList;
  int totalCount = 0;
  int totalMasuk = 0;
  int totalKeluar = 0;
  var qurrency =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Cashnote>();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/images/Container.png'),
                Positioned(
                  top: 20,
                  left: 24,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 47,
                  child: Text(
                    'Status Keuangan',
                    style: whiteText.copyWith(fontSize: 24),
                  ),
                ),
                Positioned(
                  top: 110,
                  left: MediaQuery.of(context).size.width / 8,
                  child: new FutureBuilder(
                    future: loadTotal(),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          qurrency.format(totalCount),
                          style: whiteText.copyWith(fontSize: 36),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160,
                        height: 90,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Pemasukkan',
                              style: blackText.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              child: new FutureBuilder(
                                future: loadMasuk(),
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      qurrency.format(totalMasuk),
                                      style: blackText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 90,
                        decoration: BoxDecoration(
                          color: redColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Pengeluaran',
                              style: blackText.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              child: new FutureBuilder(
                                future: loadKeluar(),
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      qurrency.format(totalKeluar),
                                      style: blackText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaksi Terakhir :',
                    style: blackText.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.50,
                child: new Center(
                  child: new FutureBuilder(
                    future: loadList(),
                    builder: (context, snapshot) {
                      return noteList.length > 0
                          ? new CardList(note: noteList)
                          : new Center(
                              child: new Text('Belum Ada Transaksi !',
                                  style:
                                      Theme.of(context).textTheme.headline6));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        elevation: 0,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future loadList() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<List<Cashnote>> futureTrans = dbconn.trans();
      futureTrans.then((transList) {
        setState(() {
          this.noteList = transList;
        });
      });
    });
  }

  Future loadTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = dbconn.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }

  Future loadMasuk() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureMasuk = dbconn.countMasuk();
      futureMasuk.then((fm) {
        setState(() {
          this.totalMasuk = fm;
        });
      });
    });
  }

  Future loadKeluar() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureKeluar = dbconn.countKeluar();
      futureKeluar.then((fk) {
        setState(() {
          this.totalKeluar = fk;
        });
      });
    });
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDataWidget()),
    );
  }
}
