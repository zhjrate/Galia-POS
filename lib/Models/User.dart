class AppUser {
  final String uid;

  AppUser({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final int phone;
  final String profileImage;
  final String activeBusiness;
  final List<UserBusinessData> businesses;
  final List usage;

  UserData(
      {this.uid,
      this.name,
      this.phone,
      this.profileImage,
      this.activeBusiness,
      this.businesses,
      this.usage});
}

class UserBusinessData {
  final String businessID;
  final String businessName;
  final String roleInBusiness;
  final bool tableView;

  UserBusinessData(
      this.businessID, this.businessName, this.roleInBusiness, this.tableView);
}

class BusinessProfile {
  final String businessID;
  final String businessName;
  final String roleInBusiness;
  final String businessImage;
  final String businessField;
  final String businessLocation;
  final int businessSize;
  final List businessUsers;

  BusinessProfile(
      {this.businessID,
      this.businessName,
      this.roleInBusiness,
      this.businessField,
      this.businessImage,
      this.businessLocation,
      this.businessSize,
      this.businessUsers});
}

// class BusinessUsers {
//   final String userRol;
//   final String userUID;

//   BusinessUsers(this.userRol, this.userUID);
// }
