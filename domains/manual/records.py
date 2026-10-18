"""Prints the DNS records the apps of a project need, then looks each one up.

records.py PROJECT [--print-only]

The records are those the apps leave in PROJECT/dns/*.json, keyed by domain.
The person adds them where their DNS is; this says which are there yet. It
exits 0 either way: a record DNS has not spread yet is no failure.
"""

import ipaddress
import json
import shutil
import subprocess
import sys
from pathlib import Path


def load(project: Path) -> list[dict]:
    records = []
    for path in sorted((project / "dns").glob("*.json")):
        for domain, rs in json.loads(path.read_text()).items():
            for r in rs:
                records.append({**r, "domain": domain, "from": path.stem})
    return records


def shown(r: dict) -> str:
    content = r["content"]
    if r["type"] == "MX":
        content = f'{r.get("priority")} {content}'
    if r["type"] == "TXT":
        content = f'"{content}"'
    return f'{r["type"]:<6} {r["name"]:<40} {content}'


def host(name: str) -> str:
    return name.rstrip(".").lower()


def answers(r: dict) -> list[str]:
    out = subprocess.run(
        ["dig", "+short", "+time=3", "+tries=2", r["type"], r["name"]],
        capture_output=True, text=True, timeout=30,
    )
    return [line.strip() for line in out.stdout.splitlines() if line.strip() and not line.startswith(";")]


def present(r: dict, got: list[str]) -> bool:
    kind, want = r["type"], r["content"]
    if kind in ("A", "AAAA"):
        try:
            return any(ipaddress.ip_address(a) == ipaddress.ip_address(want) for a in got if ":" in a or "." in a)
        except ValueError:
            return False
    if kind == "CNAME":
        return host(want) in [host(a) for a in got]
    if kind == "MX":
        for a in got:
            parts = a.split()
            if len(parts) == 2 and host(parts[1]) == host(want) and str(parts[0]) == str(r.get("priority")):
                return True
        return False
    if kind == "TXT":
        joined = ["".join(chunk for chunk in a.split('"') if chunk.strip()) if a.startswith('"') else a for a in got]
        return want in joined
    return False


def main(args: list[str]) -> int:
    if not args:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    project = Path(args[0])
    records = load(project)
    if not records:
        print(f"No app of the project needs DNS records yet: {project / 'dns'} is empty.")
        return 0

    print("Add these records where the DNS of your domains is:\n")
    for domain in sorted({r["domain"] for r in records}):
        print(domain)
        for r in records:
            if r["domain"] == domain:
                print(f"  {shown(r)}")
        print()

    if "--print-only" in args[1:]:
        return 0
    if shutil.which("dig") is None:
        print("dig is not on this Mac, so they are not looked up.")
        return 0

    missing = []
    for r in records:
        try:
            ok = present(r, answers(r))
        except (OSError, subprocess.SubprocessError):
            ok = False
        if not ok:
            missing.append(r)

    if not missing:
        print(f"All {len(records)} records are in DNS.")
        return 0
    print(f"{len(records) - len(missing)} of {len(records)} records are in DNS. Not found yet:\n")
    for r in missing:
        print(f"  {shown(r)}")
    print(
        "\nAdd them, or wait: a new record can take up to an hour to spread. "
        "damstack deploy looks again; the apps whose names are missing are not reachable meanwhile."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
