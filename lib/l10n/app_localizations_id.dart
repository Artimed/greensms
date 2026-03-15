// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Green SMS';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get back => 'Kembali';

  @override
  String get allow => 'Izinkan';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get clear => 'Bersihkan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get onboardingSubtitle => 'Asisten visual untuk operasi SMS perbankan';

  @override
  String get onboardingFeatureLocal => 'Berjalan lokal, tanpa internet';

  @override
  String get onboardingFeatureSms => 'Hanya membaca 10 SMS terakhir';

  @override
  String get onboardingFeaturePrivacy => 'Data tidak pernah dikirim ke luar';

  @override
  String get onboardingFeatureQr =>
      'QR hanya digunakan untuk berbagi nomor telepon';

  @override
  String get onboardingButton => 'Minta izin dan lanjutkan';

  @override
  String get accounts => 'Akun';

  @override
  String get noAccountsYet => 'Belum ada akun yang dikenali.';

  @override
  String get latestSms => 'SMS terbaru';

  @override
  String get smsNotLoaded => 'SMS belum dimuat.';

  @override
  String get qrModeTitle => 'Mode QR';

  @override
  String get qrModeSubtitle => 'Buka kamera layar penuh';

  @override
  String get smsDetailsTitle => 'Detail SMS';

  @override
  String smsDetailsSender(String sender) {
    return 'Pengirim: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'Waktu: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'Kartu: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'tidak ditemukan';

  @override
  String smsDetailsAmount(String amount) {
    return 'Jumlah: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'Saldo: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'Tipe: $type';
  }

  @override
  String get transferRulesTooltip => 'Aturan transfer';

  @override
  String get accountsLabel => 'Akun';

  @override
  String get refreshSmsButton => 'Segarkan SMS';

  @override
  String get dailyLimitNotSet => 'Batas harian belum diatur';

  @override
  String get setLimitInSettings => 'Atur batas di pengaturan';

  @override
  String get dailyTransferLimit => 'Batas transfer harian';

  @override
  String get usedToday => 'Terpakai hari ini';

  @override
  String get remaining => 'Sisa';

  @override
  String get limitExceeded => 'Batas terlampaui';

  @override
  String get limitWarning80 => 'Lebih dari 80% batas harian terpakai';

  @override
  String get limitExceededBlocked =>
      'Batas harian terlampaui. Transfer QR diblokir.';

  @override
  String accountBalanceLabel(String balance) {
    return 'Saldo: $balance';
  }

  @override
  String get parsedLabel => 'terurai';

  @override
  String get rawLabel => 'mentah';

  @override
  String get devicePhoneTitle => 'Nomor perangkat';

  @override
  String get devicePhoneDesc => 'Digunakan untuk membuat QR dengan nomor Anda';

  @override
  String get phoneNumberLabel => 'Nomor telepon';

  @override
  String get dailyLimitDesc =>
      'Jumlah maksimum transfer harian melalui aplikasi ini. Direset pada tengah malam. Biarkan kosong untuk menghapus batas.';

  @override
  String get limitLabel => 'Batas';

  @override
  String get limitHint => 'mis. 50000';

  @override
  String get removeLimitButton => 'Hapus batas';

  @override
  String get themeTitle => 'Tampilan';

  @override
  String get languageTitle => 'Bahasa';

  @override
  String get bankRoutingTitle => 'Negara dan bank';

  @override
  String get bankRoutingDesc =>
      'Pilih negara terlebih dahulu. Jika bank lebih dari satu, pilih bank untuk perintah pembayaran.';

  @override
  String get countryLabel => 'Negara';

  @override
  String get bankLabel => 'Bank';

  @override
  String get bankAutoSelectedHint =>
      'Hanya ada satu bank untuk negara ini, dipilih otomatis.';

  @override
  String get referenceOnlyBadge => 'reference only';

  @override
  String get bankReferenceOnlyHint =>
      'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.';

  @override
  String get languageEnglish => 'Inggris';

  @override
  String get languageRussian => 'Rusia';

  @override
  String get languageHindi => 'Bahasa Hindi';

  @override
  String get languageKazakh => 'Bahasa Kazakh';

  @override
  String get languageUzbek => 'Bahasa Uzbek';

  @override
  String get languageTagalog => 'Bahasa Tagalog';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get permissionsTitle => 'Izin';

  @override
  String get readSmsTitle => 'Baca SMS';

  @override
  String get readSmsDesc =>
      'Diperlukan untuk membaca SMS masuk dan memperbarui data.';

  @override
  String get directSmsTitle => 'Pengiriman SMS langsung';

  @override
  String get directSmsDesc => 'Kirim SMS langsung tanpa membuka aplikasi pesan';

  @override
  String get directSmsPermissionRequired =>
      'Izin SEND_SMS diperlukan. Berikan izin di pengaturan aplikasi sistem.';

  @override
  String get directSmsEnabledSnack => 'Pengiriman SMS langsung diaktifkan';

  @override
  String get directSmsDisabledSnack => 'Pengiriman SMS langsung dinonaktifkan';

  @override
  String get openSettingsButton => 'Pengaturan';

  @override
  String get permissionsManageInSystem =>
      'Menonaktifkan izin dilakukan di pengaturan aplikasi sistem.';

  @override
  String get cameraTitle => 'Kamera';

  @override
  String get cameraDesc => 'Untuk memindai QR';

  @override
  String get clearLocalDataTitle => 'Hapus data lokal';

  @override
  String get clearLocalDataDesc => 'SMS, akun, profil QR, dan riwayat';

  @override
  String get aboutTitle => 'Tentang';

  @override
  String get aboutVersion => 'Green SMS v1.0\nAplikasi lokal, tanpa internet';

  @override
  String get snackLimitRemoved => 'Batas dihapus';

  @override
  String snackLimitSet(String amount) {
    return 'Batas ditetapkan: $amount';
  }

  @override
  String get snackPhoneSaved => 'Nomor tersimpan';

  @override
  String get snackDataCleared => 'Data lokal dihapus';

  @override
  String get clearDataDialogTitle => 'Hapus data?';

  @override
  String get clearDataDialogContent =>
      'SMS, akun, profil QR, dan riwayat akan dihapus.';

  @override
  String get cameraPermissionNeeded => 'Akses kamera diperlukan';

  @override
  String get scanHint => 'Arahkan kamera ke kode QR';

  @override
  String get scanButton => 'Pindai';

  @override
  String get phoneTransferButton => 'Lewat telepon';

  @override
  String get limitWarningTitle => 'Batas harian terlampaui';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'Jumlah transfer: $amount\nSisa batas: $remaining\n\nTransfer melebihi batas harian. Tetap lanjut?';
  }

  @override
  String get sendAnywayButton => 'Tetap kirim';

  @override
  String get createSmsDialogTitle => 'Buat SMS?';

  @override
  String createSmsPhone(String phone) {
    return 'Telepon: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'Teks: $text';
  }

  @override
  String get qrNotRecognized => 'QR tidak dikenali sebagai format internal.';

  @override
  String get transferCancelledLimit =>
      'Transfer dibatalkan — batas terlampaui.';

  @override
  String get smsSentSuccess =>
      'SMS dibuat. Konfirmasikan pengiriman di aplikasi pesan.';

  @override
  String get scanningContinues => 'Pemindaian berlanjut.';

  @override
  String get noQrInImage => 'Tidak ada kode QR di gambar yang dipilih.';

  @override
  String get qrFoundNoData => 'QR ditemukan, tetapi tanpa data.';

  @override
  String get setPhoneFirst => 'Atur dulu nomor perangkat di pengaturan.';

  @override
  String get setAccountFirst => 'Atur dulu nomor rekening di pengaturan.';

  @override
  String get chooseChannelTitle => 'Pilih saluran transfer';

  @override
  String get scanningActive => 'Pemindaian aktif.';

  @override
  String get phoneQrTitle => 'QR Telepon';

  @override
  String phoneLabel(String phone) {
    return 'Telepon: $phone';
  }

  @override
  String get qrGenerationTitle => 'Pembuatan QR';

  @override
  String get noProfile => 'Tanpa profil';

  @override
  String get profileLabel => 'Profil';

  @override
  String get profileNameLabel => 'Nama profil';

  @override
  String get recipientPhone => 'Nomor penerima';

  @override
  String get phoneTransferInputTitle => 'Transfer tanpa QR';

  @override
  String get enterPhoneError => 'Masukkan nomor telepon';

  @override
  String get amountOptional => 'Jumlah (opsional)';

  @override
  String get amountRequiredLabel => 'Jumlah transfer (wajib)';

  @override
  String get enterAmountError => 'Masukkan jumlah transfer';

  @override
  String get sourceLast4Optional => 'Kartu/rekening sumber last4 (opsional)';

  @override
  String get sourceLast4Hint => 'Contoh: 1234';

  @override
  String get invalidLast4Error => 'Masukkan tepat 4 digit';

  @override
  String get sourceAccountOptionalSection => 'Rekening sumber (opsional)';

  @override
  String get sberAmountRequired => 'Jumlah wajib untuk transfer via 900.';

  @override
  String get smsTarget900 => 'Nomor: 900';

  @override
  String get noteOptional => 'Catatan (opsional)';

  @override
  String get myQrButton => 'QR Saya';

  @override
  String get qrAmountButton => 'QR dengan jumlah';

  @override
  String get showQrButton => 'Tampilkan QR';

  @override
  String get saveProfileButton => 'Simpan profil';

  @override
  String get composeSmsButton => 'Susun SMS';

  @override
  String get qrHintPhoneOnly =>
      'Tunjukkan QR ini ke penerima — sebelum kirim, dia akan mengisi jumlah dan rekening sumber';

  @override
  String get qrHint =>
      'Tunjukkan QR ini ke penerima — ia akan memindai dan melakukan transfer';

  @override
  String get profileSaved => 'Profil tersimpan';

  @override
  String qrError(Object error) {
    return 'Kesalahan QR: $error';
  }

  @override
  String get transferLimitsTitle => 'Batas dan aturan transfer';

  @override
  String get openSberSiteTooltip => 'Buka situs Sberbank';

  @override
  String get infoActualBanner =>
      'Informasi berlaku pada versi aplikasi ini. Batas dan ketentuan dapat berubah — cek di sberbank.ru atau hubungi 900.';

  @override
  String get smsCommandsTitle => 'Perintah SMS (ke nomor 900)';

  @override
  String get limitsTitle => 'Batas transfer';

  @override
  String get notificationFormatsTitle => 'Format notifikasi SMS Sberbank';

  @override
  String get importantRulesTitle => 'Aturan penting';

  @override
  String get feesTitle => 'Biaya';

  @override
  String get cannotOpenBrowser => 'Tidak dapat membuka browser';

  @override
  String get number900Copied => 'Nomor 900 disalin';

  @override
  String copiedCommand(String command) {
    return 'Disalin: $command';
  }

  @override
  String get officialSberSite => 'Situs resmi Sberbank';

  @override
  String get officialSiteButton => 'Situs resmi';

  @override
  String get helpContact900 => 'Bantuan: hubungi 900';

  @override
  String get disclaimerText =>
      'Aplikasi ini bukan produk resmi Sberbank. Aplikasi hanya membantu membaca SMS dan menyusun perintah — semua transfer dilakukan melalui perintah SMS standar lewat operator seluler Anda.';

  @override
  String get personalLimitBanner =>
      'Untuk mengecek batas pribadi Anda — kirim SMS «ЛИМИТ» ke 900. Batas dapat berbeda tergantung paket dan riwayat transaksi Anda.';

  @override
  String get phoneCopied => 'Nomor telepon disalin';

  @override
  String get copyPhoneButton => 'Salin nomor';

  @override
  String noteLabel(String note) {
    return 'Catatan: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'QR tidak dikenali sebagai format internal: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [phone] [amount]';

  @override
  String get cmdTransferMainDesc =>
      'Transfer ke nomor telepon dari kartu utama.\nContoh: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [phone] [amount] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'Transfer dari kartu tertentu.\nContoh: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'Saldo kartu utama.';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'Saldo kartu tertentu.';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => '5 transaksi terakhir pada kartu utama.';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'Blokir kartu sementara.';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc => 'Lihat batas transfer Anda saat ini via SMS.';

  @override
  String get limitEconomyPerTxLabel =>
      'Mobile Bank \"Economy\" — per transaksi';

  @override
  String get limitEconomyPerTxValue => '8.000 ₽';

  @override
  String get limitEconomyPerDayLabel => 'Mobile Bank \"Economy\" — per hari';

  @override
  String get limitEconomyPerDayValue => '8.000 ₽';

  @override
  String get limitFullPerTxLabel => 'Mobile Bank \"Full\" — per transaksi';

  @override
  String get limitFullPerTxValue => 'hingga 50.000 ₽';

  @override
  String get limitFullPerDayLabel => 'Mobile Bank \"Full\" — per hari';

  @override
  String get limitFullPerDayValue => 'hingga 500.000 ₽';

  @override
  String get limitCardToCardLabel => 'Kartu ke kartu (online)';

  @override
  String get limitCardToCardValue => 'hingga 150.000 ₽';

  @override
  String get exampleIncomingLabel => 'Masuk';

  @override
  String get exampleIncomingText =>
      'SBERBANK Kredit 10000 RUB Kartu *1234 Saldo: 25000 RUB';

  @override
  String get examplePurchaseLabel => 'Pembelian';

  @override
  String get examplePurchaseText =>
      'SBERBANK Pembelian 1500 RUB Kartu *1234 NAMA TOKO Saldo: 23500 RUB';

  @override
  String get exampleTransferLabel => 'Transfer dana';

  @override
  String get exampleTransferText =>
      'Transfer 5000 RUB dari kartu *1234 selesai. Saldo: 18500 RUB.';

  @override
  String get exampleCashWithdrawalLabel => 'Tarik tunai';

  @override
  String get exampleCashWithdrawalText =>
      'Tarik tunai 3000 RUB. Kartu *1234. Saldo: 15500 RUB.';

  @override
  String get ruleRecipientClient =>
      'Penerima harus menjadi nasabah Sberbank dan mengaktifkan Mobile Bank.';

  @override
  String get rulePhoneLinked =>
      'Nomor telepon harus terhubung ke kartu penerima.';

  @override
  String get ruleSmsIrreversible =>
      'Transfer SMS tidak dapat dibatalkan — periksa nomor penerima sebelum konfirmasi.';

  @override
  String get ruleSpecifyLast4 =>
      'Jika Anda punya beberapa kartu, sebutkan last4 kartu sumber untuk menghindari kesalahan.';

  @override
  String get ruleEconomyVsFull =>
      'Tarif \"Economy\" (gratis) — batas 8.000 ₽/hari. Tarif \"Full\" (berbayar) — hingga 100.000 ₽/hari.';

  @override
  String get ruleResetAtMidnight =>
      'Batas harian direset pukul 00:00 waktu Moskow.';

  @override
  String get feeEconomyLabel => 'Tarif \"Economy\" — biaya transfer';

  @override
  String get feeEconomyValue => '1% (minimal 30 ₽)';

  @override
  String get feeFullLabel => 'Tarif \"Full\" — biaya transfer';

  @override
  String get feeFullValue => 'Gratis';

  @override
  String get feeSubscriptionLabel => 'Langganan tarif \"Full\"';

  @override
  String get feeSubscriptionValue => '60 ₽/bulan';

  @override
  String get opIncoming => 'masuk';

  @override
  String get opOutgoing => 'keluar';

  @override
  String get opTransfer => 'transfer dana';

  @override
  String get opUnknown => 'tidak diketahui';

  @override
  String smsTargetLabel(String number) {
    return 'To: $number';
  }

  @override
  String get amountRequiredForTransfer =>
      'Amount is required for this transfer.';

  @override
  String get ussdDialogTitle => 'Open USSD?';

  @override
  String get openDialerButton => 'Open Dialer';

  @override
  String get ussdSentHint => 'USSD dialed. Confirm the transfer in the dialer.';

  @override
  String get bankNotAvailable =>
      'Bank commands not configured for your region.';

  @override
  String get transferSmsCommandTitle => 'SMS transfer command';

  @override
  String get transferUssdCommandTitle => 'USSD transfer command';

  @override
  String sendToLabel(String number) {
    return 'Send to: $number';
  }

  @override
  String get exampleLabelShort => 'Example';

  @override
  String bankLimitsContactBanner(String bankName) {
    return 'Transfer limits and fees depend on your plan. Contact $bankName for up-to-date information.';
  }

  @override
  String get notificationExamplesTitle => 'SMS notification examples';

  @override
  String get noBankSelectedBanner =>
      'No bank selected. Choose a country and bank in Settings.';

  @override
  String helpContactNumber(String number) {
    return 'Help: contact $number';
  }

  @override
  String bankDisclaimerGeneric(String bankName) {
    return 'This app is not affiliated with $bankName. Transfers use standard SMS or USSD commands through your mobile carrier.';
  }

  @override
  String get infoActualBannerGeneric =>
      'Information is based on publicly available data. Limits and conditions may change — check with your bank.';

  @override
  String get officialDataTitle => 'Official data';

  @override
  String get officialStatusLabel => 'Source status';

  @override
  String get officialChannelLabel => 'Panel channel';

  @override
  String get officialLastVerifiedLabel => 'Verified on';

  @override
  String get officialStatusVerifiedPublic => 'Verified by public source';

  @override
  String get officialStatusLimitedPublic => 'Public source is limited';

  @override
  String get officialStatusManualVerificationRequired =>
      'Manual verification required';

  @override
  String get officialStatusUnknown => 'Not specified';

  @override
  String get officialWarningLimited =>
      'Official public limits and rules for this exact channel are only partially confirmed. Treat the values as reference and verify with the bank.';

  @override
  String get officialWarningManual =>
      'This bank or channel does not have enough current public official confirmation. The values are shown for reference only.';

  @override
  String get commandChannelUnavailableBanner =>
      'A direct SMS or USSD command channel is not currently verified for this bank. The info panel is shown as a reference to official public data.';

  @override
  String get directTransferButton => 'Transfer';

  @override
  String createSmsAccount(String account) {
    return 'Account: $account';
  }

  @override
  String get recipientAccount => 'Recipient account';

  @override
  String get enterAccountError => 'Enter an account number';

  @override
  String get routeLabel => 'Transfer channel';

  @override
  String get routeSmsPhone => 'SMS by phone';

  @override
  String get routeSmsAccount => 'SMS by account';

  @override
  String get routeUssdPhone => 'USSD by phone';

  @override
  String get routeUssdAccount => 'USSD by account';

  @override
  String get accountQrTitle => 'Account QR';

  @override
  String get qrHintAccountOnly =>
      'Show this QR to the sender — they will use your account in their bank flow before sending';

  @override
  String get yourAccountTitle => 'Akun Anda';

  @override
  String get yourAccountDesc =>
      'Digunakan untuk membuat QR dengan nomor akun Anda';

  @override
  String get accountNumberLabel => 'Nomor rekening';

  @override
  String get snackAccountSaved => 'Akun disimpan';

  @override
  String get selectBankFirstHint =>
      'Pilih dan simpan bank di atas untuk mengonfigurasi';
}
