/// A signed-in user. Deliberately minimal — decoupled from
/// firebase_auth's User type so the presentation layer never imports
/// Firebase directly (that's confined to the data layer).
class AppUser {
  final String uid;
  final String? email;

  const AppUser({required this.uid, this.email});
}
