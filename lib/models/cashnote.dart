class Cashnote {
  final int id;
  final String tanggalNote;
  final String deskripsiNote;
  final String tipeNote;
  final int jumlahTrx;

  Cashnote(
      {this.id,
      this.deskripsiNote,
      this.jumlahTrx,
      this.tanggalNote,
      this.tipeNote});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggalNote,
      'deskripsi': deskripsiNote,
      'tipe': tipeNote,
      'jumlah': jumlahTrx
    };
  }
}
