module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, div, input, h1, h2, a, span)


type CssClasses
    = Header
    | AddLink
    | OpenList
    | CloseList
    | OpenSetup
    | CloseSetup
    | ListStopwatches
    | ListOpened
    | ListClosed
    | ListItem
    | ListItemDetails
    | RemoveStopwatch
    | Setup
    | SetupContainer
    | LabelSetup
    | InputText
    | InputHours
    | SpanInput
    | RateType
    | RateTypeSelected
    | SaveSetup
    | CancelSetup
    | Stopwatch
    | Income
    | BtnContainer
    | BtnSave
    | BtnControl
    | BtnPlay
    | BtnPause
    | BtnStop
    | Hidden


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
        , (.) Hidden
            [ display none ]
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
        , (.) AddLink
            [ fontSize (Css.rem 2)
            , position absolute
            , top zero
            , left zero
            , height (px 75)
            , width (px 150)
            , lineHeight (px 75)
            , textAlign center
            , cursor pointer
            , borderBottom3 (px 2) solid teal700
            , backgroundColor teal
            , hover
                [ backgroundColor teal700 ]
            ]
        , (.) CloseList
            [ fontSize (Css.rem 2)
            , position absolute
            , top zero
            , left (px 150)
            , height (px 73)
            , width (px 75)
            , lineHeight (px 73)
            , textAlign center
            , cursor pointer
            , backgroundColor red700
            , hover
                [ backgroundColor red900 ]
            ]
        , (.) OpenList
            [ fontSize (Css.rem 2)
            , position absolute
            , top zero
            , left (px 150)
            , height (px 73)
            , width (px 75)
            , lineHeight (px 73)
            , textAlign center
            , cursor pointer
            , backgroundColor indigo700
            , hover
                [ backgroundColor indigo900 ]
            ]
        , (.) CloseSetup
            [ fontSize (Css.rem 2)
            , position absolute
            , top zero
            , right zero
            , height (px 73)
            , width (px 75)
            , lineHeight (px 73)
            , textAlign center
            , cursor pointer
            , hover
                [ color grey500 ]
            ]
        , (.) OpenSetup
            [ fontSize (Css.rem 2)
            , position absolute
            , top zero
            , right zero
            , height (px 73)
            , width (px 75)
            , lineHeight (px 73)
            , textAlign center
            , cursor pointer
            , backgroundColor teal
            , hover
                [ backgroundColor teal900 ]
            ]
        , (.) ListStopwatches
            [ width (px 150)
            , height (vh 100)
            , position fixed
            , top zero
            , bottom zero
            , left zero
            , paddingTop (px 75)
            , backgroundColor teal
            , overflow auto
            , descendants
                [ (.) ListItem
                    [ margin (px 10)
                    , position relative
                    , height (px 75)
                    , descendants
                        [ (.) ListItemDetails
                            [ displayFlex
                            , backgroundColor teal900
                            , textAlign center
                            , padding (px 10)
                            , height (px 75)
                            , hover
                                [ backgroundColor teal700 ]
                            , descendants
                                [ span
                                    [ display inlineBlock
                                    , alignSelf center
                                    , nthChild "1"
                                        [ flexGrow (num 3) ]
                                    ]
                                ]
                            ]
                        , (.) RemoveStopwatch
                            [ display none
                            , backgroundColor (rgba 0 0 0 0.7)
                            , position absolute
                            , left zero
                            , right zero
                            , top zero
                            , bottom zero
                            , textAlign center
                            , alignItems center
                            , descendants
                                [ a
                                    [ display inlineBlock
                                    , width (pct 50)
                                    , height (px 75)
                                    , lineHeight (px 75)
                                    , cursor pointer
                                    , hover
                                        [ backgroundColor (rgba 255 255 255 0.3) ]
                                    ]
                                ]
                            ]
                        ]
                    , hover
                        [ descendants
                            [ (.) RemoveStopwatch
                                [ displayFlex ]
                            ]
                        ]
                    ]
                ]
            ]
        , (.) ListOpened
            [ left zero ]
        , (.) ListClosed
            [ left (px -150) ]
        , (.) Setup
            [ textAlign center
            , position absolute
            , top zero
            , bottom zero
            , left zero
            , right zero
            , height (pct 100)
            , width (pct 100)
            , backgroundColor (rgba 0 0 0 0.8)
            , descendants
                [ (.) SetupContainer
                    [ width (px 400)
                    , margin2 zero auto
                    , position relative
                    , top (pct 50)
                    , transform (translate2 zero (pct -50))
                    , children
                        [ h2
                            [ margin3 zero auto (px 30)
                            , fontFamilies [ (qt "Pacifico"), .value cursive ]
                            , fontSize (Css.rem 4)
                            , fontWeight lighter
                            , textAlign center
                            , position relative
                            , width (px 400)
                            ]
                        ]
                    ]
                , div
                    [ marginBottom (px 20) ]
                , (.) LabelSetup
                    [ display block
                    , textAlign left
                    ]
                , (.) InputText
                    [ padding2 (px 10) (px 20)
                    , border zero
                    , borderBottom3 (px 2) solid teal900
                    , backgroundColor teal
                    , color (hex "FFF")
                    , fontSize (Css.rem 2)
                    , width (px 325)
                    ]
                , (.) InputHours
                    [ width (px 400) ]
                , (.) SpanInput
                    [ backgroundColor teal900
                    , color grey50
                    , fontSize (Css.rem 2)
                    , border zero
                    , borderBottom3 (px 2) solid teal900
                    , fontWeight bold
                    , height (px 58)
                    , width (px 75)
                    , textAlign center
                    , display inlineBlock
                    , padding2 zero (px 10)
                    ]
                , (.) RateType
                    [ backgroundColor indigo700
                    , display inlineBlock
                    , padding2 (px 10) (px 20)
                    , hover
                        [ backgroundColor indigo ]
                    , descendants
                        [ input
                            [ display none
                            ]
                        ]
                    ]
                , (.) RateTypeSelected
                    [ backgroundColor indigo ]
                , (.) SaveSetup
                    [ backgroundColor indigo700
                    , color grey50
                    , border zero
                    , padding2 (px 10) (px 20)
                    , margin (px 20)
                    , hover
                        [ backgroundColor indigo900 ]
                    ]
                , (.) CancelSetup
                    [ backgroundColor red700
                    , color grey50
                    , border zero
                    , padding2 (px 10) (px 20)
                    , margin (px 20)
                    , hover
                        [ backgroundColor red900 ]
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
                [ (.) BtnSave
                    [ backgroundColor red700
                    , padding2 (px 10) (px 20)
                    , border zero
                    , color grey50
                    , fontSize (Css.rem 1.5)
                    , hover
                        [ backgroundColor red900 ]
                    , disabled
                        [ opacity (num 0.5)
                        , hover
                            [ backgroundColor red700 ]
                        ]
                    ]
                , (.) BtnControl
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
