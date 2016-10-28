module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, div, input, h1)


type CssClasses
    = Header
    | Setup
    | InputText
    | SpanInput
    | Stopwatch
    | Income
    | BtnContainer


css : Stylesheet
css =
    stylesheet
        [ body
            [ height (vh 100)
            , backgroundColor (hex "2980b9")
            , color (hex "ecf0f1")
            ]
        , (.) Header
            [ margin3 (px 0) (px 0) (px 20)
            , padding (px 20)
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
        , (.) Setup
            [ textAlign center
            , descendants
                [ div
                    [ marginBottom (px 20) ]
                , (.) InputText
                    [ padding2 (px 10) (px 20)
                    , border zero
                    , borderBottom3 (px 2) solid (hex "2c3e50")
                    , backgroundColor transparent
                    , color (hex "FFF")
                    , lineHeight (px 50)
                    , height (px 52)
                    ]
                , (.) SpanInput
                    [ backgroundColor (hex "3498db")
                    , color (hex "ecf0f1")
                    , border zero
                    , borderBottom3 (px 2) solid (hex "2c3e50")
                    , fontWeight bold
                    , lineHeight (px 50)
                    , height (px 52)
                    , width (px 50)
                    , textAlign center
                    , display inlineBlock
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
            [ fontSize (Css.rem 10)
            , backgroundColor (hex "3498db")
            , margin2 (px 50) zero
            , fontWeight bold
            , color (hex "c0392b")
            , textAlign center
            ]
        , (.) BtnContainer
            [ textAlign center ]
        ]
