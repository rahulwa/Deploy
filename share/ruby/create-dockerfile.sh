
# _JI_LANGUAGE_PATH
make_ji_pkg_list() {
  predefined_gem_list=( $(ls $_JI_LANGUAGE_PATH/gems) )
}

# _ji_CURRENT_APP_PATH
make_matched_pkg_list() {
  installed_pkg_list=()
  for gem in "${predefined_gem_list[@]}"; do
    if grep --quiet $gem $_ji_CURRENT_APP_PATH/Gemfile.lock; then
      installed_pkg_list+=("$gem")
  done
}

copy_dockerfile() {
  cp _JI_LANGUAGE_PATH/defaults/Dockerfile _ji_CURRENT_APP_PATH/Dockerfile
}

append_dependencies_in_dockerfile() {
  all_dependencies_list=()
  for gem in "${installed_pkg_list[@]}"; do
    all_dependencies_list+=(
      `awk 'BEGIN {FS="="}
        {
          gsub (" ", "", $0);
          if ($1 == "dependencies-alpine")
          {
            gsub (",", " ", $2);
            {print $2}
          }
        }' < $_JI_LANGUAGE_PATH/gems/$gem`
  done
  # Only retain uniq values
  dependencies_list=($(printf "%s\n" "${all_dependencies_list[@]}" | sort -u))
  for pkg in "${dependencies_list][@]}"; do
    if [[ $pkg != ${dependencies_list[-1]} ]]; then
      awk '1;/\$DEFAULT_PACKAGES/{print "'"$pkg"'  && \\";next}' $_ji_CURRENT_APP_PATH/Dockerfile
    elif
      awk '1;/\$DEFAULT_PACKAGES/{print "'"$pkg"'";next}' $_ji_CURRENT_APP_PATH/Dockerfile
    fi
  done
}

add_extra_dependencies_in_dockerfile() {
  all_dependencies_list=()
  for gem in "${installed_pkg_list[@]}"; do
    awk '/dependencies = /,/END/ { gsub("dependencies = ",""); gsub("END",""); print }' $_JI_LANGUAGE_PATH/gems/$gem | awk 'NF'
}