class Profile {
  String firstName;
  String lastName;
  String location;
  int age;
  double rating;
  int numberProjects;

  String get fullName => "$firstName $lastName";

  String get ageString => _abbreviatedCount(age);

  String get ratingString => rating.toString();

  String get numberProjectsString => _abbreviatedCount(numberProjects);

  String _abbreviatedCount(int num) {
    if (num < 1000) return "$num";
    if (num >= 1000 && num < 1000000) {
      String s = (num / 1000).toStringAsFixed(1);
      if (s.endsWith(".0")) {
        int idx = s.indexOf(".0");
        s = s.substring(0, idx);
      }
      return "${s}K";
    } else if (num >= 1000000 && num < 1000000000) {
      String s = (num / 1000000).toStringAsFixed(1);
      if (s.endsWith(".0")) {
        int idx = s.indexOf(".0");
        s = s.substring(0, idx);
      }
      return "${s}M";
    }
    return "";
  }
}

Profile getProfile() {
  return new Profile()
    ..firstName = "Emma"
    ..lastName = "Watson"
    ..location = "Kigali"
    ..age = 35
    ..rating = 4.6
    ..numberProjects = 17;
}