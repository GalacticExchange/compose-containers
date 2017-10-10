# Q: What is a Dangerfile, anyway? A: See http://danger.systems/

has_builder_changes = !git.modified_files.grep(/build/).empty?
has_compose_changes = !git.modified_files.grep(/compose/).empty?
has_lib_changes = has_builder_changes || has_compose_changes

has_spec_changes = !git.modified_files.grep(/spec/).empty?
has_changelog_changes = git.modified_files.include?("CHANGELOG.md")


# --------------------------------------------------------------------------------------------------------------------
# You've made changes to lib, but didn't write any tests?
# --------------------------------------------------------------------------------------------------------------------
if has_lib_changes && !has_spec_changes
  warn("There're library changes, but not tests. That's OK as long as you're refactoring existing code.", sticky: false)
end


# --------------------------------------------------------------------------------------------------------------------
# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
# --------------------------------------------------------------------------------------------------------------------
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"


# --------------------------------------------------------------------------------------------------------------------
# Have you updated CHANGELOG.md?
# --------------------------------------------------------------------------------------------------------------------
if !has_changelog_changes && has_lib_changes
  warn("Please update CHANGELOG.md with a description of your changes. "\
       "If this PR is not a user-facing change (e.g. just refactoring), "\
       "you can disregard this.", :sticky => false)
end