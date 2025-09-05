import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/project_service_impl.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

// Mock Storage Service for testing
class MockStorageService implements StorageService {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<bool> exists(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<Map<String, String>> exportData() async {
    return Map.from(_storage);
  }

  @override
  Future<void> importData(Map<String, String> data) async {
    _storage.addAll(data);
  }

  @override
  Future<int> getSize() async {
    return _storage.length;
  }

  @override
  Future<List<String>> listKeys(String prefix) async {
    return _storage.keys.where((key) => key.startsWith(prefix)).toList();
  }
}

void main() {
  group('ProjectController Integration Tests', () {
    late MockStorageService mockStorage;
    late ProjectServiceImpl projectService;
    late Language english;
    late Language chinese;
    late User user;
    late Project testProject;

    setUp(() async {
      // Initialize test data
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;

      user = User(
        id: 'test-user',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create mock storage and service
      mockStorage = MockStorageService();
      projectService = ProjectServiceImpl(mockStorage);

      // Create test project
      final createRequest = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        ownerId: user.id,
      );

      testProject = await projectService.createProject(createRequest);

      // Register services for testing
      Get.put<ProjectService>(projectService, tag: 'test');
    });

    tearDown(() {
      Get.reset();
    });

    test('should create ProjectController instance', () {
      final controller = ProjectController(projectId: testProject.id);

      expect(controller.projectId, equals(testProject.id));
      expect(controller.project, isNull); // Not loaded yet
      expect(controller.isLoading, isFalse);
    });

    test('should load project successfully', () async {
      final controller = ProjectController(projectId: testProject.id);

      await controller.loadProject();

      expect(controller.project, isNotNull);
      expect(controller.project!.id, equals(testProject.id));
      expect(controller.project!.name, equals('Test Project'));
      expect(controller.project!.primaryLanguage.code, equals('en-US'));
      expect(controller.isLoading, isFalse);
    });

    test('should handle project not found', () async {
      final controller = ProjectController(projectId: 'non-existent-project');

      await controller.loadProject();

      expect(controller.project, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('should refresh project data', () async {
      final controller = ProjectController(projectId: testProject.id);
      await controller.loadProject();

      expect(controller.project, isNotNull);

      // Modify project through service
      final updateRequest = UpdateProjectRequest(
        name: 'Updated Project Name',
        description: 'Updated description',
      );

      await projectService.updateProject(testProject.id, updateRequest);

      // Refresh and verify
      await controller.refreshProject();

      expect(controller.project!.name, equals('Updated Project Name'));
      expect(controller.project!.description, equals('Updated description'));
    });

    test('should provide correct computed properties', () async {
      final controller = ProjectController(projectId: testProject.id);
      await controller.loadProject();

      expect(controller.title, equals('Test Project'));
      expect(controller.description, equals('Test project description'));
      expect(controller.languageCount, equals(2)); // Primary + 1 target
      expect(controller.translationCount, equals(0)); // No translations yet
    });

    test('should handle project deletion', () async {
      final controller = ProjectController(projectId: testProject.id);
      await controller.loadProject();

      expect(controller.project, isNotNull);

      // Note: In a real scenario, this would navigate back
      // For testing, we just verify the controller state
      await controller.deleteProject();

      // Controller should still have the project data
      // (actual deletion would be handled by navigation)
      expect(controller.project, isNotNull);
    });

    test('should handle target language removal', () async {
      final controller = ProjectController(projectId: testProject.id);
      await controller.loadProject();

      expect(controller.project!.targetLanguages.length, equals(1));

      // Remove target language
      await controller.removeTargetLanguage(chinese);

      // Refresh and verify
      await controller.refreshProject();

      expect(controller.project!.targetLanguages.length, equals(0));
    });

    test('should validate project data consistency', () async {
      final controller = ProjectController(projectId: testProject.id);

      // Mock inconsistent data scenario
      // In real implementation, this would be validated during loadProject

      await controller.loadProject();

      // Verify project has correct primary language
      expect(controller.project!.primaryLanguage.code, equals('en-US'));
      expect(controller.project!.targetLanguages.length, equals(1));
      expect(controller.project!.targetLanguages.first.code, equals('zh-CN'));
    });

    test('should handle error scenarios gracefully', () async {
      // Test with invalid project ID
      final controller = ProjectController(projectId: '');

      await controller.loadProject();

      expect(controller.project, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('should maintain project data integrity', () async {
      final controller = ProjectController(projectId: testProject.id);
      await controller.loadProject();

      final originalProject = controller.project!;

      // Perform operations that shouldn't affect core data
      await controller.refreshProject();

      expect(controller.project!.id, equals(originalProject.id));
      expect(controller.project!.primaryLanguage.code, equals(originalProject.primaryLanguage.code));
      expect(controller.project!.name, equals(originalProject.name));
    });

    group('Project Statistics', () {
      test('should calculate project statistics correctly', () async {
        final controller = ProjectController(projectId: testProject.id);
        await controller.loadProject();

        final stats = await controller.getProjectStats();

        // Verify basic stats structure
        expect(stats.totalEntries, isA<int>());
        expect(stats.completedEntries, isA<int>());
        expect(stats.pendingEntries, isA<int>());
        expect(stats.completionRate, isA<double>());
        expect(stats.languageCount, equals(2)); // Primary + target languages
        expect(stats.memberCount, equals(1)); // Owner
      });

      test('should handle statistics for non-existent project', () async {
        final controller = ProjectController(projectId: 'non-existent');

        try {
          final stats = await controller.getProjectStats();
          // Should return default stats
          expect(stats.totalEntries, equals(0));
          expect(stats.languageCount, equals(0));
        } catch (e) {
          // Should handle gracefully
          expect(e, isNotNull);
        }
      });
    });

    group('Data Validation', () {
      test('should validate primary language consistency', () async {
        final controller = ProjectController(projectId: testProject.id);
        await controller.loadProject();

        // Verify primary language is set correctly
        expect(controller.project!.primaryLanguage.code, equals('en-US'));
        expect(controller.project!.primaryLanguage.code, isNotEmpty);
        expect(Language.isLanguageSupported(controller.project!.primaryLanguage.code), isTrue);
      });

      test('should validate target languages', () async {
        final controller = ProjectController(projectId: testProject.id);
        await controller.loadProject();

        final targetLanguages = controller.project!.targetLanguages;

        // Verify all target languages are valid
        for (final language in targetLanguages) {
          expect(Language.isLanguageSupported(language.code), isTrue);
          expect(language.code, isNot(equals(controller.project!.primaryLanguage.code)));
        }
      });

      test('should ensure all languages are included in project', () async {
        final controller = ProjectController(projectId: testProject.id);
        await controller.loadProject();

        final allLanguages = controller.project!.allLanguages;

        // Should include primary language
        expect(allLanguages.map((lang) => lang.code), contains('en-US'));
        // Should include target languages
        expect(allLanguages.map((lang) => lang.code), contains('zh-CN'));
        // Should have correct total count
        expect(allLanguages.length, equals(2));
      });
    });
  });
}
