# Bash Functions
jpt () {
    service=(docker exec -it marketplace2-"$1")
    append=()
    remain=()

    if [ "$2" == "artisan" ]; then
        shift $(expr $OPTIND + 1 )
        append+=(php artisan "$@")
    elif [ "$2" == "yarn" ]; then
        shift $(expr $OPTIND + 1 )
        append+=(yarn "$@")
    elif [ "$2" == "npm" ]; then
        shift $(expr $OPTIND + 1 )
        append+=(npm "$@")
    elif [ "$2" == "git" ]; then
        shift $(expr $OPTIND + 1 )
        append+=(git "$@")
    elif [ "$2" == "composer" ]; then
        shift $(expr $OPTIND + 1 )
        append+=(composer "$@")
    elif [ "$2" == "pint" ]; then
        shift $(expr $OPTIND + 1 )
        append+=(./vendor/bin/pint "$@")
    else
        shift $(expr $OPTIND )
        append+="$@"
    fi

    # echo "${service[@]} ${append[@]}">&2
    # exit 1;

    "${service[@]}" "${append[@]}"

}
