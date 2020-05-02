class StringHelper {
  static bool isValidPhoneNumber(String phonenumber) {
    return phonenumber.isNotEmpty &&
        phonenumber.length == 11 &&
        phonenumber.startsWith("05");
  }
}
