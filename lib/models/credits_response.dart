// To parse this JSON data, do
//
//     final creditResponse = creditResponseFromJson(jsonString);

import 'dart:convert';

CreditResponse creditResponseFromJson(String str) => CreditResponse.fromJson(json.decode(str));


class CreditResponse {
    final int id;
    final List<Cast> cast;
    final List<Cast> crew;

    CreditResponse({
        required this.id,
        required this.cast,
        required this.crew,
    });

    factory CreditResponse.fromJson(Map<String, dynamic> json) => CreditResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    );

  
}

class Cast {
    final bool adult;
    final int gender;
    final int id;
    final String knownForDepartment;
    final String name;
    final String originalName;
    final double popularity;
    final String? profilePath;
    final int? castId;
    final String? character;
    final String creditId;
    final int? order;
    final String? department;
    final String? job;

    Cast({
        required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        required this.profilePath,
        this.castId,
        this.character,
        required this.creditId,
        this.order,
        this.department,
        this.job,
    });

    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: json["department"],
        job: json["job"],
    );

    get fullProfilePath {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }
}
