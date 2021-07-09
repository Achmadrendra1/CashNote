import 'package:flutter/material.dart';
import 'package:uas_rendra/helpers/dbhelpers.dart';
import 'package:uas_rendra/models/cashnote.dart';
import 'package:intl/intl.dart';
import 'package:uas_rendra/theme.dart';
import 'package:uas_rendra/ui/edit_pages.dart';

class CardList extends StatefulWidget {
  final List<Cashnote> note;

  CardList({Key key, this.note, this.model}) : super(key: key);
  final Cashnote model;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  var formatCurrency =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  DbHelpers dbconn = DbHelpers();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.note == null ? 0 : widget.note.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDataWidget(
                        widget.note[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      widget.note[index].tipeNote == 'earning'
                          ? Image.asset(
                              'assets/images/plus.png',
                              height: 54,
                              width: 54,
                            )
                          : Image.asset(
                              'assets/images/minus.png',
                              height: 54,
                              width: 54,
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.note[index].deskripsiNote,
                              style: blackText.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.note[index].tanggalNote,
                              style: blackText.copyWith(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        formatCurrency.format(widget.note[index].jumlahTrx),
                        style: TextStyle(
                          color: widget.note[index].tipeNote == 'earning'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
