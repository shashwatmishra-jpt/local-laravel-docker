# Bash Functions
jpt () {

    if [[ "$1" == "up" || "$1" == "u" ]]; then
        docker_cmd=(docker)
        service=(compose)
        executable=(up)
        append=(-d --build --remove-orphans)
    elif [[ "$1" == "down" || "$1" == "d" ]]; then
        docker_cmd=(docker)
        service=(compose)
        executable=(down)
        append=()
    else
        docker_cmd=(docker exec -it)
        service_append="marketplace2"
        service=(${service_append}-"$1")
        executable=()
        append=()
        remain=()

        if [[ "$2" == "artisan" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(php)
            append+=(artisan "$@")
        elif [[ "$2" == "php" && "$3" == "artisan" ]]; then
            shift $(expr $OPTIND + 2 )
            append+=(php artisan "$@")
        elif [[ "$2" == "yarn" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(yarn)
            append+=("$@")
        elif [[ "$2" == "npm" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(npm)
            append+=("$@")
        elif [[ "$2" == "git" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(git)
            append+=("$@")
        elif [[ "$2" == "composer" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(composer)
            append+=("$@")
        elif [[ "$2" == "pint" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(./vendor/bin/pint)
            append+=("$@")
        elif [[ "$2" == "phpunit" || "$2" == "unit" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(./vendor/bin/phpunit)
            append+=("$@")
        else
            executable=("$2")
            shift $(expr $OPTIND + 1 )
            append+="$@"
        fi
    fi
    # echo "${service[@]} ${append[@]}"
    # exit 1;

    "${docker_cmd[@]}" "${service[@]}" "${executable[@]}" "${append[@]}"

}
