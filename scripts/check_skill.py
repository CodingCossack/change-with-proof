#!/usr/bin/env python3
"""Structural checks for the change-with-proof skill.

Stdlib only. Parses frontmatter by scanning for delimiters (no line-position
assumptions), verifies naming/description rules, and resolves relative file
references.
"""

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SKILL_DIR = REPO / "skills" / "change-with-proof"
SKILL_MD = SKILL_DIR / "SKILL.md"

MAX_FRONTMATTER_CHARS = 1024
# Bare filenames that refer to repo/harness conventions, not skill files.
CONVENTION_FILES = {"AGENTS.md", "README.md", "CLAUDE.md", "GEMINI.md", "SKILL.md"}

FILE_TOKEN = re.compile(r"`([A-Za-z0-9._/-]+\.(?:md|sh|py|yaml|yml|json))`")
MD_LINK = re.compile(r"\]\((?!https?://|#)([^)\s]+?)(?:#[^)\s]*)?\)")

errors: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


def parse_frontmatter(text: str):
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        err("SKILL.md must start with a '---' frontmatter delimiter")
        return None, None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            raw = "\n".join(lines[: i + 1])
            fields = {}
            for line in lines[1:i]:
                if not line.strip():
                    continue
                m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
                if not m:
                    err(f"unsupported frontmatter line (simple 'key: value' only): {line!r}")
                    continue
                fields[m.group(1)] = m.group(2).strip()
            return fields, raw
    err("closing '---' frontmatter delimiter not found in SKILL.md")
    return None, None


def check_frontmatter() -> None:
    text = SKILL_MD.read_text(encoding="utf-8")
    fields, raw = parse_frontmatter(text)
    if fields is None:
        return
    name = fields.get("name")
    if name != SKILL_DIR.name:
        err(f"frontmatter name {name!r} must equal skill directory name {SKILL_DIR.name!r}")
    desc = fields.get("description", "")
    if not desc.startswith("Use when"):
        err("description must start with 'Use when'")
    if "Do not use for" not in desc:
        err("description must state negative scope with 'Do not use for'")
    if len(raw) > MAX_FRONTMATTER_CHARS:
        err(f"frontmatter is {len(raw)} chars; budget is {MAX_FRONTMATTER_CHARS}")


def check_references(md_file: Path) -> None:
    text = md_file.read_text(encoding="utf-8")
    tokens = set(FILE_TOKEN.findall(text)) | set(MD_LINK.findall(text))
    for token in sorted(tokens):
        base = token.split("/")[-1]
        if "/" not in token and base in CONVENTION_FILES:
            continue
        candidates = [md_file.parent / token, SKILL_DIR / token, REPO / token]
        if not any(c.is_file() for c in candidates):
            err(f"{md_file.relative_to(REPO)}: reference {token!r} does not resolve to a file")


def main() -> int:
    if not SKILL_MD.is_file():
        print(f"FAIL: missing {SKILL_MD}", file=sys.stderr)
        return 1
    check_frontmatter()
    check_references(SKILL_MD)
    if errors:
        for e in errors:
            print(f"FAIL: {e}", file=sys.stderr)
        return 1
    print("check_skill.py: all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
