class DeveloperModel {
  String? imageurl;
  String? name;
  String? bio;
  String? content;
  String? title;
  String? copywrite;
  String? email;
  String? facebook;
  String? instagram;
  String? linkdin;
  String? website;
  String? youtube;
  DeveloperModel({
    this.imageurl,
    this.name,
    this.bio,
    this.content,
    this.title,
    this.copywrite,
    this.email,
    this.facebook,
    this.instagram,
    this.linkdin,
    this.website,
    this.youtube,
  });

  factory DeveloperModel.fromMap(Map<String, dynamic> map) {
    return DeveloperModel(
      imageurl: map['imageurl'] != null ? map['imageurl'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      copywrite: map['copywrite'] != null ? map['copywrite'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      facebook: map['facebook'] != null ? map['facebook'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      linkdin: map['linkdin'] != null ? map['linkdin'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      youtube: map['youtube'] != null ? map['youtube'] as String : null,
    );
  }
}
