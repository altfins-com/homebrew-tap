class AltfinsSkills < Formula
  desc "Install and package reusable altFINS AI skills"
  homepage "https://github.com/altfins-com/altfins-ai-skills"
  url "https://github.com/altfins-com/altfins-ai-skills/releases/download/v1.0.0/altfins-ai-skills-src.tar.gz"
  sha256 "18a350914793e2550996b773e4e2ed09c94c157e69dd880726ef0bd0b9aa558c"
  version "1.0.0"
  license "Apache-2.0"

  depends_on "python@3.12"

  def install
    (libexec/"repo").install Dir["*"]

    (bin/"altfins-skills").write <<~SH
      #!/bin/bash
      export ALTFINS_SKILLS_ROOT="#{libexec}/repo"
      CANDIDATES=(
        "#{Formula["python@3.12"].opt_bin}/python3.12"
        "#{Formula["python@3.12"].opt_bin}/python3"
      )

      if [ -n "${ALTFINS_SKILLS_PYTHON:-}" ]; then
        CANDIDATES=("${ALTFINS_SKILLS_PYTHON}" "${CANDIDATES[@]}")
      fi

      for candidate in "${CANDIDATES[@]}"; do
        if [ -x "$candidate" ]; then
          exec "$candidate" "$ALTFINS_SKILLS_ROOT/scripts/skills.py" "$@"
        fi
      done

      if command -v python3.12 >/dev/null 2>&1; then
        exec "$(command -v python3.12)" "$ALTFINS_SKILLS_ROOT/scripts/skills.py" "$@"
      fi
      if command -v python3 >/dev/null 2>&1; then
        exec "$(command -v python3)" "$ALTFINS_SKILLS_ROOT/scripts/skills.py" "$@"
      fi
      if command -v python >/dev/null 2>&1; then
        exec "$(command -v python)" "$ALTFINS_SKILLS_ROOT/scripts/skills.py" "$@"
      fi

      echo "Could not find a usable Python interpreter for altfins-skills." >&2
      exit 1
    SH
  end

  test do
    output = shell_output("#{bin}/altfins-skills list --json")
    assert_match "altfins-market-analyst", output
  end
end
