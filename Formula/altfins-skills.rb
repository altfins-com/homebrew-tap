class AltfinsSkills < Formula
  desc "Install and package reusable altFINS AI skills"
  homepage "https://github.com/altfins-com/altfins-ai-skills"
  url "https://github.com/altfins-com/altfins-ai-skills/releases/download/v0.1.0/altfins-ai-skills-src.tar.gz"
  sha256 "1166eb9ffef4a778c83fc171e85a67ef0e48be18a7aa990ba6bb5d801f4b561b"
  version "0.1.0"
  license "Apache-2.0"

  depends_on "python@3.12"

  def install
    (libexec/"repo").install Dir["*"]

    (bin/"altfins-skills").write <<~SH
      #!/bin/bash
      export ALTFINS_SKILLS_ROOT="#{libexec}/repo"
      export ALTFINS_SKILLS_PYTHON="#{Formula["python@3.12"].opt_bin}/python3"
      exec "$ALTFINS_SKILLS_PYTHON" "$ALTFINS_SKILLS_ROOT/scripts/skills.py" "$@"
    SH
  end

  test do
    output = shell_output("#{bin}/altfins-skills list --json")
    assert_match "altfins-market-analyst", output
  end
end
