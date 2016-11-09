module Models exposing (..)

import Routes


-- Model


type alias Client =
    { id : Int
    , name : String
    }


type alias Project =
    { id : Int
    , name : String
    , client : Client
    , stopwatches : List Int
    }


type alias Stopwatch =
    { id : Int
    , time : Float
    , income : Float
    , hasStarted : Bool
    , hasPaused : Bool
    , hasStopped : Bool
    }


type alias Setup =
    { rate : Maybe Float
    , rateType : RateType
    , currency : String
    , nbHours : Maybe Float
    }


type alias ClientsModel =
    { clients : List Client
    , shownClient : Maybe Client
    }


type alias ProjectsModel =
    { projects : List Project
    , shownProject : Maybe Project
    , settings : Maybe Setup
    }


type alias StopwatchesModel =
    { stopwatches : List Stopwatch
    , shownStopwatch : Maybe Stopwatch
    }


type alias Model =
    { route : Routes.Model
    , baseUrl : String
    , clients : ClientsModel
    , projects : ProjectsModel
    , stopwatches : StopwatchesModel
    }


type RateType
    = PerHours
    | PerDays


initialModel : Maybe Routes.Location -> Model
initialModel location =
    { route = Routes.init location
    , baseUrl = "http://localhost:3000"
    , clients = { clients = [], shownClient = Nothing }
    , projects = { projects = [], shownProject = Nothing, settings = Nothing }
    , stopwatches = { stopwatches = [], shownStopwatch = Nothing }
    }
