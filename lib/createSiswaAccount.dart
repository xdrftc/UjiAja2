// lib/utils/create_siswa_accounts.dart
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> createSiswaAccounts() async {
  const password = 'ujiaja2025'; // PASSWORD SERAGAM

  final List<Map<String, String>> siswaList = [
    {'nisn': '0081631759', 'nama': 'ADELLA AMANDA KHOERUNNISA'},
    {'nisn': '0092742672', 'nama': 'ALDEA NINDI FRILYA'},
    {'nisn': '0085800006', 'nama': 'ARETHA MARASTY'},
    {'nisn': '0081228471', 'nama': 'AZZURA SYARA ASYAKHRA'},
    {'nisn': '0087845279', 'nama': 'DELITA KAMILA'},
    {'nisn': '0074876277', 'nama': 'DENISA FAUZIAH'},
    {'nisn': '0086062988', 'nama': 'DESIANA TRI PUTRI'},
    {'nisn': '0099190618', 'nama': 'DEWI PUSPITASARI'},
    {'nisn': '0088981842', 'nama': 'DIAN NIKO RAMADANI'},
    {'nisn': '0083145870', 'nama': 'EZZY MILAN ANDICHA'},
    {'nisn': '0094463985', 'nama': 'FAIZAL FATHAN FAUZAN'},
    {'nisn': '0099910700', 'nama': 'FANNYSHA PUTRI RUHYANA'},
    {'nisn': '0088156961', 'nama': 'HENDRI RIZKY RAMADHAN'},
    {'nisn': '0088659658', 'nama': 'JIBRAN SATRIANURJATIKINASIH'},
    {'nisn': '0084499696', 'nama': 'KAKA SETIAWAN'},
    {'nisn': '0098916217', 'nama': 'KHOERULLOH NUR ALAM'},
    {'nisn': '0088264456', 'nama': 'KIRANA ANGGRAENI'},
    {'nisn': '0085382423', 'nama': 'LOVIETA LAILA YATMAN'},
    {'nisn': '0085304063', 'nama': 'MOCHAMAD RASYA APIANA'},
    {'nisn': '0097744813', 'nama': 'MOHAMMAD ARSIL FIRMANSYAH'},
    {'nisn': '0092945323', 'nama': 'MUHAMAD DAFFA RAFASYA'},
    {'nisn': '0084814668', 'nama': 'MUHAMAD DERA SUHADA'},
    {'nisn': '0087895983', 'nama': 'NADIA FAIRUZ ZAIN'},
    {'nisn': '0081551353', 'nama': 'NUR RIHKY RAHMDANI'},
    {'nisn': '0088268871', 'nama': 'OFIK HIDAYAT'},
    {'nisn': '0092259957', 'nama': 'REN AZAHRA MUGNI PAROKA'},
    {'nisn': '0088791959', 'nama': 'REZKA AGUNG MAHARDHIKA'},
    {'nisn': '0091599517', 'nama': 'RIFAL AUFA FADHILAH'},
    {'nisn': '0085959116', 'nama': 'RIZKY RIDWANSYAH'},
    {'nisn': '0086935937', 'nama': 'SRI SELVI RAHAYU'},
    {'nisn': '0089216632', 'nama': 'TANTI ELISYA SAPUTRI'},
    {'nisn': '0089565003', 'nama': 'WILLY HAFIDIN'},
  ];

  for (final siswa in siswaList) {
    final email = '${siswa['nisn']}@ujiaja.local';

    try {
      // 1. BUAT USER DI auth.users
      final user = await supabase.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true,
          userMetadata: {
            'nisn': siswa['nisn'],
            'nama': siswa['nama'],
            'kelas': 'XI RPL 9',
            'jurusan': 'PPLG',
          },
        ),
      );

      // 2. SIMPAN KE public.siswa
      await supabase
          .from('siswa')
          .insert({
            'id': user.user!.id,
            'nisn': siswa['nisn'],
            'nama': siswa['nama'],
            'kelas': 'XI RPL 9',
            'jurusan': 'PPLG',
            'role': 'siswa',
          })
          .onError((error, _) => null); // ignore jika sudah ada

      print('Berhasil: ${siswa['nama']}');
    } catch (e) {
      print('Gagal ${siswa['nama']}: $e');
    }
  }

  print('SELESAI! 32 siswa dibuat.');
}
