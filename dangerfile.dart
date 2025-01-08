import "package:danger_core/danger_core.dart";

abstract class GitlintConfig {
  static const List<String> types = [
    "build",
    "chore",
    "docs",
    "feat",
    "fix",
    "refactor",
    "revert",
    "style",
    "test",
  ];

  static const List<String> scopes = [
    "root",
    "lib",
    "lib-domain",
    "lib-infrastructures",
    "lib-use_cases",
    "lib-interfaces",
    "lib-libs",
    "assets",
    "android",
    "ios",
    "web",
    "windows",
    "macos",
    "linux",
    "github",
  ];

  static const List<String> issuePrefixes = ["ds", "release"];
}

class PRConfig {
  final RegExp? titlePattern;
  final RegExp? branchPattern;
  final bool requireAssignee;

  PRConfig({
    this.titlePattern,
    this.branchPattern,
    this.requireAssignee = false,
  });
}

final config = PRConfig(
  titlePattern: RegExp(
    '^(${GitlintConfig.types.join("|")})'
    '(\\((${GitlintConfig.scopes.join(("|"))})(\\/(${GitlintConfig.scopes.join(("|"))}))*\\))?'
    ': (.*\\S )?'
    '(${GitlintConfig.issuePrefixes.join("|")})-\\d{1,6}((\\.\\d+){1,2})?\$',
  ),
  branchPattern: RegExp(
    '^\\d{1,6}-'
    "${GitlintConfig.types.join("|")}-"
    '[a-zA-Z\\d-]+\$'
    '|(main)\$',
  ),
  requireAssignee: true,
);

final pr = danger.github.pr;

void checkTitle(RegExp titlePattern) {
  final isTitleValid = titlePattern.hasMatch(pr.title);

  if (!isTitleValid) {
    fail(
      "The PR title should match the following pattern: "
      "$titlePattern",
    );
  }
}

void checkBranch(RegExp branchPattern) {
  final isBranchValid = branchPattern.hasMatch(pr.head.ref);

  if (!isBranchValid) {
    fail(
      "The PR branch should match the following pattern: "
      "$branchPattern",
    );
  }
}

void checkAssignee() {
  final hasAssignee = pr.assignee == null ? false : true;

  if (!hasAssignee) {
    fail("The PR should have at least one assignee");
  }
}

void main() {
  if (config.titlePattern != null) {
    checkTitle(config.titlePattern!);
  }

  if (config.branchPattern != null) {
    checkBranch(config.branchPattern!);
  }

  if (config.requireAssignee) {
    checkAssignee();
  }
}
