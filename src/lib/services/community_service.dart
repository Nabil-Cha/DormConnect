import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/models/community.dart';

class CommunityService {
  static final supabase = Supabase.instance.client;

  static Future<void> addCommunity({
    required String name,
    required String location,
    String? image,
    List<String>? members,
  }) async {
    try {
      await supabase.from('communities').insert({
        'name': name,
        'location': location,
        'image': image ?? 'https://mldhavqvdntcrfowiqjk.supabase.co/storage/v1/object/public/assets/communities_images/default.jpg',
        'created_on': DateTime.now().toIso8601String().split('T')[0], // Date only
        'members': members ?? [],
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Eine Community mit diesem Namen existiert bereits');
      }
      throw Exception('Fehler beim Hinzufügen der Community: ${e.message}');
    } catch (e) {
      throw Exception('Fehler beim Hinzufügen der Community: $e');
    }
  }

  static Future<List<Community>> getAllCommunities() async {
    try {
      final response = await supabase
          .from('communities')
          .select()
          .order('created_on', ascending: false);

      return (response as List)
          .map((data) => Community.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Fehler beim Laden der Communities: $e');
    }
  }

  static Future<Community?> getCommunityById(int id) async {
    try {
      final response = await supabase
          .from('communities')
          .select()
          .eq('id', id)
          .single();

      return Community.fromMap(response);
    } catch (e) {
      throw Exception('Fehler beim Laden der Community: $e');
    }
  }

  static Future<Community?> getCommunityBySlug(String slug) async {
    try {
      final response = await supabase
          .from('communities')
          .select()
          .eq('slug', slug)
          .single();

      return Community.fromMap(response);
    } catch (e) {
      throw Exception('Fehler beim Laden der Community: $e');
    }
  }

  static Future<void> updateCommunity(Community community) async {
    try {
      await supabase
          .from('communities')
          .update(community.toMap())
          .eq('id', community.id);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Eine Community mit diesem Namen existiert bereits');
      }
      throw Exception('Fehler beim Aktualisieren der Community: ${e.message}');
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren der Community: $e');
    }
  }

  static Future<void> joinCommunity(int communityId, String memberId) async {
    try {
      final community = await getCommunityById(communityId);
      if (community == null) {
        throw Exception('Community nicht gefunden');
      }

      if (community.members.contains(memberId)) {
        return;
      }

      final updatedMembers = [...community.members, memberId];
      final updatedCommunity = community.copyWith(members: updatedMembers);
      await updateCommunity(updatedCommunity);
    } catch (e) {
      throw Exception('Fehler beim Beitreten zur Community: $e');
    }
  }

  static Future<void> leaveCommunity(int communityId, String memberId) async {
    try {
      final community = await getCommunityById(communityId);
      if (community == null) {
        throw Exception('Community nicht gefunden');
      }

      final updatedMembers = community.members.where((id) => id != memberId).toList();
      final updatedCommunity = community.copyWith(members: updatedMembers);
      await updateCommunity(updatedCommunity);
    } catch (e) {
      throw Exception('Fehler beim Verlassen der Community: $e');
    }
  }

  static Future<bool> isMemberOfCommunity(int communityId, String memberId) async {
    try {
      final community = await getCommunityById(communityId);
      return community?.members.contains(memberId) ?? false;
    } catch (e) {
      throw Exception('Fehler beim Überprüfen der Mitgliedschaft: $e');
    }
  }
}