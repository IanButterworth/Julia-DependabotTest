This nested workspace has 3 projects:

- root: dev env with DataStructures dependency + all subproject dependencies
- core: package with JSON dependency
- core/test: test env with Example dependency

The DataStructures compat is only set in the root.
The JSON compat is only set in core.
The Example compat is only set in core/test.

Over the entire workspace, all compat entries are set.
Currently all compat entries are for previous major releases.

The desired behavior is that dependabot will only update the existing compat entries,
and not add additional compat entries for JSON and Example in the root project.
