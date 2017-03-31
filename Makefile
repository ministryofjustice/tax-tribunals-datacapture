SOURCE_YAML_FILES := config/locales/*.yml
COMBINED_YAML_FILE := config/locales/en.yml

# Combine all the yaml files into a single
# file, and delete all the others
merge_yaml_files:
	rm $(COMBINED_YAML_FILE) || true
	make clean_yaml_files
	./bin/merge_yaml $(SOURCE_YAML_FILES) > $(COMBINED_YAML_FILE)
	ls -1 $(SOURCE_YAML_FILES) | grep -v $(COMBINED_YAML_FILE) | xargs rm

find_duplicate_strings:
	# WARNING: There is a tab inside the [] of the sed command
	cat $(COMBINED_YAML_FILE) | sed 's/^[ 	]*//' | sort | uniq -c | sort -n

clean_yaml_files:
	make remove_blank_lines
	make remove_trailing_whitespace
	make append_blank_line

# Blank lines after the *key* in a yaml file causes any html to be
# compacted onto a single line during the merge step. So, we remove
# any blank lines before doing that.
remove_blank_lines:
	for f in $(SOURCE_YAML_FILES); do \
		grep -v '^$$' $$f > foo; \
		mv foo $$f; \
	done

# Trailing whitespace causes html to be stringified, too,
# so we need to remove that as well
# WARNING: There is a tab inside the [] of the sed command
remove_trailing_whitespace:
	for f in $(SOURCE_YAML_FILES); do \
		cat $$f | sed 's/[ 	]*$$//' > foo; \
		mv foo $$f; \
	done

# Yaml files that don't end with a blank line don't merge
# as cleanly (html is stringified, so we need to ensure every yaml
# file ends in a blank line
append_blank_line:
	for f in $(SOURCE_YAML_FILES); do \
		echo >> $$f; \
	done

.PHONY: merge_yaml
