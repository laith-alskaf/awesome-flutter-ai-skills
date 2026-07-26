# AI Engineering OS — Capability Providers (Tool Registry)

This registry abstracts external tools and system capabilities into standard interfaces. Skills and Agents request these capabilities from the OS.

## Supported Providers

### 1. `github`
Provides access to version control and collaboration features.
- **Capabilities:**
  - `read_repo`: Clone, fetch, and read source files.
  - `write_branch`: Commit changes to a non-main branch.
  - `create_pr`: Open a Pull Request with a description.
- **Permissions:** `create_pr` and `write_branch` require User Approval.

### 2. `terminal`
Provides access to the local shell for executing scripts, builds, and tests.
- **Capabilities:**
  - `execute_read_only`: Run commands like `ls`, `cat`, `grep`.
  - `execute_write`: Run commands like `mkdir`, `rm`, `touch`.
  - `build`: Run framework-specific build commands (e.g., `flutter build`).
  - `test`: Run testing suites.
- **Permissions:** `execute_write` and `build` require User Approval depending on the Execution Policy.

### 3. `file_system`
Provides direct local file manipulation without the terminal.
- **Capabilities:**
  - `read_file`: Read content of specific files.
  - `write_file`: Create or overwrite files.
  - `patch_file`: Apply diffs or multi-replace operations.

### 4. `browser`
Provides headless or visual browser automation.
- **Capabilities:**
  - `navigate`: Open URLs.
  - `extract_dom`: Read documentation or website content.
  - `screenshot`: Capture visual evidence for the Reasoning Engine.

### 5. `mcp_server`
Provides integration with external Model Context Protocol (MCP) servers.
- **Capabilities:**
  - `query_vector_db`: Search codebase embeddings.
  - `query_jira`: Read ticketing context for the Session Context.

## Requesting Capabilities

When a Skill requires a tool, it declares it in its Contract. The Orchestrator verifies that the capability is available and authorized before executing the task.
