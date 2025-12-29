# plugin.json Schema

## Required Fields

| Field | Type | Constraints |
|-------|------|-------------|
| `name` | string | kebab-case, max 64 chars |
| `description` | string | Brief purpose statement |
| `version` | string | Semantic versioning (MAJOR.MINOR.PATCH) |

## Optional Metadata

| Field | Type | Purpose |
|-------|------|---------|
| `author.name` | string | Author name |
| `author.email` | string | Contact email |
| `author.url` | string | Author URL |
| `homepage` | string | Documentation URL |
| `repository` | string | Source code URL |
| `license` | string | License identifier (e.g., "MIT") |
| `keywords` | array | Search keywords |

## Component Paths

All paths must be relative, starting with `./`:

| Field | Type | Default |
|-------|------|---------|
| `commands` | string | `"./commands/"` |
| `agents` | string | `"./agents/"` |
| `skills` | string | `"./skills/"` |
| `hooks` | string | `"./hooks/hooks.json"` |
| `mcpServers` | string | `"./.mcp.json"` |
| `lspServers` | string | `"./.lsp.json"` |

## Example

```json
{
  "name": "my-plugin",
  "description": "Does X and Y for Z workflows",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  },
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"]
}
```
