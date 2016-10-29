module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, div, input, h1, a, span)


type CssClasses
    = Header
    | AddLink
    | OpenList
    | CloseList
    | ListStopwatches
    | ListOpened
    | ListClosed
    | ListItem
    | ListItemDetails
    | RemoveStopwatch
    | Setup
    | LabelSetup
    | InputText
    | InputHours
    | SpanInput
    | RateType
    | RateTypeSelected
    | Stopwatch
    | Income
    | BtnContainer
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


grey900 : Color
grey900 =
    hex "212121"


css : Stylesheet
css =
    stylesheet
        [ body
            [ height (vh 100)
            , backgroundColor teal700
            , color (hex "ecf0f1")
            ]
        , a
            [ color (hex "ecf0f1") ]
        , (.) Hidden
            [ display none ]
        , (.) Header
            [ margin3 (px 0) (px 0) (px 20)
            , padding (px 20)
            , position relative
            , children
                [ h1
                    [ margin zero
                    , fontFamilies [ (qt "Pacifico"), .value cursive ]
                    , fontSize (Css.rem 4)
                    , fontWeight lighter
                    , textAlign center
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
                    , descendants
                        [ (.) ListItemDetails
                            [ displayFlex
                            , backgroundColor teal900
                            , textAlign center
                            , padding (px 10)
                            , cursor pointer
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
                            , backgroundColor red700
                            , width (px 30)
                            , position absolute
                            , right zero
                            , top zero
                            , bottom zero
                            , textAlign center
                            , alignItems center
                            , cursor pointer
                            , hover
                                [ backgroundColor red900 ]
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
            , width (px 400)
            , margin2 zero auto
            , descendants
                [ div
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
                    , color (hex "ecf0f1")
                    , fontSize (Css.rem 2)
                    , border zero
                    , borderBottom3 (px 2) solid teal900
                    , fontWeight bold
                    , height (px 58)
                    , width (px 75)
                    , textAlign center
                    , display inlineBlock
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
                ]
            ]
        , (.) Stopwatch
            [ fontSize (Css.rem 3)
            , fontWeight bold
            , textAlign center
            , margin2 (px 50) zero
            ]
        , (.) Income
            [ fontSize (Css.rem 10)
            , backgroundColor teal
            , margin2 (px 50) zero
            , fontWeight bold
            , color grey900
            , textAlign center
            ]
        , (.) BtnContainer
            [ textAlign center ]
        ]
