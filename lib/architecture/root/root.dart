class ROOT {
  // Root address [Firebase & SharedPreference]:
  static const String firebaseRoot = 'NFBN/';
  static const String sharedpreferenceRoot = 'nfbn';

  // Basic App Elements:
  static const String institutionLogoAddress = 'assets/logo/logo.png';
  static const String institutionName = 'Nawab Faizunessa & Badrunnesa 92 Batch';
  static const String institutionAbbreviation = 'NFBN\'92 Batch';
  static const String institutionMoto = 'আলোক শিক্ষা';
  static const String institutionAddress = '';
  static const String institutionEstablishmedDate = 'Est. 2021';
  static const String institutionEstablishmedEINN = '';
  static const String institutionEmail = '';
  // Notification Subscription Topic:
  static const String defaultNotificationSubscriber = defaultNoticeSubscriber;
  // Notice Subscriber:
  static const String defaultNoticeSubscriber = 'NFBN_All';

  // Feedback Email:
  static const String feedBackMail = 'saifkhaonbd@gmail.com';
  static const String feedBackMailSubject = 'Feedback on NFBN Application';
}

class FirebaseDataRoot {
  // [Firebase]: Data - realtime address
  static const String home = 'home/glance/0';
  static const String firebaseChairmanDataRoot = 'home/chairman/0';
  static const String firebasePrincipalDataRoot = 'home/principal/0';

  // Storage:
  static const String firebaseLeadersPhotoRoot = 'home/';
  static const String firebaseSliderPhotoRoot = 'home/photo_slider';
  static const String newsPhotoRoot = 'news';
  static const String eventsPhotoRoot = 'events';

  static const String chairmanDesignation = 'VICE-CHANCELLOR';
  static const String principalDesignation = 'PRINCIPAL';
  static const String glancePhoto = 'glance';

  static const String imageErrorLink = 'https://firebasestorage.googleapis.com/v0/b/ndub-f55f9.appspot.com/o/image_error.png?alt=media&token=10f7f6f1-f322-4a7a-b473-31ec9378cd03';
}
