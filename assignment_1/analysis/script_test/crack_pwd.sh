#!/bin/bash

parent_directory="."

mkdir -p "${parent_directory}/results/"

for directory in "$parent_directory"/*/; do
    
    dir_name="$(basename "$directory")"

    pattern="${dir_name%%_*}"
    n_digits="${dir_name#*_}"

    mask=""

    echo $pattern
    echo $n_digits

    case $pattern in
    numbers)
        mask_0="?d"
        mask=""
        ;;
    lower-case)
        mask_0="?l"
        mask=""
        ;;
    upper-case)
        mask_0="?u"
        mask=""
        ;;
    alpha)
        mask_0="?1"
        mask="-1 ?l?u "
        ;;
    alphanumeric)
        mask_0="?1"
        mask="-1 ?l?u?d "
        ;;
    char-spec)
        mask_0="?s"
        mask=""
        ;;
    full)
        mask_0="?1"
        mask="-1 ?l?u?d?s "
        ;;
    *)
        exit 1
        ;;
    esac

    # Repeat pattern for number of digits
    for i in $(seq "$n_digits"); do
        mask="${mask}${mask_0}"
    done

    echo "${n_digits} digits - ${pattern}" >> "${parent_directory}/results/stats.txt"

    echo "" >> "${parent_directory}/results/stats.txt"

    hashcat="hashcat -a 3 -w 3 -m 13711 -D 1 -o ${parent_directory}/results/${pattern}_${n_digits}digits.txt "
	stats="${directory}container_12305812.hc ${mask} | sed -n '/Session/,\$p' >> ${parent_directory}/results/stats.txt"
    command="${hashcat}${stats}"

    echo ""
    echo "Running Hashcat in directory: $dir_name"
    echo "Mask: ${mask}"

    eval "$command"

    echo "" >> "${parent_directory}/results/stats.txt"
    echo "" >> "${parent_directory}/results/stats.txt"

done