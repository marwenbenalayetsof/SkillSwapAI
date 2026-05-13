class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? timezone;
  final String? website;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final int timeCredits;
  final double rating;
  final int reviewCount;
  final int completedSwaps;
  final List<String> badges;
  final List<String> endorsements;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.location,
    this.timezone,
    this.website,
    this.skillsOffered = const [],
    this.skillsWanted = const [],
    this.timeCredits = 5,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.completedSwaps = 0,
    this.badges = const [],
    this.endorsements = const [],
    this.isOnline = false,
    this.lastSeen,
    required this.createdAt,
    this.preferences = const {},
  });

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    // Firestore Timestamp has toDate() method
    if (value is dynamic) {
      try {
        // Try calling toDate() for Firestore Timestamp
        return (value as dynamic).toDate() as DateTime;
      } catch (_) {}
      try {
        return DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch as int);
      } catch (_) {}
    }
    return null;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      bio: map['bio'] as String?,
      location: map['location'] as String?,
      timezone: map['timezone'] as String?,
      website: map['website'] as String?,
      skillsOffered: List<String>.from(map['skillsOffered'] as List? ?? []),
      skillsWanted: List<String>.from(map['skillsWanted'] as List? ?? []),
      timeCredits: map['timeCredits'] as int? ?? 5,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      completedSwaps: map['completedSwaps'] as int? ?? 0,
      badges: List<String>.from(map['badges'] as List? ?? []),
      endorsements: List<String>.from(map['endorsements'] as List? ?? []),
      isOnline: map['isOnline'] as bool? ?? false,
      lastSeen: _parseDateTime(map['lastSeen']),
      createdAt: _parseDateTime(map['createdAt']) ?? DateTime.now(),
      preferences: Map<String, dynamic>.from(map['preferences'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'location': location,
      'timezone': timezone,
      'website': website,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
      'timeCredits': timeCredits,
      'rating': rating,
      'reviewCount': reviewCount,
      'completedSwaps': completedSwaps,
      'badges': badges,
      'endorsements': endorsements,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? uid, String? name, String? email, String? avatarUrl,
    String? bio, String? location, String? timezone, String? website,
    List<String>? skillsOffered, List<String>? skillsWanted,
    int? timeCredits, double? rating, int? reviewCount, int? completedSwaps,
    List<String>? badges, List<String>? endorsements,
    bool? isOnline, DateTime? lastSeen, DateTime? createdAt,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      timezone: timezone ?? this.timezone,
      website: website ?? this.website,
      skillsOffered: skillsOffered ?? this.skillsOffered,
      skillsWanted: skillsWanted ?? this.skillsWanted,
      timeCredits: timeCredits ?? this.timeCredits,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      completedSwaps: completedSwaps ?? this.completedSwaps,
      badges: badges ?? this.badges,
      endorsements: endorsements ?? this.endorsements,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
    );
  }

  String get avatarInitials => name.isNotEmpty 
      ? name.split(' ').map((n) => n[0]).take(2).join().toUpperCase() 
      : '?';

  String get ratingDisplay => reviewCount > 0 
      ? '${rating.toStringAsFixed(1)} ($reviewCount)' 
      : 'New';
}
