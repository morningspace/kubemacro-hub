#!/bin/bash

# MIT License
#
# Copyright (c) 2021 MorningSpace
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function print_step {
  local step=$1
  local line='........................................................................'
  printf "%s%s" "$step" "${line:${#step}}"
}

function gen_macro_doc {
  local name=$1
  local file=$2
  local comment="`sed -n -e "/^#[[:space:]]*@Name:[[:space:]]*$name$/,/^##$/p" $file | sed -e '1d;$d'`"
  local summary="`echo "$comment" | grep '^#[[:space:]]*@Description:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Description:[[:space:]]*//p'`"
  local usage="`echo "$comment" | grep '^#[[:space:]]*@Usage:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Usage:[[:space:]]*//p'`"
  local dependencies="`echo "$comment" | grep '^#[[:space:]]*@Dependencies:[[:space:]]*' | sed -n 's/^#[[:space:]]*@Dependencies:[[:space:]]*//p'`"
  local description=""
  local options=""
  local examples=""
  local parsing

  # Parse annotations
  while IFS= read -r line; do
    [[ $line =~ ^#[[:space:]]*@Description:[[:space:]]* ]] && parsing=Description && continue
    [[ $line =~ ^#[[:space:]]*@Options:[[:space:]]*$ ]] && parsing=Options && continue
    [[ $line =~ ^#[[:space:]]*@Examples:[[:space:]]*$ ]] && parsing=Examples && continue

    if [[ $parsing == Description ]] && [[ ! $line =~ ^##$ && ! $line =~ ^#[[:space:]]*@ ]]; then
      description+="`echo $line | sed -n 's/^#[[:space:]]*//p'`\n"
    fi

    if [[ $parsing == Options ]] && [[ ! $line =~ ^#$ ]]; then
      if [[ $line =~ '${SELECT_OPTIONS}' ]]; then
        options+="${SELECT_OPTIONS_HELP[@]}\n"
      elif [[ $line =~ '${GLOBAL_OPTIONS}' ]]; then
        options+="${GLOBAL_OPTIONS_HELP[@]}\n"
      else
        options+="`echo $line | sed -n 's/^#[[:space:]]*//p'`\n"
      fi
    fi
  
    if [[ $parsing == Examples ]] && [[ ! $line =~ ^#$ && ! $line =~ ^#[[:space:]]*@ ]]; then
      examples+="`echo $line | sed -n 's/^#[[:space:]]*//p'`\n"
    fi
  done <<< "$comment"

  # Clean up the macro doc
  cp /dev/null macros/docs/$name.md

  # Resolve the placeholders
  while IFS= read -r line; do
    case $line in
    *@Name*|*@Summary*|*@Usage*)
      echo -e "$line" | sed -e "s/@Name/$name/g" -e "s/@Summary/$summary/g" -e "s/@Usage/$usage/g" >> macros/docs/$name.md
      ;;
    *@Description*)
      echo -e "$description" >> macros/docs/$name.md
      ;;
    *@Options*)
      echo -e "$options" >> macros/docs/$name.md
      ;;
    *@Examples*)
      echo -e "$examples" >> macros/docs/$name.md
      ;;
    *@Dependencies*)
      local dep deps
      IFS=',' read -a deps <<< "$dependencies"
      if [[ -n ${deps[@]} ]]; then
        for dep in ${deps[@]}; do
          if [[ -f macros/bin/$dep.sh ]]; then
            echo -e "* [$dep](docs/$dep.md)" >> macros/docs/$name.md
          else
            echo -e "* $dep" >> macros/docs/$name.md
          fi
        done
      else
        echo -e "There is no dependency for this macro." >> macros/docs/$name.md
      fi
      ;;
    *)
      echo "$line" >> macros/docs/$name.md
    esac
  done < macros/macro-doc-template.md
}

function gen_docs {
  # Clean up
  echo "Clean up directories..."
  cp /dev/null macros/_sidebar.md
  rm -rf macros/docs
  mkdir macros/docs

  # Generate .md files for macros
  # and update _sidebar.md
  echo "Start to generate the macro docs..."
  local name file i=0
  for file in `ls macros/bin/*.sh 2>/dev/null`; do
    echo "$i) Found macro $file."
    name=${file%.sh}
    name=${name#macros/bin/}

    # Generate .md file for macro
    print_step "Generate ${name}.md file"
    gen_macro_doc $name $file
    echo "done"

    # Update _sidebar.md
    print_step "Update _sidebar.md to add the entry for ${name}"
    echo "* [${name}](docs/${name}.md)" >> macros/_sidebar.md
    echo "done"

    (( i++ ))
  done

  echo "$i macros in total have been successfully processed."
}

gen_docs $@
