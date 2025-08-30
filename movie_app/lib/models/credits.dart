class CastMember {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;

  CastMember({required this.id, required this.name, this.character, this.profilePath});

  factory CastMember.fromJson(Map<String, dynamic> json) => CastMember(
        id: json['id'],
        name: json['name'] ?? '',
        character: json['character'],
        profilePath: json['profile_path'],
      );
}

class CrewMember {
  final int id;
  final String name;
  final String? job;
  final String? profilePath;

  CrewMember({required this.id, required this.name, this.job, this.profilePath});

  factory CrewMember.fromJson(Map<String, dynamic> json) => CrewMember(
        id: json['id'],
        name: json['name'] ?? '',
        job: json['job'],
        profilePath: json['profile_path'],
      );
}
