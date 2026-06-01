.PHONY: install package clean

install:
	@bash install.sh

package:
	@mkdir -p dist
	@find . -name "SKILL.md" -not -path "*/.git/*" -not -path "./dist/*" | while read skill_md; do \
		skill_dir=$$(dirname "$$skill_md"); \
		skill_name=$$(basename "$$skill_dir"); \
		echo "  packing  $$skill_name → dist/$$skill_name.zip"; \
		(cd "$$skill_dir" && zip -rq "$(CURDIR)/dist/$$skill_name.zip" .); \
	done
	@echo "Done. Upload zips from dist/ to claude.ai → Settings → Features."

clean:
	@rm -rf dist
	@echo "Cleaned dist/"
