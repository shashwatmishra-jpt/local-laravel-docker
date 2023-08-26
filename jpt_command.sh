# Bash Functions
jpt_service () {

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
    elif [[ "$1" == "ps" ]]; then
        docker_cmd=(docker)
        service=(compose)
        executable=(ps)
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
        elif [[ "$2" == "php" ]]; then
            if [[ "$3" == "artisan" ]]; then
                shift $(expr $OPTIND + 2 )
                executable=(php)
                append+=(artisan "$@")
            else
                shift $(expr $OPTIND + 1 )
                executable=(php)
                append+=("$@")
            fi
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
            append+=("$@")
        fi
    fi
    # echo "${service[@]} ${append[@]}"
    # exit 1;

    "${docker_cmd[@]}" "${service[@]}" "${executable[@]}" "${append[@]}"

}

jpt () {
    if [ "$1" == "artisan" ] || \
        [ "$1" == "php" ] || \
        [ "$1" == "yarn" ] || \
        [ "$1" == "npm" ] || \
        [ "$1" == "git" ] || \
        [ "$1" == "composer" ] || \
        [ "$1" == "pint" ] || \
        [ "$1" == "phpunit" ] || \
        [ "$1" == "unit" ]; then
        command=(jpt_service core)
        append=("$@")
    else
        command=(jpt_service)
        append=("$@")
    fi

    "${command[@]}" "${append[@]}"

}