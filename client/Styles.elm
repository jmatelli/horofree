module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, div, input, h1, h2, a, span)


type CssClasses
    = Header
    | Stopwatch
    | Income
    | BtnContainer
    | BtnControl
    | BtnPlay
    | BtnPause
    | BtnStop


teal : Color
teal =
    hex "009688"


teal700 : Color
teal700 =
    hex "00796B"


teal900 : Color
teal900 =
    hex "004D40"


indigo : Color
indigo =
    hex "3F51B5"


indigo700 : Color
indigo700 =
    hex "303F9F"


indigo900 : Color
indigo900 =
    hex "1A237E"


red500 : Color
red500 =
    hex "F44336"


red700 : Color
red700 =
    hex "D32F2F"


red900 : Color
red900 =
    hex "B71C1C"


grey50 : Color
grey50 =
    hex "fafafa"


grey500 : Color
grey500 =
    hex "9e9e9e"


grey900 : Color
grey900 =
    hex "212121"


css : Stylesheet
css =
    stylesheet
        [ body
            [ height (vh 100)
            , backgroundColor teal700
            , color grey50
            ]
        , a
            [ color grey50 ]
        , (.) Header
            [ margin3 (px 0) (px 0) (px 20)
            , padding (px 20)
            , position relative
            , children
                [ h1
                    [ margin2 zero auto
                    , fontFamilies [ (qt "Pacifico"), .value cursive ]
                    , fontSize (Css.rem 6)
                    , fontWeight lighter
                    , textAlign center
                    , position relative
                    , width (px 400)
                    ]
                ]
            ]
        , (.) Stopwatch
            [ fontSize (Css.rem 3)
            , fontWeight bold
            , textAlign center
            , margin2 (px 50) zero
            ]
        , (.) Income
            [ fontSize (Css.rem 15)
            , backgroundColor teal
            , margin2 (px 50) zero
            , fontWeight bold
            , color grey900
            , textAlign center
            ]
        , (.) BtnContainer
            [ textAlign center
            , margin (px 20)
            , descendants
                [ (.) BtnControl
                    [ padding2 (px 10) (px 20)
                    , border3 (px 1) solid grey50
                    , color grey50
                    , backgroundColor transparent
                    , fontSize (Css.rem 1.5)
                    , margin (px 10)
                    , hover
                        [ backgroundColor (rgba 0 0 0 0.3) ]
                    , disabled
                        [ opacity (num 0.5)
                        , hover
                            [ backgroundColor transparent ]
                        ]
                    ]
                ]
            ]
        ]
