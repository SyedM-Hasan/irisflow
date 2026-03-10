class ProfileState {
  final String userName;
  final String email;
  final String phone;
  final String bio;
  final String location;
  final String memberSince;
  final int eyeHealthScore;
  final bool isPro;
  final bool gentleDimming;
  final bool restReminders;
  final bool soundAlerts;
  final List<Map<String, dynamic>> accountSettings;

  const ProfileState({
    required this.userName,
    required this.email,
    required this.phone,
    required this.bio,
    required this.location,
    required this.memberSince,
    required this.eyeHealthScore,
    required this.isPro,
    required this.gentleDimming,
    required this.restReminders,
    required this.soundAlerts,
    required this.accountSettings,
  });

  ProfileState copyWith({
    String? userName,
    String? email,
    String? phone,
    String? bio,
    String? location,
    bool? gentleDimming,
    bool? restReminders,
    bool? soundAlerts,
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      memberSince: memberSince,
      eyeHealthScore: eyeHealthScore,
      isPro: isPro,
      gentleDimming: gentleDimming ?? this.gentleDimming,
      restReminders: restReminders ?? this.restReminders,
      soundAlerts: soundAlerts ?? this.soundAlerts,
      accountSettings: accountSettings,
    );
  }
}
