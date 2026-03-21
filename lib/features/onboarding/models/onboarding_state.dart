class OnboardingState {
  const OnboardingState({
    this.currentStep = 0,
    this.role,
    this.skills = const [],
    this.experienceLevel,
    this.feedSources = const [],
    this.isComplete = false,
  });

  final int currentStep;
  final String? role;
  final List<String> skills;
  final String? experienceLevel;
  final List<String> feedSources;
  final bool isComplete;

  OnboardingState copyWith({
    int? currentStep,
    String? role,
    List<String>? skills,
    String? experienceLevel,
    List<String>? feedSources,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      feedSources: feedSources ?? this.feedSources,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  /// Whether the current step has valid selection to proceed.
  bool get canProceed {
    switch (currentStep) {
      case 0:
        return true; // welcome — always can proceed
      case 1:
        return role != null;
      case 2:
        return true; // skills — optional (0 is OK)
      case 3:
        return experienceLevel != null;
      case 4:
        return feedSources.isNotEmpty;
      default:
        return false;
    }
  }

  static const int totalSteps = 5;
}

// ── Predefined options ──

const availableRoles = [
  'Software Engineer',
  'ML Engineer',
  'Data Scientist',
  'Product Manager',
  'Designer',
  'DevOps Engineer',
  'Student',
  'Other',
];

const availableSkills = [
  'Python',
  'RAG',
  'LangChain',
  'Prompt Engineering',
  'Fine-tuning',
  'Computer Vision',
  'NLP',
  'Transformers',
  'PyTorch',
  'TensorFlow',
  'MLOps',
  'LLM APIs',
  'Agents',
  'Vector Databases',
  'Embeddings',
  'MCP',
  'Structured Outputs',
];

const availableSources = [
  FeedSource('r/MachineLearning', 'Reddit', true),
  FeedSource('r/LocalLLaMA', 'Reddit', true),
  FeedSource('Hacker News', 'HN', true),
  FeedSource('AI Blogs', 'Blogs', true),
  FeedSource('r/artificial', 'Reddit', false),
  FeedSource('r/ChatGPT', 'Reddit', false),
];

class FeedSource {
  const FeedSource(this.name, this.category, this.defaultEnabled);

  final String name;
  final String category;
  final bool defaultEnabled;
}
