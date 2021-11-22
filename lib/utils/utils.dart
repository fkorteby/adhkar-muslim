class AppUtils {
  static String englishToFarsi({number}) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];
    for (int i = 0; i < english.length; i++) {
      number = number.replaceAll(english[i], farsi[i]);
    }
    return number;
  }
}
