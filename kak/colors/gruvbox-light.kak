# gruvbox theme

evaluate-commands %sh{
    gray="rgb:928374"
    red="rgb:cc241d"
    green="rgb:98971a"
    yellow="rgb:d79921"
    blue="rgb:458588"
    purple="rgb:b16286"
    aqua="rgb:689d6a"
    orange="rgb:d65d0e"

    bg="rgb:fbf1c7"
    bg1="rgb:ebdbb2"
    bg2="rgb:d5c4a1"
    bg3="rgb:bdae93"
    bg4="rgb:a89984"

    fg0="rgb:282828"
    fg="rgb:3c3836"
    fg2="rgb:504945"
    fg3="rgb:665c54"
    fg4="rgb:7c6f64"

    echo "
        # Code highlighting
        face global value     ${purple}
        face global type      ${yellow}
        face global variable  ${blue}
        face global module    ${green}
        face global function  ${fg}
        face global string    ${green}
        face global keyword   ${red}
        face global operator  ${fg}
        face global attribute ${orange}
        face global comment   ${gray}
        face global meta      ${aqua}
        face global builtin   ${fg}+b

        # Markdown highlighting
        face global title     ${green}+b
        face global header    ${orange}
        face global bold      ${fg}+b
        face global italic    ${fg}+i
        face global mono      ${fg4}
        face global block     ${aqua}
        face global link      ${blue}+u
        face global bullet    ${yellow}
        face global list      ${fg}

        face global Default            ${fg},${bg}
        face global PrimarySelection   ${fg},${blue}+fg
        face global SecondarySelection ${bg},${blue}+fg
        face global PrimaryCursor      ${bg},${fg}+fg
        face global SecondaryCursor    ${bg},${bg4}+fg
        face global PrimaryCursorEol   ${bg},${fg4}+fg
        face global SecondaryCursorEol ${bg},${bg2}+fg
        face global LineNumbers        ${bg4}
        face global LineNumberCursor   ${yellow},${bg1}
        face global LineNumbersWrapped ${bg1}
        face global MenuForeground     ${bg2},${blue}
        face global MenuBackground     ${fg},${bg2}
        face global MenuInfo           ${bg}
        face global Information        ${bg},${fg}
        face global Error              ${bg},${red}
        face global StatusLine         ${fg},${bg}
        face global StatusLineMode     ${yellow}+b
        face global StatusLineInfo     ${purple}
        face global StatusLineValue    ${red}
        face global StatusCursor       ${bg},${fg}
        face global Prompt             ${yellow}
        face global MatchingChar       ${fg},${bg3}+b
        face global BufferPadding      ${bg2},${bg}
        face global Whitespace         ${bg2}+f
    "
}
