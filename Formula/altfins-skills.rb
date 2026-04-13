class AltfinsSkills < Formula
  desc "Install and package reusable altFINS AI skills"
  homepage "https://github.com/altfins-com/altfins-ai-skills"
  url "https://github.com/altfins-com/altfins-ai-skills/releases/download/v0.1.4/altfins-ai-skills-src.tar.gz"
  sha256 "ba1c51cb37353d12cd7296a9f1c17aae5ffb1959da7104b23a8a682c7633b753"
  version "0.1.4"
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
